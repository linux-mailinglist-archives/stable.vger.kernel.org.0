Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0307FA85
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393973AbfHBNX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:23:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393952AbfHBNXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:23:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D9A120644;
        Fri,  2 Aug 2019 13:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752205;
        bh=+OHPHZfZOZOEfK4wBcFHFl5avew7AIiqTh9LpmExL/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPcLHZzvei5Xqhl6n4e2sQ2D8RtiU0SquoT98710hmrTAF6Hw5AFdG9dtz2igtY5+
         oawq5eYRZDxuK3y1Htxrps2qgUpEzJfVQWYatQVMWk5hFX1XYEr3lKCR2HF5/aoHFG
         4EJVHe2kcuI7gLGV4H/7fH9oBixdfDEjmmt5kUL4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Parkin <julian.parkin@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 09/42] drm/amd/display: Fix dc_create failure handling and 666 color depths
Date:   Fri,  2 Aug 2019 09:22:29 -0400
Message-Id: <20190802132302.13537-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132302.13537-1-sashal@kernel.org>
References: <20190802132302.13537-1-sashal@kernel.org>
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
index e3f5e5d6f0c18..f4b89d1ea6f6f 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -462,8 +462,10 @@ void dc_link_set_test_pattern(struct dc_link *link,
 
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
index 06d5988dff723..19a951e5818ac 100644
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

