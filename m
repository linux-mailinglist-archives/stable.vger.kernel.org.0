Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DC4307A35
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 17:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhA1QBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 11:01:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:49716 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhA1QBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 11:01:41 -0500
IronPort-SDR: ViqkLdDt7ZAJoAmWc2+2T3n8Z6xq0P6nY8NIzulmwb0mJW4DNPOp/fDQwkgoc4zo54+zCpmkOe
 DjFUkmL//ToQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="167353453"
X-IronPort-AV: E=Sophos;i="5.79,383,1602572400"; 
   d="scan'208";a="167353453"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 07:59:51 -0800
IronPort-SDR: 4JR5+uxG10lAThBUWYr3Xr0P17KUjyEANVgtYHnap6gZKVVL+2UeYWLjv4gxTrJ18Op9klMQgL
 C/St54nZGi8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,383,1602572400"; 
   d="scan'208";a="430563176"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by orsmga001.jf.intel.com with SMTP; 28 Jan 2021 07:59:50 -0800
Received: by stinkbox (sSMTP sendmail emulation); Thu, 28 Jan 2021 17:59:48 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/5] drm/i915: Skip vswing programming for TBT
Date:   Thu, 28 Jan 2021 17:59:44 +0200
Message-Id: <20210128155948.13678-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

In thunderbolt mode the PHY is owned by the thunderbolt controller.
We are not supposed to touch it. So skip the vswing programming
as well (we already skipped the other steps not applicable to TBT).

Touching this stuff could supposedly interfere with the PHY
programming done by the thunderbolt controller.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_ddi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 9506b8048530..c94650488dc1 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -2827,6 +2827,9 @@ static void icl_mg_phy_ddi_vswing_sequence(struct intel_encoder *encoder,
 	int n_entries, ln;
 	u32 val;
 
+	if (enc_to_dig_port(encoder)->tc_mode == TC_PORT_TBT_ALT)
+		return;
+
 	ddi_translations = icl_get_mg_buf_trans(encoder, crtc_state, &n_entries);
 
 	if (drm_WARN_ON_ONCE(&dev_priv->drm, !ddi_translations))
@@ -2962,6 +2965,9 @@ tgl_dkl_phy_ddi_vswing_sequence(struct intel_encoder *encoder,
 	u32 val, dpcnt_mask, dpcnt_val;
 	int n_entries, ln;
 
+	if (enc_to_dig_port(encoder)->tc_mode == TC_PORT_TBT_ALT)
+		return;
+
 	ddi_translations = tgl_get_dkl_buf_trans(encoder, crtc_state, &n_entries);
 
 	if (drm_WARN_ON_ONCE(&dev_priv->drm, !ddi_translations))
-- 
2.26.2

