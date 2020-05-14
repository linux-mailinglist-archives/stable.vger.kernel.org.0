Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98C51D3F1F
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 22:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgENUp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 16:45:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:2770 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgENUp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 16:45:56 -0400
IronPort-SDR: BAlUGSzZnahn6LbNVAwrrSZWBB+ZdN+lLRolgBn9C2gAj88tchXNaa8QwUoTsiZbBu8E3PyIK/
 2/khvELY+bmA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 13:45:56 -0700
IronPort-SDR: V2gkJwqO96B3/euocKJzvykJ3utWvE2YpnZWcQaQVHY3OHnaX3F9TTVBM+14/Qc8Wk3b8PWfXu
 1EZ4CTpJk6Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,392,1583222400"; 
   d="scan'208";a="262965276"
Received: from ideak-desk.fi.intel.com ([10.237.72.183])
  by orsmga003.jf.intel.com with ESMTP; 14 May 2020 13:45:55 -0700
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] drm/i915: Fix AUX power domain toggling across TypeC mode resets
Date:   Thu, 14 May 2020 23:45:53 +0300
Message-Id: <20200514204553.27193-1-imre.deak@intel.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to select the port's AUX power domain while holding the TC
port lock. The domain depends on the port's current TC mode, which may
get changed under us if we're not holding the lock.

This was left out from
commit 8c10e2262663 ("drm/i915: Keep the TypeC port mode fixed for detect/AUX transfers")

Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 408c3c1c5e81..40d42dcff0b7 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1359,8 +1359,7 @@ intel_dp_aux_xfer(struct intel_dp *intel_dp,
 	bool is_tc_port = intel_phy_is_tc(i915, phy);
 	i915_reg_t ch_ctl, ch_data[5];
 	u32 aux_clock_divider;
-	enum intel_display_power_domain aux_domain =
-		intel_aux_power_domain(intel_dig_port);
+	enum intel_display_power_domain aux_domain;
 	intel_wakeref_t aux_wakeref;
 	intel_wakeref_t pps_wakeref;
 	int i, ret, recv_bytes;
@@ -1375,6 +1374,8 @@ intel_dp_aux_xfer(struct intel_dp *intel_dp,
 	if (is_tc_port)
 		intel_tc_port_lock(intel_dig_port);
 
+	aux_domain = intel_aux_power_domain(intel_dig_port);
+
 	aux_wakeref = intel_display_power_get(i915, aux_domain);
 	pps_wakeref = pps_lock(intel_dp);
 
-- 
2.23.1

