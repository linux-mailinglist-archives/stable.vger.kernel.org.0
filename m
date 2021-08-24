Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA55F3F64DD
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239076AbhHXRIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238795AbhHXRGO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:06:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C17E61507;
        Tue, 24 Aug 2021 16:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824383;
        bh=mhIoMzYbjb/1U29H3wpL1LFN0+mfiljrq3FStpfedtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNWnzzB4hR41Z4t4S+oN9dW8QSliitlGoqHVG+DZj02hKzVijosq4dY8JsEZJLohT
         Qx05YF2O+R15IgazLe3djRfCDzwuoaO3gQ6dmwim5TmKPhESS/a+0ylZ8DHnHot4TW
         mzNEd+LmDRGxzC+8XCEnsMpxLcIwbygI/stGIbPJPs4092q7GMuxYzXUgmjIBL278Q
         FPe/dtcO6TIR8mvcJfNikAWu9Aw2fIP27CvFiO/L3j3sYXQ4jviTKWqRBtCMIF5Kbn
         MOUJxmOTTp4S4o1QtcR+bebFJYR96pEhncSuYtglYZS9EFv5xyUcZ0dR++zR5Z4UBb
         G/kMXOCcu2PBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/98] drm/amd/display: workaround for hard hang on HPD on native DP
Date:   Tue, 24 Aug 2021 12:58:03 -0400
Message-Id: <20210824165908.709932-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
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
index 1c6e401dd4cc..0eba391e597f 100644
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

