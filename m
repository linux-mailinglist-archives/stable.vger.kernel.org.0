Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E2B657D99
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbiL1Poz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbiL1Pox (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:44:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BADA17589
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:44:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB88B6155C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC952C433D2;
        Wed, 28 Dec 2022 15:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242291;
        bh=WL2qH/J6cB6rB2qtkfSR0cCNIA8WdQICvDTEblt9lO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9PfORG9jZEaQHE6d56Bh7EsjqpxrXgJoc/5Tyt+In4zkV897sJ6MKMCjfMJshqZX
         dT2lNTn6dg30SLKQCjbb1Hh4cjvde5hlt/OQbUm3K6zKT3iMfwWF8QldF5F9mS5z2E
         otX/0w9PfA1zNqBiCp3IoHbR5vxK0bnHWCNxEluU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "H. Peter Anvin" <hpa@zytor.com>,
        Juergen Gross <jgross@suse.com>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0389/1073] x86/boot: Skip realmode init code when running as Xen PV guest
Date:   Wed, 28 Dec 2022 15:32:57 +0100
Message-Id: <20221228144338.581282370@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit f1e525009493cbd569e7c8dd7d58157855f8658d ]

When running as a Xen PV guest there is no need for setting up the
realmode trampoline, as realmode isn't supported in this environment.

Trying to setup the trampoline has been proven to be problematic in
some cases, especially when trying to debug early boot problems with
Xen requiring to keep the EFI boot-services memory mapped (some
firmware variants seem to claim basically all memory below 1Mb for boot
services).

Introduce new x86_platform_ops operations for that purpose, which can
be set to a NOP by the Xen PV specific kernel boot code.

  [ bp: s/call_init_real_mode/do_init_real_mode/ ]

Fixes: 084ee1c641a0 ("x86, realmode: Relocator for realmode code")
Suggested-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221123114523.3467-1-jgross@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/realmode.h | 1 +
 arch/x86/include/asm/x86_init.h | 4 ++++
 arch/x86/kernel/setup.c         | 2 +-
 arch/x86/kernel/x86_init.c      | 3 +++
 arch/x86/realmode/init.c        | 8 ++++++--
 arch/x86/xen/enlighten_pv.c     | 2 ++
 6 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index fd6f6e5b755a..a336feef0af1 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -91,6 +91,7 @@ static inline void set_real_mode_mem(phys_addr_t mem)
 
 void reserve_real_mode(void);
 void load_trampoline_pgtable(void);
+void init_real_mode(void);
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index e9170457697e..c1c8c581759d 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -285,6 +285,8 @@ struct x86_hyper_runtime {
  * 				possible in x86_early_init_platform_quirks() by
  * 				only using the current x86_hardware_subarch
  * 				semantics.
+ * @realmode_reserve:		reserve memory for realmode trampoline
+ * @realmode_init:		initialize realmode trampoline
  * @hyper:			x86 hypervisor specific runtime callbacks
  */
 struct x86_platform_ops {
@@ -301,6 +303,8 @@ struct x86_platform_ops {
 	void (*apic_post_init)(void);
 	struct x86_legacy_features legacy;
 	void (*set_legacy_features)(void);
+	void (*realmode_reserve)(void);
+	void (*realmode_init)(void);
 	struct x86_hyper_runtime hyper;
 	struct x86_guest guest;
 };
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 216fee7144ee..892609cde4a2 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1175,7 +1175,7 @@ void __init setup_arch(char **cmdline_p)
 	 * Moreover, on machines with SandyBridge graphics or in setups that use
 	 * crashkernel the entire 1M is reserved anyway.
 	 */
-	reserve_real_mode();
+	x86_platform.realmode_reserve();
 
 	init_mem_mapping();
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index e84ee5cdbd8c..3a164fb0d4c3 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -25,6 +25,7 @@
 #include <asm/iommu.h>
 #include <asm/mach_traps.h>
 #include <asm/irqdomain.h>
+#include <asm/realmode.h>
 
 void x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
@@ -145,6 +146,8 @@ struct x86_platform_ops x86_platform __ro_after_init = {
 	.get_nmi_reason			= default_get_nmi_reason,
 	.save_sched_clock_state		= tsc_save_sched_clock_state,
 	.restore_sched_clock_state	= tsc_restore_sched_clock_state,
+	.realmode_reserve		= reserve_real_mode,
+	.realmode_init			= init_real_mode,
 	.hyper.pin_vcpu			= x86_op_int_noop,
 
 	.guest = {
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 41d7669a97ad..af565816d2ba 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -200,14 +200,18 @@ static void __init set_real_mode_permissions(void)
 	set_memory_x((unsigned long) text_start, text_size >> PAGE_SHIFT);
 }
 
-static int __init init_real_mode(void)
+void __init init_real_mode(void)
 {
 	if (!real_mode_header)
 		panic("Real mode trampoline was not allocated");
 
 	setup_real_mode();
 	set_real_mode_permissions();
+}
 
+static int __init do_init_real_mode(void)
+{
+	x86_platform.realmode_init();
 	return 0;
 }
-early_initcall(init_real_mode);
+early_initcall(do_init_real_mode);
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 9b1a58dda935..807ab4fbe2c4 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1224,6 +1224,8 @@ asmlinkage __visible void __init xen_start_kernel(struct start_info *si)
 	xen_vcpu_info_reset(0);
 
 	x86_platform.get_nmi_reason = xen_get_nmi_reason;
+	x86_platform.realmode_reserve = x86_init_noop;
+	x86_platform.realmode_init = x86_init_noop;
 
 	x86_init.resources.memory_setup = xen_memory_setup;
 	x86_init.irqs.intr_mode_select	= x86_init_noop;
-- 
2.35.1



