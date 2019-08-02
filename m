Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC91D7F87D
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393373AbfHBNU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393366AbfHBNU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 195C721849;
        Fri,  2 Aug 2019 13:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752026;
        bh=giRhtxYzRCKHMP2+BeUpS3xr1ScaCTAL0Qv/EhoWJ+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYReBZ9ypar9TTmqZ6r1bskKK++EVSTODJt1njosat08sW4QkwVPPSSnBK5n40Dor
         umCWHNDs61yb24kh7z3ZQ1fjG+JJeP68bMeXHKep31fyHONgbTU2hPQnPFZzHotFyc
         qJX5+MXONVNqR0yaUqe4zDTvF0o3Dtf7ND6Ty8f8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Parkin <julian.parkin@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 23/76] drm/amd/display: Fix dc_create failure handling and 666 color depths
Date:   Fri,  2 Aug 2019 09:18:57 -0400
Message-Id: <20190802131951.11600-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Parkin <julian.parkin@amd.com>

[ Upstream commit 0905f32977268149f06e3ce6ea4bd6d374dd891f ]

[Why]
It is possible (but very unlikely) that constructing dc fails
before current_state is created.

We support 666 color depth in some scenarios, but this
isn't handled in get_norm_pix_clk. It uses exactly the
same pixel clock as the 888 case.

[How]
Check for non null current_state before destructing.

Add case for 666 color depth to get_norm_pix_clk to
avoid assertion.

Signed-off-by: Julian Parkin <julian.parkin@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c          | 6 ++++--
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index ee6b646180b66..0a7adc2925e35 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -608,8 +608,10 @@ const struct dc_link_settings *dc_link_get_link_cap(
 
 static void destruct(struct dc *dc)
 {
-	dc_release_state(dc->current_state);
-	dc->current_state = NULL;
+	if (dc->current_state) {
+		dc_release_state(dc->current_state);
+		dc->current_state = NULL;
+	}
 
 	destroy_links(dc);
 
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index ad82906b99db9..b87e8d80bb6a8 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1872,6 +1872,7 @@ static int get_norm_pix_clk(const struct dc_crtc_timing *timing)
 		pix_clk /= 2;
 	if (timing->pixel_encoding != PIXEL_ENCODING_YCBCR422) {
 		switch (timing->display_color_depth) {
+		case COLOR_DEPTH_666:
 		case COLOR_DEPTH_888:
 			normalized_pix_clk = pix_clk;
 			break;
-- 
2.20.1

