Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126BC3E2566
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244001AbhHFITv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244164AbhHFITY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:19:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDBC4611B0;
        Fri,  6 Aug 2021 08:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237934;
        bh=fdaF6KV7EJ1NSBdpGZsLOGivkm05PpUv307VYvf1EQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pj9mhPrrPWxKZA4SuTFP1Jvg1YuYeRJViaC6UELf03KOT5QfRBsVL6UWVV5zI7dlV
         1WyeBgGbWpy8+KqKRRNFlWkqL0ACGKWxtRQDXg8O/4vEJp7VjlVBz8i3lFWHaw+yUg
         1RygynFspK+1ogkMzRfOyC15OhA/GF0iikUPM5SI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/30] drm/amd/display: Fix max vstartup calculation for modes with borders
Date:   Fri,  6 Aug 2021 10:16:56 +0200
Message-Id: <20210806081113.746761121@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
References: <20210806081113.126861800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit d7940911fc0754d99b208f0e3098762d39f403a0 ]

[Why]
Vertical and horizontal borders in timings are treated as increasing the
active area - vblank and hblank actually shrink.

Our input into DML does not include these borders so it incorrectly
assumes it has more time than available for vstartup and tmdl
calculations for some modes with borders.

An example of such a timing would be 640x480@72Hz:

h_total: 832
h_border_left: 8
h_addressable: 640
h_border_right: 8
h_front_porch: 16
h_sync_width: 40
v_total: 520
v_border_top: 8
v_addressable: 480
v_border_bottom: 8
v_front_porch: 1
v_sync_width: 3
pix_clk_100hz: 315000

[How]
Include borders as part of destination vactive/hactive.

This change DCN20+ so it has wide impact, but the destination vactive
and hactive are only really used for vstartup calculation anyway.

Most modes do not have vertical or horizontal borders.

Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index 1812ec7ee11b..cfe85ba1018e 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -2077,8 +2077,10 @@ int dcn20_populate_dml_pipes_from_context(
 				- timing->v_border_bottom;
 		pipes[pipe_cnt].pipe.dest.htotal = timing->h_total;
 		pipes[pipe_cnt].pipe.dest.vtotal = v_total;
-		pipes[pipe_cnt].pipe.dest.hactive = timing->h_addressable;
-		pipes[pipe_cnt].pipe.dest.vactive = timing->v_addressable;
+		pipes[pipe_cnt].pipe.dest.hactive =
+			timing->h_addressable + timing->h_border_left + timing->h_border_right;
+		pipes[pipe_cnt].pipe.dest.vactive =
+			timing->v_addressable + timing->v_border_top + timing->v_border_bottom;
 		pipes[pipe_cnt].pipe.dest.interlaced = timing->flags.INTERLACE;
 		pipes[pipe_cnt].pipe.dest.pixel_rate_mhz = timing->pix_clk_100hz/10000.0;
 		if (timing->timing_3d_format == TIMING_3D_FORMAT_HW_FRAME_PACKING)
-- 
2.30.2



