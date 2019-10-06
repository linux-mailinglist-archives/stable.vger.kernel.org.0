Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C4ACD54D
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbfJFRem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:34:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728329AbfJFRek (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:34:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68AFC21479;
        Sun,  6 Oct 2019 17:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383278;
        bh=V5BW3Dan/eBvQD7BOHMpiAzvf6bQmdaJ66dFqU73JmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAmkEkP2JGNKKfhePfJ8GUctyD1ZHI7upJZtGYBV9sSyuw996xPIYtgoTx5CfaDg/
         66LoEHzB7sVCF/8hUzjcJBoaJ9O6AyTZqQXNIOX1Ir7hv8vAS+AtNlvW7oS50GTzpK
         UKewNthnCNx8XeQ8/wNBhYfNfU2it8FnyNU1IcAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bayan Zabihiyan <bayan.zabihiyan@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 046/137] drm/amd/display: Fix frames_to_insert math
Date:   Sun,  6 Oct 2019 19:20:30 +0200
Message-Id: <20191006171212.732095091@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bayan Zabihiyan <bayan.zabihiyan@amd.com>

[ Upstream commit a463b263032f7c98c5912207db43be1aa34a6438 ]

[Why]
The math on deciding on how many
"frames to insert" sometimes sent us over the max refresh rate.
Also integer overflow can occur if we have high refresh rates.

[How]
Instead of clipping the  frame duration such that it doesn’t go below the min,
just remove a frame from the number of frames to insert. +
Use unsigned long long for intermediate calculations to prevent
integer overflow.

Signed-off-by: Bayan Zabihiyan <bayan.zabihiyan@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/modules/freesync/freesync.c   | 27 ++++++++++++-------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
index 19b1eaebe4840..000a9db9dad82 100644
--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -433,6 +433,12 @@ static void apply_below_the_range(struct core_freesync *core_freesync,
 		/* Either we've calculated the number of frames to insert,
 		 * or we need to insert min duration frames
 		 */
+		if (last_render_time_in_us / frames_to_insert <
+				in_out_vrr->min_duration_in_us){
+			frames_to_insert -= (frames_to_insert > 1) ?
+					1 : 0;
+		}
+
 		if (frames_to_insert > 0)
 			inserted_frame_duration_in_us = last_render_time_in_us /
 							frames_to_insert;
@@ -885,8 +891,8 @@ void mod_freesync_build_vrr_params(struct mod_freesync *mod_freesync,
 	struct core_freesync *core_freesync = NULL;
 	unsigned long long nominal_field_rate_in_uhz = 0;
 	unsigned int refresh_range = 0;
-	unsigned int min_refresh_in_uhz = 0;
-	unsigned int max_refresh_in_uhz = 0;
+	unsigned long long min_refresh_in_uhz = 0;
+	unsigned long long max_refresh_in_uhz = 0;
 
 	if (mod_freesync == NULL)
 		return;
@@ -913,7 +919,7 @@ void mod_freesync_build_vrr_params(struct mod_freesync *mod_freesync,
 		min_refresh_in_uhz = nominal_field_rate_in_uhz;
 
 	if (!vrr_settings_require_update(core_freesync,
-			in_config, min_refresh_in_uhz, max_refresh_in_uhz,
+			in_config, (unsigned int)min_refresh_in_uhz, (unsigned int)max_refresh_in_uhz,
 			in_out_vrr))
 		return;
 
@@ -929,15 +935,15 @@ void mod_freesync_build_vrr_params(struct mod_freesync *mod_freesync,
 		return;
 
 	} else {
-		in_out_vrr->min_refresh_in_uhz = min_refresh_in_uhz;
+		in_out_vrr->min_refresh_in_uhz = (unsigned int)min_refresh_in_uhz;
 		in_out_vrr->max_duration_in_us =
 				calc_duration_in_us_from_refresh_in_uhz(
-						min_refresh_in_uhz);
+						(unsigned int)min_refresh_in_uhz);
 
-		in_out_vrr->max_refresh_in_uhz = max_refresh_in_uhz;
+		in_out_vrr->max_refresh_in_uhz = (unsigned int)max_refresh_in_uhz;
 		in_out_vrr->min_duration_in_us =
 				calc_duration_in_us_from_refresh_in_uhz(
-						max_refresh_in_uhz);
+						(unsigned int)max_refresh_in_uhz);
 
 		refresh_range = in_out_vrr->max_refresh_in_uhz -
 				in_out_vrr->min_refresh_in_uhz;
@@ -948,17 +954,18 @@ void mod_freesync_build_vrr_params(struct mod_freesync *mod_freesync,
 	in_out_vrr->fixed.ramping_active = in_config->ramping;
 
 	in_out_vrr->btr.btr_enabled = in_config->btr;
+
 	if (in_out_vrr->max_refresh_in_uhz <
 			2 * in_out_vrr->min_refresh_in_uhz)
 		in_out_vrr->btr.btr_enabled = false;
+
 	in_out_vrr->btr.btr_active = false;
 	in_out_vrr->btr.inserted_duration_in_us = 0;
 	in_out_vrr->btr.frames_to_insert = 0;
 	in_out_vrr->btr.frame_counter = 0;
 	in_out_vrr->btr.mid_point_in_us =
-			in_out_vrr->min_duration_in_us +
-				(in_out_vrr->max_duration_in_us -
-				in_out_vrr->min_duration_in_us) / 2;
+				(in_out_vrr->min_duration_in_us +
+				 in_out_vrr->max_duration_in_us) / 2;
 
 	if (in_out_vrr->state == VRR_STATE_UNSUPPORTED) {
 		in_out_vrr->adjust.v_total_min = stream->timing.v_total;
-- 
2.20.1



