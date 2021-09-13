Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7097A40948E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345570AbhIMOcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347092AbhIMOaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52B0761B66;
        Mon, 13 Sep 2021 13:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541067;
        bh=F3YbZcsfn+SkvJFB2Mh2Liy2M6H3Zi8OuGtHL15WyiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbHbPaonvNF/0VJ4bWFc4iVCDpIg2ZrIZgzOSz9EDtDZjtLejD5rWtANfTBLiIK49
         lX7r77YalaiNrWELSn7o57y97BvDPmFNydqSsGW/ruyBspXfMfFDK6BDnJPzBJxKsU
         624Y6+fT4DJJM1mGKf8W/DfKEc2X6tkxXSY4BCgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Robert Foss <robert.foss@linaro.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 150/334] drm/bridge: ti-sn65dsi86: Fix power off sequence
Date:   Mon, 13 Sep 2021 15:13:24 +0200
Message-Id: <20210913131118.427349683@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit acb06210b096830e28e9ffd2c6501fe99bdb10fd ]

When testing with a panel that's apparently a little more persnickety
about the correct power sequence (specifically Samsung ATNA33XC20), we
found that the ti-sn65dsi86 was doing things just slightly wrong.

Looking closely at the ti-sn65dsi86's datasheet, the power off
sequence is supposed to be:
1. Clear VSTREAM_ENABLE bit
2. Stop DSI stream from GPU. DSI lanes must be placed in LP11 state.
3. Program the ML_TX_MODE to 0x0 (OFF)
4. Program the DP_NUM_LANES register to 0x0
5. Clear the DP_PLL_EN bit.
6. Deassert the EN pin.
7. Remove power from supply pins

Since we were doing the whole sequence in the "disable", I believe
that step #2 (stopping the DSI stream from the GPU) wasn't
happening. We also weren't setting DP_NUM_LANES to 0.

Let's fix this.

NOTE: things are a little asymmetric now. For instance, we turn the
PLL on in "enable" but now we're not turning it off until
"post_disable". It would seem to make sense to move the PLL turning on
to "pre_enable" to match. Unfortunately, I don't believe that's
allowed. It looks as if (in the non-refclk mode which probably nobody
is using) we have to wait until the MIPI clock is there before we can
enable the PLL. In any case, the way it is here won't really
hurt--it'll just leave the PLL on a little longer.

Fixes: a095f15c00e2 ("drm/bridge: add support for sn65dsi86 bridge driver")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Robert Foss <robert.foss@linaro.org>
Reviewed-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210730084534.v2.2.If8a8ec3bf1855cf0dbb62c005a71d6698c99c125@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index 970a4859eea3..ecd4fa3a9a1d 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -558,10 +558,6 @@ static void ti_sn_bridge_disable(struct drm_bridge *bridge)
 
 	/* disable video stream */
 	regmap_update_bits(pdata->regmap, SN_ENH_FRAME_REG, VSTREAM_ENABLE, 0);
-	/* semi auto link training mode OFF */
-	regmap_write(pdata->regmap, SN_ML_TX_MODE_REG, 0);
-	/* disable DP PLL */
-	regmap_write(pdata->regmap, SN_PLL_ENABLE_REG, 0);
 }
 
 static void ti_sn_bridge_set_dsi_rate(struct ti_sn65dsi86 *pdata)
@@ -896,6 +892,13 @@ static void ti_sn_bridge_post_disable(struct drm_bridge *bridge)
 {
 	struct ti_sn65dsi86 *pdata = bridge_to_ti_sn65dsi86(bridge);
 
+	/* semi auto link training mode OFF */
+	regmap_write(pdata->regmap, SN_ML_TX_MODE_REG, 0);
+	/* Num lanes to 0 as per power sequencing in data sheet */
+	regmap_update_bits(pdata->regmap, SN_SSC_CONFIG_REG, DP_NUM_LANES_MASK, 0);
+	/* disable DP PLL */
+	regmap_write(pdata->regmap, SN_PLL_ENABLE_REG, 0);
+
 	if (!pdata->refclk)
 		ti_sn65dsi86_disable_comms(pdata);
 
-- 
2.30.2



