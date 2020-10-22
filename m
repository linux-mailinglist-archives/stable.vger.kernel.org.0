Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142EF296572
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 21:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370379AbgJVTnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 15:43:01 -0400
Received: from mga06.intel.com ([134.134.136.31]:32479 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S370377AbgJVTnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Oct 2020 15:43:00 -0400
IronPort-SDR: xLUw50XBX7drIwniDkRNk8BecWBrXLBq33Usteg+OVYviNSahzpgKABuVrbeVtArKkdNdBB4I9
 qbZwOZMMzkZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="229219213"
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="229219213"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2020 12:42:59 -0700
IronPort-SDR: R8HzbOifldxclQO2dv3ElHs52VSySzXOiLPATVFu5X7TmrgzBfbMJnLj/8mKqgx8yEKNwCMRhk
 HpDBwD1CZXmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="359370921"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by FMSMGA003.fm.intel.com with SMTP; 22 Oct 2020 12:42:56 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 22 Oct 2020 22:42:56 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] drm/modes: Switch to 64bit maths to avoid integer overflow
Date:   Thu, 22 Oct 2020 22:42:56 +0300
Message-Id: <20201022194256.30978-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

The new >8k CEA modes have dotclocks reaching 5.94 GHz, which
means our clock*1000 will now overflow the 32bit unsigned
integer. Switch to 64bit maths to avoid it.

Cc: stable@vger.kernel.org
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
An interesting question how many other place might suffer from similar
overflows. I think i915 should be mostly OK. The one place I know we use
Hz instead kHz is the hsw DPLL code, which I would prefer we also change
to use kHz. The other concern is whether we have any potential overflows
before we check this against the platform's max dotclock.

I do have this unreviewed igt series 
https://patchwork.freedesktop.org/series/69531/ which extends the
current testing with some other forms of invalid modes. Could probably
extend that with a mode.clock=INT_MAX test to see if anything else might
trip up.

No idea about other drivers.

 drivers/gpu/drm/drm_modes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index 501b4fe55a3d..511cde5c7fa6 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -762,7 +762,7 @@ int drm_mode_vrefresh(const struct drm_display_mode *mode)
 	if (mode->htotal == 0 || mode->vtotal == 0)
 		return 0;
 
-	num = mode->clock * 1000;
+	num = mode->clock;
 	den = mode->htotal * mode->vtotal;
 
 	if (mode->flags & DRM_MODE_FLAG_INTERLACE)
@@ -772,7 +772,7 @@ int drm_mode_vrefresh(const struct drm_display_mode *mode)
 	if (mode->vscan > 1)
 		den *= mode->vscan;
 
-	return DIV_ROUND_CLOSEST(num, den);
+	return DIV_ROUND_CLOSEST_ULL(mul_u32_u32(num, 1000), den);
 }
 EXPORT_SYMBOL(drm_mode_vrefresh);
 
-- 
2.26.2

