Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C2259DC35
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355171AbiHWMNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352035AbiHWMMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:12:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A00CE68CF;
        Tue, 23 Aug 2022 02:39:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACB4A61499;
        Tue, 23 Aug 2022 09:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DB2C433C1;
        Tue, 23 Aug 2022 09:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247546;
        bh=4nsgT5C/m+bixdAE9Y8NUb2nLWbf4acscREgyVVzC7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJiipDmlRsamXp2k0amt2DeWGQZnT3HgQVO3IfgIbvjYm4vH0eLqRWad+ayC+sYLW
         ZKmdD/O/w7oVhAy6hHdhKGhVel1+CPgMdQfEFSRYSWJNLlWKO80ZoUvYKqMhwMOecc
         qB2v1Iah+oOGeGYGNI7Ydzho7b5TUnw9qrxpE2RY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Samuel Holland <samuel@sholland.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 041/158] pinctrl: sunxi: Add I/O bias setting for H6 R-PIO
Date:   Tue, 23 Aug 2022 10:26:13 +0200
Message-Id: <20220823080047.711646818@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Samuel Holland <samuel@sholland.org>

commit fc153c8f283bf5925615195fc9d4056414d7b168 upstream.

H6 requires I/O bias configuration on both of its PIO devices.
Previously it was only done for the main PIO.

The setting for Port L is at bit 0, so the bank calculation needs to
account for the pin base. Otherwise the wrong bit is used.

Fixes: cc62383fcebe ("pinctrl: sunxi: Support I/O bias voltage setting on H6")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Link: https://lore.kernel.org/r/20220713025233.27248-3-samuel@sholland.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/sunxi/pinctrl-sun50i-h6-r.c |    1 +
 drivers/pinctrl/sunxi/pinctrl-sunxi.c       |    7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/sunxi/pinctrl-sun50i-h6-r.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sun50i-h6-r.c
@@ -105,6 +105,7 @@ static const struct sunxi_pinctrl_desc s
 	.npins = ARRAY_SIZE(sun50i_h6_r_pins),
 	.pin_base = PL_BASE,
 	.irq_banks = 2,
+	.io_bias_cfg_variant = BIAS_VOLTAGE_PIO_POW_MODE_SEL,
 };
 
 static int sun50i_h6_r_pinctrl_probe(struct platform_device *pdev)
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -624,7 +624,7 @@ static int sunxi_pinctrl_set_io_bias_cfg
 					 unsigned pin,
 					 struct regulator *supply)
 {
-	unsigned short bank = pin / PINS_PER_BANK;
+	unsigned short bank;
 	unsigned long flags;
 	u32 val, reg;
 	int uV;
@@ -640,6 +640,9 @@ static int sunxi_pinctrl_set_io_bias_cfg
 	if (uV == 0)
 		return 0;
 
+	pin -= pctl->desc->pin_base;
+	bank = pin / PINS_PER_BANK;
+
 	switch (pctl->desc->io_bias_cfg_variant) {
 	case BIAS_VOLTAGE_GRP_CONFIG:
 		/*
@@ -657,8 +660,6 @@ static int sunxi_pinctrl_set_io_bias_cfg
 		else
 			val = 0xD; /* 3.3V */
 
-		pin -= pctl->desc->pin_base;
-
 		reg = readl(pctl->membase + sunxi_grp_config_reg(pin));
 		reg &= ~IO_BIAS_MASK;
 		writel(reg | val, pctl->membase + sunxi_grp_config_reg(pin));


