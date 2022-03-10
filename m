Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687E14D4B90
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244232AbiCJOdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245145AbiCJOaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:30:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20D41688EE;
        Thu, 10 Mar 2022 06:25:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4941BB82615;
        Thu, 10 Mar 2022 14:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8230FC36AE2;
        Thu, 10 Mar 2022 14:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922327;
        bh=KQ/z7MJIjzydCdxJw2qt2ZWgIt4pm1aDURrKJrC2ub0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3FXbM1cS/tBmJP1An5meBuT9X6mo0UW+6W2A5dYUdDdPrdmvxPnXUNnoNtDw+MZi
         gdxmG0BIXUrxWuJ0Gh5fHQ326Chm/KdF7rQJLdJwA6Q6FrRelOx6YS659Oe+ZOtUlI
         8OJ2egbacLkh4zudL3EEFx98OoViDcdDXYy1wT9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.10 42/58] arm64: proton-pack: Include unprivileged eBPF status in Spectre v2 mitigation reporting
Date:   Thu, 10 Mar 2022 15:19:02 +0100
Message-Id: <20220310140814.068974463@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140812.869208747@linuxfoundation.org>
References: <20220310140812.869208747@linuxfoundation.org>
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
@@ -110,6 +111,15 @@ static const char *get_bhb_affected_stri
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
@@ -129,6 +139,9 @@ ssize_t cpu_show_spectre_v2(struct devic
 		v2_str = "CSV2";
 		fallthrough;
 	case SPECTRE_MITIGATED:
+		if (bhb_state == SPECTRE_MITIGATED && _unprivileged_ebpf_enabled())
+			return sprintf(buf, "Vulnerable: Unprivileged eBPF enabled\n");
+
 		return sprintf(buf, "Mitigation: %s%s\n", v2_str, bhb_str);
 	case SPECTRE_VULNERABLE:
 		fallthrough;
@@ -1108,3 +1121,16 @@ void noinstr spectre_bhb_patch_loop_iter
 					 AARCH64_INSN_MOVEWIDE_ZERO);
 	*updptr++ = cpu_to_le32(insn);
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


