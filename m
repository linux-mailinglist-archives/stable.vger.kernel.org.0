Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E2D627F9C
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237665AbiKNNA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237661AbiKNNA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:00:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3A227DFA
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:00:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4257B80EB9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2453EC433B5;
        Mon, 14 Nov 2022 13:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430852;
        bh=c5kJOyYvKntNH5g/1btKJ41Dj/6atpU9FqGQwbyPjH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEbHJduitujRJnhZtTcFyGL2j9/knt3lz2Z7fg6mw3AWgxokCAIfjcbjK0aQs3weM
         F28fuSSFNKuVew/bd1UBERMTXMzRPU4B0kEXBj2frH84Jovct4Jg7ap5LTZltBlJn0
         DJ3PG9s9EoJ+zNaJ/wSxgutGslxzebyYCLpVkv+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 007/190] drm/i915/sdvo: Grab mode_config.mutex during LVDS init to avoid WARNs
Date:   Mon, 14 Nov 2022 13:43:51 +0100
Message-Id: <20221114124459.113547862@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 12caf46cf4fc92b1c3884cb363ace2e12732fd2f ]

drm_mode_probed_add() is unhappy about being called w/o
mode_config.mutex. Grab it during LVDS fixed mode setup
to silence the WARNs.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7301
Fixes: aa2b88074a56 ("drm/i915/sdvo: Fix multi function encoder stuff")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221026101134.20865-4-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit a3cd4f447281c56377de2ee109327400eb00668d)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_sdvo.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/i915/display/intel_sdvo.c
index 282820fe55b5..6b471fc297bd 100644
--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -2900,8 +2900,12 @@ intel_sdvo_lvds_init(struct intel_sdvo *intel_sdvo, int device)
 	intel_panel_add_vbt_sdvo_fixed_mode(intel_connector);
 
 	if (!intel_panel_preferred_fixed_mode(intel_connector)) {
+		mutex_lock(&i915->drm.mode_config.mutex);
+
 		intel_ddc_get_modes(connector, &intel_sdvo->ddc);
 		intel_panel_add_edid_fixed_modes(intel_connector, false);
+
+		mutex_unlock(&i915->drm.mode_config.mutex);
 	}
 
 	intel_panel_init(intel_connector);
-- 
2.35.1



