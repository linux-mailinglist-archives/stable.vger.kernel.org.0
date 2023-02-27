Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7646A3856
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjB0CRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjB0CQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:16:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7ED44A9;
        Sun, 26 Feb 2023 18:13:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A551B80D1D;
        Mon, 27 Feb 2023 02:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436E6C4339C;
        Mon, 27 Feb 2023 02:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463907;
        bh=y3ie9eSBvvx7iivrqliMmePNbkNWd5IwR8ZJCAlDvJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0sKpygMSC5+8BtW83pb1UNaL+Yj4l/TjI1iDEobz3DiYek7gzASSu4Leyd2jLq7F
         UBIjXN6KsvPviWyEBRX+KRRPXD2jWe17b023Shr9aF8Wm9HDDqjwzcY0CKOzW+1ndA
         6/IpE2d2pPBQ1sZkcKPD0X+ACfxWsxUjCfvztV+tyq9NSmLCm1MvIdnAvLyV4UI4qY
         NLi8rqMF0IbcEHdt5ALiCgM+tBUd0Wt26aPvYc9+ojjlRUPMEhzyG3PDx6RhpL4g74
         AEFIWOLQZG4neZI8s70uxXhf5JTojzcWhznSFjLLEAp/axyXXeDW4x5Cv0UCRVOlEj
         i+D57kGdf2pQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        ludovic.desroches@microchip.com, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 7/9] pinctrl: at91: use devm_kasprintf() to avoid potential leaks
Date:   Sun, 26 Feb 2023 21:11:29 -0500
Message-Id: <20230227021131.1053662-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227021131.1053662-1-sashal@kernel.org>
References: <20230227021131.1053662-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 1c4e5c470a56f7f7c649c0c70e603abc1eab15c4 ]

Use devm_kasprintf() instead of kasprintf() to avoid any potential
leaks. At the moment drivers have no remove functionality thus
there is no need for fixes tag.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230203132714.1931596-1-claudiu.beznea@microchip.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-at91-pio4.c | 4 ++--
 drivers/pinctrl/pinctrl-at91.c      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91-pio4.c b/drivers/pinctrl/pinctrl-at91-pio4.c
index e9d7977072553..78aeb882f1cad 100644
--- a/drivers/pinctrl/pinctrl-at91-pio4.c
+++ b/drivers/pinctrl/pinctrl-at91-pio4.c
@@ -981,8 +981,8 @@ static int atmel_pinctrl_probe(struct platform_device *pdev)
 
 		pin_desc[i].number = i;
 		/* Pin naming convention: P(bank_name)(bank_pin_number). */
-		pin_desc[i].name = kasprintf(GFP_KERNEL, "P%c%d",
-					     bank + 'A', line);
+		pin_desc[i].name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "P%c%d",
+						  bank + 'A', line);
 
 		group->name = group_names[i] = pin_desc[i].name;
 		group->pin = pin_desc[i].number;
diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 404711f0985aa..3173e1f5bcb69 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1774,7 +1774,7 @@ static int at91_gpio_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < chip->ngpio; i++)
-		names[i] = kasprintf(GFP_KERNEL, "pio%c%d", alias_idx + 'A', i);
+		names[i] = devm_kasprintf(&pdev->dev, GFP_KERNEL, "pio%c%d", alias_idx + 'A', i);
 
 	chip->names = (const char *const *)names;
 
-- 
2.39.0

