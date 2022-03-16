Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9030F4DB2B0
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356660AbiCPOT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356698AbiCPOTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:19:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DAA69CD4;
        Wed, 16 Mar 2022 07:17:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E554B81B7C;
        Wed, 16 Mar 2022 14:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE81C340E9;
        Wed, 16 Mar 2022 14:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440247;
        bh=92c5oGKIW9mRLJNxR3M1moq+pdxQQ9rEzZE5veFZPLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxDvU5yutwV6gA3tr7XAb5htuB71k6wS3W4JldB2ugH5FZB9/pVU/DUv0Kh+os3K9
         tmidzCHkhN7PyK0HoNCoWjtUbLKljrG9WEF+7t5fje/FoTUBSC/rCkzzR9yc4iYb4c
         I3iDFozi1hovZKq5kuO97urU6bzCRaEjeiePBUwg7qoOAdOqXYnKqcIe1pkUWwNRU7
         za1pHMvL8ewrISo5AY+yGxSpkVDsZYshwj0Pk4E49+WOfa6euuAiVVrV1aEGVLPynZ
         kxoqidb8VE7zcKKZSDz1czFIw5mBW9HSp3vY4EM8nBI2QotIatdM+1115tqQtuXKMy
         k9GYPBkwwAJ7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, linus.walleij@linaro.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/12] gpio: Revert regression in sysfs-gpio (gpiolib.c)
Date:   Wed, 16 Mar 2022 10:16:34 -0400
Message-Id: <20220316141636.248324-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316141636.248324-1-sashal@kernel.org>
References: <20220316141636.248324-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>

[ Upstream commit fc328a7d1fcce263db0b046917a66f3aa6e68719 ]

Some GPIO lines have stopped working after the patch
commit 2ab73c6d8323f ("gpio: Support GPIO controllers without pin-ranges")

And this has supposedly been fixed in the following patches
commit 89ad556b7f96a ("gpio: Avoid using pin ranges with !PINCTRL")
commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not defined")

But an erratic behavior where some GPIO lines work while others do not work
has been introduced.

This patch reverts those changes so that the sysfs-gpio interface works
properly again.

Signed-off-by: Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index af5bb8fedfea..ac69ec8fb37a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1804,11 +1804,6 @@ static inline void gpiochip_irqchip_free_valid_mask(struct gpio_chip *gc)
  */
 int gpiochip_generic_request(struct gpio_chip *gc, unsigned offset)
 {
-#ifdef CONFIG_PINCTRL
-	if (list_empty(&gc->gpiodev->pin_ranges))
-		return 0;
-#endif
-
 	return pinctrl_gpio_request(gc->gpiodev->base + offset);
 }
 EXPORT_SYMBOL_GPL(gpiochip_generic_request);
@@ -1820,11 +1815,6 @@ EXPORT_SYMBOL_GPL(gpiochip_generic_request);
  */
 void gpiochip_generic_free(struct gpio_chip *gc, unsigned offset)
 {
-#ifdef CONFIG_PINCTRL
-	if (list_empty(&gc->gpiodev->pin_ranges))
-		return;
-#endif
-
 	pinctrl_gpio_free(gc->gpiodev->base + offset);
 }
 EXPORT_SYMBOL_GPL(gpiochip_generic_free);
-- 
2.34.1

