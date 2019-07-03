Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACC6F5DC45
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfGCCVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727735AbfGCCPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:15:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 051CC21881;
        Wed,  3 Jul 2019 02:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120148;
        bh=toYS2SyXwu9I8pPzE4SwArCm9bthNpU8eWsf8dKk7d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9p6BYILAUL9Jk+94Q4dQOixtfiOd392rc2f/KoRNr4ZfQGkERn/JYS5xlEUBDoS9
         5u85mwY7JIFdPIlkQZtgSHv6T+WRCz37BfzBQdNDNGtfHnhB/XtRrXwNif+WWGcClu
         hOMrh5tSOV1W7pNrdi0M3T79zdrexh+B1HW0Fsgc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phil Reid <preid@electromag.com.au>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 23/39] pinctrl: mcp23s08: Fix add_data and irqchip_add_nested call order
Date:   Tue,  2 Jul 2019 22:14:58 -0400
Message-Id: <20190703021514.17727-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021514.17727-1-sashal@kernel.org>
References: <20190703021514.17727-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Reid <preid@electromag.com.au>

[ Upstream commit 6dbc6e6f58556369bf999cd7d9793586f1b0e4b4 ]

Currently probing of the mcp23s08 results in an error message
"detected irqchip that is shared with multiple gpiochips:
please fix the driver"

This is due to the following:

Call to mcp23s08_irqchip_setup() with call hierarchy:
mcp23s08_irqchip_setup()
  gpiochip_irqchip_add_nested()
    gpiochip_irqchip_add_key()
      gpiochip_set_irq_hooks()

Call to devm_gpiochip_add_data() with call hierarchy:
devm_gpiochip_add_data()
  gpiochip_add_data_with_key()
    gpiochip_add_irqchip()
      gpiochip_set_irq_hooks()

The gpiochip_add_irqchip() returns immediately if there isn't a irqchip
but we added a irqchip due to the previous mcp23s08_irqchip_setup()
call. So it calls gpiochip_set_irq_hooks() a second time.

Fix this by moving the call to devm_gpiochip_add_data before
the call to mcp23s08_irqchip_setup

Fixes: 02e389e63e35 ("pinctrl: mcp23s08: fix irq setup order")
Suggested-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Phil Reid <preid@electromag.com.au>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-mcp23s08.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-mcp23s08.c b/drivers/pinctrl/pinctrl-mcp23s08.c
index 5d7a8514def9..b727de5654cd 100644
--- a/drivers/pinctrl/pinctrl-mcp23s08.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08.c
@@ -881,6 +881,10 @@ static int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
 	if (ret < 0)
 		goto fail;
 
+	ret = devm_gpiochip_add_data(dev, &mcp->chip, mcp);
+	if (ret < 0)
+		goto fail;
+
 	mcp->irq_controller =
 		device_property_read_bool(dev, "interrupt-controller");
 	if (mcp->irq && mcp->irq_controller) {
@@ -922,10 +926,6 @@ static int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
 			goto fail;
 	}
 
-	ret = devm_gpiochip_add_data(dev, &mcp->chip, mcp);
-	if (ret < 0)
-		goto fail;
-
 	if (one_regmap_config) {
 		mcp->pinctrl_desc.name = devm_kasprintf(dev, GFP_KERNEL,
 				"mcp23xxx-pinctrl.%d", raw_chip_address);
-- 
2.20.1

