Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152CC6AE9F1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbjCGR3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjCGR25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:28:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA4A3669C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:24:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1200B81995
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10C4C433EF;
        Tue,  7 Mar 2023 17:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209840;
        bh=QkL9z2Fa9wbhkW4wGzDnUW/LgCzURxPJoAccglNZzLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANt2IfUMCvsanpp8LlYPIyzQ81Auihx0tchIZ85a2pKEfZaFSeu/LnwojFE6e4tDx
         UGN/voumIsGaRlKohvX6ZG69ajJ7LtMSlvQcBFFsAvBnfCYansqqfTghV2Zsh706YY
         imU44n0QVY/hwypl9DpvMcrirDYlLhZYyc8rQB1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0348/1001] drm/vc4: hvs: Configure the HVS COB allocations
Date:   Tue,  7 Mar 2023 17:52:00 +0100
Message-Id: <20230307170036.547364416@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 1284365e3e8cc33849f90cae20bca36fd7544e24 ]

The HVS Composite Output Buffer (COB) is the memory used to
generate the output pixel data.
Until now the vc4 driver has been relying on the firmware to
have set these to sensible values.

In testing triple screen support it has been noted that only
1 line was being assigned to HVS channel 2. Whilst that is fine
for the transposer (TXP), and indeed needed as only some pixels
have an alpha channel, it is insufficient to run a live display.

Split the COB more evenly between the 3 HVS channels.

Fixes: c54619b0bfb3 ("drm/vc4: Add support for the BCM2711 HVS5")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20221207-rpi-hvs-crtc-misc-v1-1-1f8e0770798b@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 56 ++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index c4453a5ae163a..d615ba7db9209 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -776,7 +776,7 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 	struct vc4_hvs *hvs = NULL;
 	int ret;
 	u32 dispctrl;
-	u32 reg;
+	u32 reg, top;
 
 	hvs = drmm_kzalloc(drm, sizeof(*hvs), GFP_KERNEL);
 	if (!hvs)
@@ -912,6 +912,60 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 
 	HVS_WRITE(SCALER_DISPCTRL, dispctrl);
 
+	/* Recompute Composite Output Buffer (COB) allocations for the displays
+	 */
+	if (!vc4->is_vc5) {
+		/* The COB is 20736 pixels, or just over 10 lines at 2048 wide.
+		 * The bottom 2048 pixels are full 32bpp RGBA (intended for the
+		 * TXP composing RGBA to memory), whilst the remainder are only
+		 * 24bpp RGB.
+		 *
+		 * Assign 3 lines to channels 1 & 2, and just over 4 lines to
+		 * channel 0.
+		 */
+		#define VC4_COB_SIZE		20736
+		#define VC4_COB_LINE_WIDTH	2048
+		#define VC4_COB_NUM_LINES	3
+		reg = 0;
+		top = VC4_COB_LINE_WIDTH * VC4_COB_NUM_LINES;
+		reg |= (top - 1) << 16;
+		HVS_WRITE(SCALER_DISPBASE2, reg);
+		reg = top;
+		top += VC4_COB_LINE_WIDTH * VC4_COB_NUM_LINES;
+		reg |= (top - 1) << 16;
+		HVS_WRITE(SCALER_DISPBASE1, reg);
+		reg = top;
+		top = VC4_COB_SIZE;
+		reg |= (top - 1) << 16;
+		HVS_WRITE(SCALER_DISPBASE0, reg);
+	} else {
+		/* The COB is 44416 pixels, or 10.8 lines at 4096 wide.
+		 * The bottom 4096 pixels are full RGBA (intended for the TXP
+		 * composing RGBA to memory), whilst the remainder are only
+		 * RGB. Addressing is always pixel wide.
+		 *
+		 * Assign 3 lines of 4096 to channels 1 & 2, and just over 4
+		 * lines. to channel 0.
+		 */
+		#define VC5_COB_SIZE		44416
+		#define VC5_COB_LINE_WIDTH	4096
+		#define VC5_COB_NUM_LINES	3
+		reg = 0;
+		top = VC5_COB_LINE_WIDTH * VC5_COB_NUM_LINES;
+		reg |= top << 16;
+		HVS_WRITE(SCALER_DISPBASE2, reg);
+		top += 16;
+		reg = top;
+		top += VC5_COB_LINE_WIDTH * VC5_COB_NUM_LINES;
+		reg |= top << 16;
+		HVS_WRITE(SCALER_DISPBASE1, reg);
+		top += 16;
+		reg = top;
+		top = VC5_COB_SIZE;
+		reg |= top << 16;
+		HVS_WRITE(SCALER_DISPBASE0, reg);
+	}
+
 	ret = devm_request_irq(dev, platform_get_irq(pdev, 0),
 			       vc4_hvs_irq_handler, 0, "vc4 hvs", drm);
 	if (ret)
-- 
2.39.2



