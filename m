Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3084C97AE8
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 15:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbfHUNcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 09:32:24 -0400
Received: from mblankhorst.nl ([141.105.120.124]:59348 "EHLO mblankhorst.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbfHUNcY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Aug 2019 09:32:24 -0400
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        stable@vger.kernel.org, Manasi Navare <manasi.d.navare@intel.com>
Subject: [PATCH 01/10] drm/i915/dp: Fix dsc bpp calculations.
Date:   Wed, 21 Aug 2019 15:32:12 +0200
Message-Id: <20190821133221.29456-2-maarten.lankhorst@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190821133221.29456-1-maarten.lankhorst@linux.intel.com>
References: <20190821133221.29456-1-maarten.lankhorst@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There was a integer wraparound when mode_clock became too high,
and we didn't correct for the FEC overhead factor when dividing,
also the calculations would break at HBR3.

As a result our calculated bpp was way too high, and the link width
bpp limitation never came into effect.

Print out the resulting bpp calcululations as a sanity check, just
in case we ever have to debug it later on again.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Fixes: d9218c8f6cf4 ("drm/i915/dp: Add helpers for Compressed BPP and Slice Count for DSC")
Cc: <stable@vger.kernel.org> # v5.0+
Cc: Manasi Navare <manasi.d.navare@intel.com>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 16 +++++++++-------
 drivers/gpu/drm/i915/display/intel_dp.h |  4 ++--
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 921ad0a2f7ba..614a25911f07 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -4323,10 +4323,10 @@ intel_dp_get_sink_irq_esi(struct intel_dp *intel_dp, u8 *sink_irq_vector)
 		DP_DPRX_ESI_LEN;
 }
 
-u16 intel_dp_dsc_get_output_bpp(int link_clock, u8 lane_count,
-				int mode_clock, int mode_hdisplay)
+u16 intel_dp_dsc_get_output_bpp(u32 link_clock, u8 lane_count,
+				u32 mode_clock, u32 mode_hdisplay)
 {
-	u16 bits_per_pixel, max_bpp_small_joiner_ram;
+	u32 bits_per_pixel, max_bpp_small_joiner_ram;
 	int i;
 
 	/*
@@ -4335,13 +4335,14 @@ u16 intel_dp_dsc_get_output_bpp(int link_clock, u8 lane_count,
 	 * FECOverhead = 2.4%, for SST -> TimeSlotsPerMTP is 1,
 	 * for MST -> TimeSlotsPerMTP has to be calculated
 	 */
-	bits_per_pixel = (link_clock * lane_count * 8 *
-			  DP_DSC_FEC_OVERHEAD_FACTOR) /
-		mode_clock;
+	bits_per_pixel = div_u64((u64)link_clock * lane_count * 8 *
+				 DP_DSC_FEC_OVERHEAD_FACTOR, 1000ULL * mode_clock);
+	DRM_DEBUG_KMS("Max link bpp: %u\n", bits_per_pixel);
 
 	/* Small Joiner Check: output bpp <= joiner RAM (bits) / Horiz. width */
 	max_bpp_small_joiner_ram = DP_DSC_MAX_SMALL_JOINER_RAM_BUFFER /
 		mode_hdisplay;
+	DRM_DEBUG_KMS("Max small joiner bpp: %u\n", max_bpp_small_joiner_ram);
 
 	/*
 	 * Greatest allowed DSC BPP = MIN (output BPP from avaialble Link BW
@@ -4351,7 +4352,8 @@ u16 intel_dp_dsc_get_output_bpp(int link_clock, u8 lane_count,
 
 	/* Error out if the max bpp is less than smallest allowed valid bpp */
 	if (bits_per_pixel < valid_dsc_bpp[0]) {
-		DRM_DEBUG_KMS("Unsupported BPP %d\n", bits_per_pixel);
+		DRM_DEBUG_KMS("Unsupported BPP %u, min %u\n",
+			      bits_per_pixel, valid_dsc_bpp[0]);
 		return 0;
 	}
 
diff --git a/drivers/gpu/drm/i915/display/intel_dp.h b/drivers/gpu/drm/i915/display/intel_dp.h
index 657bbb1f5ed0..007d1981a33b 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.h
+++ b/drivers/gpu/drm/i915/display/intel_dp.h
@@ -102,8 +102,8 @@ bool intel_dp_source_supports_hbr2(struct intel_dp *intel_dp);
 bool intel_dp_source_supports_hbr3(struct intel_dp *intel_dp);
 bool
 intel_dp_get_link_status(struct intel_dp *intel_dp, u8 *link_status);
-u16 intel_dp_dsc_get_output_bpp(int link_clock, u8 lane_count,
-				int mode_clock, int mode_hdisplay);
+u16 intel_dp_dsc_get_output_bpp(u32 link_clock, u8 lane_count,
+				u32 mode_clock, u32 mode_hdisplay);
 u8 intel_dp_dsc_get_slice_count(struct intel_dp *intel_dp, int mode_clock,
 				int mode_hdisplay);
 
-- 
2.20.1

