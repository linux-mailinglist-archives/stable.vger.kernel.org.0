Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88AE1FDBDA
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgFRBPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:15:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729436AbgFRBPG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:15:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4637221EA;
        Thu, 18 Jun 2020 01:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442905;
        bh=FgPG6cCgUeE3avIJ+Y2VCR4P+1TbrZ2c2zsyKos1QuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u93fT35/LXUAGvqxB03JFmkW/0XADitz3UwkPKN5EAmxYCwiobhvlyPjOwunxI20x
         8VIRvH5E5BbWbt+DZDudBuumg62B2O0tAA9bKBVE45EsEJz0ctpNiem3PyyYVyNQ91
         zo6zj2IHzD353gc7XXGKOMEXe+jHqCWwCG7SdrH4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 325/388] pinctrl: freescale: imx: Fix an error handling path in 'imx_pinctrl_probe()'
Date:   Wed, 17 Jun 2020 21:07:02 -0400
Message-Id: <20200618010805.600873-325-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 9f42036c5fbb..1f81569c7ae3 100644
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

