Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851175F29E1
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiJCH1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiJCHZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:25:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC564BD09;
        Mon,  3 Oct 2022 00:18:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D71C960FB6;
        Mon,  3 Oct 2022 07:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F66C433D6;
        Mon,  3 Oct 2022 07:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781499;
        bh=e/w8t1fK9RfuxqU3rq65AWjAzC+JxuL7MvWCo2+Hd7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RM30Vn/YyEtjkb3bMA6gX00wOAMn981smzmvWoSlQ4wfT730L9SwpdYoqWzJi/TfH
         G60e1/bFYUzDLXm3Tl3xX/lXESp18A1dYuPGkU3troCk+FnSFioxlAl/oXaFFbLczR
         nTUjyxbdGtjUF6UvPx3gxYRX/uVD8+UOUEperRoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 43/83] soc: sunxi: sram: Prevent the driver from being unbound
Date:   Mon,  3 Oct 2022 09:11:08 +0200
Message-Id: <20221003070723.076001638@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 90e10a1fcd9b24b4ba8c0d35136127473dcd829e ]

This driver exports a regmap tied to the platform device (as opposed to
a syscon, which exports a regmap tied to the OF node). Because of this,
the driver can never be unbound, as that would destroy the regmap. Use
builtin_platform_driver_probe() to enforce this limitation.

Fixes: 5828729bebbb ("soc: sunxi: export a regmap for EMAC clock reg on A64")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20220815041248.53268-5-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/sunxi/sunxi_sram.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/sunxi/sunxi_sram.c b/drivers/soc/sunxi/sunxi_sram.c
index 20b5d38e6da8..852f0872f669 100644
--- a/drivers/soc/sunxi/sunxi_sram.c
+++ b/drivers/soc/sunxi/sunxi_sram.c
@@ -330,7 +330,7 @@ static struct regmap_config sunxi_sram_emac_clock_regmap = {
 	.writeable_reg	= sunxi_sram_regmap_accessible_reg,
 };
 
-static int sunxi_sram_probe(struct platform_device *pdev)
+static int __init sunxi_sram_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct dentry *d;
@@ -412,9 +412,8 @@ static struct platform_driver sunxi_sram_driver = {
 		.name		= "sunxi-sram",
 		.of_match_table	= sunxi_sram_dt_match,
 	},
-	.probe	= sunxi_sram_probe,
 };
-module_platform_driver(sunxi_sram_driver);
+builtin_platform_driver_probe(sunxi_sram_driver, sunxi_sram_probe);
 
 MODULE_AUTHOR("Maxime Ripard <maxime.ripard@free-electrons.com>");
 MODULE_DESCRIPTION("Allwinner sunXi SRAM Controller Driver");
-- 
2.35.1



