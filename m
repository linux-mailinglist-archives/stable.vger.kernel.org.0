Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 726B21193C6
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbfLJVKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:10:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:59642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbfLJVKI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 674B8246B6;
        Tue, 10 Dec 2019 21:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012208;
        bh=osEMQ+qjmPG568bwq3Y3oZd6+35Cqc6/K7SPM9SAm24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYsMBrNUu4O6C739L78hFjOmDIrMbkl1orucS7TJCA0dHrdL34hC7zarEIo9Kuol9
         FRjOier54+NlUano2ImIwidcpO9bdtfaC1xSVIjn7eyGO3+EM03riGZdeJMBo/aaF5
         GWYpyVujBsQ4/+wUY702Nte8YPymU71B8Xz9U2vc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhan liu <zhan.liu@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 160/350] drm/amd/display: setting the DIG_MODE to the correct value.
Date:   Tue, 10 Dec 2019 16:04:25 -0500
Message-Id: <20191210210735.9077-121-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhan liu <zhan.liu@amd.com>

[ Upstream commit 967a3b85bac91c55eff740e61bf270c2732f48b2 ]

[Why]
This patch is for fixing Navi14 HDMI display pink screen issue.

[How]
Call stream->link->link_enc->funcs->setup twice. This is setting
the DIG_MODE to the correct value after having been overridden by
the call to transmitter control.

Signed-off-by: Zhan Liu <zhan.liu@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index efc1d30544bb6..067f5579f4523 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -2769,6 +2769,15 @@ void core_link_enable_stream(
 					CONTROLLER_DP_TEST_PATTERN_VIDEOMODE,
 					COLOR_DEPTH_UNDEFINED);
 
+		/* This second call is needed to reconfigure the DIG
+		 * as a workaround for the incorrect value being applied
+		 * from transmitter control.
+		 */
+		if (!dc_is_virtual_signal(pipe_ctx->stream->signal))
+			stream->link->link_enc->funcs->setup(
+				stream->link->link_enc,
+				pipe_ctx->stream->signal);
+
 #ifdef CONFIG_DRM_AMD_DC_DSC_SUPPORT
 		if (pipe_ctx->stream->timing.flags.DSC) {
 			if (dc_is_dp_signal(pipe_ctx->stream->signal) ||
-- 
2.20.1

