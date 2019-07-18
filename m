Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C5B6C562
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389362AbfGRDFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390036AbfGRDFm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:05:42 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA73D21841;
        Thu, 18 Jul 2019 03:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419141;
        bh=agxZ9USqDthhFmvxTjDTB4OD6zGc12k9+pdVOWDN6SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ChE31C748a8Nslgg/r9eJdSBiApqc03OoOh8AwpXQNSZ+DLV/E3Ns1fu9xd6uc9XK
         XvGqSu1w9ie6Bi/uacSA96EsTHw/PtKQvmU4gX+CUDeAmf31OwBF/SpR0QHsoUEqLq
         i4H3YCzLf99LN/xF+PmWBAwm4lu8Ry92NrKxUuUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 27/54] pinctrl: ocelot: fix pinmuxing for pins after 31
Date:   Thu, 18 Jul 2019 12:01:22 +0900
Message-Id: <20190718030055.476573988@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



