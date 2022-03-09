Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1354D2EAB
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 13:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbiCIMGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 07:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbiCIMGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 07:06:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC61172266
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 04:05:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5826D618DB
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 12:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5218AC340E8;
        Wed,  9 Mar 2022 12:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646827532;
        bh=+1Fq7ofEh3Bf+0AqqtB6K7H8lOLd5uSlKBf87pHXEoo=;
        h=Subject:To:Cc:From:Date:From;
        b=wbdbsTzhdCdFc1zBg4gDWN3krzIPIeJ7C2zXb67cxOj1XMqPjihs0rLGdLT8oU6wg
         d5XBBmkIZZ/DDBHxUjVCahZQFfiuWdOYuk5e/FQguN5dghBDQTdmMECsllbn5gZQ1H
         6pni9IclxK+q075NrLjYk+D+2RFJhv7od0bh6+k4=
Subject: FAILED: patch "[PATCH] arm64: proton-pack: Include unprivileged eBPF status in" failed to apply to 5.4-stable tree
To:     james.morse@arm.com, catalin.marinas@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Mar 2022 13:05:29 +0100
Message-ID: <164682752912586@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 58c9a5060cb7cd529d49c93954cdafe81c1d642a Mon Sep 17 00:00:00 2001
From: James Morse <james.morse@arm.com>
Date: Thu, 3 Mar 2022 16:53:56 +0000
Subject: [PATCH] arm64: proton-pack: Include unprivileged eBPF status in
 Spectre v2 mitigation reporting

The mitigations for Spectre-BHB are only applied when an exception is
taken from user-space. The mitigation status is reported via the spectre_v2
sysfs vulnerabilities file.

When unprivileged eBPF is enabled the mitigation in the exception vectors
can be avoided by an eBPF program.

When unprivileged eBPF is enabled, print a warning and report vulnerable
via the sysfs vulnerabilities file.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>

diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index d3fbff00993d..6d45c63c6454 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/arm-smccc.h>
+#include <linux/bpf.h>
 #include <linux/cpu.h>
 #include <linux/device.h>
 #include <linux/nospec.h>
@@ -111,6 +112,15 @@ static const char *get_bhb_affected_string(enum mitigation_state bhb_state)
 	}
 }
 
+static bool _unprivileged_ebpf_enabled(void)
+{
+#ifdef CONFIG_BPF_SYSCALL
+	return !sysctl_unprivileged_bpf_disabled;
+#else
+	return false;
+#endif
+}
+
 ssize_t cpu_show_spectre_v2(struct device *dev, struct device_attribute *attr,
 			    char *buf)
 {
@@ -130,6 +140,9 @@ ssize_t cpu_show_spectre_v2(struct device *dev, struct device_attribute *attr,
 		v2_str = "CSV2";
 		fallthrough;
 	case SPECTRE_MITIGATED:
+		if (bhb_state == SPECTRE_MITIGATED && _unprivileged_ebpf_enabled())
+			return sprintf(buf, "Vulnerable: Unprivileged eBPF enabled\n");
+
 		return sprintf(buf, "Mitigation: %s%s\n", v2_str, bhb_str);
 	case SPECTRE_VULNERABLE:
 		fallthrough;
@@ -1125,3 +1138,16 @@ void __init spectre_bhb_patch_clearbhb(struct alt_instr *alt,
 	*updptr++ = cpu_to_le32(aarch64_insn_gen_nop());
 	*updptr++ = cpu_to_le32(aarch64_insn_gen_nop());
 }
+
+#ifdef CONFIG_BPF_SYSCALL
+#define EBPF_WARN "Unprivileged eBPF is enabled, data leaks possible via Spectre v2 BHB attacks!\n"
+void unpriv_ebpf_notify(int new_state)
+{
+	if (spectre_v2_state == SPECTRE_VULNERABLE ||
+	    spectre_bhb_state != SPECTRE_MITIGATED)
+		return;
+
+	if (!new_state)
+		pr_err("WARNING: %s", EBPF_WARN);
+}
+#endif

