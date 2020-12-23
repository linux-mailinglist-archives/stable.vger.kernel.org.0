Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3A12E1791
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgLWDLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:11:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727605AbgLWCSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2222A22A99;
        Wed, 23 Dec 2020 02:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689813;
        bh=o1W8LOPS4OuZ3xtMvSdO+5taIu+dtTEHp7Kb5wKltVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfvP4XM/bkUvftHWk++rn+FXexds8C/mITGJKh8raULlO4Njm5upqdiVED7EW65Ri
         WTq+NxXGPqEStDPdW3PWknFj9D8OJGlMubxDOJELIl+kAxCRkNwcbZLPK+VOkmOIlV
         7cSYesyyukuEyKMkjp2hxyEbV5dEQ2wJ4waiWbTqniR680l7gE47QkQqaqqNAqLAH5
         ZqGDBCrKz2SRcnW2SV7wB2LyuC299rDJupjFUfTJhtt6jS8hGdvbKJUp3rmSLC14Va
         lStq/7GB27T8H8ODDg5wULkb3kcB25M1TDkj66Cbr/aftxbGW4B7YEVEDRFHsWVzDh
         wE+ZDH7qeTqng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alvin Lee <alvin.lee2@amd.com>, Aric Cyr <Aric.Cyr@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 020/217] drm/amd/display: Keep GSL for full updates with planes that flip VSYNC
Date:   Tue, 22 Dec 2020 21:13:09 -0500
Message-Id: <20201223021626.2790791-20-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Lee <alvin.lee2@amd.com>

[ Upstream commit 6f2239ccdfc04938dc35e67dd60191b2c05dfb63 ]

[Why]
When enabling PIP in Heaven, the PIP planes are VSYNC
flip and is also the top-most pipe. In this case GSL
will be disabled because we only check immediate flip
for the top pipe. However, the desktop planes are still
flip immediate so we should at least keep GSL on until
the full update.

[How]
Check each pipe in the tree to see if any planes
are flip immediate. Maintain the GSL lock if yes,
and take it down after when unlocking if any planes
are flipping VSYNC. Keeping GSL on with VSYNC +
flip immediate planes causes corruption.

Signed-off-by: Alvin Lee <alvin.lee2@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn20/dcn20_hwseq.c    | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 01530e686f437..0f67e94653e40 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1158,6 +1158,7 @@ void dcn20_pipe_control_lock(
 	struct pipe_ctx *pipe,
 	bool lock)
 {
+	struct pipe_ctx *temp_pipe;
 	bool flip_immediate = false;
 
 	/* use TG master update lock to lock everything on the TG
@@ -1169,6 +1170,13 @@ void dcn20_pipe_control_lock(
 	if (pipe->plane_state != NULL)
 		flip_immediate = pipe->plane_state->flip_immediate;
 
+	temp_pipe = pipe->bottom_pipe;
+	while (!flip_immediate && temp_pipe) {
+	    if (temp_pipe->plane_state != NULL)
+		flip_immediate = temp_pipe->plane_state->flip_immediate;
+	    temp_pipe = temp_pipe->bottom_pipe;
+	}
+
 	if (flip_immediate && lock) {
 		const int TIMEOUT_FOR_FLIP_PENDING = 100000;
 		int i;
@@ -1196,6 +1204,17 @@ void dcn20_pipe_control_lock(
 		    (!flip_immediate && pipe->stream_res.gsl_group > 0))
 			dcn20_setup_gsl_group_as_lock(dc, pipe, flip_immediate);
 
+	temp_pipe = pipe->bottom_pipe;
+	while (flip_immediate && temp_pipe) {
+	    if (temp_pipe->plane_state != NULL)
+		flip_immediate = temp_pipe->plane_state->flip_immediate;
+	    temp_pipe = temp_pipe->bottom_pipe;
+	}
+
+	if (!lock && pipe->stream_res.gsl_group > 0 && pipe->plane_state &&
+		!flip_immediate)
+	    dcn20_setup_gsl_group_as_lock(dc, pipe, false);
+
 	if (pipe->stream && should_use_dmub_lock(pipe->stream->link)) {
 		union dmub_hw_lock_flags hw_locks = { 0 };
 		struct dmub_hw_lock_inst_flags inst_flags = { 0 };
-- 
2.27.0

