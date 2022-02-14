Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60CF4B457C
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbiBNJSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:18:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242804AbiBNJSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:18:32 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52F3606ED
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 01:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644830305; x=1676366305;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VtGM7t8bP4Ig1udolijPIR5eXP0/XCLSHYL9fQGs8Vc=;
  b=dtHM965vXHJ9+tlj3mmoQmbkFdT4grKn6ijenMasKgwlN/tZ4N5zaiFE
   6xeXvkxPwountNGG+HBxuZpE0NOQdVHz9h8TypdVhCMAGcz/zAPYhuAGz
   mZZgvpffEb7IL3+/ab79663D66DiBkuZbH40exRqWjFYVdcIsj6a6BCz2
   naJGmFIhFLl16SCkIhOB1kAEK6MSNwI/8baORKcxzzRYN97fRpjG2h5dK
   pOUzduMjxbmF+mhVNzN9DurXUVE/l98D9/a/PhSyz9G92fQwPuzPXekAX
   0QjIt5S2nCNvS+fhHYF4o7Hz6w+SZQ/I1xIrLUJ4rnCEG3ijMwIqDaRvU
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="250255848"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="250255848"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 01:18:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="624070427"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by FMSMGA003.fm.intel.com with SMTP; 14 Feb 2022 01:18:22 -0800
Received: by stinkbox (sSMTP sendmail emulation); Mon, 14 Feb 2022 11:18:22 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Subject: [PATCH 3/6] drm/i915: Widen the QGV point mask
Date:   Mon, 14 Feb 2022 11:18:08 +0200
Message-Id: <20220214091811.13725-4-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214091811.13725-1-ville.syrjala@linux.intel.com>
References: <20220214091811.13725-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

adlp+ adds some extra bits to the QGV point mask. The code attempts
to handle that but forgot to actually make sure we can store those
bits in the bw state. Fix it.

Cc: stable@vger.kernel.org
Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Fixes: 192fbfb76744 ("drm/i915: Implement PSF GV point support")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_bw.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_bw.h b/drivers/gpu/drm/i915/display/intel_bw.h
index 46c6eecbd917..0ceaed1c9656 100644
--- a/drivers/gpu/drm/i915/display/intel_bw.h
+++ b/drivers/gpu/drm/i915/display/intel_bw.h
@@ -30,19 +30,19 @@ struct intel_bw_state {
 	 */
 	u8 pipe_sagv_reject;
 
+	/* bitmask of active pipes */
+	u8 active_pipes;
+
 	/*
 	 * Current QGV points mask, which restricts
 	 * some particular SAGV states, not to confuse
 	 * with pipe_sagv_mask.
 	 */
-	u8 qgv_points_mask;
+	u16 qgv_points_mask;
 
 	unsigned int data_rate[I915_MAX_PIPES];
 	u8 num_active_planes[I915_MAX_PIPES];
 
-	/* bitmask of active pipes */
-	u8 active_pipes;
-
 	int min_cdclk;
 };
 
-- 
2.34.1

