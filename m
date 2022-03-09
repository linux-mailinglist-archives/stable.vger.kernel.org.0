Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B124D32AF
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiCIQFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234397AbiCIQEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:04:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DB85B89C;
        Wed,  9 Mar 2022 08:02:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C50C61670;
        Wed,  9 Mar 2022 16:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF6EC340E8;
        Wed,  9 Mar 2022 16:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841762;
        bh=mLE+SPjQEGdARUuUNecvyRHyXE7Tph/DLQD0FBJQkBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pt1TAn/lASNSfWFGZ1DuaTbQAc8SLLaaRywhCNdVEgGvo7Y5jrkynhThSKiMeuys0
         DfNWQOybudTQVg4ZH/t8pXqM+WnPP713ourVj+85C/ojrhvtU5CfEsM5U/Vouyq6pb
         IAQhlUN5/SCkQPUq3YsTxDqsDgw5nqIjoDvqUhz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 4.14 06/18] x86/speculation: Include unprivileged eBPF status in Spectre v2 mitigation reporting
Date:   Wed,  9 Mar 2022 16:59:36 +0100
Message-Id: <20220309155856.281557401@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155856.090281301@linuxfoundation.org>
References: <20220309155856.090281301@linuxfoundation.org>
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
[fllinden@amazon.com: backported to 4.14]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   35 +++++++++++++++++++++++++++++------
 include/linux/bpf.h        |   11 +++++++++++
 kernel/sysctl.c            |    8 ++++++++
 3 files changed, 48 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -31,6 +31,7 @@
 #include <asm/set_memory.h>
 #include <asm/intel-family.h>
 #include <asm/e820/api.h>
+#include <linux/bpf.h>
 
 #include "cpu.h"
 
@@ -607,6 +608,16 @@ static inline const char *spectre_v2_mod
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
@@ -950,6 +961,9 @@ static void __init spectre_v2_select_mit
 		break;
 	}
 
+	if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
+		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
+
 	if (spectre_v2_in_eibrs_mode(mode)) {
 		/* Force it so VMEXIT will restore correctly */
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
@@ -1685,6 +1699,20 @@ static char *ibpb_state(void)
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
@@ -1707,12 +1735,7 @@ static ssize_t cpu_show_common(struct de
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
@@ -337,6 +337,11 @@ static inline int bpf_map_attr_numa_node
 		attr->numa_node : NUMA_NO_NODE;
 }
 
+static inline bool unprivileged_ebpf_enabled(void)
+{
+	return !sysctl_unprivileged_bpf_disabled;
+}
+
 #else
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
@@ -400,6 +405,12 @@ static inline void __dev_map_insert_ctx(
 static inline void __dev_map_flush(struct bpf_map *map)
 {
 }
+
+static inline bool unprivileged_ebpf_enabled(void)
+{
+	return false;
+}
+
 #endif /* CONFIG_BPF_SYSCALL */
 
 #if defined(CONFIG_STREAM_PARSER) && defined(CONFIG_BPF_SYSCALL)
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -243,6 +243,11 @@ static int sysrq_sysctl_handler(struct c
 #endif
 
 #ifdef CONFIG_BPF_SYSCALL
+
+void __weak unpriv_ebpf_notify(int new_state)
+{
+}
+
 static int bpf_unpriv_handler(struct ctl_table *table, int write,
                              void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -260,6 +265,9 @@ static int bpf_unpriv_handler(struct ctl
 			return -EPERM;
 		*(int *)table->data = unpriv_enable;
 	}
+
+	unpriv_ebpf_notify(unpriv_enable);
+
 	return ret;
 }
 #endif


