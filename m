Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1871B5EEC
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 17:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgDWPRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 11:17:47 -0400
Received: from mga07.intel.com ([134.134.136.100]:23296 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728990AbgDWPRr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 11:17:47 -0400
IronPort-SDR: Eu1vlPPvBFneTxeeSVSArtaM8rrF5QRFAljrSHTORQUOdkgalYQwpfGc/mtujHKIHTSIB4G55i
 3A57mHSOVVyg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 08:17:46 -0700
IronPort-SDR: fy7yKvh7T2zNzZNCVaQq2XQHqN9fxWosy5gium/Inm9vptlj2UhOGg1ng+p0Ifj2mcXyt5m0T8
 0kPhmGDSrXXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="244896817"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga007.jf.intel.com with SMTP; 23 Apr 2020 08:17:44 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 23 Apr 2020 18:17:43 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: [PATCH] drm/edid: Fix off-by-one in DispID DTD pixel clock
Date:   Thu, 23 Apr 2020 18:17:43 +0300
Message-Id: <20200423151743.18767-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

The DispID DTD pixel clock is documented as:
"00 00 00 h → FF FF FF h | Pixel clock ÷ 10,000 0.01 → 167,772.16 Mega Pixels per Sec"
Which seems to imply that we to add one to the raw value.

Reality seems to agree as there are tiled displays in the wild
which currently show a 10kHz difference in the pixel clock
between the tiles (one tile gets its mode from the base EDID,
the other from the DispID block).

Cc: stable@vger.kernel.org
References: https://gitlab.freedesktop.org/drm/intel/-/issues/27
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/drm_edid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 43b6ca364daa..544d2603f5fc 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5120,7 +5120,7 @@ static struct drm_display_mode *drm_mode_displayid_detailed(struct drm_device *d
 	struct drm_display_mode *mode;
 	unsigned pixel_clock = (timings->pixel_clock[0] |
 				(timings->pixel_clock[1] << 8) |
-				(timings->pixel_clock[2] << 16));
+				(timings->pixel_clock[2] << 16)) + 1;
 	unsigned hactive = (timings->hactive[0] | timings->hactive[1] << 8) + 1;
 	unsigned hblank = (timings->hblank[0] | timings->hblank[1] << 8) + 1;
 	unsigned hsync = (timings->hsync[0] | (timings->hsync[1] & 0x7f) << 8) + 1;
-- 
2.24.1

