Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C372B65D625
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbjADOks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239751AbjADOkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:40:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0461AD93
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBD65B81674
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A55C433F1;
        Wed,  4 Jan 2023 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843209;
        bh=y4Dql58/RK7NsIhvw1OfRWaIyo88iZ8pveMMNIwiTVA=;
        h=Subject:To:Cc:From:Date:From;
        b=TJTxW6IAzcRd7Ef+rXPnRrqsGpg5LF7CXE8Y4ayNkyapKQJxH/NxVaHYGCOkgjwYs
         yzztT0G7URaeFZge1RX/FR8jX5qGAm8r9trNICHOWvNV0Usq97C2kXU/VWIUESZ+n7
         33cqlpJv/MsKZdiriG4VJ4B9mNjiF4BDdodmUP7c=
Subject: FAILED: patch "[PATCH] drm/i915/sdvo: Grab mode_config.mutex during LVDS init to" failed to apply to 5.10-stable tree
To:     ville.syrjala@linux.intel.com, jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:39:54 +0100
Message-ID: <16728431943729@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

a3cd4f447281 ("drm/i915/sdvo: Grab mode_config.mutex during LVDS init to avoid WARNs")
eb89e83c152b ("drm/i915: Simplify intel_panel_add_edid_alt_fixed_modes()")
a5810f551d0a ("drm/i915: Allow more varied alternate fixed modes for panels")
6e939738da20 ("drm/i915: Accept more fixed modes with VRR panels")
3cf050762534 ("drm/i915/bios: Split VBT data into per-panel vs. global parts")
c2fdb424d322 ("drm/i915/bios: Split VBT parsing to global vs. panel specific parts")
c3fbcf60bc74 ("drm/i915/bios: Split parse_driver_features() into two parts")
75bd0d5e4ead ("drm/i915/pps: Split pps_init_delays() into distinct parts")
822e5ae701af ("drm/i915: Extract intel_edp_fixup_vbt_bpp()")
949665a6e237 ("drm/i915: Respect VBT seamless DRRS min refresh rate")
790b45f1bc67 ("drm/i915/bios: Parse the seamless DRRS min refresh rate")
901a0cad2ab8 ("drm/i915/bios: Get access to the tail end of the LFP data block")
13367132a7ad ("drm/i915/bios: Reorder panel DTD parsing")
5ab58d6996d7 ("drm/i915/bios: Validate the panel_name table")
58b2e3829ec6 ("drm/i915/bios: Trust the LFP data pointers")
514003e1421e ("drm/i915/bios: Validate LFP data table pointers")
918f3025960f ("drm/i915/bios: Use the copy of the LFP data table always")
e163cfb4c96d ("drm/i915/bios: Make copies of VBT data blocks")
d58a3d699797 ("drm/i915/bios: Use the cached BDB version")
ca2a3c9204ec ("drm/i915/bios: Extract struct lvds_lfp_data_ptr_table")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a3cd4f447281c56377de2ee109327400eb00668d Mon Sep 17 00:00:00 2001
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

diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/i915/display/intel_sdvo.c
index e62f41354789..9b447708d8e8 100644
--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -2908,8 +2908,12 @@ intel_sdvo_lvds_init(struct intel_sdvo *intel_sdvo, int device)
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

