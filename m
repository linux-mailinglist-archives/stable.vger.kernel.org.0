Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37B11EAC41
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730872AbgFASRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:17:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731873AbgFASRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:17:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 368EC2074B;
        Mon,  1 Jun 2020 18:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035473;
        bh=9I28pUr8Mxdmj2lTW+PLYvHmWhPpyZ/+DI7qFTba/Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KnBjUwHFpLjH5szXoUMIPVvWcqHYAGKZfvm5vjUrufj7hkpxPM4YhVzJ4BMnHIw4B
         huau70Vs47IK/TWra3n3rIXSj8VFfKLfbLzqLmrZ39qLicLnPJPDUKVKzTAHeIA3V7
         Wgj7aQBNlDLP1jMMsOZoAfF6kwXAU35eI8PaGftA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Koo <Anthony.Koo@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 126/177] drm/amd/display: Indicate dsc updates explicitly
Date:   Mon,  1 Jun 2020 19:54:24 +0200
Message-Id: <20200601174059.070014044@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Koo <Anthony.Koo@amd.com>

[ Upstream commit acdac228c4d1b9ff8ac778835719d3381c198aad ]

[Why]
DSC updates only set type to FULL UPDATE, but doesn't
flag the change

[How]
Add DSC flag update flag

Signed-off-by: Anthony Koo <Anthony.Koo@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c   | 19 ++++++++++++-------
 drivers/gpu/drm/amd/display/dc/dc_stream.h |  1 +
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 66be2920fab0..2667691ba2aa 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1745,14 +1745,15 @@ static enum surface_update_type check_update_surfaces_for_stream(
 
 		if (stream_update->wb_update)
 			su_flags->bits.wb_update = 1;
+
+		if (stream_update->dsc_config)
+			su_flags->bits.dsc_changed = 1;
+
 		if (su_flags->raw != 0)
 			overall_type = UPDATE_TYPE_FULL;
 
 		if (stream_update->output_csc_transform || stream_update->output_color_space)
 			su_flags->bits.out_csc = 1;
-
-		if (stream_update->dsc_config)
-			overall_type = UPDATE_TYPE_FULL;
 	}
 
 	for (i = 0 ; i < surface_count; i++) {
@@ -1787,8 +1788,11 @@ enum surface_update_type dc_check_update_surfaces_for_stream(
 
 	type = check_update_surfaces_for_stream(dc, updates, surface_count, stream_update, stream_status);
 	if (type == UPDATE_TYPE_FULL) {
-		if (stream_update)
+		if (stream_update) {
+			uint32_t dsc_changed = stream_update->stream->update_flags.bits.dsc_changed;
 			stream_update->stream->update_flags.raw = 0xFFFFFFFF;
+			stream_update->stream->update_flags.bits.dsc_changed = dsc_changed;
+		}
 		for (i = 0; i < surface_count; i++)
 			updates[i].surface->update_flags.raw = 0xFFFFFFFF;
 	}
@@ -2104,14 +2108,15 @@ static void commit_planes_do_stream_update(struct dc *dc,
 				}
 			}
 
+			/* Full fe update*/
+			if (update_type == UPDATE_TYPE_FAST)
+				continue;
+
 			if (stream_update->dsc_config && dc->hwss.pipe_control_lock_global) {
 				dc->hwss.pipe_control_lock_global(dc, pipe_ctx, true);
 				dp_update_dsc_config(pipe_ctx);
 				dc->hwss.pipe_control_lock_global(dc, pipe_ctx, false);
 			}
-			/* Full fe update*/
-			if (update_type == UPDATE_TYPE_FAST)
-				continue;
 
 			if (stream_update->dpms_off) {
 				dc->hwss.pipe_control_lock(dc, pipe_ctx, true);
diff --git a/drivers/gpu/drm/amd/display/dc/dc_stream.h b/drivers/gpu/drm/amd/display/dc/dc_stream.h
index 92096de79dec..a5c7ef47b8d3 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_stream.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_stream.h
@@ -118,6 +118,7 @@ union stream_update_flags {
 		uint32_t dpms_off:1;
 		uint32_t gamut_remap:1;
 		uint32_t wb_update:1;
+		uint32_t dsc_changed : 1;
 	} bits;
 
 	uint32_t raw;
-- 
2.25.1



