Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB994DB287
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353605AbiCPOR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356542AbiCPORl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:17:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA55268FB4;
        Wed, 16 Mar 2022 07:16:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CCD4B81B7A;
        Wed, 16 Mar 2022 14:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16645C36AE7;
        Wed, 16 Mar 2022 14:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440184;
        bh=VbClFb8E8n+NuJw1jA9OR6USLSRpUdXVOjjCep7n8FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sa31CCMeX/M+YWY2Outz5lC6HjNKG0ZZvTepotHa27wHd3NnQC3WEJYyc1Eu+dZSH
         PVN0pyTahV8S6ht5Ro6vTrfOUQ1wYK0NsqCJhoh9D+nmgORjRa1IamSMNFTX2cbFmF
         jBHwrtaFY5DsJv8iNqMC9ksmbLOmzVukKc6+P8PDXfDSKfvjOYEdeAXA4zZytF4idM
         TTKZ+wxgaGxbgckR3YmeTLGxu/WB8t/yzSrRxkhqMEQyH8NlMj6VyoJ3GmgDhZtiGk
         UsWyI1fazIOaN7OdwARVoDErR4SWCEvRO7I1IxMiCZ751xBctj2D5inyVmk9o52PtO
         6ZLDx/YBio1FA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, linus.walleij@linaro.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/13] gpio: Revert regression in sysfs-gpio (gpiolib.c)
Date:   Wed, 16 Mar 2022 10:15:11 -0400
Message-Id: <20220316141513.247965-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316141513.247965-1-sashal@kernel.org>
References: <20220316141513.247965-1-sashal@kernel.org>
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
index d1b9b721218f..664d1afadf50 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1660,11 +1660,6 @@ static inline void gpiochip_irqchip_free_valid_mask(struct gpio_chip *gc)
  */
 int gpiochip_generic_request(struct gpio_chip *gc, unsigned int offset)
 {
-#ifdef CONFIG_PINCTRL
-	if (list_empty(&gc->gpiodev->pin_ranges))
-		return 0;
-#endif
-
 	return pinctrl_gpio_request(gc->gpiodev->base + offset);
 }
 EXPORT_SYMBOL_GPL(gpiochip_generic_request);
@@ -1676,11 +1671,6 @@ EXPORT_SYMBOL_GPL(gpiochip_generic_request);
  */
 void gpiochip_generic_free(struct gpio_chip *gc, unsigned int offset)
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

