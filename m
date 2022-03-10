Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE1B4D4A17
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243414AbiCJOWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243421AbiCJOVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:21:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54815C2E70;
        Thu, 10 Mar 2022 06:20:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B468E61CEE;
        Thu, 10 Mar 2022 14:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D44C340E8;
        Thu, 10 Mar 2022 14:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922036;
        bh=YYTxn4Nwrg6CuOgCloYwoSlfT43YKOmCi0fRD30gcL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nmxam5bhJ2y52W/77Kw+i70hjxKmbZjpAvNVkpQy95eyrYTBoM8RS8JMkmgaD9H3M
         QYuoDZ1tRPqexHw2BdRnMaX1n7KGYRbOv0gMcPkOsqXhVT32CrA6l6i0Lv0MvrGmYi
         dKxIGP2gw0It7v9Nx5EwP32AvY3JmFDtLGY0qbDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.14 17/31] ARM: include unprivileged BPF status in Spectre V2 reporting
Date:   Thu, 10 Mar 2022 15:18:30 +0100
Message-Id: <20220310140808.037993536@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140807.524313448@linuxfoundation.org>
References: <20220310140807.524313448@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 25875aa71dfefd1959f07e626c4d285b88b27ac2 upstream.

The mitigations for Spectre-BHB are only applied when an exception
is taken, but when unprivileged BPF is enabled, userspace can
load BPF programs that can be used to exploit the problem.

When unprivileged BPF is enabled, report the vulnerable status via
the spectre_v2 sysfs file.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/spectre.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/arm/kernel/spectre.c
+++ b/arch/arm/kernel/spectre.c
@@ -1,9 +1,19 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#include <linux/bpf.h>
 #include <linux/cpu.h>
 #include <linux/device.h>
 
 #include <asm/spectre.h>
 
+static bool _unprivileged_ebpf_enabled(void)
+{
+#ifdef CONFIG_BPF_SYSCALL
+	return !sysctl_unprivileged_bpf_disabled;
+#else
+	return false
+#endif
+}
+
 ssize_t cpu_show_spectre_v1(struct device *dev, struct device_attribute *attr,
 			    char *buf)
 {
@@ -31,6 +41,9 @@ ssize_t cpu_show_spectre_v2(struct devic
 	if (spectre_v2_state != SPECTRE_MITIGATED)
 		return sprintf(buf, "%s\n", "Vulnerable");
 
+	if (_unprivileged_ebpf_enabled())
+		return sprintf(buf, "Vulnerable: Unprivileged eBPF enabled\n");
+
 	switch (spectre_v2_methods) {
 	case SPECTRE_V2_METHOD_BPIALL:
 		method = "Branch predictor hardening";


