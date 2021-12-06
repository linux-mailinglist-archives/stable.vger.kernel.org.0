Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF41469E6B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359083AbhLFPis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376886AbhLFPgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:36:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1119BC09CE43;
        Mon,  6 Dec 2021 07:21:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF868B81139;
        Mon,  6 Dec 2021 15:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EB5C341C2;
        Mon,  6 Dec 2021 15:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804094;
        bh=UzqaebKBV5bYS0+HIMERNcMNfx6MivWVu8hV4+oWe1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pVYma+CbPyr4/5TC59Tw+t2thzyqxzMKmaszi7l25LWJzzhOFQBWYDeyzSM4zLqSl
         PuIuXGVHgCu6OAPIyeZPJM1pqx037oby2ExWU6Rwa5ZTxbgL2Sz9//IIXKkbafkp00
         1lmtTtHsQrOc9Ln13gycddC+YkAluZR5g1+kQ+gU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Braha <julianbraha@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/207] pinctrl: qcom: fix unmet dependencies on GPIOLIB for GPIOLIB_IRQCHIP
Date:   Mon,  6 Dec 2021 15:54:38 +0100
Message-Id: <20211206145611.040824733@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



