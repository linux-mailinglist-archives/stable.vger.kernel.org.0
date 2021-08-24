Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE383F63A5
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhHXQ5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234482AbhHXQ5R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00D17613E6;
        Tue, 24 Aug 2021 16:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824192;
        bh=2z1U4KI0QJU1RNa4Mg2/avK8MKmjpq+OPBD0fFEoDhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvX1jWX3sCUNdCLLUaHNmYHMRzOSsztnmQMDihpHXRWWwuYvW2nZcrxGH8PTRsncU
         Q79QwIGPqoC6klbQvt7QcNMEz4mxwe/ChiaxZvNK0lfhqdzDFnRSccgtCX3cBL39jA
         fpn7ypwuAH39ERT64ogTRLHQNqf9wP/oje5ghg10ysz3eHc+H7E/MTGGvJ6L9wpit7
         q47CSn0LhMtGahs8WWWM5y4WeRJljZPHpA3O0SqJSLW99xCqxtFLokW9lxJoahVyVY
         cMVqkvsvIILouApAHZ4s2AKksrpex5nb4p18yQht5MwZFj970WoWhEF5IBawCdsAF8
         4xPLKAqmcDglQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 024/127] drm/amd/display: workaround for hard hang on HPD on native DP
Date:   Tue, 24 Aug 2021 12:54:24 -0400
Message-Id: <20210824165607.709387-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
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

