Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 286C520C1E
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfEPQCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:02:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42824 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726950AbfEPP6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:46 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0006zc-Ec; Thu, 16 May 2019 16:58:38 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0001Ou-FD; Thu, 16 May 2019 16:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Andrea Arcangeli" <aarcange@redhat.com>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        "SchauflerCasey" <casey.schaufler@intel.com>,
        "WoodhouseDavid" <dwmw@amazon.co.uk>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Jiri Kosina" <jkosina@suse.cz>, "Andi Kleen" <ak@linux.intel.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.19779072@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 32/86] x86/speculation: Enable cross-hyperthread
 spectre v2 STIBP mitigation
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

From: Jiri Kosina <jkosina@suse.cz>

commit 53c613fe6349994f023245519265999eed75957f upstream.

STIBP is a feature provided by certain Intel ucodes / CPUs. This feature
(once enabled) prevents cross-hyperthread control of decisions made by
indirect branch predictors.

Enable this feature if

- the CPU is vulnerable to spectre v2
- the CPU supports SMT and has SMT siblings online
- spectre_v2 mitigation autoselection is enabled (default)

After some previous discussion, this leaves STIBP on all the time, as wrmsr
on crossing kernel boundary is a no-no. This could perhaps later be a bit
more optimized (like disabling it in NOHZ, experiment with disabling it in
idle, etc) if needed.

Note that the synchronization of the mask manipulation via newly added
spec_ctrl_mutex is currently not strictly needed, as the only updater is
already being serialized by cpu_add_remove_lock, but let's make this a
little bit more future-proof.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc:  "WoodhouseDavid" <dwmw@amazon.co.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc:  "SchauflerCasey" <casey.schaufler@intel.com>
Link: https://lkml.kernel.org/r/nycvar.YFH.7.76.1809251438240.15880@cbobk.fhfr.pm
[bwh: Backported to 3.16:
 - Don't add any calls to arch_smt_update() yet. They will be introduced by
   "x86/speculation: Rework SMT state change".
 - Use IS_ENABLED(CONFIG_X86_HT) instead of cpu_smt_control for now. This
   will be fixed by "x86/speculation: Rework SMT state change".]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -32,12 +32,10 @@ static void __init spectre_v2_select_mit
 static void __init ssb_select_mitigation(void);
 static void __init l1tf_select_mitigation(void);
 
-/*
- * Our boot-time value of the SPEC_CTRL MSR. We read it once so that any
- * writes to SPEC_CTRL contain whatever reserved bits have been set.
- */
+/* The base value of the SPEC_CTRL MSR that always has to be preserved. */
 u64 x86_spec_ctrl_base;
 EXPORT_SYMBOL_GPL(x86_spec_ctrl_base);
+static DEFINE_MUTEX(spec_ctrl_mutex);
 
 /*
  * The vendor and possibly platform specific bits which can be modified in
@@ -378,6 +376,46 @@ static enum spectre_v2_mitigation_cmd __
 	return cmd;
 }
 
+static bool stibp_needed(void)
+{
+	if (spectre_v2_enabled == SPECTRE_V2_NONE)
+		return false;
+
+	if (!boot_cpu_has(X86_FEATURE_STIBP))
+		return false;
+
+	return true;
+}
+
+static void update_stibp_msr(void *info)
+{
+	wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+}
+
+void arch_smt_update(void)
+{
+	u64 mask;
+
+	if (!stibp_needed())
+		return;
+
+	mutex_lock(&spec_ctrl_mutex);
+	mask = x86_spec_ctrl_base;
+	if (IS_ENABLED(CONFIG_X86_HT))
+		mask |= SPEC_CTRL_STIBP;
+	else
+		mask &= ~SPEC_CTRL_STIBP;
+
+	if (mask != x86_spec_ctrl_base) {
+		pr_info("Spectre v2 cross-process SMT mitigation: %s STIBP\n",
+				IS_ENABLED(CONFIG_X86_HT) ?
+				"Enabling" : "Disabling");
+		x86_spec_ctrl_base = mask;
+		on_each_cpu(update_stibp_msr, NULL, 1);
+	}
+	mutex_unlock(&spec_ctrl_mutex);
+}
+
 static void __init spectre_v2_select_mitigation(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
@@ -477,6 +515,9 @@ specv2_set_mode:
 		setup_force_cpu_cap(X86_FEATURE_USE_IBRS_FW);
 		pr_info("Enabling Restricted Speculation for firmware calls\n");
 	}
+
+	/* Enable STIBP if appropriate */
+	arch_smt_update();
 }
 
 #undef pr_fmt
@@ -784,6 +825,8 @@ static void __init l1tf_select_mitigatio
 static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr,
 			       char *buf, unsigned int bug)
 {
+	int ret;
+
 	if (!boot_cpu_has_bug(bug))
 		return sprintf(buf, "Not affected\n");
 
@@ -798,10 +841,12 @@ static ssize_t cpu_show_common(struct de
 		return sprintf(buf, "Mitigation: __user pointer sanitization\n");
 
 	case X86_BUG_SPECTRE_V2:
-		return sprintf(buf, "%s%s%s%s\n", spectre_v2_strings[spectre_v2_enabled],
+		ret = sprintf(buf, "%s%s%s%s%s\n", spectre_v2_strings[spectre_v2_enabled],
 			       boot_cpu_has(X86_FEATURE_USE_IBPB) ? ", IBPB" : "",
 			       boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? ", IBRS_FW" : "",
+			       (x86_spec_ctrl_base & SPEC_CTRL_STIBP) ? ", STIBP" : "",
 			       spectre_v2_module_string());
+		return ret;
 
 	case X86_BUG_SPEC_STORE_BYPASS:
 		return sprintf(buf, "%s\n", ssb_strings[ssb_mode]);

