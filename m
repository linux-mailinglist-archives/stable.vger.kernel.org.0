Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1EA44178
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731255AbfFMQO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731190AbfFMImX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:42:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37C7121479;
        Thu, 13 Jun 2019 08:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415341;
        bh=1Xvyej120jzAEw8ZdqMdUjBYsdzqfM30Il+iZxiARLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EOY14euBJhXtewDfIbIfU+xom38quIE8JaHKMS90aLARBn4CSZiuGhI17/GrnUY0q
         CATY5xoFzS3GHUgaUgP1HmcOvj28HpHMc5irXnw8Ib3Q/KQvwkKtAzBUA3vlyNuRPJ
         MtKViDstmpsZKzbxwHJOxn6grE1RxdcC8LKae3Cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Sun peng Li <Sunpeng.Li@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 090/118] drm/amd/display: Use plane->color_space for dpp if specified
Date:   Thu, 13 Jun 2019 10:33:48 +0200
Message-Id: <20190613075649.099323956@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a1e07ba89d49581471d64c48152dbe03b42bd025 ]

[Why]
The input color space for the plane was previously ignored even if it
was set.

If a limited range YUV format was given to DC then the
wrong color transformation matrix was being used since DC assumed that
it was full range instead.

[How]
Respect the given color_space format for the plane if it isn't
COLOR_SPACE_UNKNOWN. Otherwise, use the implicit default since DM
didn't specify.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Sun peng Li <Sunpeng.Li@amd.com>
Acked-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp.c          | 6 +++++-
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp.c
index bf8b68f8db4f..bce5741f2952 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp.c
@@ -388,6 +388,10 @@ void dpp1_cnv_setup (
 	default:
 		break;
 	}
+
+	/* Set default color space based on format if none is given. */
+	color_space = input_color_space ? input_color_space : color_space;
+
 	REG_SET(CNVC_SURFACE_PIXEL_FORMAT, 0,
 			CNVC_SURFACE_PIXEL_FORMAT, pixel_format);
 	REG_UPDATE(FORMAT_CONTROL, FORMAT_CONTROL__ALPHA_EN, alpha_en);
@@ -399,7 +403,7 @@ void dpp1_cnv_setup (
 		for (i = 0; i < 12; i++)
 			tbl_entry.regval[i] = input_csc_color_matrix.matrix[i];
 
-		tbl_entry.color_space = input_color_space;
+		tbl_entry.color_space = color_space;
 
 		if (color_space >= COLOR_SPACE_YCBCR601)
 			select = INPUT_CSC_SELECT_ICSC;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index a0355709abd1..7736ef123e9b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1890,7 +1890,7 @@ static void update_dpp(struct dpp *dpp, struct dc_plane_state *plane_state)
 			plane_state->format,
 			EXPANSION_MODE_ZERO,
 			plane_state->input_csc_color_matrix,
-			COLOR_SPACE_YCBCR601_LIMITED);
+			plane_state->color_space);
 
 	//set scale and bias registers
 	build_prescale_params(&bns_params, plane_state);
-- 
2.20.1



