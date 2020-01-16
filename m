Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D4F13F337
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436970AbgAPSlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:41:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390316AbgAPRLu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CBD424697;
        Thu, 16 Jan 2020 17:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194709;
        bh=jra6bcN6e0FvRK3fGf7npFyWGdYaW1XNRiWBWNJOPg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jApRsRWRSQi3D1AP/Uqo7Pc1vrRo1LZx7l05BL7qP2cL6K0g8JlO5Yz5yza8yu+KO
         pJzPF/I4NsIc6AUtdqAgSC5nx3uC8UbUwjsYiblIIYN+GMDpmwYN9ahe4uKVU3R3pL
         sIiv4zlSJmSkQp5ppfhSFm5uCroZme2JkJzeiyhM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rashmica Gupta <rashmica.g@gmail.com>,
        Andrew Jeffery <andrew@aj.id.au>, Joel Stanley <joel@jms.d.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 547/671] gpio/aspeed: Fix incorrect number of banks
Date:   Thu, 16 Jan 2020 12:03:05 -0500
Message-Id: <20200116170509.12787-284-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b696ec35efb3..e627e0e9001a 100644
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

