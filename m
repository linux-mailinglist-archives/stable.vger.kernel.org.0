Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612D6450E55
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238607AbhKOSOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:14:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240314AbhKOSHe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F7FC63308;
        Mon, 15 Nov 2021 17:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998278;
        bh=SJIbmXAXDKiZUsMy+p9ytQ0+jcp2PAnhVO1pJGakczw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHC4ZWlw1dmLf76Na8m15TlFqRDEGTo8+et0GOudQoLN/srY3MIWxmssbD9xulOmx
         +HphNdmYJN//9zPPvTaHCcHugBqlH4DhAbJSv/FlZZD67I7MZbwksNGBsX8Ra5F6zv
         GnKfQ9bKVL8LASSreLS+0vFuOGwQA2wpTSPU44GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rahul Tanwar <rtanwar@maxlinear.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 452/575] pinctrl: equilibrium: Fix function addition in multiple groups
Date:   Mon, 15 Nov 2021 18:02:57 +0100
Message-Id: <20211115165359.385757147@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index ac1c47f542c11..3b6dcaa80e000 100644
--- a/drivers/pinctrl/pinctrl-equilibrium.c
+++ b/drivers/pinctrl/pinctrl-equilibrium.c
@@ -674,6 +674,11 @@ static int eqbr_build_functions(struct eqbr_pinctrl_drv_data *drvdata)
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
@@ -805,7 +810,7 @@ static int pinctrl_reg(struct eqbr_pinctrl_drv_data *drvdata)
 
 	ret = eqbr_build_functions(drvdata);
 	if (ret) {
-		dev_err(dev, "Failed to build groups\n");
+		dev_err(dev, "Failed to build functions\n");
 		return ret;
 	}
 
-- 
2.33.0



