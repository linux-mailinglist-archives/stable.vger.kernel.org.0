Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D48D1B3E89
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730647AbgDVKZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730644AbgDVKZ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:25:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90D2E2084D;
        Wed, 22 Apr 2020 10:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551158;
        bh=zGk6FoANVMQFUDEne0uQaTPVZoZV1cfRSWWFR3MDCFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsNsilXjLDvhDVUMTG4I0ZEn/o6GC21+lYL+YacTP7VCkuYDPnA8vihJzUo6oM4/G
         fmBF8SSbIFEW+btqeZnYPRJRb2oMr7PKn8t00+eVWnzcf8VUKmXeVPSbqnUj6v7a5Z
         7cu02z6TuDIoEusTkcC5BTq8gEaA00uDux4jpKgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 125/166] drm/vc4: Fix HDMI mode validation
Date:   Wed, 22 Apr 2020 11:57:32 +0200
Message-Id: <20200422095101.951417409@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index cea18dc15f77c..340719238753d 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -681,11 +681,23 @@ static enum drm_mode_status
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



