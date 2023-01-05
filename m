Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C4765E959
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 11:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbjAEKxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 05:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbjAEKxD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 05:53:03 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80BEDA9
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 02:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672915982; x=1704451982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=77H+p9hM0CpYhz0bz/uJfxUymsXFXlc7ObFruZqbV/c=;
  b=DYNSS4DW5c/fhRHy6y/Fws674+L+hLtVRx7GvKItvn3DoYfgRqb6rATm
   xzzhbff5XM67D/DxchmVGExIL2FVAkPkVfGuPWUrIyVR7Ub6FIf+MhWH+
   7apMBWPK3iGgzWXGTQxufwMtoKMPjISWZcbZXYzgseahIGmMWHNfs4z/E
   j3Dar1WqSCVu4ajMrJ7FwXKRX6OMpI25wfSxxyyodzW7KjZ+z7ftNsebK
   YERcBFeES3X8bo4sw3ih+fIvyYTQT+9N28fIwaVZFgBtjC8KPSTSFjW8L
   nl86c7EtpSKnIio8Bv84Xl64+Q0Ds7XBUHxuDD+ZJPujjHzVRpcxHSANr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="386607745"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="386607745"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 02:52:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="718793474"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="718793474"
Received: from swathish-mobl.ger.corp.intel.com (HELO localhost) ([10.252.10.152])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 02:52:41 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     stable@vger.kernel.org
Cc:     jani.nikula@intel.com,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [6.1 BACKPORT 2/2] drm/i915/dsi: fix MIPI_BKLT_EN_1 native GPIO index
Date:   Thu,  5 Jan 2023 12:52:27 +0200
Message-Id: <20230105105227.689222-3-jani.nikula@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230105105227.689222-1-jani.nikula@intel.com>
References: <20230105105227.689222-1-jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6217e9f05a74df48c77ee68993d587cdfdb1feb7 upstream.

Due to copy-paste fail, MIPI_BKLT_EN_1 would always use PPS index 1,
never 0. Fix the sloppiest commit in recent memory.

Fixes: 963bbdb32b47 ("drm/i915/dsi: add support for ICL+ native MIPI GPIO sequence")
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221220140105.313333-1-jani.nikula@intel.com
(cherry picked from commit a561933c571798868b5fa42198427a7e6df56c09)
Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
---
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
index e3e0cb4da491..f29e239bb27d 100644
--- a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
+++ b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
@@ -430,7 +430,7 @@ static void icl_native_gpio_set_value(struct drm_i915_private *dev_priv,
 		break;
 	case MIPI_BKLT_EN_1:
 	case MIPI_BKLT_EN_2:
-		index = gpio == MIPI_AVDD_EN_1 ? 0 : 1;
+		index = gpio == MIPI_BKLT_EN_1 ? 0 : 1;
 
 		intel_de_rmw(dev_priv, PP_CONTROL(index), EDP_BLC_ENABLE,
 			     value ? EDP_BLC_ENABLE : 0);
-- 
2.34.1

