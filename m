Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCCBFE530A
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731320AbfJYSG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:06:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46788 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731437AbfJYSFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0008OS-Vw; Fri, 25 Oct 2019 19:05:36 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0001ik-Ha; Fri, 25 Oct 2019 19:05:35 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Andreas Schwab" <schwab@linux-m68k.org>,
        "Christophe Leroy" <christophe.leroy@c-s.fr>,
        "Michael Ellerman" <mpe@ellerman.id.au>
Date:   Fri, 25 Oct 2019 19:03:17 +0100
Message-ID: <lsq.1572026582.906478485@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 16/47] powerpc/32s: fix suspend/resume when IBATs 4-7
 are used
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/swsusp_32.S         | 73 ++++++++++++++++++++++---
 arch/powerpc/platforms/powermac/sleep.S | 68 +++++++++++++++++++++--
 2 files changed, 128 insertions(+), 13 deletions(-)

--- a/arch/powerpc/kernel/swsusp_32.S
+++ b/arch/powerpc/kernel/swsusp_32.S
@@ -23,11 +23,19 @@
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
@@ -112,6 +120,41 @@ _GLOBAL(swsusp_arch_suspend)
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
@@ -277,27 +320,41 @@ END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
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
@@ -37,10 +37,18 @@
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
@@ -125,6 +133,41 @@ _GLOBAL(low_sleep_handler)
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
 
@@ -325,22 +368,37 @@ grackle_wake_up:
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
 

