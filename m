Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0E04F31DF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356483AbiDEKX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236247AbiDEJbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:31:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280F546B30;
        Tue,  5 Apr 2022 02:18:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C79FBB81BBF;
        Tue,  5 Apr 2022 09:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262E5C385A2;
        Tue,  5 Apr 2022 09:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150328;
        bh=Gz/VeTBBP33tvFp+j5VVKKb+rCBIgNQIXNdX6PH2aYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TY3AJ14jZRWz1PZ63IiBAXLBUTWrmGSHKFgO6ncJh5D/n4It23/luXRHUVmowghbE
         eyBA/3kg47W5FxkeOfr8QjNXYUfp6G96xeiU5o6VeTNkSi2G/fCvTWiZLM/+lapvGU
         eg4WKkhe2dkC9JdaKeVlbA0lvkODLgPn2Wmerfyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>,
        Michael Walle <michael@walle.cc>,
        Thorsten Leemhuis <linux@leemhuis.info>,
        Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 019/913] Revert "gpio: Revert regression in sysfs-gpio (gpiolib.c)"
Date:   Tue,  5 Apr 2022 09:18:01 +0200
Message-Id: <20220405070340.390677274@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <brgl@bgdev.pl>

[ Upstream commit 56e337f2cf1326323844927a04e9dbce9a244835 ]

This reverts commit fc328a7d1fcce263db0b046917a66f3aa6e68719.

This commit - while attempting to fix a regression - has caused a number
of other problems. As the fallout from it is more significant than the
initial problem itself, revert it for now before we find a correct
solution.

Link: https://lore.kernel.org/all/20220314192522.GA3031157@roeck-us.net/
Link: https://lore.kernel.org/stable/20220314155509.552218-1-michael@walle.cc/
Link: https://lore.kernel.org/all/20211217153555.9413-1-marcelo.jimenez@gmail.com/
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Reported-and-bisected-by: Guenter Roeck <linux@roeck-us.net>
Reported-by: Michael Walle <michael@walle.cc>
Cc: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 12b59cdffdf3..358f0ad9d0f8 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1660,6 +1660,11 @@ static inline void gpiochip_irqchip_free_valid_mask(struct gpio_chip *gc)
  */
 int gpiochip_generic_request(struct gpio_chip *gc, unsigned int offset)
 {
+#ifdef CONFIG_PINCTRL
+	if (list_empty(&gc->gpiodev->pin_ranges))
+		return 0;
+#endif
+
 	return pinctrl_gpio_request(gc->gpiodev->base + offset);
 }
 EXPORT_SYMBOL_GPL(gpiochip_generic_request);
@@ -1671,6 +1676,11 @@ EXPORT_SYMBOL_GPL(gpiochip_generic_request);
  */
 void gpiochip_generic_free(struct gpio_chip *gc, unsigned int offset)
 {
+#ifdef CONFIG_PINCTRL
+	if (list_empty(&gc->gpiodev->pin_ranges))
+		return;
+#endif
+
 	pinctrl_gpio_free(gc->gpiodev->base + offset);
 }
 EXPORT_SYMBOL_GPL(gpiochip_generic_free);
-- 
2.34.1



