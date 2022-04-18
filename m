Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9917505603
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241768AbiDRNbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244612AbiDRNal (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:30:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7539A6144;
        Mon, 18 Apr 2022 05:54:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63D0DB80EC3;
        Mon, 18 Apr 2022 12:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB90C385A1;
        Mon, 18 Apr 2022 12:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286484;
        bh=byHeeG9faknbptb0sA1k9OAu1OngGyaLFRh2btI4ejQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSFDfz0uOeRn+gWWf81Gmtm2cDpIl9nqDXaPSAyrKg9SH31erojnZYGcoNxQ+97NZ
         JvL2eiPknh7bbHOa45G7S3QPZJ8nytWO8O0YhrAsAlVIe8WgFcSZedjOugTsG58AFr
         oORERIc4kncdEk7Dof94vpJoCNRwVEmmowkws3sI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 149/284] xen: fix is_xen_pmu()
Date:   Mon, 18 Apr 2022 14:12:10 +0200
Message-Id: <20220418121215.856596286@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit de2ae403b4c0e79a3410e63bc448542fbb9f9bfc ]

is_xen_pmu() is taking the cpu number as parameter, but it is not using
it. Instead it just tests whether the Xen PMU initialization on the
current cpu did succeed. As this test is done by checking a percpu
pointer, preemption needs to be disabled in order to avoid switching
the cpu while doing the test. While resuming from suspend() this seems
not to be the case:

[   88.082751] ACPI: PM: Low-level resume complete
[   88.087933] ACPI: EC: EC started
[   88.091464] ACPI: PM: Restoring platform NVS memory
[   88.097166] xen_acpi_processor: Uploading Xen processor PM info
[   88.103850] Enabling non-boot CPUs ...
[   88.108128] installing Xen timer for CPU 1
[   88.112763] BUG: using smp_processor_id() in preemptible [00000000] code: systemd-sleep/7138
[   88.122256] caller is is_xen_pmu+0x12/0x30
[   88.126937] CPU: 0 PID: 7138 Comm: systemd-sleep Tainted: G        W         5.16.13-2.fc32.qubes.x86_64 #1
[   88.137939] Hardware name: Star Labs StarBook/StarBook, BIOS 7.97 03/21/2022
[   88.145930] Call Trace:
[   88.148757]  <TASK>
[   88.151193]  dump_stack_lvl+0x48/0x5e
[   88.155381]  check_preemption_disabled+0xde/0xe0
[   88.160641]  is_xen_pmu+0x12/0x30
[   88.164441]  xen_smp_intr_init_pv+0x75/0x100

Fix that by replacing is_xen_pmu() by a simple boolean variable which
reflects the Xen PMU initialization state on cpu 0.

Modify xen_pmu_init() to return early in case it is being called for a
cpu other than cpu 0 and the boolean variable not being set.

Fixes: bf6dfb154d93 ("xen/PMU: PMU emulation code")
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20220325142002.31789-1-jgross@suse.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/pmu.c    | 10 ++++------
 arch/x86/xen/pmu.h    |  3 ++-
 arch/x86/xen/smp_pv.c |  2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index 95997e6c0696..9813298ba57d 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -505,10 +505,7 @@ irqreturn_t xen_pmu_irq_handler(int irq, void *dev_id)
 	return ret;
 }
 
-bool is_xen_pmu(int cpu)
-{
-	return (get_xenpmu_data() != NULL);
-}
+bool is_xen_pmu;
 
 void xen_pmu_init(int cpu)
 {
@@ -519,7 +516,7 @@ void xen_pmu_init(int cpu)
 
 	BUILD_BUG_ON(sizeof(struct xen_pmu_data) > PAGE_SIZE);
 
-	if (xen_hvm_domain())
+	if (xen_hvm_domain() || (cpu != 0 && !is_xen_pmu))
 		return;
 
 	xenpmu_data = (struct xen_pmu_data *)get_zeroed_page(GFP_KERNEL);
@@ -540,7 +537,8 @@ void xen_pmu_init(int cpu)
 	per_cpu(xenpmu_shared, cpu).xenpmu_data = xenpmu_data;
 	per_cpu(xenpmu_shared, cpu).flags = 0;
 
-	if (cpu == 0) {
+	if (!is_xen_pmu) {
+		is_xen_pmu = true;
 		perf_register_guest_info_callbacks(&xen_guest_cbs);
 		xen_pmu_arch_init();
 	}
diff --git a/arch/x86/xen/pmu.h b/arch/x86/xen/pmu.h
index 0e83a160589b..65c58894fc79 100644
--- a/arch/x86/xen/pmu.h
+++ b/arch/x86/xen/pmu.h
@@ -4,6 +4,8 @@
 
 #include <xen/interface/xenpmu.h>
 
+extern bool is_xen_pmu;
+
 irqreturn_t xen_pmu_irq_handler(int irq, void *dev_id);
 #ifdef CONFIG_XEN_HAVE_VPMU
 void xen_pmu_init(int cpu);
@@ -12,7 +14,6 @@ void xen_pmu_finish(int cpu);
 static inline void xen_pmu_init(int cpu) {}
 static inline void xen_pmu_finish(int cpu) {}
 #endif
-bool is_xen_pmu(int cpu);
 bool pmu_msr_read(unsigned int msr, uint64_t *val, int *err);
 bool pmu_msr_write(unsigned int msr, uint32_t low, uint32_t high, int *err);
 int pmu_apic_update(uint32_t reg);
diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
index f779d2a5b04c..54ffe4ddf9f9 100644
--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -126,7 +126,7 @@ int xen_smp_intr_init_pv(unsigned int cpu)
 	per_cpu(xen_irq_work, cpu).irq = rc;
 	per_cpu(xen_irq_work, cpu).name = callfunc_name;
 
-	if (is_xen_pmu(cpu)) {
+	if (is_xen_pmu) {
 		pmu_name = kasprintf(GFP_KERNEL, "pmu%d", cpu);
 		rc = bind_virq_to_irqhandler(VIRQ_XENPMU, cpu,
 					     xen_pmu_irq_handler,
-- 
2.34.1



