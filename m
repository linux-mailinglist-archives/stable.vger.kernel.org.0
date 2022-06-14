Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BEE54B996
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 21:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358100AbiFNSty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357850AbiFNStL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:49:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8B14EF7A;
        Tue, 14 Jun 2022 11:45:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23E9CB81A49;
        Tue, 14 Jun 2022 18:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CF7C3411B;
        Tue, 14 Jun 2022 18:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232312;
        bh=iJp1RXJ62+fQeJ/z3hN2GTJWyWeWITqs84jiYSOpQ5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wBgVqzv+tjiX66pEsFY0ATRgdICUg2ArWi7kRBQiuYjRFjjqg4HzdCtJP8HFTbGQE
         ggj2Jbq7TfUofRJkY3jh0RRaJZwIp9Mf4rzx/aATUbMlMLkkkxva4zdDZx+Ws2tI91
         cKGLIp6afDUfaQs40vBtj7ZjtAcGtXbuT+jKVmRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 04/11] x86/speculation/mmio: Add mitigation for Processor MMIO Stale Data
Date:   Tue, 14 Jun 2022 20:40:33 +0200
Message-Id: <20220614183721.551813937@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183720.512073672@linuxfoundation.org>
References: <20220614183720.512073672@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 8cb861e9e3c9a55099ad3d08e1a3b653d29c33ca upstream

Processor MMIO Stale Data is a class of vulnerabilities that may
expose data after an MMIO operation. For details please refer to
Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst.

These vulnerabilities are broadly categorized as:

Device Register Partial Write (DRPW):
  Some endpoint MMIO registers incorrectly handle writes that are
  smaller than the register size. Instead of aborting the write or only
  copying the correct subset of bytes (for example, 2 bytes for a 2-byte
  write), more bytes than specified by the write transaction may be
  written to the register. On some processors, this may expose stale
  data from the fill buffers of the core that created the write
  transaction.

Shared Buffers Data Sampling (SBDS):
  After propagators may have moved data around the uncore and copied
  stale data into client core fill buffers, processors affected by MFBDS
  can leak data from the fill buffer.

Shared Buffers Data Read (SBDR):
  It is similar to Shared Buffer Data Sampling (SBDS) except that the
  data is directly read into the architectural software-visible state.

An attacker can use these vulnerabilities to extract data from CPU fill
buffers using MDS and TAA methods. Mitigate it by clearing the CPU fill
buffers using the VERW instruction before returning to a user or a
guest.

On CPUs not affected by MDS and TAA, user application cannot sample data
from CPU fill buffers using MDS or TAA. A guest with MMIO access can
still use DRPW or SBDR to extract data architecturally. Mitigate it with
VERW instruction to clear fill buffers before VMENTER for MMIO capable
guests.

Add a kernel parameter mmio_stale_data={off|full|full,nosmt} to control
the mitigation.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |   36 +++++++
 arch/x86/include/asm/nospec-branch.h            |    2 
 arch/x86/kernel/cpu/bugs.c                      |  111 +++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c                          |    3 
 4 files changed, 148 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3019,6 +3019,7 @@
 					       kvm.nx_huge_pages=off [X86]
 					       no_entry_flush [PPC]
 					       no_uaccess_flush [PPC]
+					       mmio_stale_data=off [X86]
 
 				Exceptions:
 					       This does not have any effect on
@@ -3040,6 +3041,7 @@
 				Equivalent to: l1tf=flush,nosmt [X86]
 					       mds=full,nosmt [X86]
 					       tsx_async_abort=full,nosmt [X86]
+					       mmio_stale_data=full,nosmt [X86]
 
 	mminit_loglevel=
 			[KNL] When CONFIG_DEBUG_MEMORY_INIT is set, this
@@ -3049,6 +3051,40 @@
 			log everything. Information is printed at KERN_DEBUG
 			so loglevel=8 may also need to be specified.
 
+	mmio_stale_data=
+			[X86,INTEL] Control mitigation for the Processor
+			MMIO Stale Data vulnerabilities.
+
+			Processor MMIO Stale Data is a class of
+			vulnerabilities that may expose data after an MMIO
+			operation. Exposed data could originate or end in
+			the same CPU buffers as affected by MDS and TAA.
+			Therefore, similar to MDS and TAA, the mitigation
+			is to clear the affected CPU buffers.
+
+			This parameter controls the mitigation. The
+			options are:
+
+			full       - Enable mitigation on vulnerable CPUs
+
+			full,nosmt - Enable mitigation and disable SMT on
+				     vulnerable CPUs.
+
+			off        - Unconditionally disable mitigation
+
+			On MDS or TAA affected machines,
+			mmio_stale_data=off can be prevented by an active
+			MDS or TAA mitigation as these vulnerabilities are
+			mitigated with the same mechanism so in order to
+			disable this mitigation, you need to specify
+			mds=off and tsx_async_abort=off too.
+
+			Not specifying this option is equivalent to
+			mmio_stale_data=full.
+
+			For details see:
+			Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
+
 	module.sig_enforce
 			[KNL] When CONFIG_MODULE_SIG is set, this means that
 			modules without (valid) signatures will fail to load.
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -256,6 +256,8 @@ DECLARE_STATIC_KEY_FALSE(mds_idle_clear)
 
 DECLARE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
 
+DECLARE_STATIC_KEY_FALSE(mmio_stale_data_clear);
+
 #include <asm/segment.h>
 
 /**
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -43,6 +43,7 @@ static void __init l1tf_select_mitigatio
 static void __init mds_select_mitigation(void);
 static void __init md_clear_update_mitigation(void);
 static void __init taa_select_mitigation(void);
+static void __init mmio_select_mitigation(void);
 static void __init srbds_select_mitigation(void);
 static void __init l1d_flush_select_mitigation(void);
 
@@ -85,6 +86,10 @@ EXPORT_SYMBOL_GPL(mds_idle_clear);
  */
 DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
 
+/* Controls CPU Fill buffer clear before KVM guest MMIO accesses */
+DEFINE_STATIC_KEY_FALSE(mmio_stale_data_clear);
+EXPORT_SYMBOL_GPL(mmio_stale_data_clear);
+
 void __init check_bugs(void)
 {
 	identify_boot_cpu();
@@ -119,12 +124,14 @@ void __init check_bugs(void)
 	l1tf_select_mitigation();
 	mds_select_mitigation();
 	taa_select_mitigation();
+	mmio_select_mitigation();
 	srbds_select_mitigation();
 	l1d_flush_select_mitigation();
 
 	/*
-	 * As MDS and TAA mitigations are inter-related, update and print their
-	 * mitigation after TAA mitigation selection is done.
+	 * As MDS, TAA and MMIO Stale Data mitigations are inter-related, update
+	 * and print their mitigation after MDS, TAA and MMIO Stale Data
+	 * mitigation selection is done.
 	 */
 	md_clear_update_mitigation();
 
@@ -391,6 +398,90 @@ static int __init tsx_async_abort_parse_
 early_param("tsx_async_abort", tsx_async_abort_parse_cmdline);
 
 #undef pr_fmt
+#define pr_fmt(fmt)	"MMIO Stale Data: " fmt
+
+enum mmio_mitigations {
+	MMIO_MITIGATION_OFF,
+	MMIO_MITIGATION_UCODE_NEEDED,
+	MMIO_MITIGATION_VERW,
+};
+
+/* Default mitigation for Processor MMIO Stale Data vulnerabilities */
+static enum mmio_mitigations mmio_mitigation __ro_after_init = MMIO_MITIGATION_VERW;
+static bool mmio_nosmt __ro_after_init = false;
+
+static const char * const mmio_strings[] = {
+	[MMIO_MITIGATION_OFF]		= "Vulnerable",
+	[MMIO_MITIGATION_UCODE_NEEDED]	= "Vulnerable: Clear CPU buffers attempted, no microcode",
+	[MMIO_MITIGATION_VERW]		= "Mitigation: Clear CPU buffers",
+};
+
+static void __init mmio_select_mitigation(void)
+{
+	u64 ia32_cap;
+
+	if (!boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA) ||
+	    cpu_mitigations_off()) {
+		mmio_mitigation = MMIO_MITIGATION_OFF;
+		return;
+	}
+
+	if (mmio_mitigation == MMIO_MITIGATION_OFF)
+		return;
+
+	ia32_cap = x86_read_arch_cap_msr();
+
+	/*
+	 * Enable CPU buffer clear mitigation for host and VMM, if also affected
+	 * by MDS or TAA. Otherwise, enable mitigation for VMM only.
+	 */
+	if (boot_cpu_has_bug(X86_BUG_MDS) || (boot_cpu_has_bug(X86_BUG_TAA) &&
+					      boot_cpu_has(X86_FEATURE_RTM)))
+		static_branch_enable(&mds_user_clear);
+	else
+		static_branch_enable(&mmio_stale_data_clear);
+
+	/*
+	 * Check if the system has the right microcode.
+	 *
+	 * CPU Fill buffer clear mitigation is enumerated by either an explicit
+	 * FB_CLEAR or by the presence of both MD_CLEAR and L1D_FLUSH on MDS
+	 * affected systems.
+	 */
+	if ((ia32_cap & ARCH_CAP_FB_CLEAR) ||
+	    (boot_cpu_has(X86_FEATURE_MD_CLEAR) &&
+	     boot_cpu_has(X86_FEATURE_FLUSH_L1D) &&
+	     !(ia32_cap & ARCH_CAP_MDS_NO)))
+		mmio_mitigation = MMIO_MITIGATION_VERW;
+	else
+		mmio_mitigation = MMIO_MITIGATION_UCODE_NEEDED;
+
+	if (mmio_nosmt || cpu_mitigations_auto_nosmt())
+		cpu_smt_disable(false);
+}
+
+static int __init mmio_stale_data_parse_cmdline(char *str)
+{
+	if (!boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA))
+		return 0;
+
+	if (!str)
+		return -EINVAL;
+
+	if (!strcmp(str, "off")) {
+		mmio_mitigation = MMIO_MITIGATION_OFF;
+	} else if (!strcmp(str, "full")) {
+		mmio_mitigation = MMIO_MITIGATION_VERW;
+	} else if (!strcmp(str, "full,nosmt")) {
+		mmio_mitigation = MMIO_MITIGATION_VERW;
+		mmio_nosmt = true;
+	}
+
+	return 0;
+}
+early_param("mmio_stale_data", mmio_stale_data_parse_cmdline);
+
+#undef pr_fmt
 #define pr_fmt(fmt)     "" fmt
 
 static void __init md_clear_update_mitigation(void)
@@ -402,19 +493,31 @@ static void __init md_clear_update_mitig
 		goto out;
 
 	/*
-	 * mds_user_clear is now enabled. Update MDS mitigation, if
-	 * necessary.
+	 * mds_user_clear is now enabled. Update MDS, TAA and MMIO Stale Data
+	 * mitigation, if necessary.
 	 */
 	if (mds_mitigation == MDS_MITIGATION_OFF &&
 	    boot_cpu_has_bug(X86_BUG_MDS)) {
 		mds_mitigation = MDS_MITIGATION_FULL;
 		mds_select_mitigation();
 	}
+	if (taa_mitigation == TAA_MITIGATION_OFF &&
+	    boot_cpu_has_bug(X86_BUG_TAA)) {
+		taa_mitigation = TAA_MITIGATION_VERW;
+		taa_select_mitigation();
+	}
+	if (mmio_mitigation == MMIO_MITIGATION_OFF &&
+	    boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA)) {
+		mmio_mitigation = MMIO_MITIGATION_VERW;
+		mmio_select_mitigation();
+	}
 out:
 	if (boot_cpu_has_bug(X86_BUG_MDS))
 		pr_info("MDS: %s\n", mds_strings[mds_mitigation]);
 	if (boot_cpu_has_bug(X86_BUG_TAA))
 		pr_info("TAA: %s\n", taa_strings[taa_mitigation]);
+	if (boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA))
+		pr_info("MMIO Stale Data: %s\n", mmio_strings[mmio_mitigation]);
 }
 
 #undef pr_fmt
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6613,6 +6613,9 @@ static noinstr void vmx_vcpu_enter_exit(
 		vmx_l1d_flush(vcpu);
 	else if (static_branch_unlikely(&mds_user_clear))
 		mds_clear_cpu_buffers();
+	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
+		 kvm_arch_has_assigned_device(vcpu->kvm))
+		mds_clear_cpu_buffers();
 
 	if (vcpu->arch.cr2 != native_read_cr2())
 		native_write_cr2(vcpu->arch.cr2);


