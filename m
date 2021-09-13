Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B37D4091C5
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245174AbhIMOFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:05:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244768AbhIMOCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:02:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60BF661A4E;
        Mon, 13 Sep 2021 13:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540315;
        bh=p6ONfNBHdy5a8RKhjLNLoAQyQd8hKK3ffWN0nlkR0ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fj42H0Z4Hist7NJ2buKeybqNkTqKg92+OtMVnweZPeFakGTPciOfgHUDi0EAsHFbY
         B3z1DaEChtYnwz86tP1PLZ+mAlV5f2l7uyZF2ehlc+hELAInGlBPqlseCN0pzd6LAG
         OskzLYrHvZAJARU49HFdP6G7Vf4YzZIP8DARN9mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 143/300] leds: rt8515: Put fwnode in any case during ->probe()
Date:   Mon, 13 Sep 2021 15:13:24 +0200
Message-Id: <20210913131114.225962899@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit 8aa41952ef245449df79100e1942b5e6288b098a ]

fwnode_get_next_available_child_node() bumps a reference counting of
a returned variable. We have to balance it whenever we return to
the caller.

Fixes: e1c6edcbea13 ("leds: rt8515: Add Richtek RT8515 LED driver")
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/flash/leds-rt8515.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/flash/leds-rt8515.c b/drivers/leds/flash/leds-rt8515.c
index 590bfa180d10..44904fdee3cc 100644
--- a/drivers/leds/flash/leds-rt8515.c
+++ b/drivers/leds/flash/leds-rt8515.c
@@ -343,8 +343,9 @@ static int rt8515_probe(struct platform_device *pdev)
 
 	ret = devm_led_classdev_flash_register_ext(dev, fled, &init_data);
 	if (ret) {
-		dev_err(dev, "can't register LED %s\n", led->name);
+		fwnode_handle_put(child);
 		mutex_destroy(&rt->lock);
+		dev_err(dev, "can't register LED %s\n", led->name);
 		return ret;
 	}
 
@@ -362,6 +363,7 @@ static int rt8515_probe(struct platform_device *pdev)
 		 */
 	}
 
+	fwnode_handle_put(child);
 	return 0;
 }
 
-- 
2.30.2



