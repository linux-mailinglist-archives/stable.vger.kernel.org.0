Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3B3406239
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhIJApA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231395AbhIJAU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6C1D610E9;
        Fri, 10 Sep 2021 00:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233188;
        bh=QU4FBgYMNwDeESXPSn07nEuNpovjAHX078dG710mn1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dq/QV4h9uJxNyQr4vrEPCkdhBBVoEbvK5LSdYqs/R8+FdoMI955W4XqNv8t2yUiQX
         fWk2frvM9WLONof8QkX7H5E+iRpS/WYYI66zvg7xMhqf9U+/ugcl0aWJ2HXKgq1EgG
         aKWKAsMyGsP3yA2OSaol04gZWM3XjbKGCsP5hqISOYjMq8MWQaxWXx1C/WMPOZpGU6
         iG8iQV9MHKdKAHGoecdg7c8bI4p3HkBI2A+IQqJhVdC6n+9S/4r82/70o6i17LkiaO
         dH3dqMitaVm2S5z2COX9mUXe3BvSdw595Oejx3c4kbxrU/Xu6v056ZE/N6OU8xMYzB
         Pavl7WQj+vRKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.13 62/88] powerpc: Avoid link stack corruption in misc asm functions
Date:   Thu,  9 Sep 2021 20:17:54 -0400
Message-Id: <20210910001820.174272-62-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 33e1402435cb9f3021439a15935ea2dc69ec1844 ]

bl;mflr is used at several places to get code position.

Use bcl 20,31,+4 instead of bl in order to preserve link stack.

See commit c974809a26a1 ("powerpc/vdso: Avoid link stack corruption
in __get_datapage()") for details.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/c6eabb4fb6c156f75d56dcbcc6f243e5ac0fba42.1629791763.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/misc.S       |  2 +-
 arch/powerpc/kernel/misc_32.S    |  2 +-
 arch/powerpc/kernel/misc_64.S    |  2 +-
 arch/powerpc/kernel/reloc_32.S   |  2 +-
 arch/powerpc/kexec/relocate_32.S | 12 ++++++------
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kernel/misc.S b/arch/powerpc/kernel/misc.S
index 5be96feccb55..fb7de3543c03 100644
--- a/arch/powerpc/kernel/misc.S
+++ b/arch/powerpc/kernel/misc.S
@@ -29,7 +29,7 @@ _GLOBAL(reloc_offset)
 	li	r3, 0
 _GLOBAL(add_reloc_offset)
 	mflr	r0
-	bl	1f
+	bcl	20,31,$+4
 1:	mflr	r5
 	PPC_LL	r4,(2f-1b)(r5)
 	subf	r5,r4,r5
diff --git a/arch/powerpc/kernel/misc_32.S b/arch/powerpc/kernel/misc_32.S
index 6a076bef2932..b06f27501c25 100644
--- a/arch/powerpc/kernel/misc_32.S
+++ b/arch/powerpc/kernel/misc_32.S
@@ -67,7 +67,7 @@ _GLOBAL(reloc_got2)
 	srwi.	r8,r8,2
 	beqlr
 	mtctr	r8
-	bl	1f
+	bcl	20,31,$+4
 1:	mflr	r0
 	lis	r4,1b@ha
 	addi	r4,r4,1b@l
diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
index 4b761a18a74d..d38a019b38e1 100644
--- a/arch/powerpc/kernel/misc_64.S
+++ b/arch/powerpc/kernel/misc_64.S
@@ -255,7 +255,7 @@ _GLOBAL(scom970_write)
  * Physical (hardware) cpu id should be in r3.
  */
 _GLOBAL(kexec_wait)
-	bl	1f
+	bcl	20,31,$+4
 1:	mflr	r5
 	addi	r5,r5,kexec_flag-1b
 
diff --git a/arch/powerpc/kernel/reloc_32.S b/arch/powerpc/kernel/reloc_32.S
index 10e96f3e22fe..0508c14b4c28 100644
--- a/arch/powerpc/kernel/reloc_32.S
+++ b/arch/powerpc/kernel/reloc_32.S
@@ -30,7 +30,7 @@ R_PPC_RELATIVE = 22
 _GLOBAL(relocate)
 
 	mflr	r0		/* Save our LR */
-	bl	0f		/* Find our current runtime address */
+	bcl	20,31,$+4	/* Find our current runtime address */
 0:	mflr	r12		/* Make it accessible */
 	mtlr	r0
 
diff --git a/arch/powerpc/kexec/relocate_32.S b/arch/powerpc/kexec/relocate_32.S
index 61946c19e07c..cf6e52bdf8d8 100644
--- a/arch/powerpc/kexec/relocate_32.S
+++ b/arch/powerpc/kexec/relocate_32.S
@@ -93,7 +93,7 @@ wmmucr:
 	 * Invalidate all the TLB entries except the current entry
 	 * where we are running from
 	 */
-	bl	0f				/* Find our address */
+	bcl	20,31,$+4			/* Find our address */
 0:	mflr	r5				/* Make it accessible */
 	tlbsx	r23,0,r5			/* Find entry we are in */
 	li	r4,0				/* Start at TLB entry 0 */
@@ -158,7 +158,7 @@ write_out:
 	/* Switch to other address space in MSR */
 	insrwi	r9, r7, 1, 26		/* Set MSR[IS] = r7 */
 
-	bl	1f
+	bcl	20,31,$+4
 1:	mflr	r8
 	addi	r8, r8, (2f-1b)		/* Find the target offset */
 
@@ -202,7 +202,7 @@ next_tlb:
 	li	r9,0
 	insrwi	r9, r7, 1, 26			/* Set MSR[IS] = r7 */
 
-	bl	1f
+	bcl	20,31,$+4
 1:	mflr	r8
 	and	r8, r8, r11			/* Get our offset within page */
 	addi	r8, r8, (2f-1b)
@@ -240,7 +240,7 @@ setup_map_47x:
 	sync
 
 	/* Find the entry we are running from */
-	bl	2f
+	bcl	20,31,$+4
 2:	mflr	r23
 	tlbsx	r23, 0, r23
 	tlbre	r24, r23, 0			/* TLB Word 0 */
@@ -296,7 +296,7 @@ clear_utlb_entry:
 	/* Update the msr to the new TS */
 	insrwi	r5, r7, 1, 26
 
-	bl	1f
+	bcl	20,31,$+4
 1:	mflr	r6
 	addi	r6, r6, (2f-1b)
 
@@ -355,7 +355,7 @@ write_utlb:
 	/* Defaults to 256M */
 	lis	r10, 0x1000
 
-	bl	1f
+	bcl	20,31,$+4
 1:	mflr	r4
 	addi	r4, r4, (2f-1b)			/* virtual address  of 2f */
 
-- 
2.30.2

