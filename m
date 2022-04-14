Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83518501532
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241107AbiDNNhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245433AbiDNN25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:28:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067255FFE;
        Thu, 14 Apr 2022 06:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9330B612B3;
        Thu, 14 Apr 2022 13:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D45C385A1;
        Thu, 14 Apr 2022 13:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942570;
        bh=4v/yDrBNzH4Ef8dtWG9e+cTCiC46Aw75T/jxJC7wCug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTuSaIywNVLY/H2DEW81VwhYzbGqz+v7a1PWdwo0HR9vt4HoNYWv8tyVim+SiY88I
         iqEkjmXX2FiRtR1ei8SQfrEIDQ7xBDIZ8vcD6xSnd6UZEwqkIoagf5aQCrpY2P7xCP
         W4/vvRKGJg9ivcFv3A4xDIABpEDMtp1P72v+1g9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 182/338] xen: fix is_xen_pmu()
Date:   Thu, 14 Apr 2022 15:11:25 +0200
Message-Id: <20220414110844.077182109@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 41fd4c123165..e8248e8a04ca 100644
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



