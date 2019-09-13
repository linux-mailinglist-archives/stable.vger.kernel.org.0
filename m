Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3560B1EED
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389478AbfIMNOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:14:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388885AbfIMNOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:14:14 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E46E206BB;
        Fri, 13 Sep 2019 13:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380453;
        bh=/yCKiWZ4Jraybi1+/7SAM/NgnOajGDl0IFaunuwaOic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JyaMgPeY0FSbGS05wwjZYkAgtZSbtv1LIreoKBRZdbQ/iQuG9ATI3NnmDz2PWUsQi
         lm/sAfVp0YIa30UNJUEwIKLv2Nnqr9noC67+7XaPBjw7zjqAvIcyHSSmxhtNqhb2yO
         iNeRnqvSpfDRxxfjNgDNZt+YD4WH/Wy3UYJnkAwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 046/190] drm/i915: Rename PLANE_CTL_DECOMPRESSION_ENABLE
Date:   Fri, 13 Sep 2019 14:05:01 +0100
Message-Id: <20190913130603.454680731@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 53867b46fa8443713b3aee520d6ca558b222d829 ]

Rename PLANE_CTL_DECOMPRESSION_ENABLE to resemble the bpsec name -
PLANE_CTL_RENDER_DECOMPRESSION_ENABLE

Suggested-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20180822015053.1420-2-dhinakaran.pandiyan@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_reg.h      | 2 +-
 drivers/gpu/drm/i915/intel_display.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 16f5d2d938014..4e070afb2738b 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -6531,7 +6531,7 @@ enum {
 #define   PLANE_CTL_YUV422_UYVY			(1 << 16)
 #define   PLANE_CTL_YUV422_YVYU			(2 << 16)
 #define   PLANE_CTL_YUV422_VYUY			(3 << 16)
-#define   PLANE_CTL_DECOMPRESSION_ENABLE	(1 << 15)
+#define   PLANE_CTL_RENDER_DECOMPRESSION_ENABLE	(1 << 15)
 #define   PLANE_CTL_TRICKLE_FEED_DISABLE	(1 << 14)
 #define   PLANE_CTL_PLANE_GAMMA_DISABLE		(1 << 13) /* Pre-GLK */
 #define   PLANE_CTL_TILED_MASK			(0x7 << 10)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 3bd44d042a1d9..f5367bdc04049 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3561,11 +3561,11 @@ static u32 skl_plane_ctl_tiling(uint64_t fb_modifier)
 	case I915_FORMAT_MOD_Y_TILED:
 		return PLANE_CTL_TILED_Y;
 	case I915_FORMAT_MOD_Y_TILED_CCS:
-		return PLANE_CTL_TILED_Y | PLANE_CTL_DECOMPRESSION_ENABLE;
+		return PLANE_CTL_TILED_Y | PLANE_CTL_RENDER_DECOMPRESSION_ENABLE;
 	case I915_FORMAT_MOD_Yf_TILED:
 		return PLANE_CTL_TILED_YF;
 	case I915_FORMAT_MOD_Yf_TILED_CCS:
-		return PLANE_CTL_TILED_YF | PLANE_CTL_DECOMPRESSION_ENABLE;
+		return PLANE_CTL_TILED_YF | PLANE_CTL_RENDER_DECOMPRESSION_ENABLE;
 	default:
 		MISSING_CASE(fb_modifier);
 	}
@@ -8812,13 +8812,13 @@ skylake_get_initial_plane_config(struct intel_crtc *crtc,
 		fb->modifier = I915_FORMAT_MOD_X_TILED;
 		break;
 	case PLANE_CTL_TILED_Y:
-		if (val & PLANE_CTL_DECOMPRESSION_ENABLE)
+		if (val & PLANE_CTL_RENDER_DECOMPRESSION_ENABLE)
 			fb->modifier = I915_FORMAT_MOD_Y_TILED_CCS;
 		else
 			fb->modifier = I915_FORMAT_MOD_Y_TILED;
 		break;
 	case PLANE_CTL_TILED_YF:
-		if (val & PLANE_CTL_DECOMPRESSION_ENABLE)
+		if (val & PLANE_CTL_RENDER_DECOMPRESSION_ENABLE)
 			fb->modifier = I915_FORMAT_MOD_Yf_TILED_CCS;
 		else
 			fb->modifier = I915_FORMAT_MOD_Yf_TILED;
-- 
2.20.1



