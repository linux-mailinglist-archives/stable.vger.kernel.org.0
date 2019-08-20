Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1AD9664F
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 18:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfHTQ1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 12:27:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:30662 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbfHTQ1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 12:27:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 09:27:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,408,1559545200"; 
   d="scan'208";a="207417303"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga002.fm.intel.com with SMTP; 20 Aug 2019 09:16:58 -0700
Received: by stinkbox (sSMTP sendmail emulation); Tue, 20 Aug 2019 19:16:57 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        sunpeng.li@amd.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Paul <sean@poorly.run>
Subject: [PATCH] drm/i915: Do not create a new max_bpc prop for MST connectors
Date:   Tue, 20 Aug 2019 19:16:57 +0300
Message-Id: <20190820161657.9658-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

We're not allowed to create new properties after device registration
so for MST connectors we need to either create the max_bpc property
earlier, or we reuse one we already have. Let's do the latter apporach
since the corresponding SST connector already has the prop and its
min/max are correct also for the MST connector.

The problem was highlighted by commit 4f5368b5541a ("drm/kms:
Catch mode_object lifetime errors") which results in the following
spew:
[ 1330.878941] WARNING: CPU: 2 PID: 1554 at drivers/gpu/drm/drm_mode_object.c:45 __drm_mode_object_add+0xa0/0xb0 [drm]
...
[ 1330.879008] Call Trace:
[ 1330.879023]  drm_property_create+0xba/0x180 [drm]
[ 1330.879036]  drm_property_create_range+0x15/0x30 [drm]
[ 1330.879048]  drm_connector_attach_max_bpc_property+0x62/0x80 [drm]
[ 1330.879086]  intel_dp_add_mst_connector+0x11f/0x140 [i915]
[ 1330.879094]  drm_dp_add_port.isra.20+0x20b/0x440 [drm_kms_helper]
...

Cc: stable@vger.kernel.org
Cc: Lyude Paul <lyude@redhat.com>
Cc: sunpeng.li@amd.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sean Paul <sean@poorly.run>
Fixes: 5ca0ef8a56b8 ("drm/i915: Add max_bpc property for DP MST")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index 83faa246e361..9748581c1d62 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -536,7 +536,15 @@ static struct drm_connector *intel_dp_add_mst_connector(struct drm_dp_mst_topolo
 
 	intel_attach_force_audio_property(connector);
 	intel_attach_broadcast_rgb_property(connector);
-	drm_connector_attach_max_bpc_property(connector, 6, 12);
+
+	/*
+	 * Reuse the prop from the SST connector because we're
+	 * not allowed to create new props after device registration.
+	 */
+	connector->max_bpc_property =
+		intel_dp->attached_connector->base.max_bpc_property;
+	if (connector->max_bpc_property)
+		drm_connector_attach_max_bpc_property(connector, 6, 12);
 
 	return connector;
 
-- 
2.21.0

