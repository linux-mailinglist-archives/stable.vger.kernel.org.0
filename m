Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE679615927
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiKBDF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiKBDFY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:05:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7D723EBF
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:05:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CA50616DB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4D5C433D6;
        Wed,  2 Nov 2022 03:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358322;
        bh=qZlkKXY4nsfmP00mcpEZEyYZNk9eltTrXfIR7D4ANwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rs1dmc8iVQ6tAQtzklExL2QJf9O//pV5JukHm5ZwnCWx9h9Mag7hQ8N9ldHm0N7DB
         xorJwUNONYz87carM0Uzk24TpKSplW5Wed0T4drDcE5aSKfmcC+roRDbpWUgl2Gal3
         OHL6boPAVj6Dg5RBEhbeIaenLPfgJ07301FdwKys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Swati Sharma <swati2.sharma@intel.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Uma Shankar <uma.shankar@intel.com>
Subject: [PATCH 5.15 079/132] drm/i915/dp: Reset frl trained flag before restarting FRL training
Date:   Wed,  2 Nov 2022 03:33:05 +0100
Message-Id: <20221102022101.691189623@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

[ Upstream commit 63720a561b3c98199adf0c73e152807f15cc3b7f ]

For cases where DP has HDMI2.1 sink and FRL Link issues are detected,
reset the flag to state FRL trained status before restarting FRL
training.

Fixes: 9488a030ac91 ("drm/i915: Add support for enabling link status and recovery")
Cc: Swati Sharma <swati2.sharma@intel.com>
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Uma Shankar <uma.shankar@intel.com> (v2)
Cc: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221011063447.904649-2-ankit.k.nautiyal@intel.com
(cherry picked from commit 47e1a59e60c688c5f95b67277202f05b7e84c189)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index f87e4d510ea5..1ccdf2da042b 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3497,6 +3497,8 @@ intel_dp_handle_hdmi_link_status_change(struct intel_dp *intel_dp)
 
 		drm_dp_pcon_hdmi_frl_link_error_count(&intel_dp->aux, &intel_dp->attached_connector->base);
 
+		intel_dp->frl.is_trained = false;
+
 		/* Restart FRL training or fall back to TMDS mode */
 		intel_dp_check_frl_training(intel_dp);
 	}
-- 
2.35.1



