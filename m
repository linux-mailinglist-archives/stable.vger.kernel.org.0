Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA1D45E55B
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358517AbhKZClg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:41:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358031AbhKZCjf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:39:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBDD961242;
        Fri, 26 Nov 2021 02:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894042;
        bh=EVCyJxq0Rk/sGpamv5LAGeHhzwS5mU1kOyobSTBO/4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnpoa+tamGYF7djetfTGr9a5ttfsoNffWesiPCLhxkzJgkGCeTeh5O9L1NFxqXf9D
         OpC6A3Pxf41XEpgIwv4gC3bzsvpwRgxmK4xwy1INi+FOaKmBMtl6qzKnM9AUiRFqR7
         vcJnjXHk3yIaVjCPjJPVU+PszdlxqXhvO2X7DDzmfRAx4GeTDcj6q9nSiUoHwanW1p
         E9+1aJcV0NmYzLKOnh3am6rJYl27+EuFHVoxYxZgeMIW6VJ5f6TmMj59A9jnyctnO1
         4Hm82LkO8ANKxC5trb+iV4fTq8TM1dfIrEZtSK2ns+tWQqQP18l2obIZoTmnceWkOW
         7ltqbpgWKoERA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Braha <julianbraha@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/28] pinctrl: qcom: fix unmet dependencies on GPIOLIB for GPIOLIB_IRQCHIP
Date:   Thu, 25 Nov 2021 21:33:26 -0500
Message-Id: <20211126023343.442045-11-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023343.442045-1-sashal@kernel.org>
References: <20211126023343.442045-1-sashal@kernel.org>
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
index 5fe7b8aaf69d8..a209eb1f189ab 100644
--- a/drivers/pinctrl/qcom/Kconfig
+++ b/drivers/pinctrl/qcom/Kconfig
@@ -169,6 +169,7 @@ config PINCTRL_QCOM_SPMI_PMIC
 	select PINMUX
 	select PINCONF
 	select GENERIC_PINCONF
+  select GPIOLIB
 	select GPIOLIB_IRQCHIP
 	select IRQ_DOMAIN_HIERARCHY
 	help
@@ -183,6 +184,7 @@ config PINCTRL_QCOM_SSBI_PMIC
 	select PINMUX
 	select PINCONF
 	select GENERIC_PINCONF
+  select GPIOLIB
 	select GPIOLIB_IRQCHIP
 	select IRQ_DOMAIN_HIERARCHY
 	help
-- 
2.33.0

