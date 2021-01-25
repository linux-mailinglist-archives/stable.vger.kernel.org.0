Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863023033A0
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbhAZFAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730985AbhAYSvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2B2A224D4;
        Mon, 25 Jan 2021 18:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600637;
        bh=NSbp94STs1o2eYrzXFBDrkVHII/I0VEPC/C+cdZ6qPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3wSIn1RcTbQlY770lhzxIb5ChwTdG583hTqFOpwBixoShEBZBfx+hgrcOgWV875/
         BJORXhUboaxdldrF4atFNeKdSv/XRZ7t0/BebQv0T1PXXK51OhfLkUuK71HbhMI0+9
         rArdIJEt797mlu+tv9vnKqW9M2SttGxSeJ54/sBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>, Roman Li <Roman.Li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/199] drm/amd/display: disable dcn10 pipe split by default
Date:   Mon, 25 Jan 2021 19:38:04 +0100
Message-Id: <20210125183218.894088686@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li, Roman <Roman.Li@amd.com>

[ Upstream commit 9d03bb102028b4a3f4a64d6069b219e2e1c1f306 ]

[Why]
The initial purpose of dcn10 pipe split is to support some high
bandwidth mode which requires dispclk greater than max dispclk. By
initial bring up power measurement data, it showed power consumption is
less with pipe split for dcn block. This could be reason for enable pipe
split by default. By battery life measurement of some Chromebooks,
result shows battery life is longer with pipe split disabled.

[How]
Disable pipe split by default. Pipe split could be still enabled when
required dispclk is greater than max dispclk.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Reviewed-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c
index 462d3d981ea5e..0a01be38ee1b8 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c
@@ -608,8 +608,8 @@ static const struct dc_debug_options debug_defaults_drv = {
 		.disable_pplib_clock_request = false,
 		.disable_pplib_wm_range = false,
 		.pplib_wm_report_mode = WM_REPORT_DEFAULT,
-		.pipe_split_policy = MPC_SPLIT_DYNAMIC,
-		.force_single_disp_pipe_split = true,
+		.pipe_split_policy = MPC_SPLIT_AVOID,
+		.force_single_disp_pipe_split = false,
 		.disable_dcc = DCC_ENABLE,
 		.voltage_align_fclk = true,
 		.disable_stereo_support = true,
-- 
2.27.0



