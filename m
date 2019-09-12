Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF93B0F5B
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 15:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731545AbfILNBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 09:01:14 -0400
Received: from mblankhorst.nl ([141.105.120.124]:43432 "EHLO mblankhorst.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730454AbfILNBN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Sep 2019 09:01:13 -0400
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
To:     intel-gfx-trybot@lists.freedesktop.org
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        stable@vger.kernel.org, Manasi Navare <manasi.d.navare@intel.com>
Subject: [PATCH 01/23] drm/i915/dp: Fix dsc bpp calculations.
Date:   Thu, 12 Sep 2019 15:00:47 +0200
Message-Id: <20190912130109.5873-1-maarten.lankhorst@linux.intel.com>
X-Mailer: git-send-email 2.20.1
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
 drivers/gpu/drm/i915/display/intel_dp.c | 20 +++++++++++---------
 drivers/gpu/drm/i915/display/intel_dp.h |  4 ++--
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index d09133a958e1..a7e392f8adeb 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -4363,10 +4363,10 @@ intel_dp_get_sink_irq_esi(struct intel_dp *intel_dp, u8 *sink_irq_vector)
 		DP_DPRX_ESI_LEN;
 }
 
-u16 intel_dp_dsc_get_output_bpp(int link_clock, u8 lane_count,
-				int mode_clock, int mode_hdisplay)
+u16 intel_dp_dsc_get_output_bpp(u32 link_clock, u32 lane_count,
+				u32 mode_clock, u32 mode_hdisplay)
 {
-	u16 bits_per_pixel, max_bpp_small_joiner_ram;
+	u32 bits_per_pixel, max_bpp_small_joiner_ram;
 	int i;
 
 	/*
@@ -4375,13 +4375,14 @@ u16 intel_dp_dsc_get_output_bpp(int link_clock, u8 lane_count,
 	 * FECOverhead = 2.4%, for SST -> TimeSlotsPerMTP is 1,
 	 * for MST -> TimeSlotsPerMTP has to be calculated
 	 */
-	bits_per_pixel = (link_clock * lane_count * 8 *
-			  DP_DSC_FEC_OVERHEAD_FACTOR) /
-		mode_clock;
+	bits_per_pixel =
+		mul_u32_u32(link_clock, lane_count * 8 * DP_DSC_FEC_OVERHEAD_FACTOR) /
+		mul_u32_u32(1000ULL, mode_clock);
+	DRM_DEBUG_KMS("Max link bpp: %u\n", bits_per_pixel);
 
 	/* Small Joiner Check: output bpp <= joiner RAM (bits) / Horiz. width */
-	max_bpp_small_joiner_ram = DP_DSC_MAX_SMALL_JOINER_RAM_BUFFER /
-		mode_hdisplay;
+	max_bpp_small_joiner_ram = DP_DSC_MAX_SMALL_JOINER_RAM_BUFFER / mode_hdisplay;
+	DRM_DEBUG_KMS("Max small joiner bpp: %u\n", max_bpp_small_joiner_ram);
 
 	/*
 	 * Greatest allowed DSC BPP = MIN (output BPP from avaialble Link BW
@@ -4391,7 +4392,8 @@ u16 intel_dp_dsc_get_output_bpp(int link_clock, u8 lane_count,
 
 	/* Error out if the max bpp is less than smallest allowed valid bpp */
 	if (bits_per_pixel < valid_dsc_bpp[0]) {
-		DRM_DEBUG_KMS("Unsupported BPP %d\n", bits_per_pixel);
+		DRM_DEBUG_KMS("Unsupported BPP %u, min %u\n",
+			      bits_per_pixel, valid_dsc_bpp[0]);
 		return 0;
 	}
 
diff --git a/drivers/gpu/drm/i915/display/intel_dp.h b/drivers/gpu/drm/i915/display/intel_dp.h
index e01d1f89409d..586dc9336d63 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.h
+++ b/drivers/gpu/drm/i915/display/intel_dp.h
@@ -103,8 +103,8 @@ bool intel_dp_source_supports_hbr2(struct intel_dp *intel_dp);
 bool intel_dp_source_supports_hbr3(struct intel_dp *intel_dp);
 bool
 intel_dp_get_link_status(struct intel_dp *intel_dp, u8 *link_status);
-u16 intel_dp_dsc_get_output_bpp(int link_clock, u8 lane_count,
-				int mode_clock, int mode_hdisplay);
+u16 intel_dp_dsc_get_output_bpp(u32 link_clock, u32 lane_count,
+				u32 mode_clock, u32 mode_hdisplay);
 u8 intel_dp_dsc_get_slice_count(struct intel_dp *intel_dp, int mode_clock,
 				int mode_hdisplay);
 
-- 
2.20.1

