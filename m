Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD274D36A1
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236919AbiCIRKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 12:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236522AbiCIRKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 12:10:08 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A791BD07B
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 09:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646845267; x=1678381267;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=18jOptX9AJomq02KK/2OdDLUl9eUNHpRHllctUUtTxc=;
  b=nkaOYDA4YV5ulHd/5P2xg6EH+7vobtm5nWNDrcADnE9Ni8kZoP1DIoxn
   5h3ltEebCM6J6/lKkTOqGQRUx7nj6EfpeQbY6k/ZprOVr/MZ/qp7jOmse
   56CkNPUiMZD8v/ICYCHM4D9vSndrFEAIekt6YO5qY7rmcSM/2WAwfL++S
   uTvSgIsPTtIzniRZCO0+BuQvdDUt4fI3RU+HJ16EYrihg4PNNLF3J8078
   HKrSSoSujFTbpua8ssFlZhZ3s/v0IDGudfcQN2zlATCngIHQbECnmQ4cm
   in+EWYutwnzlSQHP1ZCTLxRrIsCIVaayxg/7zjZRPijIjLV647AfocbGD
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="318254294"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="318254294"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 08:50:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="632667378"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by FMSMGA003.fm.intel.com with SMTP; 09 Mar 2022 08:50:09 -0800
Received: by stinkbox (sSMTP sendmail emulation); Wed, 09 Mar 2022 18:50:07 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Subject: [PATCH v2 6/8] drm/i915: Fix PSF GV point mask when SAGV is not possible
Date:   Wed,  9 Mar 2022 18:49:46 +0200
Message-Id: <20220309164948.10671-7-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309164948.10671-1-ville.syrjala@linux.intel.com>
References: <20220309164948.10671-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Don't just mask off all the PSF GV points when SAGV gets disabled.
This should in fact cause the Pcode to reject the request since
at least one PSF point must remain enabled at all times.

Cc: stable@vger.kernel.org
Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Fixes: 192fbfb76744 ("drm/i915: Implement PSF GV point support")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_bw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_bw.c b/drivers/gpu/drm/i915/display/intel_bw.c
index ad1564ca7269..adf58c58513b 100644
--- a/drivers/gpu/drm/i915/display/intel_bw.c
+++ b/drivers/gpu/drm/i915/display/intel_bw.c
@@ -992,7 +992,8 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
 	 * cause.
 	 */
 	if (!intel_can_enable_sagv(dev_priv, new_bw_state)) {
-		allowed_points = BIT(max_bw_point);
+		allowed_points &= ADLS_PSF_PT_MASK;
+		allowed_points |= BIT(max_bw_point);
 		drm_dbg_kms(&dev_priv->drm, "No SAGV, using single QGV point %d\n",
 			    max_bw_point);
 	}
-- 
2.34.1

