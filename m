Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23A8A15BF12
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 14:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbgBMNUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 08:20:53 -0500
Received: from mga18.intel.com ([134.134.136.126]:53469 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbgBMNUx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 08:20:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2020 05:20:52 -0800
X-IronPort-AV: E=Sophos;i="5.70,436,1574150400"; 
   d="scan'208";a="227230281"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.161])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2020 05:20:49 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     jani.nikula@intel.com, Manasi Navare <manasi.d.navare@intel.com>,
        Vandita Kulkarni <vandita.kulkarni@intel.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/dsc: force full modeset whenever DSC is enabled at probe
Date:   Thu, 13 Feb 2020 15:20:45 +0200
Message-Id: <20200213132045.6631-1-jani.nikula@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We lack full state readout of DSC config, which may lead to DSC enable
using a config that's all zeros, failing spectacularly. Force full
modeset and thus compute config at probe to get a sane state, until we
implement DSC state readout. Any fastset that did appear to work with
DSC at probe, worked by coincidence. [1] is an example of a change that
triggered the issue on TGL DSI DSC.

[1] http://patchwork.freedesktop.org/patch/msgid/20200212150102.7600-1-ville.syrjala@linux.intel.com

Cc: Manasi Navare <manasi.d.navare@intel.com>
Cc: Vandita Kulkarni <vandita.kulkarni@intel.com>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/display/intel_display.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index e09d3c93c52b..c1c392e2e8c3 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -17835,6 +17835,24 @@ static int intel_initial_commit(struct drm_device *dev)
 			 * have readout for pipe gamma enable.
 			 */
 			crtc_state->uapi.color_mgmt_changed = true;
+
+			/*
+			 * FIXME hack to force full modeset when DSC is being
+			 * used.
+			 *
+			 * As long as we do not have full state readout and
+			 * config comparison of crtc_state->dsc, we have no way
+			 * to ensure reliable fastset. Remove once we have
+			 * readout for DSC.
+			 */
+			if (crtc_state->dsc.compression_enable) {
+				ret = drm_atomic_add_affected_connectors(state,
+									 &crtc->base);
+				if (ret)
+					goto out;
+				crtc_state->uapi.mode_changed = true;
+				drm_dbg_kms(dev, "Force full modeset for DSC\n");
+			}
 		}
 	}
 
-- 
2.20.1

