Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 298F6BCFC1
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390301AbfIXQog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:44:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409865AbfIXQof (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:44:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE38021783;
        Tue, 24 Sep 2019 16:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343474;
        bh=102bwutzRxcs2V9RTN9Y+pSZKhS2+svPGHXK6ShtJ24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/7m8EZEtFbWuYmzCMUVeRczGfpvLNnf09G6OB/Mqmd0yhXbMXsd+i63NzJ40AWtF
         QiI0Pa4e+Z4MjCG95iEgEq8dTFFEJu3m4O+gtGRnpKHiRgIIQXihhzlxAlhVSDauHD
         ru6lBHIEAROjkuedK2vS7Hmm3C2ogCR2IBYQHO0I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zi Yu Liao <ziyu.liao@amd.com>, Tony Cheng <Tony.Cheng@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 61/87] drm/amd/display: fix MPO HUBP underflow with Scatter Gather
Date:   Tue, 24 Sep 2019 12:41:17 -0400
Message-Id: <20190924164144.25591-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zi Yu Liao <ziyu.liao@amd.com>

[ Upstream commit 89cb5614736b9b5d3b833ca2237d10da6b4b0395 ]

[why]
With Scatter Gather enabled, HUBP underflows during MPO enabled video
playback. hubp_init has a register write that fixes this problem, but
the register is cleared when HUBP gets power gated.

[how]
Make a call to hubp_init during enable_plane, so that the fix can
be applied after HUBP powers back on again.

Signed-off-by: Zi Yu Liao <ziyu.liao@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index f8abe98a576be..8fdb53a44bfb3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1110,6 +1110,9 @@ void dcn20_enable_plane(
 	/* enable DCFCLK current DCHUB */
 	pipe_ctx->plane_res.hubp->funcs->hubp_clk_cntl(pipe_ctx->plane_res.hubp, true);
 
+	/* initialize HUBP on power up */
+	pipe_ctx->plane_res.hubp->funcs->hubp_init(pipe_ctx->plane_res.hubp);
+
 	/* make sure OPP_PIPE_CLOCK_EN = 1 */
 	pipe_ctx->stream_res.opp->funcs->opp_pipe_clock_control(
 			pipe_ctx->stream_res.opp,
-- 
2.20.1

