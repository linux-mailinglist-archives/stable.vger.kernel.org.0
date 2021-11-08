Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBCB44A12D
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238962AbhKIBHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:07:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239003AbhKIBGE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:06:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5080961A05;
        Tue,  9 Nov 2021 01:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419761;
        bh=3qFoeYw7sSYFRQnAVOgSOBo35uH9Ku6Kt7gT7S5MEzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RkGgfTNJCpfwUjWLnUzCW8xEydVOQC94rOZaAn10MKvox7NFY6pnXsn86V/b831+K
         tg5D8Igx8HMaBGIuBt6KKF2EYw2oAgWgTiZlgC6+Fv4HRiDFC11UqizmH110apsvpd
         /VtXk3MqrzBd972VeG1iwdcnRx2Ros9w56sVoWys8wFXcPv6EEnIt5l2HtsROv99to
         TnDH89T1YgSEeKmUQVgZaRxR4U1MBHSObrawJoSjTRWETB3s9kX/xbifo/Y30kKAvt
         FpZI//37BCR3sdIVR1+WW4WyIgHBBRnMkkDSLvLRHPrQCArbZMWRySwytkj6KemEIx
         Pb1fbMAZoyIfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jimmy Kizito <Jimmy.Kizito@amd.com>, Aric Cyr <aric.cyr@amd.com>,
        Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, Jun.Lei@amd.com,
        wenjing.liu@amd.com, Anson.Jacob@amd.com, Wesley.Chalmers@amd.com,
        george.shen@amd.com, Jerry.Zuo@amd.com, stylon.wang@amd.com,
        nicholas.kazlauskas@amd.com, vladimir.stempen@amd.com,
        qingqing.zhuo@amd.com, Samson.Tam@amd.com,
        agustin.gutierrez@amd.com, wyatt.wood@amd.com, paul.hsieh@amd.com,
        hanghong.ma@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 027/138] drm/amd/display: Fix null pointer dereference for encoders
Date:   Mon,  8 Nov 2021 12:44:53 -0500
Message-Id: <20211108174644.1187889-27-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jimmy Kizito <Jimmy.Kizito@amd.com>

[ Upstream commit 60f39edd897ea134a4ddb789a6795681691c3183 ]

[Why]
Links which are dynamically assigned link encoders have their link
encoder set to NULL.

[How]
Check that a pointer to a link_encoder object is non-NULL before using
it.

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Reviewed-by: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Jimmy Kizito <Jimmy.Kizito@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c          | 2 +-
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 3c8da3665a274..7b418f3f9291c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -4681,7 +4681,7 @@ enum dc_status dp_set_fec_ready(struct dc_link *link, bool ready)
 				link_enc->funcs->fec_set_ready(link_enc, true);
 				link->fec_state = dc_link_fec_ready;
 			} else {
-				link_enc->funcs->fec_set_ready(link->link_enc, false);
+				link_enc->funcs->fec_set_ready(link_enc, false);
 				link->fec_state = dc_link_fec_not_ready;
 				dm_error("dpcd write failed to set fec_ready");
 			}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 75fa4adcf5f40..da7c906ba5eb5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1522,7 +1522,7 @@ void dcn10_power_down_on_boot(struct dc *dc)
 		for (i = 0; i < dc->link_count; i++) {
 			struct dc_link *link = dc->links[i];
 
-			if (link->link_enc->funcs->is_dig_enabled &&
+			if (link->link_enc && link->link_enc->funcs->is_dig_enabled &&
 					link->link_enc->funcs->is_dig_enabled(link->link_enc) &&
 					dc->hwss.power_down) {
 				dc->hwss.power_down(dc);
-- 
2.33.0

