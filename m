Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D2D4ABD49
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387208AbiBGLkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352776AbiBGLaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:30:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDA7C03FEE6;
        Mon,  7 Feb 2022 03:28:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28947B80EBD;
        Mon,  7 Feb 2022 11:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA84C004E1;
        Mon,  7 Feb 2022 11:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233302;
        bh=8QV6oXiFaB4PUA8JqIhf7y6Mx274xZaFC/RUXpTItBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fo+LSCeT74grMC0GPXfs24sY/lLKCF4+EdDKEnhrTaVCMV17FzInldyrTujroZmUa
         WvDHbjWcTpDXc5JqR+RC1O7/WDXrQtShucoa+B2JtIoCbtpzrD9FpZzyd5dlkCMXRS
         8o2Iq7OVMbOop7632/NXWW1K9eO+Dq3EkjVdUjUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SASANO Takayoshi <uaa@mx5.nisiq.net>,
        Andre Przywara <andre.przywara@arm.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 079/110] pinctrl: sunxi: Fix H616 I2S3 pin data
Date:   Mon,  7 Feb 2022 12:06:52 +0100
Message-Id: <20220207103805.059120061@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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

From: Andre Przywara <andre.przywara@arm.com>

commit 1fd6bb5b47a65eacb063b37e6fa6df2b8fa92959 upstream.

Two bugs have sneaked in the H616 pinctrl data:
- PH9 uses the mux value of 0x3 twice (one should be 0x5 instead)
- PH8 and PH9 use the "i2s3" function name twice in each pin

For the double pin name we use the same trick we pulled for i2s0: append
the pin function to the group name to designate the special function.

Fixes: 25adc29407fb ("pinctrl: sunxi: Add support for the Allwinner H616 pin controller")
Reported-by: SASANO Takayoshi <uaa@mx5.nisiq.net>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Samuel Holland <samuel@sholland.org>
Link: https://lore.kernel.org/r/20220105172952.23347-1-andre.przywara@arm.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/sunxi/pinctrl-sun50i-h616.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/pinctrl/sunxi/pinctrl-sun50i-h616.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sun50i-h616.c
@@ -363,16 +363,16 @@ static const struct sunxi_desc_pin h616_
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
 		  SUNXI_FUNCTION(0x2, "uart2"),		/* CTS */
-		  SUNXI_FUNCTION(0x3, "i2s3"),	/* DO0 */
+		  SUNXI_FUNCTION(0x3, "i2s3_dout0"),	/* DO0 */
 		  SUNXI_FUNCTION(0x4, "spi1"),		/* MISO */
-		  SUNXI_FUNCTION(0x5, "i2s3"),	/* DI1 */
+		  SUNXI_FUNCTION(0x5, "i2s3_din1"),	/* DI1 */
 		  SUNXI_FUNCTION_IRQ_BANK(0x6, 6, 8)),	/* PH_EINT8 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 9),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
-		  SUNXI_FUNCTION(0x3, "i2s3"),	/* DI0 */
+		  SUNXI_FUNCTION(0x3, "i2s3_din0"),	/* DI0 */
 		  SUNXI_FUNCTION(0x4, "spi1"),		/* CS1 */
-		  SUNXI_FUNCTION(0x3, "i2s3"),	/* DO1 */
+		  SUNXI_FUNCTION(0x5, "i2s3_dout1"),	/* DO1 */
 		  SUNXI_FUNCTION_IRQ_BANK(0x6, 6, 9)),	/* PH_EINT9 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(H, 10),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),


