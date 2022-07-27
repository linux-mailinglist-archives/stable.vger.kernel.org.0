Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA6A58302C
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbiG0RfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241544AbiG0ReJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:34:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D666110D;
        Wed, 27 Jul 2022 09:49:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA7D9B821D5;
        Wed, 27 Jul 2022 16:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3EDC433D7;
        Wed, 27 Jul 2022 16:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940537;
        bh=+yI6fT1ua0UpK7wgbiWkBbblYjVdQFfX2LfImLTqYp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9Wd5J0fHHd17jIwqREFjWKTo7g9XETpSgVIazHzHitLrLdCqhSrE/CORsCWDR+zT
         One48m9Cu//PSOgda6Ul17HF1/hnd8WAakzQIkQCghQxb2mCav40LheauQzMTjuP9u
         N6QANSGf6Q76/EiZRNAj6rawH6iQDkNthK9Jbrh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Colin Foster <colin.foster@in-advantage.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 058/158] pinctrl: ocelot: Fix pincfg
Date:   Wed, 27 Jul 2022 18:12:02 +0200
Message-Id: <20220727161023.844748060@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit ba9c4745fca70bf773b2d5c602dcd85d1a40b07a ]

The blamed commit changed to use regmaps instead of __iomem. But it
didn't update the register offsets to be at word offset, so it uses byte
offset.
Another issue with the same commit is that it has a limit of 32 registers
which is incorrect. The sparx5 has 64 while lan966x has 77.

Fixes: 076d9e71bcf8 ("pinctrl: ocelot: convert pinctrl to regmap")
Acked-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://lore.kernel.org/r/20220713193750.4079621-3-horatiu.vultur@microchip.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ocelot.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 2866365132fd..6ee9f0de8ede 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -1327,7 +1327,9 @@ static int ocelot_hw_get_value(struct ocelot_pinctrl *info,
 		const struct ocelot_pincfg_data *opd = info->pincfg_data;
 		u32 regcfg;
 
-		ret = regmap_read(info->pincfg, pin, &regcfg);
+		ret = regmap_read(info->pincfg,
+				  pin * regmap_get_reg_stride(info->pincfg),
+				  &regcfg);
 		if (ret)
 			return ret;
 
@@ -1359,14 +1361,18 @@ static int ocelot_pincfg_clrsetbits(struct ocelot_pinctrl *info, u32 regaddr,
 	u32 val;
 	int ret;
 
-	ret = regmap_read(info->pincfg, regaddr, &val);
+	ret = regmap_read(info->pincfg,
+			  regaddr * regmap_get_reg_stride(info->pincfg),
+			  &val);
 	if (ret)
 		return ret;
 
 	val &= ~clrbits;
 	val |= setbits;
 
-	ret = regmap_write(info->pincfg, regaddr, val);
+	ret = regmap_write(info->pincfg,
+			   regaddr * regmap_get_reg_stride(info->pincfg),
+			   val);
 
 	return ret;
 }
@@ -1926,7 +1932,8 @@ static const struct of_device_id ocelot_pinctrl_of_match[] = {
 	{},
 };
 
-static struct regmap *ocelot_pinctrl_create_pincfg(struct platform_device *pdev)
+static struct regmap *ocelot_pinctrl_create_pincfg(struct platform_device *pdev,
+						   const struct ocelot_pinctrl *info)
 {
 	void __iomem *base;
 
@@ -1934,7 +1941,7 @@ static struct regmap *ocelot_pinctrl_create_pincfg(struct platform_device *pdev)
 		.reg_bits = 32,
 		.val_bits = 32,
 		.reg_stride = 4,
-		.max_register = 32,
+		.max_register = info->desc->npins * 4,
 		.name = "pincfg",
 	};
 
@@ -1995,7 +2002,7 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 
 	/* Pinconf registers */
 	if (info->desc->confops) {
-		pincfg = ocelot_pinctrl_create_pincfg(pdev);
+		pincfg = ocelot_pinctrl_create_pincfg(pdev, info);
 		if (IS_ERR(pincfg))
 			dev_dbg(dev, "Failed to create pincfg regmap\n");
 		else
-- 
2.35.1



