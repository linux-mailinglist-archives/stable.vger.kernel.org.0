Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B87106D9A8
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 05:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfGSD5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727356AbfGSD5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:57:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8EE921852;
        Fri, 19 Jul 2019 03:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508650;
        bh=oZq74vOU69k95kJgkuxq8/TZXIrComA3tcoACkgcGz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ovkiMuWlOdx5taxJj1PjkknHXxKMKOTShefC/J+8Mua4jfONv4lTcyAPDJiliyB4W
         zm4XpktlqWDPZ5+6KCNlMKTriBLaWGv8/w+mMG16h2+XHAQxLChys5DhCXSlGUa7es
         zdJKDnKWu6BWvRct4g0AyfH0p8+rkmoOjQLQmN1Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Koo <anthony.koo@amd.com>, Aric Cyr <Aric.Cyr@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 019/171] drm/amd/display: fix multi display seamless boot case
Date:   Thu, 18 Jul 2019 23:54:10 -0400
Message-Id: <20190719035643.14300-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Koo <anthony.koo@amd.com>

[ Upstream commit 4cd75ff096f4ef49c343093b52a952f27aba7796 ]

[Why]
There is a scenario that causes eDP to become blank if
there are multiple displays connected, and the external
display is set as the primary display such that the first
flip comes to the external display.

In this scenario, we call our optimize function before
the eDP even has a chance to flip.

[How]
There is a check that prevents bandwidth optimize from
occurring before first flip is complete on the seamless boot
display.
But actually it assumed the seamless boot display is the
first one to flip. But in this scenario it is not.
Modify the check to ensure the steam with the seamless
boot flag set is the one that has completed the first flip.

Signed-off-by: Anthony Koo <anthony.koo@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 18c775a950cc..ee6b646180b6 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1138,9 +1138,6 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 		const struct dc_link *link = context->streams[i]->link;
 		struct dc_stream_status *status;
 
-		if (context->streams[i]->apply_seamless_boot_optimization)
-			context->streams[i]->apply_seamless_boot_optimization = false;
-
 		if (!context->streams[i]->mode_changed)
 			continue;
 
@@ -1792,10 +1789,15 @@ static void commit_planes_for_stream(struct dc *dc,
 	if (dc->optimize_seamless_boot && surface_count > 0) {
 		/* Optimize seamless boot flag keeps clocks and watermarks high until
 		 * first flip. After first flip, optimization is required to lower
-		 * bandwidth.
+		 * bandwidth. Important to note that it is expected UEFI will
+		 * only light up a single display on POST, therefore we only expect
+		 * one stream with seamless boot flag set.
 		 */
-		dc->optimize_seamless_boot = false;
-		dc->optimized_required = true;
+		if (stream->apply_seamless_boot_optimization) {
+			stream->apply_seamless_boot_optimization = false;
+			dc->optimize_seamless_boot = false;
+			dc->optimized_required = true;
+		}
 	}
 
 	if (update_type == UPDATE_TYPE_FULL && !dc->optimize_seamless_boot) {
-- 
2.20.1

