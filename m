Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D401A2064FE
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389158AbgFWUOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389154AbgFWUOG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:14:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 294142137B;
        Tue, 23 Jun 2020 20:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943245;
        bh=w3neRlGvV3RCtAXDWLv4hArf6yaqvfiLchBpIDVp1d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2Tj9Jox4JSI7TgeLSi+ACLAvBPy/DTB7hF6UEt27A95l3uDWcUkBaFma1ZG0eOOO
         gA47VkP7yFprhDHYrtVRLUitcggZ/5njqQShbTR1J7pEnurMbyOd4ZwvWKPxKEZibt
         rSo/AJuIXn2XH+E3NS11Ra5WgC6qyd1VkMV6yfuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 317/477] pinctrl: freescale: imx: Fix an error handling path in imx_pinctrl_probe()
Date:   Tue, 23 Jun 2020 21:55:14 +0200
Message-Id: <20200623195422.514224408@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
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
index 9f42036c5fbb8..1f81569c7ae3b 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx.c
@@ -774,16 +774,6 @@ static int imx_pinctrl_probe_dt(struct platform_device *pdev,
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
 		      const struct imx_pinctrl_soc_info *info)
 {
@@ -874,23 +864,18 @@ int imx_pinctrl_probe(struct platform_device *pdev,
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
 
 static int __maybe_unused imx_pinctrl_suspend(struct device *dev)
-- 
2.25.1



