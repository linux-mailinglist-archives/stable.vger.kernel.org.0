Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1706A386D
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbjB0CUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbjB0CUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:20:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32411C7CE;
        Sun, 26 Feb 2023 18:15:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 777D5B80CC1;
        Mon, 27 Feb 2023 02:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8F8C433D2;
        Mon, 27 Feb 2023 02:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463786;
        bh=M7qrhE5bkbLYg/ELj0u50Mu2BsOnxBfWGHFebuMS4Ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aA87r0HbDha4xHzXtrkdZgBYqTZJvhgIn2r98LuFqZUV6WR2ycuzld4mYseY0F3cp
         fMzdeoKZGPPWo8y3l1hWGQ0mfYp3xzzl7XsP1GUdYuLCy8N2tfUsIjArXjEZsEn2gw
         d8lk4LaC3z2qCgU5zvc5eQixRgCkQ0hAXnP7/rxUTWspIsaFWyDNWp7FG5Bmgr3m4j
         BcFKcPOvkN4TC11CWkQkreYcFS5CQoPvJ67HraPCppkLmhM+fARQaDBwczxMywDSUG
         bXAnMke1P6qaC9OZIrpItZwH2WAoX1wlieWrnQf3QyqIRXN1ciwQolM2C5trPunqde
         gSDGlULBw0Y9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        ludovic.desroches@microchip.com, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 19/25] pinctrl: at91: use devm_kasprintf() to avoid potential leaks
Date:   Sun, 26 Feb 2023 21:08:42 -0500
Message-Id: <20230227020855.1051605-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020855.1051605-1-sashal@kernel.org>
References: <20230227020855.1051605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 03c32b2c5d303..c86fcdfaf825c 100644
--- a/drivers/pinctrl/pinctrl-at91-pio4.c
+++ b/drivers/pinctrl/pinctrl-at91-pio4.c
@@ -1126,8 +1126,8 @@ static int atmel_pinctrl_probe(struct platform_device *pdev)
 
 		pin_desc[i].number = i;
 		/* Pin naming convention: P(bank_name)(bank_pin_number). */
-		pin_desc[i].name = kasprintf(GFP_KERNEL, "P%c%d",
-					     bank + 'A', line);
+		pin_desc[i].name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "P%c%d",
+						  bank + 'A', line);
 
 		group->name = group_names[i] = pin_desc[i].name;
 		group->pin = pin_desc[i].number;
diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 6022496bb6a98..3b0341c730ee0 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1891,7 +1891,7 @@ static int at91_gpio_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < chip->ngpio; i++)
-		names[i] = kasprintf(GFP_KERNEL, "pio%c%d", alias_idx + 'A', i);
+		names[i] = devm_kasprintf(&pdev->dev, GFP_KERNEL, "pio%c%d", alias_idx + 'A', i);
 
 	chip->names = (const char *const *)names;
 
-- 
2.39.0

