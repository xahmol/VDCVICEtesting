; 10 SYS7181

*=$1C01

        BYTE    $0B, $1C, $0A, $00, $9E, $37, $31, $38, $31, $00, $00, $00

; Start of VDC test assembly code
; Code fills screen with screencode 102

; Hi-byte of the destination address to register 18
        ldx #$12                        ; Load $12 for register 18 (VDC) RAM address high) in X  
        lda #$00                        ; Load high byte of start in A
        jsr RegisterWrite               ; Call register write subroutine

; Lo-byte of the destination address to register 19
        inx                             ; Increase X to $13 for register 19 (VDC RAM address low)
        jsr RegisterWrite               ; Call register write subroutine

; Initialise counters and screencode

        ldy #$00                        ; Load 0 as counter in Y
        lda #$08                        ; Load 8 as number of pages to write in A
        sta $fa                         ; Store page counter in zero page address $FA
        lda #$66                        ; Loads A with screencode 102

; Screen fill loop
Copyloop
        ldx #$1f                        ; Load $1f for register 31 (VDC data) in X
        jsr RegisterWrite               ; Call register write subroutine
        iny                             ; Increase Y counter
        bne Copyloop                    ; Continue loop until Y>255 so a page is finished
        dec $fa                         ; Decrease page counter
        bne Copyloop                    ; Continue loop until page counter is zero
        rts                             ; Return to basic

; Subroutine to write to VDC register
RegisterWrite
        stx $d600                       ; Store register number loaded in X in VDC address register
;WaitUntilReady
;        bit $d600                       ; Check status bit 7 of VDC address register
;        bpl WaitUntilReady              ; Continue to wait if status is not ready
        sta $d601                       ; Write value stored in A to VDC data register
        rts                             ; End subroutine and return