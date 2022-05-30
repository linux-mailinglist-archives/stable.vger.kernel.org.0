Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9855380F3
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239469AbiE3OJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238835AbiE3OEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:04:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DE3CE5D8;
        Mon, 30 May 2022 06:40:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50F2960FA3;
        Mon, 30 May 2022 13:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E03C3411C;
        Mon, 30 May 2022 13:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918028;
        bh=I7LxCGqGRJzIqYh0gYUNNAZ2n4cqGO4jUUu8TCEeoIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMePOAabdFN6DnmCSCiKVO1ThFP5kF6STCD/v9dDk8W9fyAfESiVoQ3UKH82gY6cg
         0jLgqt8tzpNMRL9BTxzi7ArD2SxYFBjy9Ma8m93eujIbZnQ37ilcKcik2OYJNao2WV
         9Nn6SUWz8U79A09mMao+Y2oC9VXRm2Kr3UZg5AIUHhsh+PeymJTHltJENlKwtMbqUk
         Rg+Q/0DlfPjgR3L5IT2FxK1X8hxg8Og0aEth8c2X6hlqj7tM1JoYNN1NnKgJge8Y/r
         u3Fm3iCpWp73naLixRZvK3DoBHIPikhDyflYZoU7Vev7PgZEM+r1Hi+rx6Lq+s/Egu
         9+tq7W03MnI0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Samuel Holland <samuel@sholland.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>, mripard@kernel.org,
        wens@csie.org, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 038/109] drm/sun4i: Add support for D1 TCONs
Date:   Mon, 30 May 2022 09:37:14 -0400
Message-Id: <20220530133825.1933431-38-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit b9b52d2f4aafa2bd637ace0f24615bdad8e49f01 ]

D1 has a TCON TOP, so its quirks are similar to those for the R40 TCONs.
While there are some register changes, the part of the TCON TV supported
by the driver matches the R40 quirks, so that quirks structure can be
reused. D1 has the first supported TCON LCD with a TCON TOP, so the TCON
LCD needs a new quirks structure.

D1's TCON LCD hardware supports LVDS; in fact it provides dual-link LVDS
from a single TCON. However, it comes with a brand new LVDS PHY. Since
this PHY has not been tested, leave out LVDS driver support for now.

Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220424162633.12369-14-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_tcon.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
index 9f06dec0fc61..e27103f5a075 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -1544,6 +1544,12 @@ static const struct sun4i_tcon_quirks sun9i_a80_tcon_tv_quirks = {
 	.needs_edp_reset = true,
 };
 
+static const struct sun4i_tcon_quirks sun20i_d1_lcd_quirks = {
+	.has_channel_0		= true,
+	.dclk_min_div		= 1,
+	.set_mux		= sun8i_r40_tcon_tv_set_mux,
+};
+
 /* sun4i_drv uses this list to check if a device node is a TCON */
 const struct of_device_id sun4i_tcon_of_table[] = {
 	{ .compatible = "allwinner,sun4i-a10-tcon", .data = &sun4i_a10_quirks },
@@ -1561,6 +1567,8 @@ const struct of_device_id sun4i_tcon_of_table[] = {
 	{ .compatible = "allwinner,sun8i-v3s-tcon", .data = &sun8i_v3s_quirks },
 	{ .compatible = "allwinner,sun9i-a80-tcon-lcd", .data = &sun9i_a80_tcon_lcd_quirks },
 	{ .compatible = "allwinner,sun9i-a80-tcon-tv", .data = &sun9i_a80_tcon_tv_quirks },
+	{ .compatible = "allwinner,sun20i-d1-tcon-lcd", .data = &sun20i_d1_lcd_quirks },
+	{ .compatible = "allwinner,sun20i-d1-tcon-tv", .data = &sun8i_r40_tv_quirks },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, sun4i_tcon_of_table);
-- 
2.35.1

