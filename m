Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC6E551995
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244815AbiFTNGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244166AbiFTNEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC35193F0;
        Mon, 20 Jun 2022 06:00:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A05A61541;
        Mon, 20 Jun 2022 13:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21664C3411B;
        Mon, 20 Jun 2022 13:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730002;
        bh=KnvmfHGYjEmIeJj0HwTROEOQWU54zeoo8U8eu5ebRCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/t5gkOZ97NTRtOD9yDznNmGc7R9PZq9Vd8bfyGGUGVX+LsqMnyzKHVrBNP8fdLKZ
         O2EwQcb40DTtR37rAugPHuI2oYgSFMVo1RoP/buaJsz3q6VvmhGM3cincrI6R0lQoD
         2EpIQiu2jlN037BeDwnRGWvaZ7wxiKbUoRhckVsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Roman Li <roman.li@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.18 122/141] drm/amd/display: Cap OLED brightness per max frame-average luminance
Date:   Mon, 20 Jun 2022 14:51:00 +0200
Message-Id: <20220620124733.158396954@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <roman.li@amd.com>

commit 4fd17f2ac0aa4e48823ac2ede5b050fb70300bf4 upstream.

[Why]
For OLED eDP the Display Manager uses max_cll value as a limit
for brightness control.
max_cll defines the content light luminance for individual pixel.
Whereas max_fall defines frame-average level luminance.
The user may not observe the difference in brightness in between
max_fall and max_cll.
That negatively impacts the user experience.

[How]
Use max_fall value instead of max_cll as a limit for brightness control.

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2835,7 +2835,7 @@ static struct drm_mode_config_helper_fun
 
 static void update_connector_ext_caps(struct amdgpu_dm_connector *aconnector)
 {
-	u32 max_cll, min_cll, max, min, q, r;
+	u32 max_avg, min_cll, max, min, q, r;
 	struct amdgpu_dm_backlight_caps *caps;
 	struct amdgpu_display_manager *dm;
 	struct drm_connector *conn_base;
@@ -2865,7 +2865,7 @@ static void update_connector_ext_caps(st
 	caps = &dm->backlight_caps[i];
 	caps->ext_caps = &aconnector->dc_link->dpcd_sink_ext_caps;
 	caps->aux_support = false;
-	max_cll = conn_base->hdr_sink_metadata.hdmi_type1.max_cll;
+	max_avg = conn_base->hdr_sink_metadata.hdmi_type1.max_fall;
 	min_cll = conn_base->hdr_sink_metadata.hdmi_type1.min_cll;
 
 	if (caps->ext_caps->bits.oled == 1 /*||
@@ -2893,8 +2893,8 @@ static void update_connector_ext_caps(st
 	 * The results of the above expressions can be verified at
 	 * pre_computed_values.
 	 */
-	q = max_cll >> 5;
-	r = max_cll % 32;
+	q = max_avg >> 5;
+	r = max_avg % 32;
 	max = (1 << q) * pre_computed_values[r];
 
 	// min luminance: maxLum * (CV/255)^2 / 100


