Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447023E5CF0
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242574AbhHJOQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:16:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242438AbhHJOP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:15:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9355D61008;
        Tue, 10 Aug 2021 14:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604936;
        bh=2z1U4KI0QJU1RNa4Mg2/avK8MKmjpq+OPBD0fFEoDhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvZjIVix7GbOiYkA9XYB7IAmbzwKXEXlieB6SihorkP3/952kWB/Fjh2hrXVE1yEf
         56TcFSwdfGVXRYvIOSwItNpPR9U1geTx4ng82liqSg6j1tJGM2VxyxAKhOUWbf5o+O
         aCjltSI94oMOQaZwSqx5eMWWpEmgvzO5ync45Zpgm8t7Xuxye2b6gPINcnisZl027i
         R5np1n0LpbVCXtuhEPMl+nRhPUMvgTU6G5P/sEHC29sQynILp7ligHjKiXd6Glhofk
         Kn1cVd29dn2kyoza1dnK+XU9o8BJJ+lh5QBRujCjZ0qDkRVpKYlV5Ly2LcnxjawdQQ
         4klj4Eo5Av8tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 23/24] drm/amd/display: workaround for hard hang on HPD on native DP
Date:   Tue, 10 Aug 2021 10:15:04 -0400
Message-Id: <20210810141505.3117318-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141505.3117318-1-sashal@kernel.org>
References: <20210810141505.3117318-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qingqing Zhuo <qingqing.zhuo@amd.com>

[ Upstream commit c4152b297d56d3696ad0a9003169bc5b98ad7b72 ]

[Why]
HPD disable and enable sequences are not mutually exclusive
on Linux. For HPDs that spans over 1s (i.e. HPD low = 1s),
part of the disable sequence (specifically, a request to SMU
to lower refclk) could come right before the call to PHY
enable, causing DMUB to access an unresponsive PHY
and thus a hard hang on the system.

[How]
Disable 48mhz refclk off on native DP.

Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
index 75ba86f951f8..7bbedb6b4a9e 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
@@ -66,9 +66,11 @@ int rn_get_active_display_cnt_wa(
 	for (i = 0; i < context->stream_count; i++) {
 		const struct dc_stream_state *stream = context->streams[i];
 
+		/* Extend the WA to DP for Linux*/
 		if (stream->signal == SIGNAL_TYPE_HDMI_TYPE_A ||
 				stream->signal == SIGNAL_TYPE_DVI_SINGLE_LINK ||
-				stream->signal == SIGNAL_TYPE_DVI_DUAL_LINK)
+				stream->signal == SIGNAL_TYPE_DVI_DUAL_LINK ||
+				stream->signal == SIGNAL_TYPE_DISPLAY_PORT)
 			tmds_present = true;
 	}
 
-- 
2.30.2

