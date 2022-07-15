Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDDB576396
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 16:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbiGOOZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 10:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiGOOZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 10:25:55 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45936A9E5;
        Fri, 15 Jul 2022 07:25:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 80F2934DD4;
        Fri, 15 Jul 2022 14:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657895153; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xntJCVnqXRvk9vE3Jl/BFSzPfnA84i+bvpB8MsbTJGc=;
        b=lOgqztde0SbRvIEqM6HAvbK3tjPLn1bvAuQVuCXa9oRPJPnmWvKxrugSZxsdfLzsOOX/dl
        R2FwYYKg48SifuMNapYEea3ILYC/mlWR0DFoBH9jjhbI3Oriu1ZjiY+MtSyhjtmuSSAmsJ
        5k0k4Q/GW+N3aIW6S88sM87/E5K8kIc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1D52B13754;
        Fri, 15 Jul 2022 14:25:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +OLnBfF40WK+QQAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 15 Jul 2022 14:25:53 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc:     brchuckz@netscape.net, jbeulich@suse.com,
        Juergen Gross <jgross@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, stable@vger.kernel.org
Subject: [PATCH 2/3] x86: add wrapper functions for mtrr functions handling also pat
Date:   Fri, 15 Jul 2022 16:25:48 +0200
Message-Id: <20220715142549.25223-3-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220715142549.25223-1-jgross@suse.com>
References: <20220715142549.25223-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are several MTRR functions which also do PAT handling. In order
to support PAT handling without MTRR in the future, add some wrappers
for those functions.

Cc: <stable@vger.kernel.org> # 5.17
Fixes: bdd8b6c98239 ("drm/i915: replace X86_FEATURE_PAT with pat_enabled()")
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/mtrr.h      |  2 --
 arch/x86/include/asm/processor.h |  7 +++++
 arch/x86/kernel/cpu/common.c     | 44 +++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/mtrr/mtrr.c  | 25 +++---------------
 arch/x86/kernel/setup.c          |  5 +---
 arch/x86/kernel/smpboot.c        |  8 +++---
 arch/x86/power/cpu.c             |  2 +-
 7 files changed, 59 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index 12a16caed395..900083ac9f60 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -43,7 +43,6 @@ extern int mtrr_del(int reg, unsigned long base, unsigned long size);
 extern int mtrr_del_page(int reg, unsigned long base, unsigned long size);
 extern void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi);
 extern void mtrr_ap_init(void);
-extern void set_mtrr_aps_delayed_init(void);
 extern void mtrr_aps_init(void);
 extern void mtrr_bp_restore(void);
 extern int mtrr_trim_uncached_memory(unsigned long end_pfn);
@@ -86,7 +85,6 @@ static inline void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi)
 {
 }
 #define mtrr_ap_init() do {} while (0)
-#define set_mtrr_aps_delayed_init() do {} while (0)
 #define mtrr_aps_init() do {} while (0)
 #define mtrr_bp_restore() do {} while (0)
 #define mtrr_disable() do {} while (0)
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 5c934b922450..e2140204fb7e 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -865,7 +865,14 @@ bool arch_is_platform_page(u64 paddr);
 #define arch_is_platform_page arch_is_platform_page
 #endif
 
+extern bool cache_aps_delayed_init;
+
 void cache_disable(void);
 void cache_enable(void);
+void cache_bp_init(void);
+void cache_ap_init(void);
+void cache_set_aps_delayed_init(void);
+void cache_aps_init(void);
+void cache_bp_restore(void);
 
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e43322f8a4ef..0a1bd14f7966 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1929,7 +1929,7 @@ void identify_secondary_cpu(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_32
 	enable_sep_cpu();
 #endif
-	mtrr_ap_init();
+	cache_ap_init();
 	validate_apic_and_package_id(c);
 	x86_spec_ctrl_setup_ap();
 	update_srbds_msr();
@@ -2403,3 +2403,45 @@ void cache_enable(void) __releases(cache_disable_lock)
 
 	raw_spin_unlock(&cache_disable_lock);
 }
+
+void __init cache_bp_init(void)
+{
+	if (IS_ENABLED(CONFIG_MTRR))
+		mtrr_bp_init();
+	else
+		pat_disable("PAT support disabled because CONFIG_MTRR is disabled in the kernel.");
+}
+
+void cache_ap_init(void)
+{
+	if (cache_aps_delayed_init)
+		return;
+
+	mtrr_ap_init();
+}
+
+bool cache_aps_delayed_init;
+
+void cache_set_aps_delayed_init(void)
+{
+	cache_aps_delayed_init = true;
+}
+
+void cache_aps_init(void)
+{
+	/*
+	 * Check if someone has requested the delay of AP cache initialization,
+	 * by doing cache_set_aps_delayed_init(), prior to this point. If not,
+	 * then we are done.
+	 */
+	if (!cache_aps_delayed_init)
+		return;
+
+	mtrr_aps_init();
+	cache_aps_delayed_init = false;
+}
+
+void cache_bp_restore(void)
+{
+	mtrr_bp_restore();
+}
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.c b/arch/x86/kernel/cpu/mtrr/mtrr.c
index 2746cac9d8a9..c1593cfae641 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.c
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.c
@@ -69,7 +69,6 @@ unsigned int mtrr_usage_table[MTRR_MAX_VAR_RANGES];
 static DEFINE_MUTEX(mtrr_mutex);
 
 u64 size_or_mask, size_and_mask;
-static bool mtrr_aps_delayed_init;
 
 static const struct mtrr_ops *mtrr_ops[X86_VENDOR_NUM] __ro_after_init;
 
@@ -176,7 +175,8 @@ static int mtrr_rendezvous_handler(void *info)
 	if (data->smp_reg != ~0U) {
 		mtrr_if->set(data->smp_reg, data->smp_base,
 			     data->smp_size, data->smp_type);
-	} else if (mtrr_aps_delayed_init || !cpu_online(smp_processor_id())) {
+	} else if ((use_intel() && cache_aps_delayed_init) ||
+		   !cpu_online(smp_processor_id())) {
 		mtrr_if->set_all();
 	}
 	return 0;
@@ -789,7 +789,7 @@ void mtrr_ap_init(void)
 	if (!mtrr_enabled())
 		return;
 
-	if (!use_intel() || mtrr_aps_delayed_init)
+	if (!use_intel())
 		return;
 
 	/*
@@ -823,16 +823,6 @@ void mtrr_save_state(void)
 	smp_call_function_single(first_cpu, mtrr_save_fixed_ranges, NULL, 1);
 }
 
-void set_mtrr_aps_delayed_init(void)
-{
-	if (!mtrr_enabled())
-		return;
-	if (!use_intel())
-		return;
-
-	mtrr_aps_delayed_init = true;
-}
-
 /*
  * Delayed MTRR initialization for all AP's
  */
@@ -841,16 +831,7 @@ void mtrr_aps_init(void)
 	if (!use_intel() || !mtrr_enabled())
 		return;
 
-	/*
-	 * Check if someone has requested the delay of AP MTRR initialization,
-	 * by doing set_mtrr_aps_delayed_init(), prior to this point. If not,
-	 * then we are done.
-	 */
-	if (!mtrr_aps_delayed_init)
-		return;
-
 	set_mtrr(~0U, 0, 0, 0);
-	mtrr_aps_delayed_init = false;
 }
 
 void mtrr_bp_restore(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index bd6c6fd373ae..27d61f73c68a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1001,10 +1001,7 @@ void __init setup_arch(char **cmdline_p)
 	max_pfn = e820__end_of_ram_pfn();
 
 	/* update e820 for memory not covered by WB MTRRs */
-	if (IS_ENABLED(CONFIG_MTRR))
-		mtrr_bp_init();
-	else
-		pat_disable("PAT support disabled because CONFIG_MTRR is disabled in the kernel.");
+	cache_bp_init();
 
 	if (mtrr_trim_uncached_memory(max_pfn))
 		max_pfn = e820__end_of_ram_pfn();
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5e7f9532a10d..535d73a47062 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1432,7 +1432,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	uv_system_init();
 
-	set_mtrr_aps_delayed_init();
+	cache_set_aps_delayed_init();
 
 	smp_quirk_init_udelay();
 
@@ -1443,12 +1443,12 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 void arch_thaw_secondary_cpus_begin(void)
 {
-	set_mtrr_aps_delayed_init();
+	cache_set_aps_delayed_init();
 }
 
 void arch_thaw_secondary_cpus_end(void)
 {
-	mtrr_aps_init();
+	cache_aps_init();
 }
 
 /*
@@ -1491,7 +1491,7 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 
 	nmi_selftest();
 	impress_friends();
-	mtrr_aps_init();
+	cache_aps_init();
 }
 
 static int __initdata setup_possible_cpus = -1;
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index bb176c72891c..21e014715322 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -261,7 +261,7 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
 	do_fpu_end();
 	tsc_verify_tsc_adjust(true);
 	x86_platform.restore_sched_clock_state();
-	mtrr_bp_restore();
+	cache_bp_restore();
 	perf_restore_debug_store();
 
 	c = &cpu_data(smp_processor_id());
-- 
2.35.3

