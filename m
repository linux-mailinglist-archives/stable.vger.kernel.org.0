Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E266F6D9887
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 15:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbjDFNrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 09:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238761AbjDFNrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 09:47:19 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B526F6EAF
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 06:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680788838; x=1712324838;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rx6NRwCG3zzfbrT+I88OAD+AeQRS8XmAJrho0BU1D98=;
  b=FcyCVRKjU7p2q8j5kLzgXty7SUmwh1OrmM/KOqSZndrPBaCkkbd4/VDW
   nKq+QGwJAqW4PXz+icCgpAdh284smBN+Y0UgaHDMjQFbvXRJ79vKwpsNt
   uRCcr7WUC9Lb9fmf1cjkPNPUpzJmnUguMm5qW+zHXuv7Hg3upS0bElUhV
   ctcmXRM1YSAchicDajtlawwy3rQJn0XJq+7ixxpMrtD3U1jbQ8vRs4M1s
   GX94bNXQsEVgh50AmGYBUJjEVOtUnUkUN7a4e3Hf3scYfOD4C3Sa5d/fq
   pN5DUI0KlBrQSiysyveMTcOuDkBAbVBIhKBgpr2cfTF9TAfeasgbLnesR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="331372142"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="331372142"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 06:46:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="798328155"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="798328155"
Received: from unknown (HELO localhost) ([10.237.66.160])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 06:46:21 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@intel.com>,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        Manasi Navare <navaremanasi@google.com>,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] drm/dsc: fix drm_edp_dsc_sink_output_bpp() DPCD high byte usage
Date:   Thu,  6 Apr 2023 16:46:14 +0300
Message-Id: <20230406134615.1422509-1-jani.nikula@intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The operator precedence between << and & is wrong, leading to the high
byte being completely ignored. For example, with the 6.4 format, 32
becomes 0 and 24 becomes 8. Fix it, and remove the slightly confusing
and unnecessary DP_DSC_MAX_BITS_PER_PIXEL_HI_SHIFT macro while at it.

Fixes: 0575650077ea ("drm/dp: DRM DP helper/macros to get DP sink DSC parameters")
Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Cc: Manasi Navare <navaremanasi@google.com>
Cc: Anusha Srivatsa <anusha.srivatsa@intel.com>
Cc: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 include/drm/display/drm_dp.h        | 1 -
 include/drm/display/drm_dp_helper.h | 5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/drm/display/drm_dp.h b/include/drm/display/drm_dp.h
index 358db4a9f167..89d5a700b04d 100644
--- a/include/drm/display/drm_dp.h
+++ b/include/drm/display/drm_dp.h
@@ -286,7 +286,6 @@
 
 #define DP_DSC_MAX_BITS_PER_PIXEL_HI        0x068   /* eDP 1.4 */
 # define DP_DSC_MAX_BITS_PER_PIXEL_HI_MASK  (0x3 << 0)
-# define DP_DSC_MAX_BITS_PER_PIXEL_HI_SHIFT 8
 # define DP_DSC_MAX_BPP_DELTA_VERSION_MASK  0x06
 # define DP_DSC_MAX_BPP_DELTA_AVAILABILITY  0x08
 
diff --git a/include/drm/display/drm_dp_helper.h b/include/drm/display/drm_dp_helper.h
index 533d3ee7fe05..86f24a759268 100644
--- a/include/drm/display/drm_dp_helper.h
+++ b/include/drm/display/drm_dp_helper.h
@@ -181,9 +181,8 @@ static inline u16
 drm_edp_dsc_sink_output_bpp(const u8 dsc_dpcd[DP_DSC_RECEIVER_CAP_SIZE])
 {
 	return dsc_dpcd[DP_DSC_MAX_BITS_PER_PIXEL_LOW - DP_DSC_SUPPORT] |
-		(dsc_dpcd[DP_DSC_MAX_BITS_PER_PIXEL_HI - DP_DSC_SUPPORT] &
-		 DP_DSC_MAX_BITS_PER_PIXEL_HI_MASK <<
-		 DP_DSC_MAX_BITS_PER_PIXEL_HI_SHIFT);
+		((dsc_dpcd[DP_DSC_MAX_BITS_PER_PIXEL_HI - DP_DSC_SUPPORT] &
+		  DP_DSC_MAX_BITS_PER_PIXEL_HI_MASK) << 8);
 }
 
 static inline u32
-- 
2.39.2

