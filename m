Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933E74061A0
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbhIJAnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232674AbhIJATD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4C13611C2;
        Fri, 10 Sep 2021 00:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233071;
        bh=qGLb3QTiSCz8SrUkiu5OPBBspFGjPc7B2rXYIOOeTyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/4jT1CS6aMmWE3CtqQvOvwm5aRAynJU8CcFEo6snYrWEeV/CzBjn/ZPTqt3rYV1u
         VIcyJgA08QR56ktbrxLmJD8j6dFKoDoTU0x8+Juj3vNIrBmjROJiWwXv1eiD1uTg+U
         w9QoYJDz+GQ45g88bxfSgbjFM+zs0g2oKxul8dGi/PGSuc5mKt29qBv7n9hHoOuYey
         KOjUEpXqeAV0S1F/+6uCczoFToo4azKB0BG8Fd1iIiYxAQbTEaj6d8sKr0294q7Trf
         Ee3nyCvz/8NuCKMU7f7kGFjLKlFBUTDiwKou2TzkRLAPVFt0yOxvqaglsvqG2QZQgE
         OjSHFuYuNiQ7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 81/99] MIPS: ingenic: Unconditionally enable clock of CPU #0
Date:   Thu,  9 Sep 2021 20:15:40 -0400
Message-Id: <20210910001558.173296-81-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 71f8817c28e2e1e5549138e2aef68c2fd784e162 ]

Make sure that the PLL that feeds the CPU won't be stopped while the
kernel is running.

This fixes a problem on JZ4760 (and probably others) where under very
specific conditions, the main PLL would be turned OFF when the kernel
was shutting down, causing the shutdown process to fail.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/generic/board-ingenic.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/mips/generic/board-ingenic.c b/arch/mips/generic/board-ingenic.c
index 0cec0bea13d6..11387a93867b 100644
--- a/arch/mips/generic/board-ingenic.c
+++ b/arch/mips/generic/board-ingenic.c
@@ -7,6 +7,8 @@
  * Copyright (C) 2020 Paul Cercueil <paul@crapouillou.net>
  */
 
+#include <linux/clk.h>
+#include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_fdt.h>
 #include <linux/pm.h>
@@ -108,10 +110,36 @@ static const struct platform_suspend_ops ingenic_pm_ops __maybe_unused = {
 
 static int __init ingenic_pm_init(void)
 {
+	struct device_node *cpu_node;
+	struct clk *cpu0_clk;
+	int ret;
+
 	if (boot_cpu_type() == CPU_XBURST) {
 		if (IS_ENABLED(CONFIG_PM_SLEEP))
 			suspend_set_ops(&ingenic_pm_ops);
 		_machine_halt = ingenic_halt;
+
+		/*
+		 * Unconditionally enable the clock for the first CPU.
+		 * This makes sure that the PLL that feeds the CPU won't be
+		 * stopped while the kernel is running.
+		 */
+		cpu_node = of_get_cpu_node(0, NULL);
+		if (!cpu_node) {
+			pr_err("Unable to get CPU node\n");
+		} else {
+			cpu0_clk = of_clk_get(cpu_node, 0);
+			if (IS_ERR(cpu0_clk)) {
+				pr_err("Unable to get CPU0 clock\n");
+				return PTR_ERR(cpu0_clk);
+			}
+
+			ret = clk_prepare_enable(cpu0_clk);
+			if (ret) {
+				pr_err("Unable to enable CPU0 clock\n");
+				return ret;
+			}
+		}
 	}
 
 	return 0;
-- 
2.30.2

