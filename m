Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE264259687
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgIAQDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:03:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731565AbgIAPmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:42:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 055E92064B;
        Tue,  1 Sep 2020 15:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974954;
        bh=hEcf91JbzgPXRuztevJtJxtp78NU32tVPVA7ZRUoHnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=REPgVan5/Q6Rt1Oq2idcuIrKb4w5nba6deQdQXHzhMO+s6skHdRD47/9OZ176YHQc
         pvhthVi37NyLxw7wWFPFvyxWS5Qhm0rDPT+3Puw3eUEbfml6ARtPk4EWfxpTNuTNGK
         z98qu/dpcu2oWVNxUhWoDgbH5o/u2e6We7D+muPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Koo <Anthony.Koo@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 124/255] drm/amd/display: Fix LFC multiplier changing erratically
Date:   Tue,  1 Sep 2020 17:09:40 +0200
Message-Id: <20200901151006.670575737@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Koo <Anthony.Koo@amd.com>

[ Upstream commit e4ed4dbbc8383d42a197da8fe7ca6434b0f14def ]

[Why]
1. There is a calculation that is using frame_time_in_us instead of
last_render_time_in_us to calculate whether choosing an LFC multiplier
would cause the inserted frame duration to be outside of range.

2. We do not handle unsigned integer subtraction correctly and it underflows
to a really large value, which causes some logic errors.

[How]
1. Fix logic to calculate 'within range' using last_render_time_in_us
2. Split out delta_from_mid_point_delta_in_us calculation to ensure
we don't underflow and wrap around

Signed-off-by: Anthony Koo <Anthony.Koo@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/modules/freesync/freesync.c   | 36 +++++++++++++++----
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
index eb7421e83b865..23a7fa8447e24 100644
--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -324,22 +324,44 @@ static void apply_below_the_range(struct core_freesync *core_freesync,
 
 		/* Choose number of frames to insert based on how close it
 		 * can get to the mid point of the variable range.
+		 *  - Delta for CEIL: delta_from_mid_point_in_us_1
+		 *  - Delta for FLOOR: delta_from_mid_point_in_us_2
 		 */
-		if ((frame_time_in_us / mid_point_frames_ceil) > in_out_vrr->min_duration_in_us &&
-				(delta_from_mid_point_in_us_1 < delta_from_mid_point_in_us_2 ||
-						mid_point_frames_floor < 2)) {
+		if ((last_render_time_in_us / mid_point_frames_ceil) < in_out_vrr->min_duration_in_us) {
+			/* Check for out of range.
+			 * If using CEIL produces a value that is out of range,
+			 * then we are forced to use FLOOR.
+			 */
+			frames_to_insert = mid_point_frames_floor;
+		} else if (mid_point_frames_floor < 2) {
+			/* Check if FLOOR would result in non-LFC. In this case
+			 * choose to use CEIL
+			 */
+			frames_to_insert = mid_point_frames_ceil;
+		} else if (delta_from_mid_point_in_us_1 < delta_from_mid_point_in_us_2) {
+			/* If choosing CEIL results in a frame duration that is
+			 * closer to the mid point of the range.
+			 * Choose CEIL
+			 */
 			frames_to_insert = mid_point_frames_ceil;
-			delta_from_mid_point_delta_in_us = delta_from_mid_point_in_us_2 -
-					delta_from_mid_point_in_us_1;
 		} else {
+			/* If choosing FLOOR results in a frame duration that is
+			 * closer to the mid point of the range.
+			 * Choose FLOOR
+			 */
 			frames_to_insert = mid_point_frames_floor;
-			delta_from_mid_point_delta_in_us = delta_from_mid_point_in_us_1 -
-					delta_from_mid_point_in_us_2;
 		}
 
 		/* Prefer current frame multiplier when BTR is enabled unless it drifts
 		 * too far from the midpoint
 		 */
+		if (delta_from_mid_point_in_us_1 < delta_from_mid_point_in_us_2) {
+			delta_from_mid_point_delta_in_us = delta_from_mid_point_in_us_2 -
+					delta_from_mid_point_in_us_1;
+		} else {
+			delta_from_mid_point_delta_in_us = delta_from_mid_point_in_us_1 -
+					delta_from_mid_point_in_us_2;
+		}
 		if (in_out_vrr->btr.frames_to_insert != 0 &&
 				delta_from_mid_point_delta_in_us < BTR_DRIFT_MARGIN) {
 			if (((last_render_time_in_us / in_out_vrr->btr.frames_to_insert) <
-- 
2.25.1



