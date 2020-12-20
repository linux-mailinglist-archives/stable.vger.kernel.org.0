Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E212DF300
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 04:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbgLTDf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 22:35:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbgLTDf6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 22:35:58 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Park <Chris.Park@amd.com>, Wenjing Liu <Wenjing.Liu@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.9 08/15] drm/amd/display: Prevent bandwidth overflow
Date:   Sat, 19 Dec 2020 22:34:26 -0500
Message-Id: <20201220033434.2728348-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201220033434.2728348-1-sashal@kernel.org>
References: <20201220033434.2728348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Park <Chris.Park@amd.com>

[ Upstream commit 80089dd8410f356d5104496d5ab71a66a4f4646b ]

[Why]
At very high pixel clock, bandwidth calculation exceeds 32 bit size
and overflow value. This causes the resulting selection of link rate
to be inaccurate.

[How]
Change order of operation and use fixed point to deal with integer
accuracy. Also address bug found when forcing link rate.

Signed-off-by: Chris Park <Chris.Park@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Eryk Brol <eryk.brol@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index b0f8bfd48d102..462f8b18440b3 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -3394,10 +3394,13 @@ uint32_t dc_bandwidth_in_kbps_from_timing(
 {
 	uint32_t bits_per_channel = 0;
 	uint32_t kbps;
+	struct fixed31_32 link_bw_kbps;
 
 	if (timing->flags.DSC) {
-		kbps = (timing->pix_clk_100hz * timing->dsc_cfg.bits_per_pixel);
-		kbps = kbps / 160 + ((kbps % 160) ? 1 : 0);
+		link_bw_kbps = dc_fixpt_from_int(timing->pix_clk_100hz);
+		link_bw_kbps = dc_fixpt_div_int(link_bw_kbps, 160);
+		link_bw_kbps = dc_fixpt_mul_int(link_bw_kbps, timing->dsc_cfg.bits_per_pixel);
+		kbps = dc_fixpt_ceil(link_bw_kbps);
 		return kbps;
 	}
 
-- 
2.27.0

