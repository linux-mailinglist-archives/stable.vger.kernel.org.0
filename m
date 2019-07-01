Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB0BA3A2B9
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 03:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbfFIB0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 21:26:46 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:59992 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbfFIB0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jun 2019 21:26:46 -0400
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id E56E427BEC; Sat,  8 Jun 2019 21:26:42 -0400 (EDT)
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Michael Schmitz" <schmitzmic@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Geert Uytterhoeven" <geert@linux-m68k.org>, stable@vger.kernel.org
Message-Id: <62e2c6d87f091669718584461fcb76546ecf58d5.1560043151.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1560043151.git.fthain@telegraphics.com.au>
References: <cover.1560043151.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 5/7] scsi: mac_scsi: Fix pseudo DMA implementation, take 2
Date:   Sun, 09 Jun 2019 11:19:11 +1000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A system bus error during a PDMA transfer can mess up the calculation of
the transfer residual (the PDMA handshaking hardware lacks a byte
counter). This results in data corruption.

The algorithm in this patch anticipates a bus error by starting each
transfer with a MOVE.B instruction. If a bus error is caught the transfer
will be retried. If a bus error is caught later in the transfer (for a
MOVE.W instruction) the transfer gets failed and subsequent requests for
that target will use PIO instead of PDMA.

This avoids the "!REQ and !ACK" error so the severity level of that
message is reduced to KERN_DEBUG.

Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org # v4.14+
Fixes: 3a0f64bfa907 ("mac_scsi: Fix pseudo DMA implementation")
Reported-by: Chris Jones <chris@martin-jones.com>
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
Changed since v1:
 - Dropped new mac_pdma.h file.
---
 drivers/scsi/mac_scsi.c | 371 +++++++++++++++++++++++-----------------
 1 file changed, 218 insertions(+), 153 deletions(-)

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index ba1afcaadae8..27364b71e833 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -3,6 +3,8 @@
  *
  * Copyright 1998, Michael Schmitz <mschmitz@lbl.gov>
  *
+ * Copyright 2019 Finn Thain
+ *
  * derived in part from:
  */
 /*
@@ -11,6 +13,7 @@
  * Copyright 1995, Russell King
  */
 
+#include <linux/delay.h>
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
@@ -89,101 +92,217 @@ static int __init mac_scsi_setup(char *str)
 __setup("mac5380=", mac_scsi_setup);
 #endif /* !MODULE */
 
-/* Pseudo DMA asm originally by Ove Edlund */
-
-#define CP_IO_TO_MEM(s,d,n)				\
-__asm__ __volatile__					\
-    ("    cmp.w  #4,%2\n"				\
-     "    bls    8f\n"					\
-     "    move.w %1,%%d0\n"				\
-     "    neg.b  %%d0\n"				\
-     "    and.w  #3,%%d0\n"				\
-     "    sub.w  %%d0,%2\n"				\
-     "    bra    2f\n"					\
-     " 1: move.b (%0),(%1)+\n"				\
-     " 2: dbf    %%d0,1b\n"				\
-     "    move.w %2,%%d0\n"				\
-     "    lsr.w  #5,%%d0\n"				\
-     "    bra    4f\n"					\
-     " 3: move.l (%0),(%1)+\n"				\
-     "31: move.l (%0),(%1)+\n"				\
-     "32: move.l (%0),(%1)+\n"				\
-     "33: move.l (%0),(%1)+\n"				\
-     "34: move.l (%0),(%1)+\n"				\
-     "35: move.l (%0),(%1)+\n"				\
-     "36: move.l (%0),(%1)+\n"				\
-     "37: move.l (%0),(%1)+\n"				\
-     " 4: dbf    %%d0,3b\n"				\
-     "    move.w %2,%%d0\n"				\
-     "    lsr.w  #2,%%d0\n"				\
-     "    and.w  #7,%%d0\n"				\
-     "    bra    6f\n"					\
-     " 5: move.l (%0),(%1)+\n"				\
-     " 6: dbf    %%d0,5b\n"				\
-     "    and.w  #3,%2\n"				\
-     "    bra    8f\n"					\
-     " 7: move.b (%0),(%1)+\n"				\
-     " 8: dbf    %2,7b\n"				\
-     "    moveq.l #0, %2\n"				\
-     " 9: \n"						\
-     ".section .fixup,\"ax\"\n"				\
-     "    .even\n"					\
-     "91: moveq.l #1, %2\n"				\
-     "    jra 9b\n"					\
-     "94: moveq.l #4, %2\n"				\
-     "    jra 9b\n"					\
-     ".previous\n"					\
-     ".section __ex_table,\"a\"\n"			\
-     "   .align 4\n"					\
-     "   .long  1b,91b\n"				\
-     "   .long  3b,94b\n"				\
-     "   .long 31b,94b\n"				\
-     "   .long 32b,94b\n"				\
-     "   .long 33b,94b\n"				\
-     "   .long 34b,94b\n"				\
-     "   .long 35b,94b\n"				\
-     "   .long 36b,94b\n"				\
-     "   .long 37b,94b\n"				\
-     "   .long  5b,94b\n"				\
-     "   .long  7b,91b\n"				\
-     ".previous"					\
-     : "=a"(s), "=a"(d), "=d"(n)			\
-     : "0"(s), "1"(d), "2"(n)				\
-     : "d0")
+/*
+ * According to "Inside Macintosh: Devices", Mac OS requires disk drivers to
+ * specify the number of bytes between the delays expected from a SCSI target.
+ * This allows the operating system to "prevent bus errors when a target fails
+ * to deliver the next byte within the processor bus error timeout period."
+ * Linux SCSI drivers lack knowledge of the timing behaviour of SCSI targets
+ * so bus errors are unavoidable.
+ *
+ * If a MOVE.B instruction faults, we assume that zero bytes were transferred
+ * and simply retry. That assumption probably depends on target behaviour but
+ * seems to hold up okay. The NOP provides synchronization: without it the
+ * fault can sometimes occur after the program counter has moved past the
+ * offending instruction. Post-increment addressing can't be used.
+ */
+
+#define MOVE_BYTE(operands) \
+	asm volatile ( \
+		"1:     moveb " operands "     \n" \
+		"11:    nop                    \n" \
+		"       addq #1,%0             \n" \
+		"       subq #1,%1             \n" \
+		"40:                           \n" \
+		"                              \n" \
+		".section .fixup,\"ax\"        \n" \
+		".even                         \n" \
+		"90:    movel #1, %2           \n" \
+		"       jra 40b                \n" \
+		".previous                     \n" \
+		"                              \n" \
+		".section __ex_table,\"a\"     \n" \
+		".align  4                     \n" \
+		".long   1b,90b                \n" \
+		".long  11b,90b                \n" \
+		".previous                     \n" \
+		: "+a" (addr), "+r" (n), "+r" (result) : "a" (io))
+
+/*
+ * If a MOVE.W (or MOVE.L) instruction faults, it cannot be retried because
+ * the residual byte count would be uncertain. In that situation the MOVE_WORD
+ * macro clears n in the fixup section to abort the transfer.
+ */
+
+#define MOVE_WORD(operands) \
+	asm volatile ( \
+		"1:     movew " operands "     \n" \
+		"11:    nop                    \n" \
+		"       subq #2,%1             \n" \
+		"40:                           \n" \
+		"                              \n" \
+		".section .fixup,\"ax\"        \n" \
+		".even                         \n" \
+		"90:    movel #0, %1           \n" \
+		"       movel #2, %2           \n" \
+		"       jra 40b                \n" \
+		".previous                     \n" \
+		"                              \n" \
+		".section __ex_table,\"a\"     \n" \
+		".align  4                     \n" \
+		".long   1b,90b                \n" \
+		".long  11b,90b                \n" \
+		".previous                     \n" \
+		: "+a" (addr), "+r" (n), "+r" (result) : "a" (io))
+
+#define MOVE_16_WORDS(operands) \
+	asm volatile ( \
+		"1:     movew " operands "     \n" \
+		"2:     movew " operands "     \n" \
+		"3:     movew " operands "     \n" \
+		"4:     movew " operands "     \n" \
+		"5:     movew " operands "     \n" \
+		"6:     movew " operands "     \n" \
+		"7:     movew " operands "     \n" \
+		"8:     movew " operands "     \n" \
+		"9:     movew " operands "     \n" \
+		"10:    movew " operands "     \n" \
+		"11:    movew " operands "     \n" \
+		"12:    movew " operands "     \n" \
+		"13:    movew " operands "     \n" \
+		"14:    movew " operands "     \n" \
+		"15:    movew " operands "     \n" \
+		"16:    movew " operands "     \n" \
+		"17:    nop                    \n" \
+		"       subl  #32,%1           \n" \
+		"40:                           \n" \
+		"                              \n" \
+		".section .fixup,\"ax\"        \n" \
+		".even                         \n" \
+		"90:    movel #0, %1           \n" \
+		"       movel #2, %2           \n" \
+		"       jra 40b                \n" \
+		".previous                     \n" \
+		"                              \n" \
+		".section __ex_table,\"a\"     \n" \
+		".align  4                     \n" \
+		".long   1b,90b                \n" \
+		".long   2b,90b                \n" \
+		".long   3b,90b                \n" \
+		".long   4b,90b                \n" \
+		".long   5b,90b                \n" \
+		".long   6b,90b                \n" \
+		".long   7b,90b                \n" \
+		".long   8b,90b                \n" \
+		".long   9b,90b                \n" \
+		".long  10b,90b                \n" \
+		".long  11b,90b                \n" \
+		".long  12b,90b                \n" \
+		".long  13b,90b                \n" \
+		".long  14b,90b                \n" \
+		".long  15b,90b                \n" \
+		".long  16b,90b                \n" \
+		".long  17b,90b                \n" \
+		".previous                     \n" \
+		: "+a" (addr), "+r" (n), "+r" (result) : "a" (io))
+
+#define MAC_PDMA_DELAY		32
+
+static inline int mac_pdma_recv(void __iomem *io, unsigned char *start, int n)
+{
+	unsigned char *addr = start;
+	int result = 0;
+
+	if (n >= 1) {
+		MOVE_BYTE("%3@,%0@");
+		if (result)
+			goto out;
+	}
+	if (n >= 1 && ((unsigned long)addr & 1)) {
+		MOVE_BYTE("%3@,%0@");
+		if (result)
+			goto out;
+	}
+	while (n >= 32)
+		MOVE_16_WORDS("%3@,%0@+");
+	while (n >= 2)
+		MOVE_WORD("%3@,%0@+");
+	if (result)
+		return start - addr; /* Negated to indicate uncertain length */
+	if (n == 1)
+		MOVE_BYTE("%3@,%0@");
+out:
+	return addr - start;
+}
+
+static inline int mac_pdma_send(unsigned char *start, void __iomem *io, int n)
+{
+	unsigned char *addr = start;
+	int result = 0;
+
+	if (n >= 1) {
+		MOVE_BYTE("%0@,%3@");
+		if (result)
+			goto out;
+	}
+	if (n >= 1 && ((unsigned long)addr & 1)) {
+		MOVE_BYTE("%0@,%3@");
+		if (result)
+			goto out;
+	}
+	while (n >= 32)
+		MOVE_16_WORDS("%0@+,%3@");
+	while (n >= 2)
+		MOVE_WORD("%0@+,%3@");
+	if (result)
+		return start - addr; /* Negated to indicate uncertain length */
+	if (n == 1)
+		MOVE_BYTE("%0@,%3@");
+out:
+	return addr - start;
+}
 
 static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
                                 unsigned char *dst, int len)
 {
 	u8 __iomem *s = hostdata->pdma_io + (INPUT_DATA_REG << 4);
 	unsigned char *d = dst;
-	int n = len;
-	int transferred;
+
+	hostdata->pdma_residual = len;
 
 	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 	                              BASR_DRQ | BASR_PHASE_MATCH,
 	                              BASR_DRQ | BASR_PHASE_MATCH, HZ / 64)) {
-		CP_IO_TO_MEM(s, d, n);
+		int bytes;
 
-		transferred = d - dst - n;
-		hostdata->pdma_residual = len - transferred;
+		bytes = mac_pdma_recv(s, d, min(hostdata->pdma_residual, 512));
 
-		/* No bus error. */
-		if (n == 0)
+		if (bytes > 0) {
+			d += bytes;
+			hostdata->pdma_residual -= bytes;
+		}
+
+		if (hostdata->pdma_residual == 0)
 			return 0;
 
-		/* Target changed phase early? */
 		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
-		                           BUS_AND_STATUS_REG, BASR_ACK, BASR_ACK, HZ / 64) < 0)
-			scmd_printk(KERN_ERR, hostdata->connected,
+		                           BUS_AND_STATUS_REG, BASR_ACK,
+		                           BASR_ACK, HZ / 64) < 0)
+			scmd_printk(KERN_DEBUG, hostdata->connected,
 			            "%s: !REQ and !ACK\n", __func__);
 		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
 			return 0;
 
+		if (bytes == 0)
+			udelay(MAC_PDMA_DELAY);
+
+		if (bytes >= 0)
+			continue;
+
 		dsprintk(NDEBUG_PSEUDO_DMA, hostdata->host,
-		         "%s: bus error (%d/%d)\n", __func__, transferred, len);
+		         "%s: bus error (%d/%d)\n", __func__, d - dst, len);
 		NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
-		d = dst + transferred;
-		n = len - transferred;
+		return -1;
 	}
 
 	scmd_printk(KERN_ERR, hostdata->connected,
@@ -192,93 +311,27 @@ static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
 	return -1;
 }
 
-
-#define CP_MEM_TO_IO(s,d,n)				\
-__asm__ __volatile__					\
-    ("    cmp.w  #4,%2\n"				\
-     "    bls    8f\n"					\
-     "    move.w %0,%%d0\n"				\
-     "    neg.b  %%d0\n"				\
-     "    and.w  #3,%%d0\n"				\
-     "    sub.w  %%d0,%2\n"				\
-     "    bra    2f\n"					\
-     " 1: move.b (%0)+,(%1)\n"				\
-     " 2: dbf    %%d0,1b\n"				\
-     "    move.w %2,%%d0\n"				\
-     "    lsr.w  #5,%%d0\n"				\
-     "    bra    4f\n"					\
-     " 3: move.l (%0)+,(%1)\n"				\
-     "31: move.l (%0)+,(%1)\n"				\
-     "32: move.l (%0)+,(%1)\n"				\
-     "33: move.l (%0)+,(%1)\n"				\
-     "34: move.l (%0)+,(%1)\n"				\
-     "35: move.l (%0)+,(%1)\n"				\
-     "36: move.l (%0)+,(%1)\n"				\
-     "37: move.l (%0)+,(%1)\n"				\
-     " 4: dbf    %%d0,3b\n"				\
-     "    move.w %2,%%d0\n"				\
-     "    lsr.w  #2,%%d0\n"				\
-     "    and.w  #7,%%d0\n"				\
-     "    bra    6f\n"					\
-     " 5: move.l (%0)+,(%1)\n"				\
-     " 6: dbf    %%d0,5b\n"				\
-     "    and.w  #3,%2\n"				\
-     "    bra    8f\n"					\
-     " 7: move.b (%0)+,(%1)\n"				\
-     " 8: dbf    %2,7b\n"				\
-     "    moveq.l #0, %2\n"				\
-     " 9: \n"						\
-     ".section .fixup,\"ax\"\n"				\
-     "    .even\n"					\
-     "91: moveq.l #1, %2\n"				\
-     "    jra 9b\n"					\
-     "94: moveq.l #4, %2\n"				\
-     "    jra 9b\n"					\
-     ".previous\n"					\
-     ".section __ex_table,\"a\"\n"			\
-     "   .align 4\n"					\
-     "   .long  1b,91b\n"				\
-     "   .long  3b,94b\n"				\
-     "   .long 31b,94b\n"				\
-     "   .long 32b,94b\n"				\
-     "   .long 33b,94b\n"				\
-     "   .long 34b,94b\n"				\
-     "   .long 35b,94b\n"				\
-     "   .long 36b,94b\n"				\
-     "   .long 37b,94b\n"				\
-     "   .long  5b,94b\n"				\
-     "   .long  7b,91b\n"				\
-     ".previous"					\
-     : "=a"(s), "=a"(d), "=d"(n)			\
-     : "0"(s), "1"(d), "2"(n)				\
-     : "d0")
-
 static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
                                  unsigned char *src, int len)
 {
 	unsigned char *s = src;
 	u8 __iomem *d = hostdata->pdma_io + (OUTPUT_DATA_REG << 4);
-	int n = len;
-	int transferred;
+
+	hostdata->pdma_residual = len;
 
 	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 	                              BASR_DRQ | BASR_PHASE_MATCH,
 	                              BASR_DRQ | BASR_PHASE_MATCH, HZ / 64)) {
-		CP_MEM_TO_IO(s, d, n);
+		int bytes;
 
-		transferred = s - src - n;
-		hostdata->pdma_residual = len - transferred;
+		bytes = mac_pdma_send(s, d, min(hostdata->pdma_residual, 512));
 
-		/* Target changed phase early? */
-		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
-		                           BUS_AND_STATUS_REG, BASR_ACK, BASR_ACK, HZ / 64) < 0)
-			scmd_printk(KERN_ERR, hostdata->connected,
-			            "%s: !REQ and !ACK\n", __func__);
-		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
-			return 0;
+		if (bytes > 0) {
+			s += bytes;
+			hostdata->pdma_residual -= bytes;
+		}
 
-		/* No bus error. */
-		if (n == 0) {
+		if (hostdata->pdma_residual == 0) {
 			if (NCR5380_poll_politely(hostdata, TARGET_COMMAND_REG,
 			                          TCR_LAST_BYTE_SENT,
 			                          TCR_LAST_BYTE_SENT, HZ / 64) < 0)
@@ -287,17 +340,29 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 			return 0;
 		}
 
+		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
+		                           BUS_AND_STATUS_REG, BASR_ACK,
+		                           BASR_ACK, HZ / 64) < 0)
+			scmd_printk(KERN_DEBUG, hostdata->connected,
+			            "%s: !REQ and !ACK\n", __func__);
+		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
+			return 0;
+
+		if (bytes == 0)
+			udelay(MAC_PDMA_DELAY);
+
+		if (bytes >= 0)
+			continue;
+
 		dsprintk(NDEBUG_PSEUDO_DMA, hostdata->host,
-		         "%s: bus error (%d/%d)\n", __func__, transferred, len);
+		         "%s: bus error (%d/%d)\n", __func__, s - src, len);
 		NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
-		s = src + transferred;
-		n = len - transferred;
+		return -1;
 	}
 
 	scmd_printk(KERN_ERR, hostdata->connected,
 	            "%s: phase mismatch or !DRQ\n", __func__);
 	NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
-
 	return -1;
 }
 
-- 
2.21.0

