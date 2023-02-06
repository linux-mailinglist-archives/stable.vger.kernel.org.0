Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714C768C6E0
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 20:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBFTd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 14:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjBFTd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 14:33:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF50A2278B;
        Mon,  6 Feb 2023 11:33:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43AE460F66;
        Mon,  6 Feb 2023 19:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8B3C4339E;
        Mon,  6 Feb 2023 19:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675712004;
        bh=ltcx1qeeSJScHI0s0nVFJOfuuP7m+2Wa2sIT/EiYuZU=;
        h=From:To:Cc:Subject:Date:From;
        b=ImtggLDgTQjbm4+Rd+XzSaineQh+lSsrx9T+nppGBn1ETBctz4xNDJtKYVMYPezx8
         7NWdzl8HQsSL6BrMfbpMCO0WG5MpRnJqMgRuPVRwuw/o8SUdLy2/M5iBVw7QI3r3fQ
         uQWmx9Ah0UZaDKEBYXhXs9eR/ptv6OB3UcLCZIBcHzRgwE0DYxWK+6/2nHjFhrkWYp
         w02AR6A7LqO89qwGxekiWCn35trq7u3E085fpSLrKVjpNOW5CsZZsCxhgNLJq6US5m
         oWvJFskxFwMiUTrpW/Vm5Tf7r+Qiml0mNbLAkx/3rJTcEMbkDw+3HggMZPeaY+Jf8G
         Q072lcxVoZaRw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org,
        Anup Patel <anup@brainfault.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Michael Walle <michael@walle.cc>,
        Thierry Reding <treding@nvidia.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] cpuidle: add ARCH_SUSPEND_POSSIBLE dependencies
Date:   Mon,  6 Feb 2023 20:33:06 +0100
Message-Id: <20230206193319.4107220-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Some ARMv4 processors don't support suspend, which leads
to a build failure with the tegra and qualcomm cpuidle driver:

WARNING: unmet direct dependencies detected for ARM_CPU_SUSPEND
  Depends on [n]: ARCH_SUSPEND_POSSIBLE [=n]
  Selected by [y]:
  - ARM_TEGRA_CPUIDLE [=y] && CPU_IDLE [=y] && (ARM [=y] || ARM64) && (ARCH_TEGRA [=n] || COMPILE_TEST [=y]) && !ARM64 && MMU [=y]

arch/arm/kernel/sleep.o: in function `__cpu_suspend':
(.text+0x68): undefined reference to `cpu_sa110_suspend_size'
(.text+0x68): undefined reference to `cpu_fa526_suspend_size'

Add an explicit dependency to make randconfig builds avoid
this combination.

Fixes: faae6c9f2e68 ("cpuidle: tegra: Enable compile testing")
Fixes: a871be6b8eee ("cpuidle: Convert Qualcomm SPM driver to a generic CPUidle driver")
Link: https://lore.kernel.org/all/20211013160125.772873-1-arnd@kernel.org/
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I found this in my backlog of patches that never made it upstream,
testing shows this is still needed. Please apply.
---
 drivers/cpuidle/Kconfig.arm | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpuidle/Kconfig.arm b/drivers/cpuidle/Kconfig.arm
index 747aa537389b..f0714a32921e 100644
--- a/drivers/cpuidle/Kconfig.arm
+++ b/drivers/cpuidle/Kconfig.arm
@@ -102,6 +102,7 @@ config ARM_MVEBU_V7_CPUIDLE
 config ARM_TEGRA_CPUIDLE
 	bool "CPU Idle Driver for NVIDIA Tegra SoCs"
 	depends on (ARCH_TEGRA || COMPILE_TEST) && !ARM64 && MMU
+	depends on ARCH_SUSPEND_POSSIBLE
 	select ARCH_NEEDS_CPU_IDLE_COUPLED if SMP
 	select ARM_CPU_SUSPEND
 	help
@@ -110,6 +111,7 @@ config ARM_TEGRA_CPUIDLE
 config ARM_QCOM_SPM_CPUIDLE
 	bool "CPU Idle Driver for Qualcomm Subsystem Power Manager (SPM)"
 	depends on (ARCH_QCOM || COMPILE_TEST) && !ARM64 && MMU
+	depends on ARCH_SUSPEND_POSSIBLE
 	select ARM_CPU_SUSPEND
 	select CPU_IDLE_MULTIPLE_DRIVERS
 	select DT_IDLE_STATES
-- 
2.39.0

