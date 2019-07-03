Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62FB75DC42
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbfGCCPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:15:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727742AbfGCCPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:15:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23E0B21880;
        Wed,  3 Jul 2019 02:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120149;
        bh=PUuHdxl7TTy7bW0AsWJdX81k6IKf5IQiWJ1Ej54CLrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drcCmHhEYgLYkbyybfuvhizTPaA1sQxvFbJGFwopM2D1uxqW6LaIiD2+HBRLxSV6d
         ejzzH8F2B2H8jJqd5IE4CAQ3xct8NsR79dbiKegAsQiZ2l5P0b/nmORhtz9fs8vuIx
         C3njSGFsOwRmsp25ybk7XhozB8vaqL798PyHguPA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 24/39] pinctrl: ocelot: fix gpio direction for pins after 31
Date:   Tue,  2 Jul 2019 22:14:59 -0400
Message-Id: <20190703021514.17727-24-sashal@kernel.org>
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

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit f2818ba3a0125670cb9999bb5a65ebb631a8da2f ]

The third argument passed to REG is not the correct one and
ocelot_gpio_set_direction is not working for pins after 31. Fix that by
passing the pin number instead of the modulo 32 value.

Fixes: da801ab56ad8 pinctrl: ocelot: add MSCC Jaguar2 support
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 3b4ca52d2456..d2478db975bd 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -432,7 +432,7 @@ static int ocelot_gpio_set_direction(struct pinctrl_dev *pctldev,
 	struct ocelot_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
 	unsigned int p = pin % 32;
 
-	regmap_update_bits(info->map, REG(OCELOT_GPIO_OE, info, p), BIT(p),
+	regmap_update_bits(info->map, REG(OCELOT_GPIO_OE, info, pin), BIT(p),
 			   input ? 0 : BIT(p));
 
 	return 0;
-- 
2.20.1

