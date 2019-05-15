Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A560A1F2A5
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbfEOLKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:10:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729167AbfEOLKP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:10:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAED821726;
        Wed, 15 May 2019 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918614;
        bh=thvOr7Hp/0reyBoea1gsug2/SCALyYgn8KZc0DpQ55A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFU9tlqn4EV0td+jg8yIqVW6uGLUm4ipmFFIAvnfKC6RPNouvLtQQrGjIhKYENU8Z
         EO8ntHhDaT9CT9pCwDXs9xTu6H/kobUsDUWbgx/3mQUDsIZm7m3JdhbMOZoZEHf2IV
         pmbIHrs1aTEhVH+WvBgM1WM9y21qkW0CJhCsG3t4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "WoodhouseDavid" <dwmw@amazon.co.uk>,
        Andi Kleen <ak@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "SchauflerCasey" <casey.schaufler@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 199/266] x86/speculation: Enable cross-hyperthread spectre v2 STIBP mitigation
Date:   Wed, 15 May 2019 12:55:06 +0200
Message-Id: <20190515090729.686124279@linuxfoundation.org>
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
[bwh: Backported to 4.4:
 - Don't add any calls to arch_smt_update() yet. They will be introduced by
   "x86/speculation: Rework SMT state change".
 - Use IS_ENABLED(CONFIG_SMP) instead of cpu_smt_control for now. This
   will be fixed by "x86/speculation: Rework SMT state change".]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   55 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 5 deletions(-)

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
@@ -315,6 +313,46 @@ static enum spectre_v2_mitigation_cmd __
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
+	if (IS_ENABLED(CONFIG_SMP))
+		mask |= SPEC_CTRL_STIBP;
+	else
+		mask &= ~SPEC_CTRL_STIBP;
+
+	if (mask != x86_spec_ctrl_base) {
+		pr_info("Spectre v2 cross-process SMT mitigation: %s STIBP\n",
+				IS_ENABLED(CONFIG_SMP) ?
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
@@ -414,6 +452,9 @@ specv2_set_mode:
 		setup_force_cpu_cap(X86_FEATURE_USE_IBRS_FW);
 		pr_info("Enabling Restricted Speculation for firmware calls\n");
 	}
+
+	/* Enable STIBP if appropriate */
+	arch_smt_update();
 }
 
 #undef pr_fmt
@@ -722,6 +763,8 @@ static void __init l1tf_select_mitigatio
 static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr,
 			       char *buf, unsigned int bug)
 {
+	int ret;
+
 	if (!boot_cpu_has_bug(bug))
 		return sprintf(buf, "Not affected\n");
 
@@ -736,10 +779,12 @@ static ssize_t cpu_show_common(struct de
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


