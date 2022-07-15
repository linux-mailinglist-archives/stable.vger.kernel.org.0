Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF922576399
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 16:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbiGOOZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 10:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbiGOOZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 10:25:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6BD6BC3C;
        Fri, 15 Jul 2022 07:25:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F419634DD5;
        Fri, 15 Jul 2022 14:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657895154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vwUbrqUUHvFoVh3Zv7qCqQxs3hoqoCxPCyuEJqRoUEM=;
        b=ANCRktCNdbwJrH1JJDcdGCzxaLCVeh7q2T72wPJjvT6lgNoOU4jRPubM60FZJ0pFrZQyLu
        6Ka5m5KPYPmolEHu7zfcIXo5p3SnSBIP3r5SzvByFDah0ynL6x2M5mFCiilSfsV4zPjePI
        j2kL3wL2uTim4xmH1slYYf1MYzImfmo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 89D0F13754;
        Fri, 15 Jul 2022 14:25:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WJg6IPF40WK+QQAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 15 Jul 2022 14:25:53 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     brchuckz@netscape.net, jbeulich@suse.com,
        Juergen Gross <jgross@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] x86: decouple pat and mtrr handling
Date:   Fri, 15 Jul 2022 16:25:49 +0200
Message-Id: <20220715142549.25223-4-jgross@suse.com>
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

Today PAT is usable only with MTRR being active, with some nasty tweaks
to make PAT usable when running as Xen PV guest, which doesn't support
MTRR.

The reason for this coupling is, that both, PAT MSR changes and MTRR
changes, require a similar sequence and so full PAT support was added
using the already available MTRR handling.

Xen PV PAT handling can work without MTRR, as it just needs to consume
the PAT MSR setting done by the hypervisor without the ability and need
to change it. This in turn has resulted in a convoluted initialization
sequence and wrong decisions regarding cache mode availability due to
misguiding PAT availability flags.

Fix all of that by allowing to use PAT without MTRR and by adding an
environment dependent PAT init function.

Cc: <stable@vger.kernel.org> # 5.17
Fixes: bdd8b6c98239 ("drm/i915: replace X86_FEATURE_PAT with pat_enabled()")
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/memtype.h     |  13 ++-
 arch/x86/include/asm/mtrr.h        |  21 +++--
 arch/x86/kernel/cpu/common.c       |  13 +--
 arch/x86/kernel/cpu/mtrr/generic.c |  14 ----
 arch/x86/kernel/cpu/mtrr/mtrr.c    |  33 ++++----
 arch/x86/kernel/cpu/mtrr/mtrr.h    |   1 -
 arch/x86/kernel/setup.c            |   7 --
 arch/x86/mm/pat/memtype.c          | 127 +++++++++++++++++++++--------
 arch/x86/xen/enlighten_pv.c        |   4 +
 9 files changed, 146 insertions(+), 87 deletions(-)

diff --git a/arch/x86/include/asm/memtype.h b/arch/x86/include/asm/memtype.h
index 9ca760e430b9..93ad980631dc 100644
--- a/arch/x86/include/asm/memtype.h
+++ b/arch/x86/include/asm/memtype.h
@@ -8,7 +8,18 @@
 extern bool pat_enabled(void);
 extern void pat_disable(const char *reason);
 extern void pat_init(void);
-extern void init_cache_modes(void);
+#ifdef CONFIG_X86_PAT
+void pat_init_set(void (*func)(void));
+void pat_init_noset(void);
+void pat_cpu_init(void);
+void pat_ap_init_nomtrr(void);
+void pat_aps_init_nomtrr(void);
+#else
+#define pat_init_set(f) do { } while (0)
+#define pat_cpu_init(f) do { } while (0)
+#define pat_ap_init_nomtrr(f) do { } while (0)
+#define pat_aps_init_nomtrr(f) do { } while (0)
+#endif
 
 extern int memtype_reserve(u64 start, u64 end,
 		enum page_cache_mode req_pcm, enum page_cache_mode *ret_pcm);
diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index 900083ac9f60..bb76e5c6e21d 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -42,9 +42,9 @@ extern int mtrr_add_page(unsigned long base, unsigned long size,
 extern int mtrr_del(int reg, unsigned long base, unsigned long size);
 extern int mtrr_del_page(int reg, unsigned long base, unsigned long size);
 extern void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi);
-extern void mtrr_ap_init(void);
-extern void mtrr_aps_init(void);
-extern void mtrr_bp_restore(void);
+extern bool mtrr_ap_init(void);
+extern bool mtrr_aps_init(void);
+extern bool mtrr_bp_restore(void);
 extern int mtrr_trim_uncached_memory(unsigned long end_pfn);
 extern int amd_special_default_mtrr(void);
 void mtrr_disable(void);
@@ -84,9 +84,18 @@ static inline int mtrr_trim_uncached_memory(unsigned long end_pfn)
 static inline void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi)
 {
 }
-#define mtrr_ap_init() do {} while (0)
-#define mtrr_aps_init() do {} while (0)
-#define mtrr_bp_restore() do {} while (0)
+static inline bool mtrr_ap_init(void)
+{
+	return false;
+}
+static inline bool mtrr_aps_init(void)
+{
+	return false;
+}
+static inline bool mtrr_bp_restore(void)
+{
+	return false;
+}
 #define mtrr_disable() do {} while (0)
 #define mtrr_enable() do {} while (0)
 #  endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0a1bd14f7966..3edfb779dab5 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2408,8 +2408,8 @@ void __init cache_bp_init(void)
 {
 	if (IS_ENABLED(CONFIG_MTRR))
 		mtrr_bp_init();
-	else
-		pat_disable("PAT support disabled because CONFIG_MTRR is disabled in the kernel.");
+
+	pat_cpu_init();
 }
 
 void cache_ap_init(void)
@@ -2417,7 +2417,8 @@ void cache_ap_init(void)
 	if (cache_aps_delayed_init)
 		return;
 
-	mtrr_ap_init();
+	if (!mtrr_ap_init())
+		pat_ap_init_nomtrr();
 }
 
 bool cache_aps_delayed_init;
@@ -2437,11 +2438,13 @@ void cache_aps_init(void)
 	if (!cache_aps_delayed_init)
 		return;
 
-	mtrr_aps_init();
+	if (!mtrr_aps_init())
+		pat_aps_init_nomtrr();
 	cache_aps_delayed_init = false;
 }
 
 void cache_bp_restore(void)
 {
-	mtrr_bp_restore();
+	if (!mtrr_bp_restore())
+		pat_cpu_init();
 }
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 84732215b61d..bb6dd96923a4 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -441,20 +441,6 @@ static void __init print_mtrr_state(void)
 		pr_debug("TOM2: %016llx aka %lldM\n", mtrr_tom2, mtrr_tom2>>20);
 }
 
-/* PAT setup for BP. We need to go through sync steps here */
-void __init mtrr_bp_pat_init(void)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	cache_disable();
-
-	pat_init();
-
-	cache_enable();
-	local_irq_restore(flags);
-}
-
 /* Grab all of the MTRR state for this CPU into *state */
 bool __init get_mtrr_state(void)
 {
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.c b/arch/x86/kernel/cpu/mtrr/mtrr.c
index c1593cfae641..76b1553d90f9 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.c
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.c
@@ -762,9 +762,6 @@ void __init mtrr_bp_init(void)
 			/* BIOS may override */
 			__mtrr_enabled = get_mtrr_state();
 
-			if (mtrr_enabled())
-				mtrr_bp_pat_init();
-
 			if (mtrr_cleanup(phys_addr)) {
 				changed_by_mtrr_cleanup = 1;
 				mtrr_if->set_all();
@@ -772,25 +769,17 @@ void __init mtrr_bp_init(void)
 		}
 	}
 
-	if (!mtrr_enabled()) {
+	if (!mtrr_enabled())
 		pr_info("Disabled\n");
-
-		/*
-		 * PAT initialization relies on MTRR's rendezvous handler.
-		 * Skip PAT init until the handler can initialize both
-		 * features independently.
-		 */
-		pat_disable("MTRRs disabled, skipping PAT initialization too.");
-	}
 }
 
-void mtrr_ap_init(void)
+bool mtrr_ap_init(void)
 {
 	if (!mtrr_enabled())
-		return;
+		return false;
 
 	if (!use_intel())
-		return;
+		return false;
 
 	/*
 	 * Ideally we should hold mtrr_mutex here to avoid mtrr entries
@@ -806,6 +795,8 @@ void mtrr_ap_init(void)
 	 *      lock to prevent mtrr entry changes
 	 */
 	set_mtrr_from_inactive_cpu(~0U, 0, 0, 0);
+
+	return true;
 }
 
 /**
@@ -826,20 +817,24 @@ void mtrr_save_state(void)
 /*
  * Delayed MTRR initialization for all AP's
  */
-void mtrr_aps_init(void)
+bool mtrr_aps_init(void)
 {
 	if (!use_intel() || !mtrr_enabled())
-		return;
+		return false;
 
 	set_mtrr(~0U, 0, 0, 0);
+
+	return true;
 }
 
-void mtrr_bp_restore(void)
+bool mtrr_bp_restore(void)
 {
 	if (!use_intel() || !mtrr_enabled())
-		return;
+		return false;
 
 	mtrr_if->set_all();
+
+	return true;
 }
 
 static int __init mtrr_init_finialize(void)
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index 2ac99e561181..f6135a539073 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -53,7 +53,6 @@ void set_mtrr_prepare_save(struct set_mtrr_context *ctxt);
 void fill_mtrr_var_range(unsigned int index,
 		u32 base_lo, u32 base_hi, u32 mask_lo, u32 mask_hi);
 bool get_mtrr_state(void);
-void mtrr_bp_pat_init(void);
 
 extern void __init set_mtrr_ops(const struct mtrr_ops *ops);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 27d61f73c68a..14bb40cd22c6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1008,13 +1008,6 @@ void __init setup_arch(char **cmdline_p)
 
 	max_possible_pfn = max_pfn;
 
-	/*
-	 * This call is required when the CPU does not support PAT. If
-	 * mtrr_bp_init() invoked it already via pat_init() the call has no
-	 * effect.
-	 */
-	init_cache_modes();
-
 	/*
 	 * Define random base addresses for memory sections after max_pfn is
 	 * defined and before each memory section base is used.
diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index d5ef64ddd35e..3d4bc27ffebb 100644
--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -41,6 +41,7 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/rbtree.h>
+#include <linux/stop_machine.h>
 
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
@@ -65,30 +66,23 @@ static bool __read_mostly pat_disabled = !IS_ENABLED(CONFIG_X86_PAT);
 static bool __read_mostly pat_bp_enabled;
 static bool __read_mostly pat_cm_initialized;
 
-/*
- * PAT support is enabled by default, but can be disabled for
- * various user-requested or hardware-forced reasons:
- */
-void pat_disable(const char *msg_reason)
-{
-	if (pat_disabled)
-		return;
+static void init_cache_modes(void);
 
-	if (pat_bp_initialized) {
-		WARN_ONCE(1, "x86/PAT: PAT cannot be disabled after initialization\n");
-		return;
-	}
-
-	pat_disabled = true;
-	pr_info("x86/PAT: %s\n", msg_reason);
+#ifdef CONFIG_X86_PAT
+static void pat_init_nopat(void)
+{
+	init_cache_modes();
 }
 
 static int __init nopat(char *str)
 {
-	pat_disable("PAT support disabled via boot option.");
+	pat_disabled = true;
+	pr_info("PAT support disabled via boot option.");
+	pat_init_set(pat_init_nopat);
 	return 0;
 }
 early_param("nopat", nopat);
+#endif
 
 bool pat_enabled(void)
 {
@@ -243,13 +237,17 @@ static void pat_bp_init(u64 pat)
 	u64 tmp_pat;
 
 	if (!boot_cpu_has(X86_FEATURE_PAT)) {
-		pat_disable("PAT not supported by the CPU.");
+		pr_info("PAT not supported by the CPU.");
+		pat_disabled = true;
+		pat_init_set(pat_init_nopat);
 		return;
 	}
 
 	rdmsrl(MSR_IA32_CR_PAT, tmp_pat);
 	if (!tmp_pat) {
-		pat_disable("PAT support disabled by the firmware.");
+		pr_info("PAT support disabled by the firmware.");
+		pat_disabled = true;
+		pat_init_set(pat_init_nopat);
 		return;
 	}
 
@@ -272,7 +270,7 @@ static void pat_ap_init(u64 pat)
 	wrmsrl(MSR_IA32_CR_PAT, pat);
 }
 
-void init_cache_modes(void)
+static void init_cache_modes(void)
 {
 	u64 pat = 0;
 
@@ -318,25 +316,12 @@ void init_cache_modes(void)
 	__init_cache_modes(pat);
 }
 
-/**
- * pat_init - Initialize the PAT MSR and PAT table on the current CPU
- *
- * This function initializes PAT MSR and PAT table with an OS-defined value
- * to enable additional cache attributes, WC, WT and WP.
- *
- * This function must be called on all CPUs using the specific sequence of
- * operations defined in Intel SDM. mtrr_rendezvous_handler() provides this
- * procedure for PAT.
- */
-void pat_init(void)
+#ifdef CONFIG_X86_PAT
+static void pat_init_native(void)
 {
 	u64 pat;
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
-#ifndef CONFIG_X86_PAT
-	pr_info_once("x86/PAT: PAT support disabled because CONFIG_X86_PAT is disabled in the kernel.\n");
-#endif
-
 	if (pat_disabled)
 		return;
 
@@ -406,6 +391,80 @@ void pat_init(void)
 
 #undef PAT
 
+void pat_init_noset(void)
+{
+	pat_bp_enabled = true;
+	init_cache_modes();
+}
+
+static void (*pat_init_func)(void) = pat_init_native;
+
+void __init pat_init_set(void (*func)(void))
+{
+	pat_init_func = func;
+}
+
+/**
+ * pat_init - Initialize the PAT MSR and PAT table on the current CPU
+ *
+ * This function initializes PAT MSR and PAT table with an OS-defined value
+ * to enable additional cache attributes, WC, WT and WP.
+ *
+ * This function must be called on all CPUs using the specific sequence of
+ * operations defined in Intel SDM. mtrr_rendezvous_handler() provides this
+ * procedure for PAT.
+ */
+void pat_init(void)
+{
+	pat_init_func();
+}
+
+static int __pat_cpu_init(void *data)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	cache_disable();
+
+	pat_init();
+
+	cache_enable();
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+void pat_cpu_init(void)
+{
+	if (pat_init_func != pat_init_native)
+		pat_init();
+	else
+		__pat_cpu_init(NULL);
+}
+
+void pat_ap_init_nomtrr(void)
+{
+	if (pat_init_func != pat_init_native)
+		return;
+
+	stop_machine_from_inactive_cpu(__pat_cpu_init, NULL, cpu_callout_mask);
+}
+
+void pat_aps_init_nomtrr(void)
+{
+	if (pat_init_func != pat_init_native)
+		return;
+
+	stop_machine(__pat_cpu_init, NULL, cpu_online_mask);
+}
+#else
+void pat_init(void)
+{
+	pr_info_once("x86/PAT: PAT support disabled because CONFIG_X86_PAT is disabled in the kernel.\n");
+	init_cache_modes();
+}
+#endif /* CONFIG_X86_PAT */
+
 static DEFINE_SPINLOCK(memtype_lock);	/* protects memtype accesses */
 
 /*
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 70fb2ea85e90..97831d822872 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -69,6 +69,7 @@
 #include <asm/mwait.h>
 #include <asm/pci_x86.h>
 #include <asm/cpu.h>
+#include <asm/memtype.h>
 #ifdef CONFIG_X86_IOPL_IOPERM
 #include <asm/io_bitmap.h>
 #endif
@@ -1317,6 +1318,9 @@ asmlinkage __visible void __init xen_start_kernel(struct start_info *si)
 		initrd_start = __pa(xen_start_info->mod_start);
 	}
 
+	/* Don't try to modify PAT MSR. */
+	pat_init_set(pat_init_noset);
+
 	/* Poke various useful things into boot_params */
 	boot_params.hdr.type_of_loader = (9 << 4) | 0;
 	boot_params.hdr.ramdisk_image = initrd_start;
-- 
2.35.3

