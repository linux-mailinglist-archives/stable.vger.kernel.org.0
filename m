Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BBE2B5FF2
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgKQM5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:57:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbgKQM5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19E612465E;
        Tue, 17 Nov 2020 12:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617825;
        bh=Dnu8iBGItyBWo369q6DLtywwEWWtsRu49TGsKXt5pkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jI7miV2WRzVvKfh868xaDNeIJ+JvKaGfOAxLr2c9j5NuMbYAYiIrLW3Lota+S5qJ1
         WvCUV/GFIIoRcgS+bSYUqrzPfrrEdAZwaZUam2zyeHl7uJUfrJm+9Y9ZNLw2wvrXz/
         cgdaMNfY/Sbnhu4EQdU4FCMYJuowMzgDrhEIKcjQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        =?UTF-8?q?Jan=20Kundr=C3=A1t?= <jan.kundrat@cesnet.cz>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 07/21] pinctrl: mcp23s08: Print error message when regmap init fails
Date:   Tue, 17 Nov 2020 07:56:38 -0500
Message-Id: <20201117125652.599614-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125652.599614-1-sashal@kernel.org>
References: <20201117125652.599614-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit a835d3a114ab0dc2f0d8c6963c3f53734b1c5965 ]

It is useful for debugging to have the error message printed
when regmap initialisation fails. Add it to the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Martin Hundebøll <martin@geanix.com>
Link: https://lore.kernel.org/r/20201009180856.4738-2-andriy.shevchenko@linux.intel.com
Tested-by: Jan Kundrát <jan.kundrat@cesnet.cz>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-mcp23s08_spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-mcp23s08_spi.c b/drivers/pinctrl/pinctrl-mcp23s08_spi.c
index 1f47a661b0a79..52e32634bb5a7 100644
--- a/drivers/pinctrl/pinctrl-mcp23s08_spi.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08_spi.c
@@ -126,6 +126,8 @@ static int mcp23s08_spi_regmap_init(struct mcp23s08 *mcp, struct device *dev,
 	copy->name = name;
 
 	mcp->regmap = devm_regmap_init(dev, &mcp23sxx_spi_regmap, mcp, copy);
+	if (IS_ERR(mcp->regmap))
+		dev_err(dev, "regmap init failed for %s\n", mcp->chip.label);
 	return PTR_ERR_OR_ZERO(mcp->regmap);
 }
 
-- 
2.27.0

