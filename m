Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19392C0A12
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733151AbgKWNQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:16:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732272AbgKWMnd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:43:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3E8F2100A;
        Mon, 23 Nov 2020 12:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135413;
        bh=q8fvpMJZjR9vGHGV+DCn6u/6ynwERGa7D9RKMaPEbdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fqg9zPfsqzn8YuIl78GqhJRoFAlx1+K1Yri+SuItz5hWJEN02NUp20jSDXt7MI1PU
         lxRh5QNtz8f/HOZFxxs/79CXjeGUkFr6dvmiyoDq61NWxY5iBaOya7FN0hPBEu7agW
         EotVZyVITKoA/XHZBc9esbMlmNw3Kvsixx1mO8Fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        =?UTF-8?q?Jan=20Kundr=C3=A1t?= <jan.kundrat@cesnet.cz>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 060/252] pinctrl: mcp23s08: Print error message when regmap init fails
Date:   Mon, 23 Nov 2020 13:20:10 +0100
Message-Id: <20201123121838.491829491@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7c72cffe14127..9ae10318f6f35 100644
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



