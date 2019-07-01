Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2013620BF2
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfEPQAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:00:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43048 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727115AbfEPP6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:48 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImK-0006zx-Gs; Thu, 16 May 2019 16:58:44 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001Rv-Nc; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Borislav Petkov" <bp@suse.de>, "Jon Masters" <jcm@redhat.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.351069030@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 69/86] x86/speculation/mds: Add mitigation control
 for MDS
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit bc1241700acd82ec69fde98c5763ce51086269f8 upstream.

Now that the mitigations are in place, add a command line parameter to
control the mitigation, a mitigation selector function and a SMT update
mechanism.

This is the minimal straight forward initial implementation which just
provides an always on/off mode. The command line parameter is:

  mds=[full|off]

This is consistent with the existing mitigations for other speculative
hardware vulnerabilities.

The idle invocation is dynamically updated according to the SMT state of
the system similar to the dynamic update of the STIBP mitigation. The idle
mitigation is limited to CPUs which are only affected by MSBDS and not any
other variant, because the other variants cannot be mitigated on SMT
enabled systems.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Jon Masters <jcm@redhat.com>
Tested-by: Jon Masters <jcm@redhat.com>
[bwh: Backported to 3.16:
 - Drop " __ro_after_init"
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1774,6 +1774,28 @@ bytes respectively. Such letter suffixes
 			Format: <first>,<last>
 			Specifies range of consoles to be captured by the MDA.
 
+	mds=		[X86,INTEL]
+			Control mitigation for the Micro-architectural Data
+			Sampling (MDS) vulnerability.
+
+			Certain CPUs are vulnerable to an exploit against CPU
+			internal buffers which can forward information to a
+			disclosure gadget under certain conditions.
+
+			In vulnerable processors, the speculatively
+			forwarded data can be used in a cache side channel
+			attack, to access data to which the attacker does
+			not have direct access.
+
+			This parameter controls the MDS mitigation. The
+			options are:
+
+			full    - Enable MDS mitigation on vulnerable CPUs
+			off     - Unconditionally disable MDS mitigation
+
+			Not specifying this option is equivalent to
+			mds=full.
+
 	mem=nn[KMG]	[KNL,BOOT] Force usage of a specific amount of memory
 			Amount of memory to be used when the kernel is not able
 			to see the whole system memory or for test.
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -953,4 +953,10 @@ bool xen_set_default_idle(void);
 
 void stop_this_cpu(void *dummy);
 void df_debug(struct pt_regs *regs, long error_code);
+
+enum mds_mitigations {
+	MDS_MITIGATION_OFF,
+	MDS_MITIGATION_FULL,
+};
+
 #endif /* _ASM_X86_PROCESSOR_H */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -32,6 +32,7 @@
 static void __init spectre_v2_select_mitigation(void);
 static void __init ssb_select_mitigation(void);
 static void __init l1tf_select_mitigation(void);
+static void __init mds_select_mitigation(void);
 
 /* The base value of the SPEC_CTRL MSR that always has to be preserved. */
 u64 x86_spec_ctrl_base;
@@ -157,6 +158,8 @@ void __init check_bugs(void)
 
 	l1tf_select_mitigation();
 
+	mds_select_mitigation();
+
 #ifdef CONFIG_X86_32
 	/*
 	 * Check whether we are able to run this kernel safely on SMP.
@@ -268,6 +271,50 @@ static void x86_amd_ssb_disable(void)
 }
 
 #undef pr_fmt
+#define pr_fmt(fmt)	"MDS: " fmt
+
+/* Default mitigation for L1TF-affected CPUs */
+static enum mds_mitigations mds_mitigation = MDS_MITIGATION_FULL;
+
+static const char * const mds_strings[] = {
+	[MDS_MITIGATION_OFF]	= "Vulnerable",
+	[MDS_MITIGATION_FULL]	= "Mitigation: Clear CPU buffers"
+};
+
+static void __init mds_select_mitigation(void)
+{
+	if (!boot_cpu_has_bug(X86_BUG_MDS)) {
+		mds_mitigation = MDS_MITIGATION_OFF;
+		return;
+	}
+
+	if (mds_mitigation == MDS_MITIGATION_FULL) {
+		if (boot_cpu_has(X86_FEATURE_MD_CLEAR))
+			static_branch_enable(&mds_user_clear);
+		else
+			mds_mitigation = MDS_MITIGATION_OFF;
+	}
+	pr_info("%s\n", mds_strings[mds_mitigation]);
+}
+
+static int __init mds_cmdline(char *str)
+{
+	if (!boot_cpu_has_bug(X86_BUG_MDS))
+		return 0;
+
+	if (!str)
+		return -EINVAL;
+
+	if (!strcmp(str, "off"))
+		mds_mitigation = MDS_MITIGATION_OFF;
+	else if (!strcmp(str, "full"))
+		mds_mitigation = MDS_MITIGATION_FULL;
+
+	return 0;
+}
+early_param("mds", mds_cmdline);
+
+#undef pr_fmt
 #define pr_fmt(fmt)     "Spectre V2 : " fmt
 
 static enum spectre_v2_mitigation spectre_v2_enabled = SPECTRE_V2_NONE;
@@ -665,6 +712,26 @@ static void update_indir_branch_cond(voi
 		static_branch_disable(&switch_to_cond_stibp);
 }
 
+/* Update the static key controlling the MDS CPU buffer clear in idle */
+static void update_mds_branch_idle(void)
+{
+	/*
+	 * Enable the idle clearing if SMT is active on CPUs which are
+	 * affected only by MSBDS and not any other MDS variant.
+	 *
+	 * The other variants cannot be mitigated when SMT is enabled, so
+	 * clearing the buffers on idle just to prevent the Store Buffer
+	 * repartitioning leak would be a window dressing exercise.
+	 */
+	if (!boot_cpu_has_bug(X86_BUG_MSBDS_ONLY))
+		return;
+
+	if (sched_smt_active())
+		static_branch_enable(&mds_idle_clear);
+	else
+		static_branch_disable(&mds_idle_clear);
+}
+
 void arch_smt_update(void)
 {
 	/* Enhanced IBRS implies STIBP. No update required. */
@@ -685,6 +752,9 @@ void arch_smt_update(void)
 		break;
 	}
 
+	if (mds_mitigation == MDS_MITIGATION_FULL)
+		update_mds_branch_idle();
+
 	mutex_unlock(&spec_ctrl_mutex);
 }
 

