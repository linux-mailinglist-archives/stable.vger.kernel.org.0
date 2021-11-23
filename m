Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8743F45A1AA
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 12:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhKWLmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:42:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233037AbhKWLmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 06:42:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1854A60240;
        Tue, 23 Nov 2021 11:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637667584;
        bh=EBL6v5kVcIla3YEPhlRQhSkw0xfkaxDRona2iJPMUn4=;
        h=Subject:To:Cc:From:Date:From;
        b=scILhHGnewsDhMR+7wuaRFPVzhibwqhGb45MfIIuJ3gfqxHYTQmPGFlfnK8vyEQnQ
         ciK2L0OU9spO0PQDBI6eRo4C7NVadiuYdHfn8f5xn69xy5pnDUFmQeLGWO2pDUsmv5
         kv1cc4/Z66B6/CnAeHxH7sHi55yV/d33/GL141MU=
Subject: FAILED: patch "[PATCH] drm/i915/dp: Drop redundant debug print" failed to apply to 5.15-stable tree
To:     swati2.sharma@intel.com, ankit.k.nautiyal@intel.com,
        imre.deak@intel.com, jani.nikula@intel.com, jose.souza@intel.com,
        manasi.d.navare@intel.com, seanpaul@chromium.org,
        stable@vger.kernel.org, uma.shankar@intel.com,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Nov 2021 12:39:42 +0100
Message-ID: <1637667582113189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b6dfa416172939edaa46a5a647457b94c6d94119 Mon Sep 17 00:00:00 2001
From: Swati Sharma <swati2.sharma@intel.com>
Date: Thu, 12 Aug 2021 18:41:07 +0530
Subject: [PATCH] drm/i915/dp: Drop redundant debug print
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

drm_dp_dpcd_read/write already has debug error message.
Drop redundant error messages which gives false
status even if correct value is read in drm_dp_dpcd_read().

v2: -Added fixes tag (Ankit)
v3: -Fixed build error (CI)

Fixes: 9488a030ac91 ("drm/i915: Add support for enabling link status and recovery")
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: Manasi Navare <manasi.d.navare@intel.com>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Uma Shankar <uma.shankar@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.12+
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Swati Sharma <swati2.sharma@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210812131107.5531-1-swati2.sharma@intel.com

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 7e5d9b959c1d..fd4f7e82e420 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3917,23 +3917,18 @@ static void intel_dp_check_device_service_irq(struct intel_dp *intel_dp)
 
 static void intel_dp_check_link_service_irq(struct intel_dp *intel_dp)
 {
-	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
 	u8 val;
 
 	if (intel_dp->dpcd[DP_DPCD_REV] < 0x11)
 		return;
 
 	if (drm_dp_dpcd_readb(&intel_dp->aux,
-			      DP_LINK_SERVICE_IRQ_VECTOR_ESI0, &val) != 1 || !val) {
-		drm_dbg_kms(&i915->drm, "Error in reading link service irq vector\n");
+			      DP_LINK_SERVICE_IRQ_VECTOR_ESI0, &val) != 1 || !val)
 		return;
-	}
 
 	if (drm_dp_dpcd_writeb(&intel_dp->aux,
-			       DP_LINK_SERVICE_IRQ_VECTOR_ESI0, val) != 1) {
-		drm_dbg_kms(&i915->drm, "Error in writing link service irq vector\n");
+			       DP_LINK_SERVICE_IRQ_VECTOR_ESI0, val) != 1)
 		return;
-	}
 
 	if (val & HDMI_LINK_STATUS_CHANGED)
 		intel_dp_handle_hdmi_link_status_change(intel_dp);

