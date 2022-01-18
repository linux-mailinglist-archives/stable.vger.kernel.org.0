Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95458491531
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343664AbiARC0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:26:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38730 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245576AbiARCYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:24:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC5C6B81236;
        Tue, 18 Jan 2022 02:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25722C36AF2;
        Tue, 18 Jan 2022 02:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472679;
        bh=WB5Fr75X8G4jw0/y8XuyPCD1/8boh+YgNcljnWxG620=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqTo4oGylP80XBGENs2kr2FjwFdQ3xBd6o0dDHKSdb6Bem9pZwGI9VNHG387N/dC9
         z45Q4x+o5chkCBWZodYFq48Vp8bMhUz9RDpcNH19t75nsvCxwgrmKlHnRPP69nnQri
         795rqd4cQNaXS5hEkFJu29pvj2tGsCYhO450iqyv9Q0xss7YXyT9I6F7zd0L4ziDBw
         1pbPsiLi53qRrkbs71QC3TxAwS+SVJTSOi0oSjEAGhIHghChEw0UMQrzqV9+sPcKMx
         tH9Th6EFbnB4Txv9Pp4iGeaAGDPQOA1/sC2dKVtrXef7001+3lqCzk1BgwobouVzVv
         X8GHlFHyMF9hg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, gor@linux.ibm.com,
        borntraeger@linux.ibm.com, egorenar@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, ebiederm@xmission.com,
        rppt@kernel.org, valentin.schneider@arm.com, iii@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 095/217] s390/nmi: add missing __pa/__va address conversion of extended save area
Date:   Mon, 17 Jan 2022 21:17:38 -0500
Message-Id: <20220118021940.1942199-95-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index 78a8ea6fd582a..2e280e812dfd1 100644
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

