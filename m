Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B374522A9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350167AbhKPBPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:15:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244262AbhKOTMQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:12:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 608FD63400;
        Mon, 15 Nov 2021 18:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000394;
        bh=vAwMGHO+K2kNv+dRoRSP0A9wrzpTrEvkYe+haWOfJys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtOKXKemUirMHWDcLXQrRg9t1AUtVCRRNDckHzNN5C4gEMoiJaSZ8AZcAg56cGoU/
         mEoFE9eUJsM1yEwBTlR0O7wIaQTiAx5eMIoEyTbm4qNkq7pGzt5v5r4Xgy0kVxrl21
         bX4XtzqBe4puByLMqa0/udMLT9+6zjUAKqh7dgNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rahul Tanwar <rtanwar@maxlinear.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 637/849] pinctrl: equilibrium: Fix function addition in multiple groups
Date:   Mon, 15 Nov 2021 18:02:00 +0100
Message-Id: <20211115165441.817519524@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Tanwar <rtanwar@maxlinear.com>

[ Upstream commit 53b3947ddb7f309d1f611f8dc9bfd6ea9d699907 ]

Ignore the same function with multiple groups.
Fix a typo in error print.

Fixes: 1948d5c51dba ("pinctrl: Add pinmux & GPIO controller driver for a new SoC")
Signed-off-by: Rahul Tanwar <rtanwar@maxlinear.com>
Link: https://lore.kernel.org/r/20211020093815.20870-1-rtanwar@maxlinear.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-equilibrium.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-equilibrium.c b/drivers/pinctrl/pinctrl-equilibrium.c
index 38cc20fa9d5af..44e6973b2ea93 100644
--- a/drivers/pinctrl/pinctrl-equilibrium.c
+++ b/drivers/pinctrl/pinctrl-equilibrium.c
@@ -675,6 +675,11 @@ static int eqbr_build_functions(struct eqbr_pinctrl_drv_data *drvdata)
 		return ret;
 
 	for (i = 0; i < nr_funcs; i++) {
+
+		/* Ignore the same function with multiple groups */
+		if (funcs[i].name == NULL)
+			continue;
+
 		ret = pinmux_generic_add_function(drvdata->pctl_dev,
 						  funcs[i].name,
 						  funcs[i].groups,
@@ -815,7 +820,7 @@ static int pinctrl_reg(struct eqbr_pinctrl_drv_data *drvdata)
 
 	ret = eqbr_build_functions(drvdata);
 	if (ret) {
-		dev_err(dev, "Failed to build groups\n");
+		dev_err(dev, "Failed to build functions\n");
 		return ret;
 	}
 
-- 
2.33.0



