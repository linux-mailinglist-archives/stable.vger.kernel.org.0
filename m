Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E6D2061F6
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390841AbgFWUww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404039AbgFWUrM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:47:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE0BF214DB;
        Tue, 23 Jun 2020 20:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945232;
        bh=tB9HClPapjm2N8It0LFNU0Er/q0BNIUsiI8D6yFKrBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UY/d5v+Ho99bKNujIG7oWFz9dWgZGoGBDiWoCrrPSg/7+5He86YP3jRgO5GFwfA2j
         XAol+KsA8cJ7RIgpMew860fD9TuUU2LNJdnOXPxcanGdW9NpBVL9zKaYe8ivbtbBd9
         Yl4vdJU7WiLn6P2y1iYNefm9hyM2X1MTxs8PElmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 090/136] pinctrl: freescale: imx: Fix an error handling path in imx_pinctrl_probe()
Date:   Tue, 23 Jun 2020 21:59:06 +0200
Message-Id: <20200623195308.195412749@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 11d8da5cabf7c6c3263ba2cd9c00260395867048 ]

'pinctrl_unregister()' should not be called to undo
'devm_pinctrl_register_and_init()', it is already handled by the framework.

This simplifies the error handling paths of the probe function.
The 'imx_free_resources()' can be removed as well.

Fixes: a51c158bf0f7 ("pinctrl: imx: use radix trees for groups and functions")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Link: https://lore.kernel.org/r/20200530204955.588962-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/freescale/pinctrl-imx.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/pinctrl/freescale/pinctrl-imx.c b/drivers/pinctrl/freescale/pinctrl-imx.c
index 17f2c5a505b25..ec0119e1e7810 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx.c
@@ -661,16 +661,6 @@ static int imx_pinctrl_probe_dt(struct platform_device *pdev,
 	return 0;
 }
 
-/*
- * imx_free_resources() - free memory used by this driver
- * @info: info driver instance
- */
-static void imx_free_resources(struct imx_pinctrl *ipctl)
-{
-	if (ipctl->pctl)
-		pinctrl_unregister(ipctl->pctl);
-}
-
 int imx_pinctrl_probe(struct platform_device *pdev,
 		      struct imx_pinctrl_soc_info *info)
 {
@@ -761,21 +751,16 @@ int imx_pinctrl_probe(struct platform_device *pdev,
 					     &ipctl->pctl);
 	if (ret) {
 		dev_err(&pdev->dev, "could not register IMX pinctrl driver\n");
-		goto free;
+		return ret;
 	}
 
 	ret = imx_pinctrl_probe_dt(pdev, ipctl);
 	if (ret) {
 		dev_err(&pdev->dev, "fail to probe dt properties\n");
-		goto free;
+		return ret;
 	}
 
 	dev_info(&pdev->dev, "initialized IMX pinctrl driver\n");
 
 	return pinctrl_enable(ipctl->pctl);
-
-free:
-	imx_free_resources(ipctl);
-
-	return ret;
 }
-- 
2.25.1



