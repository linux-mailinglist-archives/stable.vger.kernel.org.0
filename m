Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5933F8DB8D
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbfHNRE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728561AbfHNRE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:04:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85D5D214DA;
        Wed, 14 Aug 2019 17:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802297;
        bh=ryyqDji8vE1T9WU4gG8iEcKm+aP8x84iFRvKo0Xh4/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBmuKp3bJq0ga+Vq246OcQ+T95NR/yY04uOQgXf9o1bSNnxj2K6hVeLBNpIAjJPqH
         s9O3yeyYYwir6v55iVQgX5ddo8baptTrYI4D3r6iU0jof4OPjXnCnZYO1Kw+c57j88
         rhvlHZ4nIDRWVZE57MBYGlrVRQOKkx7Kh+Jb6uas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Parkin <julian.parkin@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 071/144] drm/amd/display: Fix dc_create failure handling and 666 color depths
Date:   Wed, 14 Aug 2019 19:00:27 +0200
Message-Id: <20190814165802.821915294@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 6ad7b54812f1c..b2525ab8a95f6 100644
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



