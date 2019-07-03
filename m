Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 840CF5DC40
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727757AbfGCCPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727745AbfGCCPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:15:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35DE9218A3;
        Wed,  3 Jul 2019 02:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120150;
        bh=Lu7Rm6lZyhB8upg6bSwZbm8eUXjav1L23VNJbikpp7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrX+7Z5QYbmpcjLn2AWD4lFCHZaEe2VMFL9evJ36/VucMBFM8uVZzTtb4mnimxBPj
         45C+ieJ1TXkm0QUfddwFmKqkRlahNKNeeQSz6drb8bMhENC5F20LhyppMSkLhZsG4m
         Uyt3Ruhnhk12be5irczrPnUDlLHZmijzkfGjUsyk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 25/39] pinctrl: ocelot: fix pinmuxing for pins after 31
Date:   Tue,  2 Jul 2019 22:15:00 -0400
Message-Id: <20190703021514.17727-25-sashal@kernel.org>
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

[ Upstream commit 4b36082e2e09c2769710756390d54cfca563ed96 ]

The actual layout for OCELOT_GPIO_ALT[01] when there are more than 32 pins
is interleaved, i.e. OCELOT_GPIO_ALT0[0], OCELOT_GPIO_ALT1[0],
OCELOT_GPIO_ALT0[1], OCELOT_GPIO_ALT1[1]. Introduce a new REG_ALT macro to
facilitate the register offset calculation and use it where necessary.

Fixes: da801ab56ad8 pinctrl: ocelot: add MSCC Jaguar2 support
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ocelot.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index d2478db975bd..fb76fb2e9ea5 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -396,7 +396,7 @@ static int ocelot_pin_function_idx(struct ocelot_pinctrl *info,
 	return -1;
 }
 
-#define REG(r, info, p) ((r) * (info)->stride + (4 * ((p) / 32)))
+#define REG_ALT(msb, info, p) (OCELOT_GPIO_ALT0 * (info)->stride + 4 * ((msb) + ((info)->stride * ((p) / 32))))
 
 static int ocelot_pinmux_set_mux(struct pinctrl_dev *pctldev,
 				 unsigned int selector, unsigned int group)
@@ -412,19 +412,21 @@ static int ocelot_pinmux_set_mux(struct pinctrl_dev *pctldev,
 
 	/*
 	 * f is encoded on two bits.
-	 * bit 0 of f goes in BIT(pin) of ALT0, bit 1 of f goes in BIT(pin) of
-	 * ALT1
+	 * bit 0 of f goes in BIT(pin) of ALT[0], bit 1 of f goes in BIT(pin) of
+	 * ALT[1]
 	 * This is racy because both registers can't be updated at the same time
 	 * but it doesn't matter much for now.
 	 */
-	regmap_update_bits(info->map, REG(OCELOT_GPIO_ALT0, info, pin->pin),
+	regmap_update_bits(info->map, REG_ALT(0, info, pin->pin),
 			   BIT(p), f << p);
-	regmap_update_bits(info->map, REG(OCELOT_GPIO_ALT1, info, pin->pin),
+	regmap_update_bits(info->map, REG_ALT(1, info, pin->pin),
 			   BIT(p), f << (p - 1));
 
 	return 0;
 }
 
+#define REG(r, info, p) ((r) * (info)->stride + (4 * ((p) / 32)))
+
 static int ocelot_gpio_set_direction(struct pinctrl_dev *pctldev,
 				     struct pinctrl_gpio_range *range,
 				     unsigned int pin, bool input)
@@ -445,9 +447,9 @@ static int ocelot_gpio_request_enable(struct pinctrl_dev *pctldev,
 	struct ocelot_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
 	unsigned int p = offset % 32;
 
-	regmap_update_bits(info->map, REG(OCELOT_GPIO_ALT0, info, offset),
+	regmap_update_bits(info->map, REG_ALT(0, info, offset),
 			   BIT(p), 0);
-	regmap_update_bits(info->map, REG(OCELOT_GPIO_ALT1, info, offset),
+	regmap_update_bits(info->map, REG_ALT(1, info, offset),
 			   BIT(p), 0);
 
 	return 0;
-- 
2.20.1

