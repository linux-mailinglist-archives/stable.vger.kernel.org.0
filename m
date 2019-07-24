Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D91373C6D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391853AbfGXUBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388390AbfGXUBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:01:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 135FD2147A;
        Wed, 24 Jul 2019 20:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998474;
        bh=MF8rD2QGHB9J0ZLkwA0r7YPIlLeoGOqpJ0E+xa3tB/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdDojLmHYzy4IxOg+7z7mOeBfVKc1QkThqptF1Nf2bPaFRKTLnl+xwQn9Cldc2XQs
         c84UsSMpwz+028U9kD7UZzQXiWlogHTQpDpGi8+DVNurnJduXHgn5DVcpl3rDpI274
         U0bsSufkkyKSp7kpnij444yMnarBUX9HvTW1GZlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Schwab <schwab@linux-m68k.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.1 349/371] powerpc/32s: fix suspend/resume when IBATs 4-7 are used
Date:   Wed, 24 Jul 2019 21:21:41 +0200
Message-Id: <20190724191750.045555914@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 6ecb78ef56e08d2119d337ae23cb951a640dc52d upstream.

Previously, only IBAT1 and IBAT2 were used to map kernel linear mem.
Since commit 63b2bc619565 ("powerpc/mm/32s: Use BATs for
STRICT_KERNEL_RWX"), we may have all 8 BATs used for mapping
kernel text. But the suspend/restore functions only save/restore
BATs 0 to 3, and clears BATs 4 to 7.

Make suspend and restore functions respectively save and reload
the 8 BATs on CPUs having MMU_FTR_USE_HIGH_BATS feature.

Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/swsusp_32.S         |   73 ++++++++++++++++++++++++++++----
 arch/powerpc/platforms/powermac/sleep.S |   68 +++++++++++++++++++++++++++--
 2 files changed, 128 insertions(+), 13 deletions(-)

--- a/arch/powerpc/kernel/swsusp_32.S
+++ b/arch/powerpc/kernel/swsusp_32.S
@@ -25,11 +25,19 @@
 #define SL_IBAT2	0x48
 #define SL_DBAT3	0x50
 #define SL_IBAT3	0x58
-#define SL_TB		0x60
-#define SL_R2		0x68
-#define SL_CR		0x6c
-#define SL_LR		0x70
-#define SL_R12		0x74	/* r12 to r31 */
+#define SL_DBAT4	0x60
+#define SL_IBAT4	0x68
+#define SL_DBAT5	0x70
+#define SL_IBAT5	0x78
+#define SL_DBAT6	0x80
+#define SL_IBAT6	0x88
+#define SL_DBAT7	0x90
+#define SL_IBAT7	0x98
+#define SL_TB		0xa0
+#define SL_R2		0xa8
+#define SL_CR		0xac
+#define SL_LR		0xb0
+#define SL_R12		0xb4	/* r12 to r31 */
 #define SL_SIZE		(SL_R12 + 80)
 
 	.section .data
@@ -114,6 +122,41 @@ _GLOBAL(swsusp_arch_suspend)
 	mfibatl	r4,3
 	stw	r4,SL_IBAT3+4(r11)
 
+BEGIN_MMU_FTR_SECTION
+	mfspr	r4,SPRN_DBAT4U
+	stw	r4,SL_DBAT4(r11)
+	mfspr	r4,SPRN_DBAT4L
+	stw	r4,SL_DBAT4+4(r11)
+	mfspr	r4,SPRN_DBAT5U
+	stw	r4,SL_DBAT5(r11)
+	mfspr	r4,SPRN_DBAT5L
+	stw	r4,SL_DBAT5+4(r11)
+	mfspr	r4,SPRN_DBAT6U
+	stw	r4,SL_DBAT6(r11)
+	mfspr	r4,SPRN_DBAT6L
+	stw	r4,SL_DBAT6+4(r11)
+	mfspr	r4,SPRN_DBAT7U
+	stw	r4,SL_DBAT7(r11)
+	mfspr	r4,SPRN_DBAT7L
+	stw	r4,SL_DBAT7+4(r11)
+	mfspr	r4,SPRN_IBAT4U
+	stw	r4,SL_IBAT4(r11)
+	mfspr	r4,SPRN_IBAT4L
+	stw	r4,SL_IBAT4+4(r11)
+	mfspr	r4,SPRN_IBAT5U
+	stw	r4,SL_IBAT5(r11)
+	mfspr	r4,SPRN_IBAT5L
+	stw	r4,SL_IBAT5+4(r11)
+	mfspr	r4,SPRN_IBAT6U
+	stw	r4,SL_IBAT6(r11)
+	mfspr	r4,SPRN_IBAT6L
+	stw	r4,SL_IBAT6+4(r11)
+	mfspr	r4,SPRN_IBAT7U
+	stw	r4,SL_IBAT7(r11)
+	mfspr	r4,SPRN_IBAT7L
+	stw	r4,SL_IBAT7+4(r11)
+END_MMU_FTR_SECTION_IFSET(MMU_FTR_USE_HIGH_BATS)
+
 #if  0
 	/* Backup various CPU config stuffs */
 	bl	__save_cpu_setup
@@ -279,27 +322,41 @@ END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 	mtibatu	3,r4
 	lwz	r4,SL_IBAT3+4(r11)
 	mtibatl	3,r4
-#endif
-
 BEGIN_MMU_FTR_SECTION
-	li	r4,0
+	lwz	r4,SL_DBAT4(r11)
 	mtspr	SPRN_DBAT4U,r4
+	lwz	r4,SL_DBAT4+4(r11)
 	mtspr	SPRN_DBAT4L,r4
+	lwz	r4,SL_DBAT5(r11)
 	mtspr	SPRN_DBAT5U,r4
+	lwz	r4,SL_DBAT5+4(r11)
 	mtspr	SPRN_DBAT5L,r4
+	lwz	r4,SL_DBAT6(r11)
 	mtspr	SPRN_DBAT6U,r4
+	lwz	r4,SL_DBAT6+4(r11)
 	mtspr	SPRN_DBAT6L,r4
+	lwz	r4,SL_DBAT7(r11)
 	mtspr	SPRN_DBAT7U,r4
+	lwz	r4,SL_DBAT7+4(r11)
 	mtspr	SPRN_DBAT7L,r4
+	lwz	r4,SL_IBAT4(r11)
 	mtspr	SPRN_IBAT4U,r4
+	lwz	r4,SL_IBAT4+4(r11)
 	mtspr	SPRN_IBAT4L,r4
+	lwz	r4,SL_IBAT5(r11)
 	mtspr	SPRN_IBAT5U,r4
+	lwz	r4,SL_IBAT5+4(r11)
 	mtspr	SPRN_IBAT5L,r4
+	lwz	r4,SL_IBAT6(r11)
 	mtspr	SPRN_IBAT6U,r4
+	lwz	r4,SL_IBAT6+4(r11)
 	mtspr	SPRN_IBAT6L,r4
+	lwz	r4,SL_IBAT7(r11)
 	mtspr	SPRN_IBAT7U,r4
+	lwz	r4,SL_IBAT7+4(r11)
 	mtspr	SPRN_IBAT7L,r4
 END_MMU_FTR_SECTION_IFSET(MMU_FTR_USE_HIGH_BATS)
+#endif
 
 	/* Flush all TLBs */
 	lis	r4,0x1000
--- a/arch/powerpc/platforms/powermac/sleep.S
+++ b/arch/powerpc/platforms/powermac/sleep.S
@@ -38,10 +38,18 @@
 #define SL_IBAT2	0x48
 #define SL_DBAT3	0x50
 #define SL_IBAT3	0x58
-#define SL_TB		0x60
-#define SL_R2		0x68
-#define SL_CR		0x6c
-#define SL_R12		0x70	/* r12 to r31 */
+#define SL_DBAT4	0x60
+#define SL_IBAT4	0x68
+#define SL_DBAT5	0x70
+#define SL_IBAT5	0x78
+#define SL_DBAT6	0x80
+#define SL_IBAT6	0x88
+#define SL_DBAT7	0x90
+#define SL_IBAT7	0x98
+#define SL_TB		0xa0
+#define SL_R2		0xa8
+#define SL_CR		0xac
+#define SL_R12		0xb0	/* r12 to r31 */
 #define SL_SIZE		(SL_R12 + 80)
 
 	.section .text
@@ -126,6 +134,41 @@ _GLOBAL(low_sleep_handler)
 	mfibatl	r4,3
 	stw	r4,SL_IBAT3+4(r1)
 
+BEGIN_MMU_FTR_SECTION
+	mfspr	r4,SPRN_DBAT4U
+	stw	r4,SL_DBAT4(r1)
+	mfspr	r4,SPRN_DBAT4L
+	stw	r4,SL_DBAT4+4(r1)
+	mfspr	r4,SPRN_DBAT5U
+	stw	r4,SL_DBAT5(r1)
+	mfspr	r4,SPRN_DBAT5L
+	stw	r4,SL_DBAT5+4(r1)
+	mfspr	r4,SPRN_DBAT6U
+	stw	r4,SL_DBAT6(r1)
+	mfspr	r4,SPRN_DBAT6L
+	stw	r4,SL_DBAT6+4(r1)
+	mfspr	r4,SPRN_DBAT7U
+	stw	r4,SL_DBAT7(r1)
+	mfspr	r4,SPRN_DBAT7L
+	stw	r4,SL_DBAT7+4(r1)
+	mfspr	r4,SPRN_IBAT4U
+	stw	r4,SL_IBAT4(r1)
+	mfspr	r4,SPRN_IBAT4L
+	stw	r4,SL_IBAT4+4(r1)
+	mfspr	r4,SPRN_IBAT5U
+	stw	r4,SL_IBAT5(r1)
+	mfspr	r4,SPRN_IBAT5L
+	stw	r4,SL_IBAT5+4(r1)
+	mfspr	r4,SPRN_IBAT6U
+	stw	r4,SL_IBAT6(r1)
+	mfspr	r4,SPRN_IBAT6L
+	stw	r4,SL_IBAT6+4(r1)
+	mfspr	r4,SPRN_IBAT7U
+	stw	r4,SL_IBAT7(r1)
+	mfspr	r4,SPRN_IBAT7L
+	stw	r4,SL_IBAT7+4(r1)
+END_MMU_FTR_SECTION_IFSET(MMU_FTR_USE_HIGH_BATS)
+
 	/* Backup various CPU config stuffs */
 	bl	__save_cpu_setup
 
@@ -326,22 +369,37 @@ grackle_wake_up:
 	mtibatl	3,r4
 
 BEGIN_MMU_FTR_SECTION
-	li	r4,0
+	lwz	r4,SL_DBAT4(r1)
 	mtspr	SPRN_DBAT4U,r4
+	lwz	r4,SL_DBAT4+4(r1)
 	mtspr	SPRN_DBAT4L,r4
+	lwz	r4,SL_DBAT5(r1)
 	mtspr	SPRN_DBAT5U,r4
+	lwz	r4,SL_DBAT5+4(r1)
 	mtspr	SPRN_DBAT5L,r4
+	lwz	r4,SL_DBAT6(r1)
 	mtspr	SPRN_DBAT6U,r4
+	lwz	r4,SL_DBAT6+4(r1)
 	mtspr	SPRN_DBAT6L,r4
+	lwz	r4,SL_DBAT7(r1)
 	mtspr	SPRN_DBAT7U,r4
+	lwz	r4,SL_DBAT7+4(r1)
 	mtspr	SPRN_DBAT7L,r4
+	lwz	r4,SL_IBAT4(r1)
 	mtspr	SPRN_IBAT4U,r4
+	lwz	r4,SL_IBAT4+4(r1)
 	mtspr	SPRN_IBAT4L,r4
+	lwz	r4,SL_IBAT5(r1)
 	mtspr	SPRN_IBAT5U,r4
+	lwz	r4,SL_IBAT5+4(r1)
 	mtspr	SPRN_IBAT5L,r4
+	lwz	r4,SL_IBAT6(r1)
 	mtspr	SPRN_IBAT6U,r4
+	lwz	r4,SL_IBAT6+4(r1)
 	mtspr	SPRN_IBAT6L,r4
+	lwz	r4,SL_IBAT7(r1)
 	mtspr	SPRN_IBAT7U,r4
+	lwz	r4,SL_IBAT7+4(r1)
 	mtspr	SPRN_IBAT7L,r4
 END_MMU_FTR_SECTION_IFSET(MMU_FTR_USE_HIGH_BATS)
 


