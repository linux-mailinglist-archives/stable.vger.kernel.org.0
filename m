Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E05164A050
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbiLLNXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiLLNXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:23:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060E424D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:23:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96EDA61025
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DD2C433F0;
        Mon, 12 Dec 2022 13:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851398;
        bh=feB1qyBeXQiyfxC25OOeCwBFJONsKUa0FBlbjwF/Zak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyMntsNs8SNe+hg1P6o/7g68CX68w3/szkwulh0/7Q+RXmiO7JlCIputNEFFK5Scf
         D0YnjNWPsTNO1tD7mfXVPJkktSmKR8ZoRjMgWbdku/wxx6Zh47Lv5N3cLS/pOZNC2h
         TgvwegdfGpRr4qmHCunbFzYDTHLU+a3LLXdCeyAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qiqi Zhang <eddy.zhang@rock-chips.com>,
        Douglas Anderson <dianders@chromium.org>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/67] drm/bridge: ti-sn65dsi86: Fix output polarity setting bug
Date:   Mon, 12 Dec 2022 14:17:11 +0100
Message-Id: <20221212130919.342484618@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
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

From: Qiqi Zhang <eddy.zhang@rock-chips.com>

[ Upstream commit 8c115864501fc09932cdfec53d9ec1cde82b4a28 ]

According to the description in ti-sn65dsi86's datasheet:

CHA_HSYNC_POLARITY:
0 = Active High Pulse. Synchronization signal is high for the sync
pulse width. (default)
1 = Active Low Pulse. Synchronization signal is low for the sync
pulse width.

CHA_VSYNC_POLARITY:
0 = Active High Pulse. Synchronization signal is high for the sync
pulse width. (Default)
1 = Active Low Pulse. Synchronization signal is low for the sync
pulse width.

We should only set these bits when the polarity is negative.

Fixes: a095f15c00e2 ("drm/bridge: add support for sn65dsi86 bridge driver")
Signed-off-by: Qiqi Zhang <eddy.zhang@rock-chips.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221125104558.84616-1-eddy.zhang@rock-chips.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index dbb4a374cb64..20ea1c6bc8bb 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -460,9 +460,9 @@ static void ti_sn_bridge_set_video_timings(struct ti_sn_bridge *pdata)
 		&pdata->bridge.encoder->crtc->state->adjusted_mode;
 	u8 hsync_polarity = 0, vsync_polarity = 0;
 
-	if (mode->flags & DRM_MODE_FLAG_PHSYNC)
+	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
 		hsync_polarity = CHA_HSYNC_POLARITY;
-	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
+	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
 		vsync_polarity = CHA_VSYNC_POLARITY;
 
 	ti_sn_bridge_write_u16(pdata, SN_CHA_ACTIVE_LINE_LENGTH_LOW_REG,
-- 
2.35.1



