Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B7B4F32BE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236602AbiDEJDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240225AbiDEIpy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:45:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93362314E;
        Tue,  5 Apr 2022 01:36:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B0B5B81A32;
        Tue,  5 Apr 2022 08:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA488C385A0;
        Tue,  5 Apr 2022 08:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147767;
        bh=6A9UA5U7G9iRpRC1UBSpjmRYtdP73I5SljYYhYL/gGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqUQ1+DDzKak6j9uj7yc9KoZnByPOXfhlywqA1TgDcDBKdiblfnFwhziiNHZsjAG3
         iGEE8Noiu4BvgzpGrIEhyr8X4Hom7r8TtEWApsfbCG5rLfGz5lj9LZej13QJQtpBOu
         8djlSIEUYA7fOqCWwRc7xgzx11L7pZBWePufI7Rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aidan MacDonald <aidanmacdonald.0x0@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.16 0075/1017] pinctrl: ingenic: Fix regmap on X series SoCs
Date:   Tue,  5 Apr 2022 09:16:28 +0200
Message-Id: <20220405070356.417244391@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Aidan MacDonald <aidanmacdonald.0x0@gmail.com>

commit 9279c00fa40250e5cb23a8423dce7dbc6516a0ea upstream.

The X series Ingenic SoCs have a shadow GPIO group which is at a higher
offset than the other groups, and is used for all GPIO configuration.
The regmap did not take this offset into account and set max_register
too low, so the regmap API blocked writes to the shadow group, which
made the pinctrl driver unable to configure any pins.

Fix this by adding regmap access tables to the chip info. The way that
max_register was computed was also off by one, since max_register is an
inclusive bound, not an exclusive bound; this has been fixed.

Cc: stable@vger.kernel.org
Signed-off-by: Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
Fixes: 6626a76ef857 ("pinctrl: ingenic: Add .max_register in  regmap_config")
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20220317000740.1045204-1-aidanmacdonald.0x0@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-ingenic.c |   46 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -119,6 +119,8 @@ struct ingenic_chip_info {
 	unsigned int num_functions;
 
 	const u32 *pull_ups, *pull_downs;
+
+	const struct regmap_access_table *access_table;
 };
 
 struct ingenic_pinctrl {
@@ -2179,6 +2181,17 @@ static const struct function_desc x1000_
 	{ "mac", x1000_mac_groups, ARRAY_SIZE(x1000_mac_groups), },
 };
 
+static const struct regmap_range x1000_access_ranges[] = {
+	regmap_reg_range(0x000, 0x400 - 4),
+	regmap_reg_range(0x700, 0x800 - 4),
+};
+
+/* shared with X1500 */
+static const struct regmap_access_table x1000_access_table = {
+	.yes_ranges = x1000_access_ranges,
+	.n_yes_ranges = ARRAY_SIZE(x1000_access_ranges),
+};
+
 static const struct ingenic_chip_info x1000_chip_info = {
 	.num_chips = 4,
 	.reg_offset = 0x100,
@@ -2189,6 +2202,7 @@ static const struct ingenic_chip_info x1
 	.num_functions = ARRAY_SIZE(x1000_functions),
 	.pull_ups = x1000_pull_ups,
 	.pull_downs = x1000_pull_downs,
+	.access_table = &x1000_access_table,
 };
 
 static int x1500_uart0_data_pins[] = { 0x4a, 0x4b, };
@@ -2300,6 +2314,7 @@ static const struct ingenic_chip_info x1
 	.num_functions = ARRAY_SIZE(x1500_functions),
 	.pull_ups = x1000_pull_ups,
 	.pull_downs = x1000_pull_downs,
+	.access_table = &x1000_access_table,
 };
 
 static const u32 x1830_pull_ups[4] = {
@@ -2506,6 +2521,16 @@ static const struct function_desc x1830_
 	{ "mac", x1830_mac_groups, ARRAY_SIZE(x1830_mac_groups), },
 };
 
+static const struct regmap_range x1830_access_ranges[] = {
+	regmap_reg_range(0x0000, 0x4000 - 4),
+	regmap_reg_range(0x7000, 0x8000 - 4),
+};
+
+static const struct regmap_access_table x1830_access_table = {
+	.yes_ranges = x1830_access_ranges,
+	.n_yes_ranges = ARRAY_SIZE(x1830_access_ranges),
+};
+
 static const struct ingenic_chip_info x1830_chip_info = {
 	.num_chips = 4,
 	.reg_offset = 0x1000,
@@ -2516,6 +2541,7 @@ static const struct ingenic_chip_info x1
 	.num_functions = ARRAY_SIZE(x1830_functions),
 	.pull_ups = x1830_pull_ups,
 	.pull_downs = x1830_pull_downs,
+	.access_table = &x1830_access_table,
 };
 
 static const u32 x2000_pull_ups[5] = {
@@ -2969,6 +2995,17 @@ static const struct function_desc x2000_
 	{ "otg", x2000_otg_groups, ARRAY_SIZE(x2000_otg_groups), },
 };
 
+static const struct regmap_range x2000_access_ranges[] = {
+	regmap_reg_range(0x000, 0x500 - 4),
+	regmap_reg_range(0x700, 0x800 - 4),
+};
+
+/* shared with X2100 */
+static const struct regmap_access_table x2000_access_table = {
+	.yes_ranges = x2000_access_ranges,
+	.n_yes_ranges = ARRAY_SIZE(x2000_access_ranges),
+};
+
 static const struct ingenic_chip_info x2000_chip_info = {
 	.num_chips = 5,
 	.reg_offset = 0x100,
@@ -2979,6 +3016,7 @@ static const struct ingenic_chip_info x2
 	.num_functions = ARRAY_SIZE(x2000_functions),
 	.pull_ups = x2000_pull_ups,
 	.pull_downs = x2000_pull_downs,
+	.access_table = &x2000_access_table,
 };
 
 static const u32 x2100_pull_ups[5] = {
@@ -3189,6 +3227,7 @@ static const struct ingenic_chip_info x2
 	.num_functions = ARRAY_SIZE(x2100_functions),
 	.pull_ups = x2100_pull_ups,
 	.pull_downs = x2100_pull_downs,
+	.access_table = &x2000_access_table,
 };
 
 static u32 ingenic_gpio_read_reg(struct ingenic_gpio_chip *jzgc, u8 reg)
@@ -4168,7 +4207,12 @@ static int __init ingenic_pinctrl_probe(
 		return PTR_ERR(base);
 
 	regmap_config = ingenic_pinctrl_regmap_config;
-	regmap_config.max_register = chip_info->num_chips * chip_info->reg_offset;
+	if (chip_info->access_table) {
+		regmap_config.rd_table = chip_info->access_table;
+		regmap_config.wr_table = chip_info->access_table;
+	} else {
+		regmap_config.max_register = chip_info->num_chips * chip_info->reg_offset - 4;
+	}
 
 	jzpc->map = devm_regmap_init_mmio(dev, base, &regmap_config);
 	if (IS_ERR(jzpc->map)) {


