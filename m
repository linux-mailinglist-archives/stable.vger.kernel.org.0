Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FCA1AF06C
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgDROnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:43:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728483AbgDROnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:43:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62FD521D82;
        Sat, 18 Apr 2020 14:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587220981;
        bh=jTuUCyPuJOG1nAdrPAoxt4PboG749EAUEnTxsfy/RmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F19wmD4jCz0CkmDTLVPpVQFEhmsV7156Rv+UIWcVAmcsNycuVLVmlDSpQ4OcHoYvF
         aLXDUZZwgBmMCQjLtXGf2XuB1SGNrqSOlawBIkGGoIFX+fmleYEf6jMwpd5ZZOB8MP
         mrDdaUGL2X+0BAaLb7iMguBNni4MfoHz4KEUSeho=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 26/47] drm/vc4: Fix HDMI mode validation
Date:   Sat, 18 Apr 2020 10:42:06 -0400
Message-Id: <20200418144227.9802-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144227.9802-1-sashal@kernel.org>
References: <20200418144227.9802-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit b1e7396a1d0e6af6806337fdaaa44098d6b3343c ]

Current mode validation impedes setting up some video modes which should
be supported otherwise. Namely 1920x1200@60Hz.

Fix this by lowering the minimum HDMI state machine clock to pixel clock
ratio allowed.

Fixes: 32e823c63e90 ("drm/vc4: Reject HDMI modes with too high of clocks.")
Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
Suggested-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20200326122001.22215-1-nsaenzjulienne@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index fd5522fd179e5..86b98856756d9 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -698,11 +698,23 @@ static enum drm_mode_status
 vc4_hdmi_encoder_mode_valid(struct drm_encoder *crtc,
 			    const struct drm_display_mode *mode)
 {
-	/* HSM clock must be 108% of the pixel clock.  Additionally,
-	 * the AXI clock needs to be at least 25% of pixel clock, but
-	 * HSM ends up being the limiting factor.
+	/*
+	 * As stated in RPi's vc4 firmware "HDMI state machine (HSM) clock must
+	 * be faster than pixel clock, infinitesimally faster, tested in
+	 * simulation. Otherwise, exact value is unimportant for HDMI
+	 * operation." This conflicts with bcm2835's vc4 documentation, which
+	 * states HSM's clock has to be at least 108% of the pixel clock.
+	 *
+	 * Real life tests reveal that vc4's firmware statement holds up, and
+	 * users are able to use pixel clocks closer to HSM's, namely for
+	 * 1920x1200@60Hz. So it was decided to have leave a 1% margin between
+	 * both clocks. Which, for RPi0-3 implies a maximum pixel clock of
+	 * 162MHz.
+	 *
+	 * Additionally, the AXI clock needs to be at least 25% of
+	 * pixel clock, but HSM ends up being the limiting factor.
 	 */
-	if (mode->clock > HSM_CLOCK_FREQ / (1000 * 108 / 100))
+	if (mode->clock > HSM_CLOCK_FREQ / (1000 * 101 / 100))
 		return MODE_CLOCK_HIGH;
 
 	return MODE_OK;
-- 
2.20.1

