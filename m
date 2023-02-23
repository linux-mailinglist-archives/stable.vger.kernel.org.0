Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C624A6A0CBC
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 16:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbjBWPUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 10:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjBWPUw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 10:20:52 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028F5570A4
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 07:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677165651; x=1708701651;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=C7J9mfPQ99h+PpWIb0r1Q/aPVGAydtpIwJaOLnrMRdo=;
  b=O0JlS0+LYUaCZy45kpoXm9jVf3Y4S2iuavIaXIzebkeKe0w9/y+32Nrd
   s/IQXuXeiptMP/bLhRy2NMg9Eje6DoQKvLwm5+9KoqB969ehAr9+lS+IR
   Mq0jBRq6VGrdjrN4Mit9aYZObLp2go4JROEImSQqLlTjoNYiXZNmCTpHp
   YSNCaIC+TNiEphgk9KfFqnrYt/2G6aC/PVOXuAD/y25EzbUF/3zl+4NF1
   n7skeVSOOhqh9ZrfzFCKeG7ZYTyIuUz1xm+u38BO7v7LM8IVxoNjv2llg
   iBT4/Cay16SVifDanqsSMpJY5CfhJJq759l4Qed0fhZFUyIn4OLqFZfOr
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="360729626"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="360729626"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 07:20:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="674563911"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="674563911"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.70])
  by fmsmga007.fm.intel.com with SMTP; 23 Feb 2023 07:20:49 -0800
Received: by stinkbox (sSMTP sendmail emulation); Thu, 23 Feb 2023 17:20:48 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Lee Shawn C <shawn.c.lee@intel.com>
Subject: [PATCH] drm/i915: Preserve crtc_state->inherited during state clearing
Date:   Thu, 23 Feb 2023 17:20:48 +0200
Message-Id: <20230223152048.20878-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

intel_crtc_prepare_cleared_state() is unintentionally losing
the "inherited" flag. This will happen if intel_initial_commit()
is forced to go through the full modeset calculations for
whatever reason.

Afterwards the first real commit from userspace will not get
forced to the full modeset path, and thus eg. audio state may
not get recomputed properly. So if the monitor was already
enabled during boot audio will not work until userspace itself
does an explicit full modeset.

Cc: stable@vger.kernel.org
Tested-by: Lee Shawn C <shawn.c.lee@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_display.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index a1fbdf32bd21..ed95c0acfaae 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -5078,6 +5078,7 @@ intel_crtc_prepare_cleared_state(struct intel_atomic_state *state,
 	 * only fields that are know to not cause problems are preserved. */
 
 	saved_state->uapi = crtc_state->uapi;
+	saved_state->inherited = crtc_state->inherited;
 	saved_state->scaler_state = crtc_state->scaler_state;
 	saved_state->shared_dpll = crtc_state->shared_dpll;
 	saved_state->dpll_hw_state = crtc_state->dpll_hw_state;
-- 
2.39.2

