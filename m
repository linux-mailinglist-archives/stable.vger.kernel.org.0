Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E6466C9EF
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbjAPQ5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbjAPQ5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:57:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E4F241C6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:40:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 972496105A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A369EC433D2;
        Mon, 16 Jan 2023 16:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887221;
        bh=B+vkLlySk54vdl+8iZ/nzFqfefPkw456WI6vL6o8vCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffPwr/xFmTAvKNXfc85LAR4mrHFeFKW7jlemx/VAudVx+tsWrWbJwOkHK8lY5nAhP
         gdfTKc1Ck6+cPDxHBqkYw1gq9ePVZqly4kz1PvraBuJvWsGMG9VimKkauMmRo1c6S/
         HX9s9PHsqkYxdkDBflniOHqkgmekqJ52K4+vIy/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/521] xen/events: only register debug interrupt for 2-level events
Date:   Mon, 16 Jan 2023 16:45:28 +0100
Message-Id: <20230116154850.189513257@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit d04b1ae5a9b0c868dda8b4b34175ef08f3cb9e93 ]

xen_debug_interrupt() is specific to 2-level event handling. So don't
register it with fifo event handling being active.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Link: https://lore.kernel.org/r/20201022094907.28560-4-jgross@suse.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Stable-dep-of: 69143f60868b ("x86/xen: Fix memory leak in xen_smp_intr_init{_pv}()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/smp.c               | 19 +++++++++++--------
 arch/x86/xen/xen-ops.h           |  2 ++
 drivers/xen/events/events_base.c | 10 ++++++----
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 7a43b2ae19f1..63a3605b2225 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -88,14 +88,17 @@ int xen_smp_intr_init(unsigned int cpu)
 	per_cpu(xen_callfunc_irq, cpu).irq = rc;
 	per_cpu(xen_callfunc_irq, cpu).name = callfunc_name;
 
-	debug_name = kasprintf(GFP_KERNEL, "debug%d", cpu);
-	rc = bind_virq_to_irqhandler(VIRQ_DEBUG, cpu, xen_debug_interrupt,
-				     IRQF_PERCPU | IRQF_NOBALANCING,
-				     debug_name, NULL);
-	if (rc < 0)
-		goto fail;
-	per_cpu(xen_debug_irq, cpu).irq = rc;
-	per_cpu(xen_debug_irq, cpu).name = debug_name;
+	if (!xen_fifo_events) {
+		debug_name = kasprintf(GFP_KERNEL, "debug%d", cpu);
+		rc = bind_virq_to_irqhandler(VIRQ_DEBUG, cpu,
+					     xen_debug_interrupt,
+					     IRQF_PERCPU | IRQF_NOBALANCING,
+					     debug_name, NULL);
+		if (rc < 0)
+			goto fail;
+		per_cpu(xen_debug_irq, cpu).irq = rc;
+		per_cpu(xen_debug_irq, cpu).name = debug_name;
+	}
 
 	callfunc_name = kasprintf(GFP_KERNEL, "callfuncsingle%d", cpu);
 	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_SINGLE_VECTOR,
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 2f111f47ba98..9faec8543237 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -30,6 +30,8 @@ extern struct start_info *xen_start_info;
 extern struct shared_info xen_dummy_shared_info;
 extern struct shared_info *HYPERVISOR_shared_info;
 
+extern bool xen_fifo_events;
+
 void xen_setup_mfn_list_list(void);
 void xen_build_mfn_list_list(void);
 void xen_setup_machphys_mapping(void);
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index d138027034fd..b6b3131cb079 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -2100,8 +2100,8 @@ void xen_callback_vector(void)
 void xen_callback_vector(void) {}
 #endif
 
-static bool fifo_events = true;
-module_param(fifo_events, bool, 0);
+bool xen_fifo_events = true;
+module_param_named(fifo_events, xen_fifo_events, bool, 0);
 
 static int xen_evtchn_cpu_prepare(unsigned int cpu)
 {
@@ -2130,10 +2130,12 @@ void __init xen_init_IRQ(void)
 	int ret = -EINVAL;
 	unsigned int evtchn;
 
-	if (fifo_events)
+	if (xen_fifo_events)
 		ret = xen_evtchn_fifo_init();
-	if (ret < 0)
+	if (ret < 0) {
 		xen_evtchn_2l_init();
+		xen_fifo_events = false;
+	}
 
 	xen_cpu_init_eoi(smp_processor_id());
 
-- 
2.35.1



