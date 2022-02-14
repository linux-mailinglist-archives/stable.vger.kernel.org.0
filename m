Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE8B4B47AF
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245550AbiBNJwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:52:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343574AbiBNJux (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:50:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ABD6578F;
        Mon, 14 Feb 2022 01:41:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88B62611B8;
        Mon, 14 Feb 2022 09:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957ABC340E9;
        Mon, 14 Feb 2022 09:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831703;
        bh=KT0cpzHQsGiBnRibBTCq6GDlT8qPrltSL9wtE+Ft7B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttCItVLB5XIC+tLZuYGuWYeatANMFjFYjhrwaMCjvR5vYkWzCt4/U4U/WoJOrh7Na
         +xOQ6J5sU2yRSou660CI2s7jLAMtT9oCjZRjQ1jNIL9EvKGs4EefdMs4S49jZ8/HnY
         TkS2OY6fQK8d7cYbcezFenYF1sFJ4y8SZ9zztaBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/116] gpio: sifive: use the correct register to read output values
Date:   Mon, 14 Feb 2022 10:26:06 +0100
Message-Id: <20220214092501.062169573@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

[ Upstream commit cc38ef936840ac29204d806deb4d1836ec509594 ]

Setting the output of a GPIO to 1 using gpiod_set_value(), followed by
reading the same GPIO using gpiod_get_value(), will currently yield an
incorrect result.

This is because the SiFive GPIO device stores the output values in reg_set,
not reg_dat.

Supply the flag BGPIOF_READ_OUTPUT_REG_SET to bgpio_init() so that the
generic driver reads the correct register.

Fixes: 96868dce644d ("gpio/sifive: Add GPIO driver for SiFive SoCs")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
[Bartosz: added the Fixes tag]
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-sifive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-sifive.c b/drivers/gpio/gpio-sifive.c
index d5eb9ca119016..4f28fa73450c1 100644
--- a/drivers/gpio/gpio-sifive.c
+++ b/drivers/gpio/gpio-sifive.c
@@ -206,7 +206,7 @@ static int sifive_gpio_probe(struct platform_device *pdev)
 			 NULL,
 			 chip->base + SIFIVE_GPIO_OUTPUT_EN,
 			 chip->base + SIFIVE_GPIO_INPUT_EN,
-			 0);
+			 BGPIOF_READ_OUTPUT_REG_SET);
 	if (ret) {
 		dev_err(dev, "unable to init generic GPIO\n");
 		return ret;
-- 
2.34.1



