Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC72C9E218
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbfH0IQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729818AbfH0Hxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:53:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 655A422CBB;
        Tue, 27 Aug 2019 07:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892414;
        bh=Vn3VQ9BO5RUW2G55zvoCymSiadZJ3yZF3cX1695rJNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugSdQIyrLX4HJ3PsBFwJ7n7oWq7BJ/c8W+FK7zs2B3mK+uWF5L+RqjqW7iW+zuxV1
         d/rp7Bw7gLTCDCGe+gE6gGXlGrsZFH4MujRhYig/LlfqrTgFuijd8enFjj9PeYA/s3
         0sxNQMflsXy3SsxrsJdpYvaGbHnVGbL2llz6UkBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chen Yu <yu.c.chen@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>
Subject: [PATCH 4.14 46/62] x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family 15h/16h
Date:   Tue, 27 Aug 2019 09:50:51 +0200
Message-Id: <20190827072703.201654412@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072659.803647352@linuxfoundation.org>
References: <20190827072659.803647352@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

commit c49a0a80137c7ca7d6ced4c812c9e07a949f6f24 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/admin-guide/kernel-parameters.txt |    7 +
 arch/x86/include/asm/msr-index.h                |    1 
 arch/x86/kernel/cpu/amd.c                       |   66 ++++++++++++++++++
 arch/x86/power/cpu.c                            |   86 ++++++++++++++++++++----
 4 files changed, 147 insertions(+), 13 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3788,6 +3788,13 @@
 			Run specified binary instead of /init from the ramdisk,
 			used for early userspace startup. See initrd.
 
+	rdrand=		[X86]
+			force - Override the decision by the kernel to hide the
+				advertisement of RDRAND support (this affects
+				certain AMD processors because of buggy BIOS
+				support, specifically around the suspend/resume
+				path).
+
 	rdt=		[HW,X86,RDT]
 			Turn on/off individual RDT features. List is:
 			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, mba.
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -334,6 +334,7 @@
 #define MSR_AMD64_PATCH_LEVEL		0x0000008b
 #define MSR_AMD64_TSC_RATIO		0xc0000104
 #define MSR_AMD64_NB_CFG		0xc001001f
+#define MSR_AMD64_CPUID_FN_1		0xc0011004
 #define MSR_AMD64_PATCH_LOADER		0xc0010020
 #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -772,6 +772,64 @@ static void init_amd_ln(struct cpuinfo_x
 	msr_set_bit(MSR_AMD64_DE_CFG, 31);
 }
 
+static bool rdrand_force;
+
+static int __init rdrand_cmdline(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (!strcmp(str, "force"))
+		rdrand_force = true;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+early_param("rdrand", rdrand_cmdline);
+
+static void clear_rdrand_cpuid_bit(struct cpuinfo_x86 *c)
+{
+	/*
+	 * Saving of the MSR used to hide the RDRAND support during
+	 * suspend/resume is done by arch/x86/power/cpu.c, which is
+	 * dependent on CONFIG_PM_SLEEP.
+	 */
+	if (!IS_ENABLED(CONFIG_PM_SLEEP))
+		return;
+
+	/*
+	 * The nordrand option can clear X86_FEATURE_RDRAND, so check for
+	 * RDRAND support using the CPUID function directly.
+	 */
+	if (!(cpuid_ecx(1) & BIT(30)) || rdrand_force)
+		return;
+
+	msr_clear_bit(MSR_AMD64_CPUID_FN_1, 62);
+
+	/*
+	 * Verify that the CPUID change has occurred in case the kernel is
+	 * running virtualized and the hypervisor doesn't support the MSR.
+	 */
+	if (cpuid_ecx(1) & BIT(30)) {
+		pr_info_once("BIOS may not properly restore RDRAND after suspend, but hypervisor does not support hiding RDRAND via CPUID.\n");
+		return;
+	}
+
+	clear_cpu_cap(c, X86_FEATURE_RDRAND);
+	pr_info_once("BIOS may not properly restore RDRAND after suspend, hiding RDRAND via CPUID. Use rdrand=force to reenable.\n");
+}
+
+static void init_amd_jg(struct cpuinfo_x86 *c)
+{
+	/*
+	 * Some BIOS implementations do not restore proper RDRAND support
+	 * across suspend and resume. Check on whether to hide the RDRAND
+	 * instruction support via CPUID.
+	 */
+	clear_rdrand_cpuid_bit(c);
+}
+
 static void init_amd_bd(struct cpuinfo_x86 *c)
 {
 	u64 value;
@@ -786,6 +844,13 @@ static void init_amd_bd(struct cpuinfo_x
 			wrmsrl_safe(MSR_F15H_IC_CFG, value);
 		}
 	}
+
+	/*
+	 * Some BIOS implementations do not restore proper RDRAND support
+	 * across suspend and resume. Check on whether to hide the RDRAND
+	 * instruction support via CPUID.
+	 */
+	clear_rdrand_cpuid_bit(c);
 }
 
 static void init_amd_zn(struct cpuinfo_x86 *c)
@@ -828,6 +893,7 @@ static void init_amd(struct cpuinfo_x86
 	case 0x10: init_amd_gh(c); break;
 	case 0x12: init_amd_ln(c); break;
 	case 0x15: init_amd_bd(c); break;
+	case 0x16: init_amd_jg(c); break;
 	case 0x17: init_amd_zn(c); break;
 	}
 
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -13,6 +13,7 @@
 #include <linux/smp.h>
 #include <linux/perf_event.h>
 #include <linux/tboot.h>
+#include <linux/dmi.h>
 
 #include <asm/pgtable.h>
 #include <asm/proto.h>
@@ -24,7 +25,7 @@
 #include <asm/debugreg.h>
 #include <asm/cpu.h>
 #include <asm/mmu_context.h>
-#include <linux/dmi.h>
+#include <asm/cpu_device_id.h>
 
 #ifdef CONFIG_X86_32
 __visible unsigned long saved_context_ebx;
@@ -398,15 +399,14 @@ static int __init bsp_pm_check_init(void
 
 core_initcall(bsp_pm_check_init);
 
-static int msr_init_context(const u32 *msr_id, const int total_num)
+static int msr_build_context(const u32 *msr_id, const int num)
 {
-	int i = 0;
+	struct saved_msrs *saved_msrs = &saved_context.saved_msrs;
 	struct saved_msr *msr_array;
+	int total_num;
+	int i, j;
 
-	if (saved_context.saved_msrs.array || saved_context.saved_msrs.num > 0) {
-		pr_err("x86/pm: MSR quirk already applied, please check your DMI match table.\n");
-		return -EINVAL;
-	}
+	total_num = saved_msrs->num + num;
 
 	msr_array = kmalloc_array(total_num, sizeof(struct saved_msr), GFP_KERNEL);
 	if (!msr_array) {
@@ -414,19 +414,30 @@ static int msr_init_context(const u32 *m
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < total_num; i++) {
-		msr_array[i].info.msr_no	= msr_id[i];
+	if (saved_msrs->array) {
+		/*
+		 * Multiple callbacks can invoke this function, so copy any
+		 * MSR save requests from previous invocations.
+		 */
+		memcpy(msr_array, saved_msrs->array,
+		       sizeof(struct saved_msr) * saved_msrs->num);
+
+		kfree(saved_msrs->array);
+	}
+
+	for (i = saved_msrs->num, j = 0; i < total_num; i++, j++) {
+		msr_array[i].info.msr_no	= msr_id[j];
 		msr_array[i].valid		= false;
 		msr_array[i].info.reg.q		= 0;
 	}
-	saved_context.saved_msrs.num	= total_num;
-	saved_context.saved_msrs.array	= msr_array;
+	saved_msrs->num   = total_num;
+	saved_msrs->array = msr_array;
 
 	return 0;
 }
 
 /*
- * The following section is a quirk framework for problematic BIOSen:
+ * The following sections are a quirk framework for problematic BIOSen:
  * Sometimes MSRs are modified by the BIOSen after suspended to
  * RAM, this might cause unexpected behavior after wakeup.
  * Thus we save/restore these specified MSRs across suspend/resume
@@ -441,7 +452,7 @@ static int msr_initialize_bdw(const stru
 	u32 bdw_msr_id[] = { MSR_IA32_THERM_CONTROL };
 
 	pr_info("x86/pm: %s detected, MSR saving is needed during suspending.\n", d->ident);
-	return msr_init_context(bdw_msr_id, ARRAY_SIZE(bdw_msr_id));
+	return msr_build_context(bdw_msr_id, ARRAY_SIZE(bdw_msr_id));
 }
 
 static const struct dmi_system_id msr_save_dmi_table[] = {
@@ -456,9 +467,58 @@ static const struct dmi_system_id msr_sa
 	{}
 };
 
+static int msr_save_cpuid_features(const struct x86_cpu_id *c)
+{
+	u32 cpuid_msr_id[] = {
+		MSR_AMD64_CPUID_FN_1,
+	};
+
+	pr_info("x86/pm: family %#hx cpu detected, MSR saving is needed during suspending.\n",
+		c->family);
+
+	return msr_build_context(cpuid_msr_id, ARRAY_SIZE(cpuid_msr_id));
+}
+
+static const struct x86_cpu_id msr_save_cpu_table[] = {
+	{
+		.vendor = X86_VENDOR_AMD,
+		.family = 0x15,
+		.model = X86_MODEL_ANY,
+		.feature = X86_FEATURE_ANY,
+		.driver_data = (kernel_ulong_t)msr_save_cpuid_features,
+	},
+	{
+		.vendor = X86_VENDOR_AMD,
+		.family = 0x16,
+		.model = X86_MODEL_ANY,
+		.feature = X86_FEATURE_ANY,
+		.driver_data = (kernel_ulong_t)msr_save_cpuid_features,
+	},
+	{}
+};
+
+typedef int (*pm_cpu_match_t)(const struct x86_cpu_id *);
+static int pm_cpu_check(const struct x86_cpu_id *c)
+{
+	const struct x86_cpu_id *m;
+	int ret = 0;
+
+	m = x86_match_cpu(msr_save_cpu_table);
+	if (m) {
+		pm_cpu_match_t fn;
+
+		fn = (pm_cpu_match_t)m->driver_data;
+		ret = fn(m);
+	}
+
+	return ret;
+}
+
 static int pm_check_save_msr(void)
 {
 	dmi_check_system(msr_save_dmi_table);
+	pm_cpu_check(msr_save_cpu_table);
+
 	return 0;
 }
 


