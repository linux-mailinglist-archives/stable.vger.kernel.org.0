Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51492407B5
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 16:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgHJOk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 10:40:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:57952 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbgHJOk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 10:40:59 -0400
IronPort-SDR: 3J1Gr4VbcBK8FJGC/Zu7k8hQvWg2pM5E0n7r+YCY6dwpactcfe13VNOscaK9pVP4+AeqdMeu8s
 FTMhomecRmWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9708"; a="153510530"
X-IronPort-AV: E=Sophos;i="5.75,457,1589266800"; 
   d="scan'208";a="153510530"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 07:40:58 -0700
IronPort-SDR: t+mAzmVMJRSTGHhtrmZTpLdSx8iQucC1cwsH6QVxI/Gtzypg1rA5OhFJrwZPtIyHki0ojKHGek
 s1ABaMZ7HWQA==
X-IronPort-AV: E=Sophos;i="5.75,457,1589266800"; 
   d="scan'208";a="469066255"
Received: from unknown (HELO linux-desktop.iind.intel.com) ([10.223.34.173])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 07:40:55 -0700
From:   Uma Shankar <uma.shankar@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     alex.zuo@intel.com, Abhishek Kumar <abhishek4.kumar@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        stable@vger.kernel.org, Uma Shankar <uma.shankar@intel.com>
Subject: [PATCH] drm/i915/display: Fix NV12 sub plane atomic state
Date:   Mon, 10 Aug 2020 20:46:02 +0530
Message-Id: <20200810151602.20757-1-uma.shankar@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhishek Kumar <abhishek4.kumar@intel.com>

For NV12 display sub plane is also configured and drivers internally
create plane atomic state. Driver copies all of the param of main
plane atomic state to sub planer atomic state but in sub plane
atomic state crtc is not added ,so when drm atomic state is configured
for commit ,fake commit handler is created for sub plane and also
state is not cleared when NV12 buffer is not displayed.

Fixes: 1f594b209fe1 ("drm/i915: Remove special case slave handling during hw programming")
Change-Id: I447b16bf433dfb5b43b2e4cade258fc775aee065
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Abhishek Kumar <abhishek4.kumar@intel.com>
Signed-off-by: Uma Shankar <uma.shankar@intel.com>
---
 drivers/gpu/drm/i915/display/intel_display.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 522c772a2111..76da2189b01d 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -12502,6 +12502,7 @@ static int icl_check_nv12_planes(struct intel_crtc_state *crtc_state)
 	struct intel_atomic_state *state = to_intel_atomic_state(crtc_state->uapi.state);
 	struct intel_plane *plane, *linked;
 	struct intel_plane_state *plane_state;
+	int ret;
 	int i;
 
 	if (INTEL_GEN(dev_priv) < 11)
@@ -12576,6 +12577,11 @@ static int icl_check_nv12_planes(struct intel_crtc_state *crtc_state)
 		linked_state->uapi.src = plane_state->uapi.src;
 		linked_state->uapi.dst = plane_state->uapi.dst;
 
+		/* Update Linked plane crtc same as of main plane */
+		ret = drm_atomic_set_crtc_for_plane(&linked_state->uapi, plane_state->uapi.crtc);
+		if(ret)
+			return ret;
+
 		if (icl_is_hdr_plane(dev_priv, plane->id)) {
 			if (linked->id == PLANE_SPRITE5)
 				plane_state->cus_ctl |= PLANE_CUS_PLANE_7;
-- 
2.26.2

