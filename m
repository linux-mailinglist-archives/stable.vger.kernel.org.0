Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2611540E6E7
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242550AbhIPR0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343975AbhIPRWE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:22:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0A5961BB5;
        Thu, 16 Sep 2021 16:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810575;
        bh=Ruc48eyXaD3uQ5drzDTKk8RQ+LthBucD3UIoQgJsNFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqW9ITGymCf5XzxSXJ7BCnwuajxp70kKYe0RzgiyHv3TrY0JGTDxqJE/3hMnVXJeK
         63TL7G/Mm2naImT5SjXcDKgvbnsbw2c63EVnbIwsjn7DDkNCPP5cuS5IUvDZJHScTC
         Ofk/Rrlq+fv0dtUqPEffs4WEMDurVPe+R469SU/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Gover <tim.gover@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 164/432] drm: vc4: Fix pixel-wrap issue with DVP teardown
Date:   Thu, 16 Sep 2021 17:58:33 +0200
Message-Id: <20210916155816.308185416@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Gover <tim.gover@raspberrypi.com>

[ Upstream commit 0b066a6809d0f8fd9868e383add36aa5a2fa409d ]

Adjust the DVP enable/disable sequence to avoid a pixel getting stuck
in an internal, non resettable FIFO within PixelValve when changing
HDMI resolution.

The blank pixels features of the DVP can prevent signals back to
pixelvalve causing it to not clear the FIFO. Adjust the ordering
and timing of operations to ensure the clear signal makes it through to
pixelvalve.

Signed-off-by: Tim Gover <tim.gover@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20210628130533.144617-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index ad92dbb128b3..f91d37beb113 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -613,12 +613,12 @@ static void vc4_hdmi_encoder_post_crtc_disable(struct drm_encoder *encoder,
 
 	HDMI_WRITE(HDMI_RAM_PACKET_CONFIG, 0);
 
-	HDMI_WRITE(HDMI_VID_CTL, HDMI_READ(HDMI_VID_CTL) |
-		   VC4_HD_VID_CTL_CLRRGB | VC4_HD_VID_CTL_CLRSYNC);
+	HDMI_WRITE(HDMI_VID_CTL, HDMI_READ(HDMI_VID_CTL) | VC4_HD_VID_CTL_CLRRGB);
 
-	HDMI_WRITE(HDMI_VID_CTL,
-		   HDMI_READ(HDMI_VID_CTL) | VC4_HD_VID_CTL_BLANKPIX);
+	mdelay(1);
 
+	HDMI_WRITE(HDMI_VID_CTL,
+		   HDMI_READ(HDMI_VID_CTL) & ~VC4_HD_VID_CTL_ENABLE);
 	vc4_hdmi_disable_scrambling(encoder);
 }
 
@@ -628,12 +628,12 @@ static void vc4_hdmi_encoder_post_crtc_powerdown(struct drm_encoder *encoder,
 	struct vc4_hdmi *vc4_hdmi = encoder_to_vc4_hdmi(encoder);
 	int ret;
 
+	HDMI_WRITE(HDMI_VID_CTL,
+		   HDMI_READ(HDMI_VID_CTL) | VC4_HD_VID_CTL_BLANKPIX);
+
 	if (vc4_hdmi->variant->phy_disable)
 		vc4_hdmi->variant->phy_disable(vc4_hdmi);
 
-	HDMI_WRITE(HDMI_VID_CTL,
-		   HDMI_READ(HDMI_VID_CTL) & ~VC4_HD_VID_CTL_ENABLE);
-
 	clk_disable_unprepare(vc4_hdmi->pixel_bvb_clock);
 	clk_disable_unprepare(vc4_hdmi->pixel_clock);
 
@@ -1015,6 +1015,7 @@ static void vc4_hdmi_encoder_post_crtc_enable(struct drm_encoder *encoder,
 
 	HDMI_WRITE(HDMI_VID_CTL,
 		   VC4_HD_VID_CTL_ENABLE |
+		   VC4_HD_VID_CTL_CLRRGB |
 		   VC4_HD_VID_CTL_UNDERFLOW_ENABLE |
 		   VC4_HD_VID_CTL_FRAME_COUNTER_RESET |
 		   (vsync_pos ? 0 : VC4_HD_VID_CTL_VSYNC_LOW) |
-- 
2.30.2



