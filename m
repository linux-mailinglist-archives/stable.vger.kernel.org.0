Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4086210CE
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbiKHMdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiKHMdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:33:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F50813D16
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 04:33:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29D10B81A9D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 12:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD78C433D6;
        Tue,  8 Nov 2022 12:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667910796;
        bh=2bYUFivjiatceHDgyNp8AJ1EPBXu1dQYqGuGAwf/TJ4=;
        h=Subject:To:Cc:From:Date:From;
        b=tdblEOo5cDY3qSRTB9mLaDwkYp/+irr0M5nn68LYZvCd6AOdMCcpSANwX3iWfOgAz
         PJB0eOPH/C9toYsqbPe9Cfn9DZwbQL+mXy7wGE9MD80D09b8+ciZNwSZYa50D+uaj4
         eBpUWsmTLg1rC0NjTwtyMo65xd2u6XkLB7D0l2pI=
Subject: FAILED: patch "[PATCH] drm/i915/sdvo: Grab mode_config.mutex during LVDS init to" failed to apply to 6.0-stable tree
To:     ville.syrjala@linux.intel.com, jani.nikula@intel.com,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Nov 2022 13:33:14 +0100
Message-ID: <1667910794126115@kroah.com>
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


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

12caf46cf4fc ("drm/i915/sdvo: Grab mode_config.mutex during LVDS init to avoid WARNs")
d372ec94a018 ("drm/i915: Simplify intel_panel_add_edid_alt_fixed_modes()")
a5810f551d0a ("drm/i915: Allow more varied alternate fixed modes for panels")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 12caf46cf4fc92b1c3884cb363ace2e12732fd2f Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Wed, 26 Oct 2022 13:11:29 +0300
Subject: [PATCH] drm/i915/sdvo: Grab mode_config.mutex during LVDS init to
 avoid WARNs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/i915/display/intel_sdvo.c
index 8ee7b05ab733..774c1dc31a52 100644
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

