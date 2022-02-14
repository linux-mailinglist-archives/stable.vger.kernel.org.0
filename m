Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2164B4B7A
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345035AbiBNKIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:08:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345841AbiBNKHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:07:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CB874DDF;
        Mon, 14 Feb 2022 01:49:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D6F161291;
        Mon, 14 Feb 2022 09:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25556C340E9;
        Mon, 14 Feb 2022 09:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832177;
        bh=vORUuYiT5WoDNpghQfBIA5NS9bGKaidEpPRJMV74JMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LxyOhMtzJ9/dipHaoo9i6UE0OWGr2419tsMSrULOskFKF0j+SgM8VFbRyQjGMeKS8
         awZHc5JrA9nHlLMYI9CaMSBGapP54EXH9UBz0zEFNmpWDXTWAn0RCYIpvaV7qEt4E1
         mBEz6h6QYKY155djJfPQEhhtNCgzTJ9xDp5WzHWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/172] drm/vc4: hdmi: Allow DBLCLK modes even if horz timing is odd.
Date:   Mon, 14 Feb 2022 10:25:54 +0100
Message-Id: <20220214092509.722721872@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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
index e880bdd8dcfd2..9170d948b4483 100644
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



