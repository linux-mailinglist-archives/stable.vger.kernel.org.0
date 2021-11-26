Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A475445E4F0
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357730AbhKZChz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:37:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357731AbhKZCfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:35:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2321A611BF;
        Fri, 26 Nov 2021 02:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893941;
        bh=UzqaebKBV5bYS0+HIMERNcMNfx6MivWVu8hV4+oWe1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rOEiY1/mk2DC7/jio0ZFmHt/XblHTI4YWTuQ1vcB1nw6gWfyDCgY/Z8OeUmmaJXOB
         tkpNCfeVp4iA3NzpnAKbLoAQ/GWqLKd5M5tAIIUV3bJSUiP4DJICMlbKHxmbv//HhF
         9lTI92/v3T3wfv4T4GL1cpk1qv9MFANPG2aJJfF0QGyVrRgP4HXPwnW5WeENDrUODg
         bat/IXkHzDHAXu+QAImxQEJgftf0lza4M5eaFtC1xQWpmcCx32dx3SS6Pv8oCr+d5e
         eHrI+tfGKhRA1w4BN18rBN/qC38Bh9DsUlsG7NsBGpTC3yZpidzpEzatFZqCsPxKWj
         nJdxWi/+/86OA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Braha <julianbraha@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 13/39] pinctrl: qcom: fix unmet dependencies on GPIOLIB for GPIOLIB_IRQCHIP
Date:   Thu, 25 Nov 2021 21:31:30 -0500
Message-Id: <20211126023156.441292-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 60430d4c4eddcdf8eac2bdbec9704f84a436eedf ]

When PINCTRL_QCOM_SPMI_PMIC or PINCTRL_QCOM_SSBI_PMIC
is selected, and GPIOLIB is not selected, Kbuild
gives the following warnings:

WARNING: unmet direct dependencies detected for GPIOLIB_IRQCHIP
  Depends on [n]: GPIOLIB [=n]
  Selected by [y]:
  - PINCTRL_QCOM_SPMI_PMIC [=y] && PINCTRL [=y] && (ARCH_QCOM [=n] || COMPILE_TEST [=y]) && OF [=y] && SPMI [=y]

WARNING: unmet direct dependencies detected for GPIOLIB_IRQCHIP
  Depends on [n]: GPIOLIB [=n]
  Selected by [y]:
  - PINCTRL_QCOM_SSBI_PMIC [=y] && PINCTRL [=y] && (ARCH_QCOM [=n] || COMPILE_TEST [=y]) && OF [=y]

This is because these config options enable GPIOLIB_IRQCHIP
without selecting or depending on GPIOLIB, despite
GPIOLIB_IRQCHIP depending on GPIOLIB.

These unmet dependency bugs were detected by Kismet,
a static analysis tool for Kconfig. Please advise if this
is not the appropriate solution.

Signed-off-by: Julian Braha <julianbraha@gmail.com>
Link: https://lore.kernel.org/r/20211029004610.35131-1-julianbraha@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/qcom/Kconfig b/drivers/pinctrl/qcom/Kconfig
index 5ff4207df66e1..f1b5176a5085b 100644
--- a/drivers/pinctrl/qcom/Kconfig
+++ b/drivers/pinctrl/qcom/Kconfig
@@ -189,6 +189,7 @@ config PINCTRL_QCOM_SPMI_PMIC
 	select PINMUX
 	select PINCONF
 	select GENERIC_PINCONF
+  select GPIOLIB
 	select GPIOLIB_IRQCHIP
 	select IRQ_DOMAIN_HIERARCHY
 	help
@@ -203,6 +204,7 @@ config PINCTRL_QCOM_SSBI_PMIC
 	select PINMUX
 	select PINCONF
 	select GENERIC_PINCONF
+  select GPIOLIB
 	select GPIOLIB_IRQCHIP
 	select IRQ_DOMAIN_HIERARCHY
 	help
-- 
2.33.0

