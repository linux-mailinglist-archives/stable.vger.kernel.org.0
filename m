Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727BF1FE1BB
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbgFRB4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728705AbgFRBZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:25:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 748D12083B;
        Thu, 18 Jun 2020 01:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443518;
        bh=pWp5whErmJ4Ic7w6wL0o19Xjfyw0DXak7LVcI12+LI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRSo04dZkrWUWYCJ8v6fttMdaECQUl1+OvNnsbX3L8Rfh5pWEEE3BMCt1YSx8VJAb
         riKWXLpUQSFufPEv+4SIpR0Tbw48f/CnwxaAbocurjv1wCrhvhUnuYNIy6NZtOkRPJ
         8qDROkUx/TRxrhcmlUh9TUV0GpIwKGzBYFNOr5cQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 141/172] pinctrl: imxl: Fix an error handling path in 'imx1_pinctrl_core_probe()'
Date:   Wed, 17 Jun 2020 21:21:47 -0400
Message-Id: <20200618012218.607130-141-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 9eb728321286c4b31e964d2377fca2368526d408 ]

When 'pinctrl_register()' has been turned into 'devm_pinctrl_register()',
an error handling path has not been updated.

Axe a now unneeded 'pinctrl_unregister()'.

Fixes: e55e025d1687 ("pinctrl: imxl: Use devm_pinctrl_register() for pinctrl registration")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20200530201952.585798-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/freescale/pinctrl-imx1-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/freescale/pinctrl-imx1-core.c b/drivers/pinctrl/freescale/pinctrl-imx1-core.c
index deb7870b3d1a..961c24e0cc8f 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx1-core.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx1-core.c
@@ -638,7 +638,6 @@ int imx1_pinctrl_core_probe(struct platform_device *pdev,
 
 	ret = of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
 	if (ret) {
-		pinctrl_unregister(ipctl->pctl);
 		dev_err(&pdev->dev, "Failed to populate subdevices\n");
 		return ret;
 	}
-- 
2.25.1

