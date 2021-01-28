Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F47307A36
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 17:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhA1QBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 11:01:44 -0500
Received: from mga14.intel.com ([192.55.52.115]:49979 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhA1QBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 11:01:44 -0500
IronPort-SDR: PPUqFx85IbnRTHZTPrm9m66fZDr4KH9D/XoR0sOJO1s7HTpNl7tl5gMhjweYZlNLCSiXY4V1L6
 BxYz5AhnPESA==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="179474022"
X-IronPort-AV: E=Sophos;i="5.79,383,1602572400"; 
   d="scan'208";a="179474022"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 07:59:58 -0800
IronPort-SDR: /T2hFtUULmzkVkmJMV9j9+NbKcdPcBKVfUBmIQ9OHQDUwvOeRlKT93RuJAYLPPZXGUjYDiXjKM
 3R/xqeo3oo5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,383,1602572400"; 
   d="scan'208";a="369899951"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by orsmga002.jf.intel.com with SMTP; 28 Jan 2021 07:59:56 -0800
Received: by stinkbox (sSMTP sendmail emulation); Thu, 28 Jan 2021 17:59:55 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 3/5] drm/i915: Power up combo PHY lanes for for HDMI as well
Date:   Thu, 28 Jan 2021 17:59:46 +0200
Message-Id: <20210128155948.13678-3-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210128155948.13678-1-ville.syrjala@linux.intel.com>
References: <20210128155948.13678-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Currently we only explicitly power up the combo PHY lanes
for DP. The spec says we should do it for HDMI as well.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_ddi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 88cc6e2fbe91..8fbeb8c24efb 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -4337,6 +4337,8 @@ static void intel_enable_ddi_hdmi(struct intel_atomic_state *state,
 		intel_de_write(dev_priv, reg, val);
 	}
 
+	intel_ddi_power_up_lanes(encoder, crtc_state);
+
 	/* In HDMI/DVI mode, the port width, and swing/emphasis values
 	 * are ignored so nothing special needs to be done besides
 	 * enabling the port.
-- 
2.26.2

