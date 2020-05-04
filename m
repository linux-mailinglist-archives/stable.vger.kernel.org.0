Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE381C4558
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731018AbgEDSAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731011AbgEDSAe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:00:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74C13206B8;
        Mon,  4 May 2020 18:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615233;
        bh=Dp1rLS8Oy9aebYRRZCDInVfYF7OYXthvspq2OHe+RgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xI6WsATGNM6cPZY0Ij+Ykc5dkt98CQGMBssa1OtqLBuV/QqP4Eln3bKqHYN3iwFyQ
         Lt62HY63b4/ShxvjZ8y9AHUgsKK9iHfHBrLZs1GokO+dRs1Z6y6d+zYSaw0fxQ0/8W
         cHmONVoW1mAtFwqGIdVuPD+I0rqFdMAo9qnA1fmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>
Subject: [PATCH 4.14 02/26] drm/edid: Fix off-by-one in DispID DTD pixel clock
Date:   Mon,  4 May 2020 19:57:16 +0200
Message-Id: <20200504165442.980999284@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165442.494398840@linuxfoundation.org>
References: <20200504165442.494398840@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 6292b8efe32e6be408af364132f09572aed14382 upstream.

The DispID DTD pixel clock is documented as:
"00 00 00 h → FF FF FF h | Pixel clock ÷ 10,000 0.01 → 167,772.16 Mega Pixels per Sec"
Which seems to imply that we to add one to the raw value.

Reality seems to agree as there are tiled displays in the wild
which currently show a 10kHz difference in the pixel clock
between the tiles (one tile gets its mode from the base EDID,
the other from the DispID block).

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200423151743.18767-1-ville.syrjala@linux.intel.com
Reviewed-by: Manasi Navare <manasi.d.navare@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_edid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -4502,7 +4502,7 @@ static struct drm_display_mode *drm_mode
 	struct drm_display_mode *mode;
 	unsigned pixel_clock = (timings->pixel_clock[0] |
 				(timings->pixel_clock[1] << 8) |
-				(timings->pixel_clock[2] << 16));
+				(timings->pixel_clock[2] << 16)) + 1;
 	unsigned hactive = (timings->hactive[0] | timings->hactive[1] << 8) + 1;
 	unsigned hblank = (timings->hblank[0] | timings->hblank[1] << 8) + 1;
 	unsigned hsync = (timings->hsync[0] | (timings->hsync[1] & 0x7f) << 8) + 1;


