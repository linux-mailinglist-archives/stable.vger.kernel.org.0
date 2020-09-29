Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D9627C92C
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbgI2MIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730227AbgI2Lhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76A0E23AA8;
        Tue, 29 Sep 2020 11:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379345;
        bh=OzleeDIta0QfHtPpyIbCwpHJnZGHsVVa7sJkl6FetZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4qwd3JqTnzsbAEAJZIEvIrXgPhb1O6Cim3mdrv51nr6EMaWlhb3mDDgbqn5dIxUg
         UM3SCYY3yLMDLCa6YUNv9pwaJzXrEvyaPE/iWiQelkTjR0lFiawAbK9YpxYMlujIYQ
         SxxlohwCRIoc66e2A+WvnDOZr0Yp8ZYd3gv47uKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        David Francis <David.Francis@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/388] drm/amd/display: Initialize DSC PPS variables to 0
Date:   Tue, 29 Sep 2020 12:57:02 +0200
Message-Id: <20200929110014.885947112@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Francis <David.Francis@amd.com>

[ Upstream commit b6adc57cff616da18ff8cff028d2ddf585c97334 ]

For DSC MST, sometimes monitors would break out
in full-screen static. The issue traced back to the
PPS generation code, where these variables were being used
uninitialized and were picking up garbage.

memset to 0 to avoid this

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: David Francis <David.Francis@amd.com>
Signed-off-by: Mikita Lipski <mikita.lipski@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c | 3 +++
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dsc.c   | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c
index a519dbc5ecb65..5d6cbaebebc03 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c
@@ -496,6 +496,9 @@ bool dp_set_dsc_pps_sdp(struct pipe_ctx *pipe_ctx, bool enable)
 		struct dsc_config dsc_cfg;
 		uint8_t dsc_packed_pps[128];
 
+		memset(&dsc_cfg, 0, sizeof(dsc_cfg));
+		memset(dsc_packed_pps, 0, 128);
+
 		/* Enable DSC hw block */
 		dsc_cfg.pic_width = stream->timing.h_addressable + stream->timing.h_border_left + stream->timing.h_border_right;
 		dsc_cfg.pic_height = stream->timing.v_addressable + stream->timing.v_border_top + stream->timing.v_border_bottom;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dsc.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dsc.c
index 1b419407af942..01040501d40e3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dsc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dsc.c
@@ -207,6 +207,9 @@ static bool dsc2_get_packed_pps(struct display_stream_compressor *dsc, const str
 	struct dsc_reg_values dsc_reg_vals;
 	struct dsc_optc_config dsc_optc_cfg;
 
+	memset(&dsc_reg_vals, 0, sizeof(dsc_reg_vals));
+	memset(&dsc_optc_cfg, 0, sizeof(dsc_optc_cfg));
+
 	DC_LOG_DSC("Getting packed DSC PPS for DSC Config:");
 	dsc_config_log(dsc, dsc_cfg);
 	DC_LOG_DSC("DSC Picture Parameter Set (PPS):");
-- 
2.25.1



