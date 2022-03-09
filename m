Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BDC4D3314
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiCIQL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236154AbiCIQJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:09:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5985AA48;
        Wed,  9 Mar 2022 08:07:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49D33617AA;
        Wed,  9 Mar 2022 16:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C72AC340E8;
        Wed,  9 Mar 2022 16:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646842069;
        bh=rKln5HfmJ7CAsIJqUftQHhI05Ko1JEKlKJ2HDsRvn3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNZjgehSL76yiMdTpqX1fVCFA1GvHWAQ2uQLht2DF6/5KfGTwpzKKsWnvqTTm2rK9
         A2lOWkB78fZdADyLlYp7f/zcNtFvcBFvu6ZrV0FCXrxT5MTJIfgXBn2HIIL2xb3C0c
         +P3SpWC36jMJzrh3lIObB9HeqPDX10DAnco8ISm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 5.15 05/43] x86/speculation: Include unprivileged eBPF status in Spectre v2 mitigation reporting
Date:   Wed,  9 Mar 2022 16:59:49 +0100
Message-Id: <20220309155859.894293683@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.734715884@linuxfoundation.org>
References: <20220309155859.734715884@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 44a3918c8245ab10c6c9719dd12e7a8d291980d8 upstream.

With unprivileged eBPF enabled, eIBRS (without retpoline) is vulnerable
to Spectre v2 BHB-based attacks.

When both are enabled, print a warning message and report it in the
'spectre_v2' sysfs vulnerabilities file.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
[fllinden@amazon.com: backported to 5.15]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   35 +++++++++++++++++++++++++++++------
 include/linux/bpf.h        |   12 ++++++++++++
 kernel/sysctl.c            |    7 +++++++
 3 files changed, 48 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -16,6 +16,7 @@
 #include <linux/prctl.h>
 #include <linux/sched/smt.h>
 #include <linux/pgtable.h>
+#include <linux/bpf.h>
 
 #include <asm/spec-ctrl.h>
 #include <asm/cmdline.h>
@@ -650,6 +651,16 @@ static inline const char *spectre_v2_mod
 static inline const char *spectre_v2_module_string(void) { return ""; }
 #endif
 
+#define SPECTRE_V2_EIBRS_EBPF_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!\n"
+
+#ifdef CONFIG_BPF_SYSCALL
+void unpriv_ebpf_notify(int new_state)
+{
+	if (spectre_v2_enabled == SPECTRE_V2_EIBRS && !new_state)
+		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
+}
+#endif
+
 static inline bool match_option(const char *arg, int arglen, const char *opt)
 {
 	int len = strlen(opt);
@@ -994,6 +1005,9 @@ static void __init spectre_v2_select_mit
 		break;
 	}
 
+	if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
+		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
+
 	if (spectre_v2_in_eibrs_mode(mode)) {
 		/* Force it so VMEXIT will restore correctly */
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
@@ -1780,6 +1794,20 @@ static char *ibpb_state(void)
 	return "";
 }
 
+static ssize_t spectre_v2_show_state(char *buf)
+{
+	if (spectre_v2_enabled == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
+		return sprintf(buf, "Vulnerable: Unprivileged eBPF enabled\n");
+
+	return sprintf(buf, "%s%s%s%s%s%s\n",
+		       spectre_v2_strings[spectre_v2_enabled],
+		       ibpb_state(),
+		       boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? ", IBRS_FW" : "",
+		       stibp_state(),
+		       boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? ", RSB filling" : "",
+		       spectre_v2_module_string());
+}
+
 static ssize_t srbds_show_state(char *buf)
 {
 	return sprintf(buf, "%s\n", srbds_strings[srbds_mitigation]);
@@ -1805,12 +1833,7 @@ static ssize_t cpu_show_common(struct de
 		return sprintf(buf, "%s\n", spectre_v1_strings[spectre_v1_mitigation]);
 
 	case X86_BUG_SPECTRE_V2:
-		return sprintf(buf, "%s%s%s%s%s%s\n", spectre_v2_strings[spectre_v2_enabled],
-			       ibpb_state(),
-			       boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? ", IBRS_FW" : "",
-			       stibp_state(),
-			       boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? ", RSB filling" : "",
-			       spectre_v2_module_string());
+		return spectre_v2_show_state(buf);
 
 	case X86_BUG_SPEC_STORE_BYPASS:
 		return sprintf(buf, "%s\n", ssb_strings[ssb_mode]);
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1666,6 +1666,12 @@ bool bpf_prog_has_kfunc_call(const struc
 const struct btf_func_model *
 bpf_jit_find_kfunc_model(const struct bpf_prog *prog,
 			 const struct bpf_insn *insn);
+
+static inline bool unprivileged_ebpf_enabled(void)
+{
+	return !sysctl_unprivileged_bpf_disabled;
+}
+
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
@@ -1884,6 +1890,12 @@ bpf_jit_find_kfunc_model(const struct bp
 {
 	return NULL;
 }
+
+static inline bool unprivileged_ebpf_enabled(void)
+{
+	return false;
+}
+
 #endif /* CONFIG_BPF_SYSCALL */
 
 void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -228,6 +228,10 @@ static int bpf_stats_handler(struct ctl_
 	return ret;
 }
 
+void __weak unpriv_ebpf_notify(int new_state)
+{
+}
+
 static int bpf_unpriv_handler(struct ctl_table *table, int write,
 			      void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -245,6 +249,9 @@ static int bpf_unpriv_handler(struct ctl
 			return -EPERM;
 		*(int *)table->data = unpriv_enable;
 	}
+
+	unpriv_ebpf_notify(unpriv_enable);
+
 	return ret;
 }
 #endif /* CONFIG_BPF_SYSCALL && CONFIG_SYSCTL */


