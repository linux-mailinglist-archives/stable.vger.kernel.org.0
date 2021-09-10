Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76D8406262
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241701AbhIJAp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232381AbhIJAVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6B26610E9;
        Fri, 10 Sep 2021 00:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233202;
        bh=qGLb3QTiSCz8SrUkiu5OPBBspFGjPc7B2rXYIOOeTyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rx1LLeiuBuCVFp4yuvtdPP3F/Iiy8sFgfdu9VA26wpZULj1mi9dQ42K6KkAgDczQ6
         AOd1mI3QQ3zzdlrRRADqwU8tqTvaT6cQn6b1ijJsP5B+xOfxMvLKiAKuU2sZTWu1dQ
         SuzaOtddDGLaZahunOSSQ2dPusrOcrXWPRUrTHgjQyYkE+k9VtFoCpCMiASVyI7UVR
         CVI5i5BB49LHBRmjfCFayX78ZLs0BKGaOwgjUpA2l4HvAMe45W1ykDiYclB/PsLxj3
         7qeazaRm1fQX+uzJEuHZxgbCtTWMP8plD7zDBxqMqIw1EgmuVTmgBqr/+whD5YLTkl
         MiZtCdjO11EQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 72/88] MIPS: ingenic: Unconditionally enable clock of CPU #0
Date:   Thu,  9 Sep 2021 20:18:04 -0400
Message-Id: <20210910001820.174272-72-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
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

