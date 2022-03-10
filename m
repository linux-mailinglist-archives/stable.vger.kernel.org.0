Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B924D4BB3
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239030AbiCJOek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243014AbiCJObn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFFF4C418;
        Thu, 10 Mar 2022 06:30:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82901B825A7;
        Thu, 10 Mar 2022 14:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB77C340E8;
        Thu, 10 Mar 2022 14:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922639;
        bh=l37UARKIQ5Jo8vDSJTC9HNb2cDupJ6KmhPyrEn/bpO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHK+156FAP130K4mIf8QZEcgb893X357q2q2jkFheqP7N9gIxaAkc5wrOMOTDXWyW
         Ux2EIYOvjivk5XQCxpkA+R+vxCpjNZOmz/Hur8gpXDmE01vMFRNoOoSFAwGevPLhqp
         ob+ko2yLOXPOnQe7pWO5AiKoIyANwwf7dxSxArBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.15 41/58] arm64: proton-pack: Include unprivileged eBPF status in Spectre v2 mitigation reporting
Date:   Thu, 10 Mar 2022 15:19:30 +0100
Message-Id: <20220310140814.152279375@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140812.983088611@linuxfoundation.org>
References: <20220310140812.983088611@linuxfoundation.org>
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

From: James Morse <james.morse@arm.com>

commit 58c9a5060cb7cd529d49c93954cdafe81c1d642a upstream.

The mitigations for Spectre-BHB are only applied when an exception is
taken from user-space. The mitigation status is reported via the spectre_v2
sysfs vulnerabilities file.

When unprivileged eBPF is enabled the mitigation in the exception vectors
can be avoided by an eBPF program.

When unprivileged eBPF is enabled, print a warning and report vulnerable
via the sysfs vulnerabilities file.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/proton-pack.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/arm-smccc.h>
+#include <linux/bpf.h>
 #include <linux/cpu.h>
 #include <linux/device.h>
 #include <linux/nospec.h>
@@ -111,6 +112,15 @@ static const char *get_bhb_affected_stri
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
@@ -130,6 +140,9 @@ ssize_t cpu_show_spectre_v2(struct devic
 		v2_str = "CSV2";
 		fallthrough;
 	case SPECTRE_MITIGATED:
+		if (bhb_state == SPECTRE_MITIGATED && _unprivileged_ebpf_enabled())
+			return sprintf(buf, "Vulnerable: Unprivileged eBPF enabled\n");
+
 		return sprintf(buf, "Mitigation: %s%s\n", v2_str, bhb_str);
 	case SPECTRE_VULNERABLE:
 		fallthrough;
@@ -1125,3 +1138,16 @@ void __init spectre_bhb_patch_clearbhb(s
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


