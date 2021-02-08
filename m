Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAC9313BE3
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 18:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBHR6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 12:58:03 -0500
Received: from mga03.intel.com ([134.134.136.65]:44379 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235117AbhBHRzf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 12:55:35 -0500
IronPort-SDR: Tipotbjdaq9Ortl0sFeU9F1dILnWZWT1Je4+AhSDI4hRXt92fOOgr7ORmg8Xp6+sgiLlnQ4gQ3
 4jkmkbmbi4MA==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="181819288"
X-IronPort-AV: E=Sophos;i="5.81,162,1610438400"; 
   d="scan'208";a="181819288"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 09:53:49 -0800
IronPort-SDR: 95UUo/tth85uM333HCKFkqaA2cRJKMKJNaSB94myeCwaaiyOp5Gdf1i+aBGxCqA5yCm3q+g48j
 WuBM8QmnLJGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,162,1610438400"; 
   d="scan'208";a="377878453"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by fmsmga008.fm.intel.com with SMTP; 08 Feb 2021 09:53:46 -0800
Received: by stinkbox (sSMTP sendmail emulation); Mon, 08 Feb 2021 19:53:45 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     gregkh@linuxfoundation.org
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Imre Deak <imre.deak@intel.com>
Subject: [PATCH stable-5.10 2/2] drm/i915: Skip vswing programming for TBT
Date:   Mon,  8 Feb 2021 19:53:41 +0200
Message-Id: <20210208175341.8695-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210208175341.8695-1-ville.syrjala@linux.intel.com>
References: <16127808794868@kroah.com>
 <20210208175341.8695-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit eaf5bfe37db871031232d2bf2535b6ca92afbad8 upstream.

In thunderbolt mode the PHY is owned by the thunderbolt controller.
We are not supposed to touch it. So skip the vswing programming
as well (we already skipped the other steps not applicable to TBT).

Touching this stuff could supposedly interfere with the PHY
programming done by the thunderbolt controller.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210128155948.13678-1-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit f8c6b615b921d8a1bcd74870f9105e62b0bceff3)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit eaf5bfe37db871031232d2bf2535b6ca92afbad8)
---
 drivers/gpu/drm/i915/display/intel_ddi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 51f4f4374dea..cdb19ec66890 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -2597,6 +2597,9 @@ static void icl_mg_phy_ddi_vswing_sequence(struct intel_encoder *encoder,
 	u32 n_entries, val;
 	int ln, rate = 0;
 
+	if (enc_to_dig_port(encoder)->tc_mode == TC_PORT_TBT_ALT)
+		return;
+
 	if (type != INTEL_OUTPUT_HDMI) {
 		struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 
@@ -2741,6 +2744,9 @@ tgl_dkl_phy_ddi_vswing_sequence(struct intel_encoder *encoder, int link_clock,
 	u32 n_entries, val, ln, dpcnt_mask, dpcnt_val;
 	int rate = 0;
 
+	if (enc_to_dig_port(encoder)->tc_mode == TC_PORT_TBT_ALT)
+		return;
+
 	if (type != INTEL_OUTPUT_HDMI) {
 		struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 
-- 
2.26.2

