Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8A0616EB
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfGGTnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:43:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57402 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727572AbfGGTiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:10 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz7-0006ik-Gg; Sun, 07 Jul 2019 20:38:05 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz5-0005cj-SO; Sun, 07 Jul 2019 20:38:03 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Christophe Leroy" <christophe.leroy@c-s.fr>,
        "Michael Ellerman" <mpe@ellerman.id.au>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.49548321@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 080/129] powerpc/83xx: Also save/restore SPRG4-7
 during suspend
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 36da5ff0bea2dc67298150ead8d8471575c54c7d upstream.

The 83xx has 8 SPRG registers and uses at least SPRG4
for DTLB handling LRU.

Fixes: 2319f1239592 ("powerpc/mm: e300c2/c3/c4 TLB errata workaround")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/platforms/83xx/suspend-asm.S | 34 ++++++++++++++++++-----
 1 file changed, 27 insertions(+), 7 deletions(-)

--- a/arch/powerpc/platforms/83xx/suspend-asm.S
+++ b/arch/powerpc/platforms/83xx/suspend-asm.S
@@ -26,13 +26,13 @@
 #define SS_MSR		0x74
 #define SS_SDR1		0x78
 #define SS_LR		0x7c
-#define SS_SPRG		0x80 /* 4 SPRGs */
-#define SS_DBAT		0x90 /* 8 DBATs */
-#define SS_IBAT		0xd0 /* 8 IBATs */
-#define SS_TB		0x110
-#define SS_CR		0x118
-#define SS_GPREG	0x11c /* r12-r31 */
-#define STATE_SAVE_SIZE 0x16c
+#define SS_SPRG		0x80 /* 8 SPRGs */
+#define SS_DBAT		0xa0 /* 8 DBATs */
+#define SS_IBAT		0xe0 /* 8 IBATs */
+#define SS_TB		0x120
+#define SS_CR		0x128
+#define SS_GPREG	0x12c /* r12-r31 */
+#define STATE_SAVE_SIZE 0x17c
 
 	.section .data
 	.align	5
@@ -103,6 +103,16 @@ _GLOBAL(mpc83xx_enter_deep_sleep)
 	stw	r7, SS_SPRG+12(r3)
 	stw	r8, SS_SDR1(r3)
 
+	mfspr	r4, SPRN_SPRG4
+	mfspr	r5, SPRN_SPRG5
+	mfspr	r6, SPRN_SPRG6
+	mfspr	r7, SPRN_SPRG7
+
+	stw	r4, SS_SPRG+16(r3)
+	stw	r5, SS_SPRG+20(r3)
+	stw	r6, SS_SPRG+24(r3)
+	stw	r7, SS_SPRG+28(r3)
+
 	mfspr	r4, SPRN_DBAT0U
 	mfspr	r5, SPRN_DBAT0L
 	mfspr	r6, SPRN_DBAT1U
@@ -493,6 +503,16 @@ mpc83xx_deep_resume:
 	mtspr	SPRN_IBAT7U, r6
 	mtspr	SPRN_IBAT7L, r7
 
+	lwz	r4, SS_SPRG+16(r3)
+	lwz	r5, SS_SPRG+20(r3)
+	lwz	r6, SS_SPRG+24(r3)
+	lwz	r7, SS_SPRG+28(r3)
+
+	mtspr	SPRN_SPRG4, r4
+	mtspr	SPRN_SPRG5, r5
+	mtspr	SPRN_SPRG6, r6
+	mtspr	SPRN_SPRG7, r7
+
 	lwz	r4, SS_SPRG+0(r3)
 	lwz	r5, SS_SPRG+4(r3)
 	lwz	r6, SS_SPRG+8(r3)

