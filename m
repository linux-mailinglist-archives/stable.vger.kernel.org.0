Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64270657889
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbiL1OwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiL1Ovz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:51:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5AE12628
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:51:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE93161365
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E342BC433D2;
        Wed, 28 Dec 2022 14:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239085;
        bh=a30lcUAUkVhTXqbEPEJwUaKuaBs4RVEPcVVf/mU1yTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/PasEldQHVQBBkAIJouPAc6LCbOueGP0rp5XQSLxdam7VExsUsLDego7dWZq3erU
         l3GEI/K9DpYoX88mm6n+tNGl05KmSlr+ooaLkXm6L4dByOFX3AoiMSCVRGArMiZtr2
         1HzCunpXw6A7mdjuSieQqCjbga+ImkmT8ENzxoFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/731] x86/xen: Fix memory leak in xen_smp_intr_init{_pv}()
Date:   Wed, 28 Dec 2022 15:33:50 +0100
Message-Id: <20221228144300.118403027@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit 69143f60868b3939ddc89289b29db593b647295e ]

These local variables @{resched|pmu|callfunc...}_name saves the new
string allocated by kasprintf(), and when bind_{v}ipi_to_irqhandler()
fails, it goes to the @fail tag, and calls xen_smp_intr_free{_pv}() to
free resource, however the new string is not saved, which cause a memory
leak issue. fix it.

Fixes: 9702785a747a ("i386: move xen")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20221123155858.11382-2-xiujianfeng@huawei.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/smp.c    | 24 ++++++++++++------------
 arch/x86/xen/smp_pv.c | 12 ++++++------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index c1b2f764b29a..cdec892b28e2 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -32,30 +32,30 @@ static irqreturn_t xen_reschedule_interrupt(int irq, void *dev_id)
 
 void xen_smp_intr_free(unsigned int cpu)
 {
+	kfree(per_cpu(xen_resched_irq, cpu).name);
+	per_cpu(xen_resched_irq, cpu).name = NULL;
 	if (per_cpu(xen_resched_irq, cpu).irq >= 0) {
 		unbind_from_irqhandler(per_cpu(xen_resched_irq, cpu).irq, NULL);
 		per_cpu(xen_resched_irq, cpu).irq = -1;
-		kfree(per_cpu(xen_resched_irq, cpu).name);
-		per_cpu(xen_resched_irq, cpu).name = NULL;
 	}
+	kfree(per_cpu(xen_callfunc_irq, cpu).name);
+	per_cpu(xen_callfunc_irq, cpu).name = NULL;
 	if (per_cpu(xen_callfunc_irq, cpu).irq >= 0) {
 		unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu).irq, NULL);
 		per_cpu(xen_callfunc_irq, cpu).irq = -1;
-		kfree(per_cpu(xen_callfunc_irq, cpu).name);
-		per_cpu(xen_callfunc_irq, cpu).name = NULL;
 	}
+	kfree(per_cpu(xen_debug_irq, cpu).name);
+	per_cpu(xen_debug_irq, cpu).name = NULL;
 	if (per_cpu(xen_debug_irq, cpu).irq >= 0) {
 		unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu).irq, NULL);
 		per_cpu(xen_debug_irq, cpu).irq = -1;
-		kfree(per_cpu(xen_debug_irq, cpu).name);
-		per_cpu(xen_debug_irq, cpu).name = NULL;
 	}
+	kfree(per_cpu(xen_callfuncsingle_irq, cpu).name);
+	per_cpu(xen_callfuncsingle_irq, cpu).name = NULL;
 	if (per_cpu(xen_callfuncsingle_irq, cpu).irq >= 0) {
 		unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu).irq,
 				       NULL);
 		per_cpu(xen_callfuncsingle_irq, cpu).irq = -1;
-		kfree(per_cpu(xen_callfuncsingle_irq, cpu).name);
-		per_cpu(xen_callfuncsingle_irq, cpu).name = NULL;
 	}
 }
 
@@ -65,6 +65,7 @@ int xen_smp_intr_init(unsigned int cpu)
 	char *resched_name, *callfunc_name, *debug_name;
 
 	resched_name = kasprintf(GFP_KERNEL, "resched%d", cpu);
+	per_cpu(xen_resched_irq, cpu).name = resched_name;
 	rc = bind_ipi_to_irqhandler(XEN_RESCHEDULE_VECTOR,
 				    cpu,
 				    xen_reschedule_interrupt,
@@ -74,9 +75,9 @@ int xen_smp_intr_init(unsigned int cpu)
 	if (rc < 0)
 		goto fail;
 	per_cpu(xen_resched_irq, cpu).irq = rc;
-	per_cpu(xen_resched_irq, cpu).name = resched_name;
 
 	callfunc_name = kasprintf(GFP_KERNEL, "callfunc%d", cpu);
+	per_cpu(xen_callfunc_irq, cpu).name = callfunc_name;
 	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_VECTOR,
 				    cpu,
 				    xen_call_function_interrupt,
@@ -86,10 +87,10 @@ int xen_smp_intr_init(unsigned int cpu)
 	if (rc < 0)
 		goto fail;
 	per_cpu(xen_callfunc_irq, cpu).irq = rc;
-	per_cpu(xen_callfunc_irq, cpu).name = callfunc_name;
 
 	if (!xen_fifo_events) {
 		debug_name = kasprintf(GFP_KERNEL, "debug%d", cpu);
+		per_cpu(xen_debug_irq, cpu).name = debug_name;
 		rc = bind_virq_to_irqhandler(VIRQ_DEBUG, cpu,
 					     xen_debug_interrupt,
 					     IRQF_PERCPU | IRQF_NOBALANCING,
@@ -97,10 +98,10 @@ int xen_smp_intr_init(unsigned int cpu)
 		if (rc < 0)
 			goto fail;
 		per_cpu(xen_debug_irq, cpu).irq = rc;
-		per_cpu(xen_debug_irq, cpu).name = debug_name;
 	}
 
 	callfunc_name = kasprintf(GFP_KERNEL, "callfuncsingle%d", cpu);
+	per_cpu(xen_callfuncsingle_irq, cpu).name = callfunc_name;
 	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_SINGLE_VECTOR,
 				    cpu,
 				    xen_call_function_single_interrupt,
@@ -110,7 +111,6 @@ int xen_smp_intr_init(unsigned int cpu)
 	if (rc < 0)
 		goto fail;
 	per_cpu(xen_callfuncsingle_irq, cpu).irq = rc;
-	per_cpu(xen_callfuncsingle_irq, cpu).name = callfunc_name;
 
 	return 0;
 
diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
index cd5539fc5eb4..b47b5111397a 100644
--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -97,18 +97,18 @@ asmlinkage __visible void cpu_bringup_and_idle(void)
 
 void xen_smp_intr_free_pv(unsigned int cpu)
 {
+	kfree(per_cpu(xen_irq_work, cpu).name);
+	per_cpu(xen_irq_work, cpu).name = NULL;
 	if (per_cpu(xen_irq_work, cpu).irq >= 0) {
 		unbind_from_irqhandler(per_cpu(xen_irq_work, cpu).irq, NULL);
 		per_cpu(xen_irq_work, cpu).irq = -1;
-		kfree(per_cpu(xen_irq_work, cpu).name);
-		per_cpu(xen_irq_work, cpu).name = NULL;
 	}
 
+	kfree(per_cpu(xen_pmu_irq, cpu).name);
+	per_cpu(xen_pmu_irq, cpu).name = NULL;
 	if (per_cpu(xen_pmu_irq, cpu).irq >= 0) {
 		unbind_from_irqhandler(per_cpu(xen_pmu_irq, cpu).irq, NULL);
 		per_cpu(xen_pmu_irq, cpu).irq = -1;
-		kfree(per_cpu(xen_pmu_irq, cpu).name);
-		per_cpu(xen_pmu_irq, cpu).name = NULL;
 	}
 }
 
@@ -118,6 +118,7 @@ int xen_smp_intr_init_pv(unsigned int cpu)
 	char *callfunc_name, *pmu_name;
 
 	callfunc_name = kasprintf(GFP_KERNEL, "irqwork%d", cpu);
+	per_cpu(xen_irq_work, cpu).name = callfunc_name;
 	rc = bind_ipi_to_irqhandler(XEN_IRQ_WORK_VECTOR,
 				    cpu,
 				    xen_irq_work_interrupt,
@@ -127,10 +128,10 @@ int xen_smp_intr_init_pv(unsigned int cpu)
 	if (rc < 0)
 		goto fail;
 	per_cpu(xen_irq_work, cpu).irq = rc;
-	per_cpu(xen_irq_work, cpu).name = callfunc_name;
 
 	if (is_xen_pmu) {
 		pmu_name = kasprintf(GFP_KERNEL, "pmu%d", cpu);
+		per_cpu(xen_pmu_irq, cpu).name = pmu_name;
 		rc = bind_virq_to_irqhandler(VIRQ_XENPMU, cpu,
 					     xen_pmu_irq_handler,
 					     IRQF_PERCPU|IRQF_NOBALANCING,
@@ -138,7 +139,6 @@ int xen_smp_intr_init_pv(unsigned int cpu)
 		if (rc < 0)
 			goto fail;
 		per_cpu(xen_pmu_irq, cpu).irq = rc;
-		per_cpu(xen_pmu_irq, cpu).name = pmu_name;
 	}
 
 	return 0;
-- 
2.35.1



