Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FDB26EB17
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgIRCDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgIRCDJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:03:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 425AB21734;
        Fri, 18 Sep 2020 02:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394585;
        bh=OzleeDIta0QfHtPpyIbCwpHJnZGHsVVa7sJkl6FetZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8HSnMpOPpULYEQxr9atXQSMeKJ4+WZ4xoL9sQykVS56016Fo7qdpkC6QIh1aniJe
         WuDYwzOPU9TIFPbOENkg6cG3FOHEtbj9ACaGGWCFlMwNxy8sVx787RFrdcZmVaQ6lI
         kD/QJ/geDgHm6V85+ISLj581WovOTByq4THFYH4E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Francis <David.Francis@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 094/330] drm/amd/display: Initialize DSC PPS variables to 0
Date:   Thu, 17 Sep 2020 21:57:14 -0400
Message-Id: <20200918020110.2063155-94-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

