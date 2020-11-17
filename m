Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD952B6347
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732580AbgKQNgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:36:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732576AbgKQNgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:36:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B8A720780;
        Tue, 17 Nov 2020 13:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620182;
        bh=ZQOU+KaXU427X6FDYgvER0NThEXdA4kIOuopGtcHNEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4WL+wbLkwph7+zt5svUNiAF300CVtqyoMPcm/i9AIeiF89kJpE2vvUsuYtjLyUDG
         ctP5DKmEy234Zoy5NcsaeCTs55u/iiZtG/TTIXXp5Vl/YgZoe5DaOIVjMUOKCsHb54
         B1pJZkwOCKvrvynwID6gp9rRWTvkPoP7rWRUwzIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?q?Jan=20Kundr=C3=A1t?= <jan.kundrat@cesnet.cz>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 134/255] pinctrl: mcp23s08: Use full chunk of memory for regmap configuration
Date:   Tue, 17 Nov 2020 14:04:34 +0100
Message-Id: <20201117122145.460890570@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 2b12c13637134897ba320bd8906a8d918ee7069b ]

It appears that simplification of mcp23s08_spi_regmap_init() made
a regression due to wrong size calculation for dev_kmemdup() call.
It misses the fact that config variable is already a pointer, thus
the sizeof() calculation is wrong and only 4 or 8 bytes were copied.

Fix the parameters to devm_kmemdup() to copy a full chunk of memory.

Fixes: 0874758ecb2b ("pinctrl: mcp23s08: Refactor mcp23s08_spi_regmap_init()")
Reported-by: Martin Hundebøll <martin@geanix.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Martin Hundebøll <martin@geanix.com>
Link: https://lore.kernel.org/r/20201009180856.4738-1-andriy.shevchenko@linux.intel.com
Tested-by: Jan Kundrát <jan.kundrat@cesnet.cz>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-mcp23s08_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-mcp23s08_spi.c b/drivers/pinctrl/pinctrl-mcp23s08_spi.c
index 1f47a661b0a79..7c72cffe14127 100644
--- a/drivers/pinctrl/pinctrl-mcp23s08_spi.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08_spi.c
@@ -119,7 +119,7 @@ static int mcp23s08_spi_regmap_init(struct mcp23s08 *mcp, struct device *dev,
 		return -EINVAL;
 	}
 
-	copy = devm_kmemdup(dev, &config, sizeof(config), GFP_KERNEL);
+	copy = devm_kmemdup(dev, config, sizeof(*config), GFP_KERNEL);
 	if (!copy)
 		return -ENOMEM;
 
-- 
2.27.0



