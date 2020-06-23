Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DF6206546
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388919AbgFWUMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387612AbgFWUL6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:11:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D34D02073E;
        Tue, 23 Jun 2020 20:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943118;
        bh=qCwwKKQpp5o/nt8/xbyiQ5qTYy0kjm6IZqzVdG/ItpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKJBfKHCV7gDnrxkrS2jUIGglAOqEflbMgV90jZoyRRDrYKMSL1nUOfycEsbk4LKc
         x5P6lp3Fag420HVwITQrZBjDhSzbAj7HZgIoPwwSR3O4sFp59xd/kG+kPlptvM3Z7x
         kj0oTAwTfE36Vt7t1+OgjA6Mnlj47MLZ4uicuI+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 265/477] pinctrl: Fix return value about devm_platform_ioremap_resource()
Date:   Tue, 23 Jun 2020 21:54:22 +0200
Message-Id: <20200623195420.094080299@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit b5d9ff10dca49f4d4b7846c3751c6bec50d07375 ]

When call function devm_platform_ioremap_resource(), we should use IS_ERR()
to check the return value and return PTR_ERR() if failed.

Fixes: 4b024225c4a8 ("pinctrl: use devm_platform_ioremap_resource() to simplify code")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/r/1590234326-2194-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm281xx.c | 2 +-
 drivers/pinctrl/pinctrl-at91-pio4.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm281xx.c b/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
index f690fc5cd6885..71e6661783006 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
@@ -1406,7 +1406,7 @@ static int __init bcm281xx_pinctrl_probe(struct platform_device *pdev)
 	pdata->reg_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(pdata->reg_base)) {
 		dev_err(&pdev->dev, "Failed to ioremap MEM resource\n");
-		return -ENODEV;
+		return PTR_ERR(pdata->reg_base);
 	}
 
 	/* Initialize the dynamic part of pinctrl_desc */
diff --git a/drivers/pinctrl/pinctrl-at91-pio4.c b/drivers/pinctrl/pinctrl-at91-pio4.c
index 694912409fd9e..54222ccddfb19 100644
--- a/drivers/pinctrl/pinctrl-at91-pio4.c
+++ b/drivers/pinctrl/pinctrl-at91-pio4.c
@@ -1019,7 +1019,7 @@ static int atmel_pinctrl_probe(struct platform_device *pdev)
 
 	atmel_pioctrl->reg_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(atmel_pioctrl->reg_base))
-		return -EINVAL;
+		return PTR_ERR(atmel_pioctrl->reg_base);
 
 	atmel_pioctrl->clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(atmel_pioctrl->clk)) {
-- 
2.25.1



