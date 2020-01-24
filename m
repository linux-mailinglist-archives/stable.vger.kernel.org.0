Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E78B148399
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404450AbgAXLce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:32:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404448AbgAXLcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:32:33 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79529222C2;
        Fri, 24 Jan 2020 11:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865553;
        bh=qBbBftGjyQ8ngYqtOARXAu/XpohrVD5JsN0yW8v9P8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZUCCjmPQFEzsXuom/iGNEmKno40zTtfCjmjjp/eEY1YZXamjHhsOrHipejcs4A7d
         FcQGuS5YRyGXAjUtHtB7PjgFIRG870eEnClYtWjZkxWekBE6v8TgHK5CNStkizmZzU
         fgS5egqkydVCX0na4+FWaa6mmRHaTK35Gjz/SQnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rashmica Gupta <rashmica.g@gmail.com>,
        Andrew Jeffery <andrew@aj.id.au>, Joel Stanley <joel@jms.d.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 561/639] gpio/aspeed: Fix incorrect number of banks
Date:   Fri, 24 Jan 2020 10:32:11 +0100
Message-Id: <20200124093159.612855976@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rashmica Gupta <rashmica.g@gmail.com>

[ Upstream commit 3c4710ae6f883f9c6e3df5e27e274702a1221c57 ]

The current calculation for the number of GPIO banks is only correct if
the number of GPIOs is a multiple of 32 (if there were 31 GPIOs we would
currently say there are 0 banks, which is incorrect).

Fixes: 361b79119a4b7 ('gpio: Add Aspeed driver')

Signed-off-by: Rashmica Gupta <rashmica.g@gmail.com>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20190906062623.13354-1-rashmica.g@gmail.com
Reviewed-by: Joel Stanley <joel@jms.d.au>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-aspeed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-aspeed.c b/drivers/gpio/gpio-aspeed.c
index b696ec35efb38..e627e0e9001ae 100644
--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -1199,7 +1199,7 @@ static int __init aspeed_gpio_probe(struct platform_device *pdev)
 	gpio->chip.irq.need_valid_mask = true;
 
 	/* Allocate a cache of the output registers */
-	banks = gpio->config->nr_gpios >> 5;
+	banks = DIV_ROUND_UP(gpio->config->nr_gpios, 32);
 	gpio->dcache = devm_kcalloc(&pdev->dev,
 				    banks, sizeof(u32), GFP_KERNEL);
 	if (!gpio->dcache)
-- 
2.20.1



