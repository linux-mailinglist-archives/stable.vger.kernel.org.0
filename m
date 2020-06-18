Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4EC1FE3BA
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgFRCM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729148AbgFRBVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:21:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA773214DB;
        Thu, 18 Jun 2020 01:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443280;
        bh=pa5xwxs/YMVeg48Xp1oAklH4xCcH4s/8Z/abaSwieRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ub8SSKzs1CjhBG2BQLBlO1tKbwJJ40lC5yLytrFLAfaLoyFEI3zLfC4iVB0+95+e6
         r1AWPdD/KCUGqRcOUXXT8aIQN1BsfQz8veIzSVTBv0V7n+0Q5Usum2mqqc+DhJyF5e
         tPydOaMujpuLa+Fv3Tvybi0cd2VW22K1dBgAXYvE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 224/266] pinctrl: freescale: imx: Use 'devm_of_iomap()' to avoid a resource leak in case of error in 'imx_pinctrl_probe()'
Date:   Wed, 17 Jun 2020 21:15:49 -0400
Message-Id: <20200618011631.604574-224-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ba403242615c2c99e27af7984b1650771a2cc2c9 ]

Use 'devm_of_iomap()' instead 'of_iomap()' to avoid a resource leak in
case of error.

Update the error handling code accordingly.

Fixes: 26d8cde5260b ("pinctrl: freescale: imx: add shared input select reg support")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200602200626.677981-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/freescale/pinctrl-imx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/freescale/pinctrl-imx.c b/drivers/pinctrl/freescale/pinctrl-imx.c
index 1f81569c7ae3..cb7e0f08d2cf 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx.c
@@ -824,12 +824,13 @@ int imx_pinctrl_probe(struct platform_device *pdev,
 				return -EINVAL;
 			}
 
-			ipctl->input_sel_base = of_iomap(np, 0);
+			ipctl->input_sel_base = devm_of_iomap(&pdev->dev, np,
+							      0, NULL);
 			of_node_put(np);
-			if (!ipctl->input_sel_base) {
+			if (IS_ERR(ipctl->input_sel_base)) {
 				dev_err(&pdev->dev,
 					"iomuxc input select base address not found\n");
-				return -ENOMEM;
+				return PTR_ERR(ipctl->input_sel_base);
 			}
 		}
 	}
-- 
2.25.1

