Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B341F288
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbfEOLLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729660AbfEOLLy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F24420644;
        Wed, 15 May 2019 11:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918713;
        bh=w5G/w/BCVjAaX1NiKWxIb/FeJ3hWv1707Z43aV2XzJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IiU1/UKnY9mvASfF5xqfidXihcKcvfrJx4bGaqMGdQXJJRKk4bp3DoQfsmfTq102M
         bApvPBV1B4aiggkIPhV4aFFun3r7jXr7rLqlkE4fVnx4sQzMBqKwY/JoEQLoe6j8TW
         CKxRjcyB03U/Dgb8GlnVtPURd7G6A4FyDciLTKNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, Jon Masters <jcm@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 236/266] x86/speculation/mds: Add mitigation control for MDS
Date:   Wed, 15 May 2019 12:55:43 +0200
Message-Id: <20190515090730.984802096@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[bwh: Backported to 4.4:
 - Drop " __ro_after_init"
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-parameters.txt |   22 +++++++++++
 arch/x86/include/asm/processor.h    |    6 +++
 arch/x86/kernel/cpu/bugs.c          |   70 ++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2035,6 +2035,28 @@ bytes respectively. Such letter suffixes
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
@@ -845,4 +845,10 @@ bool xen_set_default_idle(void);
 
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
@@ -96,6 +97,8 @@ void __init check_bugs(void)
 
 	l1tf_select_mitigation();
 
+	mds_select_mitigation();
+
 #ifdef CONFIG_X86_32
 	/*
 	 * Check whether we are able to run this kernel safely on SMP.
@@ -202,6 +205,50 @@ static void x86_amd_ssb_disable(void)
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
@@ -599,6 +646,26 @@ static void update_indir_branch_cond(voi
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
@@ -619,6 +686,9 @@ void arch_smt_update(void)
 		break;
 	}
 
+	if (mds_mitigation == MDS_MITIGATION_FULL)
+		update_mds_branch_idle();
+
 	mutex_unlock(&spec_ctrl_mutex);
 }
 


