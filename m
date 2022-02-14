Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE95C4B4974
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243979AbiBNKbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:31:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347902AbiBNKb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:31:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF18C9FAE8;
        Mon, 14 Feb 2022 02:00:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B55C60B34;
        Mon, 14 Feb 2022 10:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F57CC340E9;
        Mon, 14 Feb 2022 10:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832803;
        bh=p0GSrWSRYFcwVAlTWHkexOEppvNxSNDFbwq10rI/KzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxexTiaH6PadwzLe2+gcbrqQKardm3Ft7kUfO0UbSyouOWo5YhPo97k6ietqNfksf
         xiGkulkWDqjbifUqxsBlDwvtrq2En/33cAoQJZpMc7bm1W2uQj+03/81P/mFRQs4kX
         i9f0vKFvUM4T619jEFgUEnw4G7wIM+W2khmaoHU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 129/203] gpio: sifive: use the correct register to read output values
Date:   Mon, 14 Feb 2022 10:26:13 +0100
Message-Id: <20220214092514.619622657@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
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
index 403f9e833d6a3..7d82388b4ab7c 100644
--- a/drivers/gpio/gpio-sifive.c
+++ b/drivers/gpio/gpio-sifive.c
@@ -223,7 +223,7 @@ static int sifive_gpio_probe(struct platform_device *pdev)
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



