Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25894795C7
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389248AbfG2Tp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389732AbfG2Tp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:45:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 924CF2171F;
        Mon, 29 Jul 2019 19:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429556;
        bh=NljQuSTzO2M/JfMc0jAmcqezMEWVRtpAYocA8vn465Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mC1GbWLMIZat00zSifSOG3KRw2XE3DQWso6Nc6BLgSueU49hZjeNLjeivMiOOtIgC
         xNkoD27tA4S3QRjsZX2O9UKU57czJm3KLi5IBZ7Vk3NGeyZoxQeyzvGy1bxD1yshEA
         QkUSVnadQ8T9lIykU8oVI6WKflHUbt2Rp8A87ZB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Koo <anthony.koo@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 021/215] drm/amd/display: fix multi display seamless boot case
Date:   Mon, 29 Jul 2019 21:20:17 +0200
Message-Id: <20190729190743.425605466@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



