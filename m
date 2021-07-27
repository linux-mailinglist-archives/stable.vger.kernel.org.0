Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649BA3D766D
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236936AbhG0N2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:28:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236940AbhG0NU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3175661AE2;
        Tue, 27 Jul 2021 13:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391999;
        bh=fdaF6KV7EJ1NSBdpGZsLOGivkm05PpUv307VYvf1EQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxA5QRT7hh22HTwuy2pBgYy/Kr5bCLuyAyxTsyxgUF9ZNwV0CPCd43HpjDzoRS0tv
         w+u/2M3ePwyNqecY0B66JNz0CO23fK2RxPQgpcnXbtl3JG8HjfJEQNSIs1Od2CQyg7
         tFqh/UnLy18UAlZfGxQUyEzVpWtw2300JoyQLIaiPxv8tpjNvx/UotJfhxWxcVucLF
         hkPFAxfEXOK4X9vlwMiuPPoy3hI27yQ/0hvV6n2KKf155QZ0VgAs0O1wfGWuPzE4P7
         VJt7IVad66yUaG2rilYZXCvD+3OxgK8pgjO6XFm4gQu8JKO3lUvr4scQ0SwXaTdoyJ
         3M621j2IqbXvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 16/17] drm/amd/display: Fix max vstartup calculation for modes with borders
Date:   Tue, 27 Jul 2021 09:19:37 -0400
Message-Id: <20210727131938.834920-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131938.834920-1-sashal@kernel.org>
References: <20210727131938.834920-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

