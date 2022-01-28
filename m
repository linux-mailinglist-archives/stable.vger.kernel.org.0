Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009DD49F76F
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 11:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiA1Kib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 05:38:31 -0500
Received: from mga05.intel.com ([192.55.52.43]:23125 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbiA1Kia (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jan 2022 05:38:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643366310; x=1674902310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=udWskcxBD8KE9j2ASe+SCLg1Ex9DIrnidn92gZOSA/w=;
  b=kKagjTw3KuNekDKrQ51DelMa6eS5bnuqNcVHcj9axSmq/kJ7Ll3oZ8bl
   71PL9LV44OBmruWjseCxqRIrWcQvB6H3eyk2Czys3jcp3ngpbJtZeB2Wf
   Qm60bOzNr78dMyoDawuJ7nFsW0/eQyON+xyVGalQOA/RLv2vDPQxXBK7A
   SeZIxhQs2MBLG0rTRvgQrLEUcqtRZqIVEpW+l7GO1JBlp6HALW/9yxx1R
   5buTIYkJaknSCwTbanYBYrzYrhWaUuGAYkTTQ3yyFcU7aCM91Ty3gUCNf
   kJjBDyEwR6nObckLHoEaIK1a6iusUbd99Slv6nL+X6HLRasE2vhFH4lMX
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10240"; a="333449499"
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="333449499"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 02:38:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="496097680"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.147])
  by orsmga002.jf.intel.com with SMTP; 28 Jan 2022 02:38:28 -0800
Received: by stinkbox (sSMTP sendmail emulation); Fri, 28 Jan 2022 12:38:27 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2 10/17] drm/i915: Disable DRRS on IVB/HSW port != A
Date:   Fri, 28 Jan 2022 12:37:50 +0200
Message-Id: <20220128103757.22461-11-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128103757.22461-1-ville.syrjala@linux.intel.com>
References: <20220128103757.22461-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Currently we allow DRRS on IVB PCH ports, but we're missing a
few programming steps meaning it is guaranteed to not work.
And on HSW DRRS is not supported on anything but port A ever
as only transcoder EDP has the M2/N2 registers (though I'm
not sure if HSW ever has eDP on any other port).

Starting from BDW all transcoders have the dynamically
reprogrammable M/N registers so DRRS could work on any
port.

Stop initializing DRRS on ports where it cannot possibly work.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_drrs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_drrs.c b/drivers/gpu/drm/i915/display/intel_drrs.c
index 53f014b4436b..9f673255578e 100644
--- a/drivers/gpu/drm/i915/display/intel_drrs.c
+++ b/drivers/gpu/drm/i915/display/intel_drrs.c
@@ -413,6 +413,7 @@ intel_drrs_init(struct intel_connector *connector,
 		struct drm_display_mode *fixed_mode)
 {
 	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_encoder *encoder = connector->encoder;
 	struct drm_display_mode *downclock_mode = NULL;
 
 	INIT_DELAYED_WORK(&dev_priv->drrs.work, intel_drrs_downclock_work);
@@ -424,6 +425,13 @@ intel_drrs_init(struct intel_connector *connector,
 		return NULL;
 	}
 
+	if ((DISPLAY_VER(dev_priv) < 8 && !HAS_GMCH(dev_priv)) &&
+	    encoder->port != PORT_A) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "DRRS only supported on eDP port A\n");
+		return NULL;
+	}
+
 	if (dev_priv->vbt.drrs_type != SEAMLESS_DRRS_SUPPORT) {
 		drm_dbg_kms(&dev_priv->drm, "VBT doesn't support DRRS\n");
 		return NULL;
-- 
2.34.1

