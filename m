Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B646A3952
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 04:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjB0DMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 22:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjB0DMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 22:12:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950D511E8F;
        Sun, 26 Feb 2023 19:12:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D21DA60D3E;
        Mon, 27 Feb 2023 02:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C259C433AA;
        Mon, 27 Feb 2023 02:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463653;
        bh=9fFmLIjyGzvoCvdtVc65Ti5AHUAr+vsnbtdd5jhjFbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHtI21vS3qm7O+KmydBY6fXQh09A9wTWnNkDnULluQeXSWvJUjJmw4L+fJMLXa2dU
         TcYMM0YU2OnUw+a0ac4fclgzD0yd2+CY97ZbmdukfUjKs1QyWWOt+TBbbWOnScXVaM
         QeKL5MFjOihTo7rTUtJ2vKUJW27I2CuQcjNryiV2IytnNXqtKozWiwrq3KfYMPnmow
         7ctlZwBxlYe8L1XWSa1h7+rvF7z+TrxdsT/888HvWT5VOfKFOn+N5mVeJqAJMP3eH7
         RtYlG/2t63Xu61rpPh9MjurB4UBylEj3Je0bVZR8AXnH0iGvQc3xGiOB/IhMvXmybc
         v8Eymfh4mu1ZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        ludovic.desroches@microchip.com, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 43/58] pinctrl: at91: use devm_kasprintf() to avoid potential leaks
Date:   Sun, 26 Feb 2023 21:04:41 -0500
Message-Id: <20230227020457.1048737-43-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
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
index 82b921fd630d5..7f193f2b1566a 100644
--- a/drivers/pinctrl/pinctrl-at91-pio4.c
+++ b/drivers/pinctrl/pinctrl-at91-pio4.c
@@ -1120,8 +1120,8 @@ static int atmel_pinctrl_probe(struct platform_device *pdev)
 
 		pin_desc[i].number = i;
 		/* Pin naming convention: P(bank_name)(bank_pin_number). */
-		pin_desc[i].name = kasprintf(GFP_KERNEL, "P%c%d",
-					     bank + 'A', line);
+		pin_desc[i].name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "P%c%d",
+						  bank + 'A', line);
 
 		group->name = group_names[i] = pin_desc[i].name;
 		group->pin = pin_desc[i].number;
diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 81dbffab621fb..ff3b6a8a0b170 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1883,7 +1883,7 @@ static int at91_gpio_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < chip->ngpio; i++)
-		names[i] = kasprintf(GFP_KERNEL, "pio%c%d", alias_idx + 'A', i);
+		names[i] = devm_kasprintf(&pdev->dev, GFP_KERNEL, "pio%c%d", alias_idx + 'A', i);
 
 	chip->names = (const char *const *)names;
 
-- 
2.39.0

