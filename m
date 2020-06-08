Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EAB1F2C2B
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732997AbgFIAVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729863AbgFHXRq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6198B2083E;
        Mon,  8 Jun 2020 23:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658266;
        bh=HTQXwy4hfn0GnYPnVOAVpxQx4T3zMeWsNO3v/JrvKpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yhD85PM4p4FEZeBnT/dwKEabSKDXNejyIlI9s5Dxyaz0jNLpYfkx3o2o3PBk4Br2M
         1eeNNLJl1FuZy9be6AEllw0UBL2550DJjdFmorrkauvpryobvMYsljeAsQqTBczSJT
         s+/8x3EbRlwK6nOfXOMllCcRo9P/bG42VW/r0XS8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Leo (Hanghong) Ma" <hanghong.ma@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 273/606] drm/amd/amdgpu: Update update_config() logic
Date:   Mon,  8 Jun 2020 19:06:38 -0400
Message-Id: <20200608231211.3363633-273-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Leo (Hanghong) Ma" <hanghong.ma@amd.com>

[ Upstream commit 650e723cecf2738dee828564396f3239829aba83 ]

[Why]
For MST case: when update_config is called to disable a stream,
this clears the settings for all the streams on that link.
We should only clear the settings for the stream that was disabled.

[How]
Clear the settings after the call to remove display is called.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Leo (Hanghong) Ma <hanghong.ma@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
index 3abeff7722e3..e80371542622 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -316,15 +316,15 @@ static void update_config(void *handle, struct cp_psp_stream_config *config)
 	struct mod_hdcp_display *display = &hdcp_work[link_index].display;
 	struct mod_hdcp_link *link = &hdcp_work[link_index].link;
 
-	memset(display, 0, sizeof(*display));
-	memset(link, 0, sizeof(*link));
-
-	display->index = aconnector->base.index;
-
 	if (config->dpms_off) {
 		hdcp_remove_display(hdcp_work, link_index, aconnector);
 		return;
 	}
+
+	memset(display, 0, sizeof(*display));
+	memset(link, 0, sizeof(*link));
+
+	display->index = aconnector->base.index;
 	display->state = MOD_HDCP_DISPLAY_ACTIVE;
 
 	if (aconnector->dc_sink != NULL)
-- 
2.25.1

