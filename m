Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3278F3A6451
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235708AbhFNLXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234768AbhFNLVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:21:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A3A36199D;
        Mon, 14 Jun 2021 10:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667930;
        bh=sqXNUKRqZ/jQVQRs9cUbyrUHoCei3o6O3ABjrOCWC/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4CrFUKwiOLWzRkJH/ebwXPWVD9jHm3HBDgiTCwdvI91jNWgSnRKT7YAKETFOYN9X
         Jlsat/4scmbZY4stnv769mUebF/Ej10DMzE3I6RocjDlrxPy1Pcj8YQDn3urQI07i1
         qZC1nrKzjt9LvqnFuzZL/uBA5oB2l8+4vJCSLZQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.12 129/173] drm/mcde: Fix off by 10^3 in calculation
Date:   Mon, 14 Jun 2021 12:27:41 +0200
Message-Id: <20210614102702.459333664@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit c8a570443943304cac2e4186dbce6989b6c2b8b5 upstream.

The calclulation of how many bytes we stuff into the
DSI pipeline for video mode panels is off by three
orders of magnitude because we did not account for the
fact that the DRM mode clock is in kilohertz rather
than hertz.

This used to be:
drm_mode_vrefresh(mode) * mode->htotal * mode->vtotal
which would become for example for s6e63m0:
60 x 514 x 831 = 25628040 Hz, but mode->clock is
25628 as it is in kHz.

This affects only the Samsung GT-I8190 "Golden" phone
right now since it is the only MCDE device with a video
mode display.

Curiously some specimen work with this code and wild
settings in the EOL and empty packets at the end of the
display, but I have noticed an eeire flicker until now.
Others were not so lucky and got black screens.

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reported-by: Stephan Gerhold <stephan@gerhold.net>
Fixes: 920dd1b1425b ("drm/mcde: Use mode->clock instead of reverse calculating it from the vrefresh")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20210608213318.3897858-1-linus.walleij@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mcde/mcde_dsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/mcde/mcde_dsi.c
+++ b/drivers/gpu/drm/mcde/mcde_dsi.c
@@ -577,7 +577,7 @@ static void mcde_dsi_setup_video_mode(st
 	 * porches and sync.
 	 */
 	/* (ps/s) / (pixels/s) = ps/pixels */
-	pclk = DIV_ROUND_UP_ULL(1000000000000, mode->clock);
+	pclk = DIV_ROUND_UP_ULL(1000000000000, (mode->clock * 1000));
 	dev_dbg(d->dev, "picoseconds between two pixels: %llu\n",
 		pclk);
 


