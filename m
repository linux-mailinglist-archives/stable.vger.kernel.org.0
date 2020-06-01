Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E663A1EAC9F
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbgFASNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730992AbgFASNy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:13:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1A72206E2;
        Mon,  1 Jun 2020 18:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035233;
        bh=NdnPmtsS3tWnrdzORWnRxa8zNY3r7zHEa+3nzOiybw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGI8uW/UTMz+oRhYxdDZ79gg6RqVBMxh2hkEPQ0/TSedAqM52NMmPYfDX5KlbWBoS
         jpe+Sp9aK3Q34IS+9b1Is36+CNvOaQLLKOgoSYg7eHAoj81soqHoN/sJvas6lPvZkI
         wG6RRANFC1JWS+NS8MDaCRbNsbnwxXQEryswxjhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        "Leo (Hanghong) Ma" <hanghong.ma@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 068/177] drm/amd/amdgpu: Update update_config() logic
Date:   Mon,  1 Jun 2020 19:53:26 +0200
Message-Id: <20200601174054.581376739@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo (Hanghong) Ma <hanghong.ma@amd.com>

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



