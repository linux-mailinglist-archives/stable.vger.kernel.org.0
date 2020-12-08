Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D9C2D3647
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 23:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbgLHW3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 17:29:48 -0500
Received: from mga14.intel.com ([192.55.52.115]:20442 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729429AbgLHW3s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 17:29:48 -0500
IronPort-SDR: lBHkZvdf7d40cJVKCXy9YFaSI3zdv/UW9oSDarj+nLS1eOOMeNCKXKbE1WopDhKwP4nY3Sq1Wp
 q4N04lsHw5rA==
X-IronPort-AV: E=McAfee;i="6000,8403,9829"; a="173219818"
X-IronPort-AV: E=Sophos;i="5.78,404,1599548400"; 
   d="scan'208";a="173219818"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2020 14:29:07 -0800
IronPort-SDR: f8MYwESe+vLPVFvik/oLGE2gyPiVJBYjZKP+GPUT4KWaJ/CefC/mbgzNi3jfwE6GU4A33oLG3m
 9vtb0biHjOeQ==
X-IronPort-AV: E=Sophos;i="5.78,404,1599548400"; 
   d="scan'208";a="363846381"
Received: from labuser-z97x-ud5h.jf.intel.com ([10.165.21.211])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 08 Dec 2020 14:29:06 -0800
From:   Manasi Navare <manasi.d.navare@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     Manasi Navare <manasi.d.navare@intel.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Jani Nikula <jani.nikula@intel.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] drm/i915/display/dp: Compute the correct slice count for VDSC on DP
Date:   Tue,  8 Dec 2020 14:32:10 -0800
Message-Id: <20201208223210.19635-3-manasi.d.navare@intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20201208223210.19635-1-manasi.d.navare@intel.com>
References: <20201208223210.19635-1-manasi.d.navare@intel.com>
MIME-Version: 1.0
X-Git-Pile: INTEL_DII
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes the slice count computation algorithm
for calculating the slice count based on Peak pixel rate
and the max slice width allowed on the DSC engines.
We need to ensure slice count > min slice count req
as per DP spec based on peak pixel rate and that it is
greater than min slice count based on the max slice width
advertised by DPCD. So use max of these two.
In the prev patch we were using min of these 2 causing it
to violate the max slice width limitation causing a blank
screen on 8K@60.

Fixes: d9218c8f6cf4 ("drm/i915/dp: Add helpers for Compressed BPP and Slice Count for DSC")
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Manasi Navare <manasi.d.navare@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201204205804.25225-1-manasi.d.navare@intel.com
(cherry picked from commit d371d6ea92ad2a47f42bbcaa786ee5f6069c9c14)
---
 drivers/gpu/drm/i915/display/intel_dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 3896d08c4177..2165398d2c7c 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -615,7 +615,7 @@ static u8 intel_dp_dsc_get_slice_count(struct intel_dp *intel_dp,
 		return 0;
 	}
 	/* Also take into account max slice width */
-	min_slice_count = min_t(u8, min_slice_count,
+	min_slice_count = max_t(u8, min_slice_count,
 				DIV_ROUND_UP(mode_hdisplay,
 					     max_slice_width));
 
