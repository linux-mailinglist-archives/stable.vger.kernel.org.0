Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928B42C8114
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 10:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgK3Jbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 04:31:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:8324 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbgK3Jbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Nov 2020 04:31:43 -0500
IronPort-SDR: t+A4pj+ljBBdPCs6p7hJHcG5aNWJsWmgA3mo6IVtOYAPUDGKU6VcCYoZjlR6XdNVO1jOKRxhlj
 WywPHTB6bXig==
X-IronPort-AV: E=McAfee;i="6000,8403,9820"; a="190787003"
X-IronPort-AV: E=Sophos;i="5.78,381,1599548400"; 
   d="scan'208";a="190787003"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 01:31:02 -0800
IronPort-SDR: Z7GgltN4bb+GBVtJQwqzig3y8rLTrTDXFS6XMmtzqvz+3dRAzVQqWBLEGq+QqIu1iIF4KCd/r+
 VrlOmgIcJ9QA==
X-IronPort-AV: E=Sophos;i="5.78,381,1599548400"; 
   d="scan'208";a="367055058"
Received: from genxfsim-desktop.iind.intel.com ([10.223.74.178])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 01:31:00 -0800
From:   Anshuman Gupta <anshuman.gupta@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     imre.deak@intel.com, ville.syrjala@linux.intel.com,
        Anshuman Gupta <anshuman.gupta@intel.com>,
        stable@vger.kernel.org
Subject: [RFC 2/2] drm/i915/display: Protect pipe_update against dc3co exit
Date:   Mon, 30 Nov 2020 14:46:46 +0530
Message-Id: <20201130091646.25576-3-anshuman.gupta@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201130091646.25576-1-anshuman.gupta@intel.com>
References: <20201130091646.25576-1-anshuman.gupta@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

At usual case DC3CO exit happen automatically by DMC f/w whenever
PSR2 clears idle. This happens smoothly by DMC f/w to work with flips.
But there are certain scenario where DC3CO  Disallowed by driver
asynchronous with flips. In such scenario display engine could
be already in DC3CO state and driver has disallowed it,
It initiates DC3CO exit sequence in DMC f/w which requires a
dc3co exit delay of 200us in driver.
It requires to protect intel_pipe_update_{update_end} with
dc3co exit delay.

Cc: Imre Deak <imre.deak@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
---
 drivers/gpu/drm/i915/display/intel_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index ba26545392bc..3b81b98c0daf 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -15924,6 +15924,8 @@ static void intel_update_crtc(struct intel_atomic_state *state,
 	else
 		intel_fbc_enable(state, crtc);
 
+	/* Protect intel_pipe_update_{start,end} with power_domians lock */
+	mutex_lock(&dev_priv->power_domains.lock);
 	/* Perform vblank evasion around commit operation */
 	intel_pipe_update_start(new_crtc_state);
 
@@ -15935,6 +15937,7 @@ static void intel_update_crtc(struct intel_atomic_state *state,
 		i9xx_update_planes_on_crtc(state, crtc);
 
 	intel_pipe_update_end(new_crtc_state);
+	mutex_unlock(&dev_prive->power_domains.lock);
 
 	/*
 	 * We usually enable FIFO underrun interrupts as part of the
-- 
2.26.2

