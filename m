Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4359B4917B7
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiARCmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:42:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52892 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240459AbiARCfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:35:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78B87612E3;
        Tue, 18 Jan 2022 02:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEF5C341DB;
        Tue, 18 Jan 2022 02:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473351;
        bh=ckflUerAfLhOFK4VpMPfLsx+zloNep3KUJDX17KtN8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCLkFDHx+REuNDYQUpTod/mi9mCD1sUlP1kZ9ZzsgV59XAL9mF0/zgkewfvtJdBOZ
         jYh3ws+0nh4DS0+9+zqBk/6rh9czrOQBaNdGM7rKUZGalpgJn4+8MdBlX/Bsd01Mkk
         iE1XRJqYeNJVkgj05w146zYC6Q0XzOAL8oSjEmjbtaxIuf+cgj5E5CsE8PGgqKYlxk
         uccktA9eF7Qpc28O3+z+UuhjAiYwaLQequu8ZLyDohwUzgpafv2EZiyAHuKVJlrZ1K
         Cex9CKTUmZ0p2DEUbjI1zI21vzvMcCUUOzcBH5W35Yt/mPSTWqLvzWyU+FoMswdP/x
         ZGZgpypgkB2sA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, gor@linux.ibm.com,
        borntraeger@linux.ibm.com, egorenar@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, ebiederm@xmission.com,
        valentin.schneider@arm.com, rppt@kernel.org, iii@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 081/188] s390/nmi: add missing __pa/__va address conversion of extended save area
Date:   Mon, 17 Jan 2022 21:30:05 -0500
Message-Id: <20220118023152.1948105-81-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 402ff5a3387dc8ec6987a80d3ce26b0c25773622 ]

Add missing __pa/__va address conversion of machine check extended
save area designation, which is an absolute address.

Note: this currently doesn't fix a real bug, since virtual addresses
are indentical to physical ones.

Reported-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Tested-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/machine_kexec.c |  2 +-
 arch/s390/kernel/nmi.c           | 10 +++++-----
 arch/s390/kernel/smp.c           |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/s390/kernel/machine_kexec.c b/arch/s390/kernel/machine_kexec.c
index 0505e55a62979..a16467b3825ec 100644
--- a/arch/s390/kernel/machine_kexec.c
+++ b/arch/s390/kernel/machine_kexec.c
@@ -86,7 +86,7 @@ static noinline void __machine_kdump(void *image)
 			continue;
 	}
 	/* Store status of the boot CPU */
-	mcesa = (struct mcesa *)(S390_lowcore.mcesad & MCESA_ORIGIN_MASK);
+	mcesa = __va(S390_lowcore.mcesad & MCESA_ORIGIN_MASK);
 	if (MACHINE_HAS_VX)
 		save_vx_regs((__vector128 *) mcesa->vector_save_area);
 	if (MACHINE_HAS_GS) {
diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index 20f8e1868853f..3f18c1412eba3 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -68,7 +68,7 @@ void __init nmi_alloc_boot_cpu(struct lowcore *lc)
 {
 	if (!nmi_needs_mcesa())
 		return;
-	lc->mcesad = (unsigned long) &boot_mcesa;
+	lc->mcesad = __pa(&boot_mcesa);
 	if (MACHINE_HAS_GS)
 		lc->mcesad |= ilog2(MCESA_MAX_SIZE);
 }
@@ -94,7 +94,7 @@ static int __init nmi_init(void)
 	__ctl_store(cr0, 0, 0);
 	__ctl_clear_bit(0, 28); /* disable lowcore protection */
 	/* Replace boot_mcesa on the boot CPU */
-	S390_lowcore.mcesad = origin | mcesa_origin_lc;
+	S390_lowcore.mcesad = __pa(origin) | mcesa_origin_lc;
 	__ctl_load(cr0, 0, 0);
 	return 0;
 }
@@ -111,7 +111,7 @@ int nmi_alloc_per_cpu(struct lowcore *lc)
 		return -ENOMEM;
 	/* The pointer is stored with mcesa_bits ORed in */
 	kmemleak_not_leak((void *) origin);
-	lc->mcesad = origin | mcesa_origin_lc;
+	lc->mcesad = __pa(origin) | mcesa_origin_lc;
 	return 0;
 }
 
@@ -119,7 +119,7 @@ void nmi_free_per_cpu(struct lowcore *lc)
 {
 	if (!nmi_needs_mcesa())
 		return;
-	kmem_cache_free(mcesa_cache, (void *)(lc->mcesad & MCESA_ORIGIN_MASK));
+	kmem_cache_free(mcesa_cache, __va(lc->mcesad & MCESA_ORIGIN_MASK));
 }
 
 static notrace void s390_handle_damage(void)
@@ -246,7 +246,7 @@ static int notrace s390_validate_registers(union mci mci, int umode)
 			: "Q" (S390_lowcore.fpt_creg_save_area));
 	}
 
-	mcesa = (struct mcesa *)(S390_lowcore.mcesad & MCESA_ORIGIN_MASK);
+	mcesa = __va(S390_lowcore.mcesad & MCESA_ORIGIN_MASK);
 	if (!MACHINE_HAS_VX) {
 		/* Validate floating point registers */
 		asm volatile(
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 1a04e5bdf6555..5c3d3d8f6b5d8 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -622,7 +622,7 @@ int smp_store_status(int cpu)
 		return -EIO;
 	if (!MACHINE_HAS_VX && !MACHINE_HAS_GS)
 		return 0;
-	pa = __pa(lc->mcesad & MCESA_ORIGIN_MASK);
+	pa = lc->mcesad & MCESA_ORIGIN_MASK;
 	if (MACHINE_HAS_GS)
 		pa |= lc->mcesad & MCESA_LC_MASK;
 	if (__pcpu_sigp_relax(pcpu->address, SIGP_STORE_ADDITIONAL_STATUS,
-- 
2.34.1

