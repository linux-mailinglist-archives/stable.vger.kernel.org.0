Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32644B4C10
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347833AbiBNKhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:37:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347716AbiBNKeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:34:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867A0A2F18;
        Mon, 14 Feb 2022 02:00:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22FCD60C62;
        Mon, 14 Feb 2022 10:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE731C340E9;
        Mon, 14 Feb 2022 10:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832849;
        bh=qG8TxJIEufoTrtV8bFIDKUVwWO6LpLeVz8gYbFL9Sw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JuhLnPxGi3lAvS2Q8MzXhPNea7moHse8J1nCGB5wOnhcTkWbXpXFOmUDLPb6QMzVV
         ALxNuke9Hl8uH3YdFfHBi0H92w/yk+GUTZd90tuvb6z1B8IZ/ynehA+qHcTkzddoy3
         lj7A43tOW2dV+awi1FqC4vZOVTnczs+3xWMwzYUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 113/203] drm/vc4: hdmi: Allow DBLCLK modes even if horz timing is odd.
Date:   Mon, 14 Feb 2022 10:25:57 +0100
Message-Id: <20220214092514.092096297@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 1d118965965f89948236ebe23072bb1fca5e7832 ]

The 2711 pixel valve can't produce odd horizontal timings, and
checks were added to vc4_hdmi_encoder_atomic_check and
vc4_hdmi_encoder_mode_valid to filter out/block selection of
such modes.

Modes with DRM_MODE_FLAG_DBLCLK double all the horizontal timing
values before programming them into the PV. The PV values,
therefore, can not be odd, and so the modes can be supported.

Amend the filtering appropriately.

Fixes: 57fb32e632be ("drm/vc4: hdmi: Block odd horizontal timings")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220127135116.298278-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index c000946996edb..24f11c07bc3c7 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1090,6 +1090,7 @@ static int vc4_hdmi_encoder_atomic_check(struct drm_encoder *encoder,
 	unsigned long long tmds_rate;
 
 	if (vc4_hdmi->variant->unsupported_odd_h_timings &&
+	    !(mode->flags & DRM_MODE_FLAG_DBLCLK) &&
 	    ((mode->hdisplay % 2) || (mode->hsync_start % 2) ||
 	     (mode->hsync_end % 2) || (mode->htotal % 2)))
 		return -EINVAL;
@@ -1137,6 +1138,7 @@ vc4_hdmi_encoder_mode_valid(struct drm_encoder *encoder,
 	struct vc4_hdmi *vc4_hdmi = encoder_to_vc4_hdmi(encoder);
 
 	if (vc4_hdmi->variant->unsupported_odd_h_timings &&
+	    !(mode->flags & DRM_MODE_FLAG_DBLCLK) &&
 	    ((mode->hdisplay % 2) || (mode->hsync_start % 2) ||
 	     (mode->hsync_end % 2) || (mode->htotal % 2)))
 		return MODE_H_ILLEGAL;
-- 
2.34.1



