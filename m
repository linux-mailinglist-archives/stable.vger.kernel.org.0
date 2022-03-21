Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5E74E2943
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348507AbiCUODs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349070AbiCUODS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:03:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694081770AB;
        Mon, 21 Mar 2022 07:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AE53B816CE;
        Mon, 21 Mar 2022 14:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C335CC340F2;
        Mon, 21 Mar 2022 14:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871215;
        bh=ZLNrGtC/1yYtaIEPvn2dN37TDlIhPm1AaMyY5zLM+o8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7NgKpvKl3q9avqaRcNYT4cF5OVB2Njhg6V/6NFTNzCmV8N6nR5CYGg4zR8tn0oNs
         0XzNqdhFeKKiqsaF/PAz/FpIqS9CBgE82la5PICagMZnq4pyhnkb9hIzm7IT/tOxbJ
         vyFC+1NMT93lI+G79RQCu1fBChobyOyg1ilnteYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Marek Vasut <marex@denx.de>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Max Krummenacher <max.krummenacher@toradex.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 15/32] drm/imx: parallel-display: Remove bus flags check in imx_pd_bridge_atomic_check()
Date:   Mon, 21 Mar 2022 14:52:51 +0100
Message-Id: <20220321133221.004491467@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133220.559554263@linuxfoundation.org>
References: <20220321133220.559554263@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Niedermaier <cniedermaier@dh-electronics.com>

[ Upstream commit 6061806a863e8b65b109eb06a280041cc7525442 ]

If display timings were read from the devicetree using
of_get_display_timing() and pixelclk-active is defined
there, the flag DISPLAY_FLAGS_SYNC_POSEDGE/NEGEDGE is
automatically generated. Through the function
drm_bus_flags_from_videomode() e.g. called in the
panel-simple driver this flag got into the bus flags,
but then in imx_pd_bridge_atomic_check() the bus flag
check failed and will not initialize the display. The
original commit fe141cedc433 does not explain why this
check was introduced. So remove the bus flags check,
because it stops the initialization of the display with
valid bus flags.

Fixes: fe141cedc433 ("drm/imx: pd: Use bus format/flags provided by the bridge when available")
Signed-off-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Cc: Marek Vasut <marex@denx.de>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: linux-arm-kernel@lists.infradead.org
To: dri-devel@lists.freedesktop.org
Tested-by: Max Krummenacher <max.krummenacher@toradex.com>
Acked-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220201113643.4638-1-cniedermaier@dh-electronics.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/parallel-display.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/gpu/drm/imx/parallel-display.c b/drivers/gpu/drm/imx/parallel-display.c
index a8aba0141ce7..06cb1a59b9bc 100644
--- a/drivers/gpu/drm/imx/parallel-display.c
+++ b/drivers/gpu/drm/imx/parallel-display.c
@@ -217,14 +217,6 @@ static int imx_pd_bridge_atomic_check(struct drm_bridge *bridge,
 	if (!imx_pd_format_supported(bus_fmt))
 		return -EINVAL;
 
-	if (bus_flags &
-	    ~(DRM_BUS_FLAG_DE_LOW | DRM_BUS_FLAG_DE_HIGH |
-	      DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE |
-	      DRM_BUS_FLAG_PIXDATA_DRIVE_NEGEDGE)) {
-		dev_warn(imxpd->dev, "invalid bus_flags (%x)\n", bus_flags);
-		return -EINVAL;
-	}
-
 	bridge_state->output_bus_cfg.flags = bus_flags;
 	bridge_state->input_bus_cfg.flags = bus_flags;
 	imx_crtc_state->bus_flags = bus_flags;
-- 
2.34.1



