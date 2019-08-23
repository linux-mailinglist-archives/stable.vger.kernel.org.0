Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD5A9A4D1
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 03:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387792AbfHWBLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 21:11:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33546 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387676AbfHWBLZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 21:11:25 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1i0y6L-0000Mj-Us; Fri, 23 Aug 2019 03:10:50 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 86DF91C0883;
        Fri, 23 Aug 2019 03:10:49 +0200 (CEST)
Date:   Fri, 23 Aug 2019 01:10:49 -0000
From:   tip-bot2 for Tom Lendacky <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family
 15h/16h
Cc:     linux-kernel@vger.kernel.org, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Chen Yu <yu.c.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <7543af91666f491547bd86cebb1e17c66824ab9f.1566229943.git.thomas.lendacky@amd.com>
References: <7543af91666f491547bd86cebb1e17c66824ab9f.1566229943.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Message-ID: <156652264945.9541.4969272027980914591.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from
 these emails
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     c49a0a80137c7ca7d6ced4c812c9e07a949f6f24
Gitweb:        https://git.kernel.org/tip/c49a0a80137c7ca7d6ced4c812c9e07a949f6f24
Author:        Tom Lendacky <thomas.lendacky@amd.com>
AuthorDate:    Mon, 19 Aug 2019 15:52:35 
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 19 Aug 2019 19:42:52 +02:00

x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family 15h/16h

There have been reports of RDRAND issues after resuming from suspend on
some AMD family 15h and family 16h systems. This issue stems from a BIOS
not performing the proper steps during resume to ensure RDRAND continues
to function properly.

RDRAND support is indicated by CPUID Fn00000001_ECX[30]. This bit can be
reset by clearing MSR C001_1004[62]. Any software that checks for RDRAND
support using CPUID, including the kernel, will believe that RDRAND is
not supported.

Update the CPU initialization to clear the RDRAND CPUID bit for any family
15h and 16h processor that supports RDRAND. If it is known that the family
15h or family 16h system does not have an RDRAND resume issue or that the
system will not be placed in suspend, the "rdrand=force" kernel parameter
can be used to stop the clearing of the RDRAND CPUID bit.

Additionally, update the suspend and resume path to save and restore the
MSR C001_1004 value to ensure that the RDRAND CPUID setting remains in
place after resuming from suspend.

Note, that clearing the RDRAND CPUID bit does not prevent a processor
that normally supports the RDRAND instruction from executing it. So any
code that determined the support based on family and model won't #UD.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chen Yu <yu.c.chen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: <stable@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "x86@kernel.org" <x86@kernel.org>
Link: https://lkml.kernel.org/r/7543af91666f491547bd86cebb1e17c66824ab9f.1566229943.git.thomas.lendacky@amd.com
---
 Documentation/admin-guide/kernel-parameters.txt |  7 +-
 arch/x86/include/asm/msr-index.h                |  1 +-
 arch/x86/kernel/cpu/amd.c                       | 66 +------------
 arch/x86/power/cpu.c                            | 86 ++--------------
 4 files changed, 13 insertions(+), 147 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 4c19719..47d981a 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4090,13 +4090,6 @@
 			Run specified binary instead of /init from the ramdisk,
 			used for early userspace startup. See initrd.
 
-	rdrand=		[X86]
-			force - Override the decision by the kernel to hide the
-				advertisement of RDRAND support (this affects
-				certain AMD processors because of buggy BIOS
-				support, specifically around the suspend/resume
-				path).
-
 	rdt=		[HW,X86,RDT]
 			Turn on/off individual RDT features. List is:
 			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 271d837..6b4fc27 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -381,7 +381,6 @@
 #define MSR_AMD64_PATCH_LEVEL		0x0000008b
 #define MSR_AMD64_TSC_RATIO		0xc0000104
 #define MSR_AMD64_NB_CFG		0xc001001f
-#define MSR_AMD64_CPUID_FN_1		0xc0011004
 #define MSR_AMD64_PATCH_LOADER		0xc0010020
 #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 68c363c..8d4e504 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -804,64 +804,6 @@ static void init_amd_ln(struct cpuinfo_x86 *c)
 	msr_set_bit(MSR_AMD64_DE_CFG, 31);
 }
 
-static bool rdrand_force;
-
-static int __init rdrand_cmdline(char *str)
-{
-	if (!str)
-		return -EINVAL;
-
-	if (!strcmp(str, "force"))
-		rdrand_force = true;
-	else
-		return -EINVAL;
-
-	return 0;
-}
-early_param("rdrand", rdrand_cmdline);
-
-static void clear_rdrand_cpuid_bit(struct cpuinfo_x86 *c)
-{
-	/*
-	 * Saving of the MSR used to hide the RDRAND support during
-	 * suspend/resume is done by arch/x86/power/cpu.c, which is
-	 * dependent on CONFIG_PM_SLEEP.
-	 */
-	if (!IS_ENABLED(CONFIG_PM_SLEEP))
-		return;
-
-	/*
-	 * The nordrand option can clear X86_FEATURE_RDRAND, so check for
-	 * RDRAND support using the CPUID function directly.
-	 */
-	if (!(cpuid_ecx(1) & BIT(30)) || rdrand_force)
-		return;
-
-	msr_clear_bit(MSR_AMD64_CPUID_FN_1, 62);
-
-	/*
-	 * Verify that the CPUID change has occurred in case the kernel is
-	 * running virtualized and the hypervisor doesn't support the MSR.
-	 */
-	if (cpuid_ecx(1) & BIT(30)) {
-		pr_info_once("BIOS may not properly restore RDRAND after suspend, but hypervisor does not support hiding RDRAND via CPUID.\n");
-		return;
-	}
-
-	clear_cpu_cap(c, X86_FEATURE_RDRAND);
-	pr_info_once("BIOS may not properly restore RDRAND after suspend, hiding RDRAND via CPUID. Use rdrand=force to reenable.\n");
-}
-
-static void init_amd_jg(struct cpuinfo_x86 *c)
-{
-	/*
-	 * Some BIOS implementations do not restore proper RDRAND support
-	 * across suspend and resume. Check on whether to hide the RDRAND
-	 * instruction support via CPUID.
-	 */
-	clear_rdrand_cpuid_bit(c);
-}
-
 static void init_amd_bd(struct cpuinfo_x86 *c)
 {
 	u64 value;
@@ -876,13 +818,6 @@ static void init_amd_bd(struct cpuinfo_x86 *c)
 			wrmsrl_safe(MSR_F15H_IC_CFG, value);
 		}
 	}
-
-	/*
-	 * Some BIOS implementations do not restore proper RDRAND support
-	 * across suspend and resume. Check on whether to hide the RDRAND
-	 * instruction support via CPUID.
-	 */
-	clear_rdrand_cpuid_bit(c);
 }
 
 static void init_amd_zn(struct cpuinfo_x86 *c)
@@ -925,7 +860,6 @@ static void init_amd(struct cpuinfo_x86 *c)
 	case 0x10: init_amd_gh(c); break;
 	case 0x12: init_amd_ln(c); break;
 	case 0x15: init_amd_bd(c); break;
-	case 0x16: init_amd_jg(c); break;
 	case 0x17: init_amd_zn(c); break;
 	}
 
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index c9ef6a7..24b079e 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -12,7 +12,6 @@
 #include <linux/smp.h>
 #include <linux/perf_event.h>
 #include <linux/tboot.h>
-#include <linux/dmi.h>
 
 #include <asm/pgtable.h>
 #include <asm/proto.h>
@@ -24,7 +23,7 @@
 #include <asm/debugreg.h>
 #include <asm/cpu.h>
 #include <asm/mmu_context.h>
-#include <asm/cpu_device_id.h>
+#include <linux/dmi.h>
 
 #ifdef CONFIG_X86_32
 __visible unsigned long saved_context_ebx;
@@ -398,14 +397,15 @@ static int __init bsp_pm_check_init(void)
 
 core_initcall(bsp_pm_check_init);
 
-static int msr_build_context(const u32 *msr_id, const int num)
+static int msr_init_context(const u32 *msr_id, const int total_num)
 {
-	struct saved_msrs *saved_msrs = &saved_context.saved_msrs;
+	int i = 0;
 	struct saved_msr *msr_array;
-	int total_num;
-	int i, j;
 
-	total_num = saved_msrs->num + num;
+	if (saved_context.saved_msrs.array || saved_context.saved_msrs.num > 0) {
+		pr_err("x86/pm: MSR quirk already applied, please check your DMI match table.\n");
+		return -EINVAL;
+	}
 
 	msr_array = kmalloc_array(total_num, sizeof(struct saved_msr), GFP_KERNEL);
 	if (!msr_array) {
@@ -413,30 +413,19 @@ static int msr_build_context(const u32 *msr_id, const int num)
 		return -ENOMEM;
 	}
 
-	if (saved_msrs->array) {
-		/*
-		 * Multiple callbacks can invoke this function, so copy any
-		 * MSR save requests from previous invocations.
-		 */
-		memcpy(msr_array, saved_msrs->array,
-		       sizeof(struct saved_msr) * saved_msrs->num);
-
-		kfree(saved_msrs->array);
-	}
-
-	for (i = saved_msrs->num, j = 0; i < total_num; i++, j++) {
-		msr_array[i].info.msr_no	= msr_id[j];
+	for (i = 0; i < total_num; i++) {
+		msr_array[i].info.msr_no	= msr_id[i];
 		msr_array[i].valid		= false;
 		msr_array[i].info.reg.q		= 0;
 	}
-	saved_msrs->num   = total_num;
-	saved_msrs->array = msr_array;
+	saved_context.saved_msrs.num	= total_num;
+	saved_context.saved_msrs.array	= msr_array;
 
 	return 0;
 }
 
 /*
- * The following sections are a quirk framework for problematic BIOSen:
+ * The following section is a quirk framework for problematic BIOSen:
  * Sometimes MSRs are modified by the BIOSen after suspended to
  * RAM, this might cause unexpected behavior after wakeup.
  * Thus we save/restore these specified MSRs across suspend/resume
@@ -451,7 +440,7 @@ static int msr_initialize_bdw(const struct dmi_system_id *d)
 	u32 bdw_msr_id[] = { MSR_IA32_THERM_CONTROL };
 
 	pr_info("x86/pm: %s detected, MSR saving is needed during suspending.\n", d->ident);
-	return msr_build_context(bdw_msr_id, ARRAY_SIZE(bdw_msr_id));
+	return msr_init_context(bdw_msr_id, ARRAY_SIZE(bdw_msr_id));
 }
 
 static const struct dmi_system_id msr_save_dmi_table[] = {
@@ -466,58 +455,9 @@ static const struct dmi_system_id msr_save_dmi_table[] = {
 	{}
 };
 
-static int msr_save_cpuid_features(const struct x86_cpu_id *c)
-{
-	u32 cpuid_msr_id[] = {
-		MSR_AMD64_CPUID_FN_1,
-	};
-
-	pr_info("x86/pm: family %#hx cpu detected, MSR saving is needed during suspending.\n",
-		c->family);
-
-	return msr_build_context(cpuid_msr_id, ARRAY_SIZE(cpuid_msr_id));
-}
-
-static const struct x86_cpu_id msr_save_cpu_table[] = {
-	{
-		.vendor = X86_VENDOR_AMD,
-		.family = 0x15,
-		.model = X86_MODEL_ANY,
-		.feature = X86_FEATURE_ANY,
-		.driver_data = (kernel_ulong_t)msr_save_cpuid_features,
-	},
-	{
-		.vendor = X86_VENDOR_AMD,
-		.family = 0x16,
-		.model = X86_MODEL_ANY,
-		.feature = X86_FEATURE_ANY,
-		.driver_data = (kernel_ulong_t)msr_save_cpuid_features,
-	},
-	{}
-};
-
-typedef int (*pm_cpu_match_t)(const struct x86_cpu_id *);
-static int pm_cpu_check(const struct x86_cpu_id *c)
-{
-	const struct x86_cpu_id *m;
-	int ret = 0;
-
-	m = x86_match_cpu(msr_save_cpu_table);
-	if (m) {
-		pm_cpu_match_t fn;
-
-		fn = (pm_cpu_match_t)m->driver_data;
-		ret = fn(m);
-	}
-
-	return ret;
-}
-
 static int pm_check_save_msr(void)
 {
 	dmi_check_system(msr_save_dmi_table);
-	pm_cpu_check(msr_save_cpu_table);
-
 	return 0;
 }
 
