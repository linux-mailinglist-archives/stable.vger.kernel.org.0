Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16F0197F79
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 17:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgC3PWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 11:22:47 -0400
Received: from mga12.intel.com ([192.55.52.136]:3777 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728926AbgC3PWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 11:22:47 -0400
IronPort-SDR: 4z+ijVWFfz5HK/UuwwDMlXCpq+aJ/jvL5BU33E1/9Vj6W7FyuXox1pBpMPDtIeBZxmksHY5zj9
 V/AR9PKxeg7w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 08:22:48 -0700
IronPort-SDR: VPsHJZfrK7HppLj1wlNQEaTO2HIfOiOdtz+dyMZJjicCB9DfuV2IOxCItKP6sT2BP3gQg8PWkm
 MATqeatPWQcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,324,1580803200"; 
   d="scan'208";a="248733724"
Received: from ideak-desk.fi.intel.com ([10.237.72.183])
  by orsmga003.jf.intel.com with ESMTP; 30 Mar 2020 08:22:45 -0700
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] drm/i915/icl+: Don't enable DDI IO power on a TypeC port in TBT mode
Date:   Mon, 30 Mar 2020 18:22:44 +0300
Message-Id: <20200330152244.11316-1-imre.deak@intel.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The DDI IO power well must not be enabled for a TypeC port in TBT mode,
ensure this during driver loading/system resume.

This gets rid of error messages like
[drm] *ERROR* power well DDI E TC2 IO state mismatch (refcount 1/enabled 0)

and avoids leaking the power ref when disabling the output.

Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/display/intel_ddi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 916a802af788..654151d9a6db 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -1899,7 +1899,11 @@ static void intel_ddi_get_power_domains(struct intel_encoder *encoder,
 		return;
 
 	dig_port = enc_to_dig_port(encoder);
-	intel_display_power_get(dev_priv, dig_port->ddi_io_power_domain);
+
+	if (!intel_phy_is_tc(dev_priv, phy) ||
+	    dig_port->tc_mode != TC_PORT_TBT_ALT)
+		intel_display_power_get(dev_priv,
+					dig_port->ddi_io_power_domain);
 
 	/*
 	 * AUX power is only needed for (e)DP mode, and for HDMI mode on TC
-- 
2.23.1

