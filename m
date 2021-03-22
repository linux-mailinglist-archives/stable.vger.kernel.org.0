Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372F4344116
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhCVMah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231148AbhCVMaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:30:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F91360C3D;
        Mon, 22 Mar 2021 12:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416220;
        bh=tsxQnpDRffd3gBbNueiaQHMMdRXQEbgd2XCUXstZ2vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9ZPCYUmUi/opocvfVUDKukD799AQIUKBNAYb7TcoiCveUis2I7sGfB6O/IaN7vx4
         SKu6v45DDdLIiQ76KfXtU8xVK4SlQnQJFffP/WFOkjyYPPauZpBbIeH2GDhAFF1k5w
         vhWzOmiIn2EdFiZ96OWlWZ/kLFPT/v5zOGxmhJK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Calvin Hou <Calvin.Hou@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Krunoslav Kovac <Krunoslav.Kovac@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Vladimir Stempen <Vladimir.Stempen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 024/120] drm/amd/display: Correct algorithm for reversed gamma
Date:   Mon, 22 Mar 2021 13:26:47 +0100
Message-Id: <20210322121930.466921565@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Calvin Hou <Calvin.Hou@amd.com>

commit 34fa493a565cc6fcee6919787c11e264f55603c6 upstream.

[Why]
DCN30 needs to correctly program reversed gamma curve, which DCN20
already has.
Also needs to fix a bug that 252-255 values are clipped.

[How]
Apply two fixes into DCN30.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1513
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Calvin Hou <Calvin.Hou@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Reviewed-by: Krunoslav Kovac <Krunoslav.Kovac@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Acked-by: Vladimir Stempen <Vladimir.Stempen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c |   26 +++++++++++------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
@@ -113,6 +113,7 @@ bool cm3_helper_translate_curve_to_hw_fo
 	struct pwl_result_data *rgb_resulted;
 	struct pwl_result_data *rgb;
 	struct pwl_result_data *rgb_plus_1;
+	struct pwl_result_data *rgb_minus_1;
 	struct fixed31_32 end_value;
 
 	int32_t region_start, region_end;
@@ -140,7 +141,7 @@ bool cm3_helper_translate_curve_to_hw_fo
 		region_start = -MAX_LOW_POINT;
 		region_end   = NUMBER_REGIONS - MAX_LOW_POINT;
 	} else {
-		/* 10 segments
+		/* 11 segments
 		 * segment is from 2^-10 to 2^0
 		 * There are less than 256 points, for optimization
 		 */
@@ -154,9 +155,10 @@ bool cm3_helper_translate_curve_to_hw_fo
 		seg_distr[7] = 4;
 		seg_distr[8] = 4;
 		seg_distr[9] = 4;
+		seg_distr[10] = 1;
 
 		region_start = -10;
-		region_end = 0;
+		region_end = 1;
 	}
 
 	for (i = region_end - region_start; i < MAX_REGIONS_NUMBER ; i++)
@@ -189,6 +191,10 @@ bool cm3_helper_translate_curve_to_hw_fo
 	rgb_resulted[hw_points - 1].green = output_tf->tf_pts.green[start_index];
 	rgb_resulted[hw_points - 1].blue = output_tf->tf_pts.blue[start_index];
 
+	rgb_resulted[hw_points].red = rgb_resulted[hw_points - 1].red;
+	rgb_resulted[hw_points].green = rgb_resulted[hw_points - 1].green;
+	rgb_resulted[hw_points].blue = rgb_resulted[hw_points - 1].blue;
+
 	// All 3 color channels have same x
 	corner_points[0].red.x = dc_fixpt_pow(dc_fixpt_from_int(2),
 					     dc_fixpt_from_int(region_start));
@@ -259,15 +265,18 @@ bool cm3_helper_translate_curve_to_hw_fo
 
 	rgb = rgb_resulted;
 	rgb_plus_1 = rgb_resulted + 1;
+	rgb_minus_1 = rgb;
 
 	i = 1;
 	while (i != hw_points + 1) {
-		if (dc_fixpt_lt(rgb_plus_1->red, rgb->red))
-			rgb_plus_1->red = rgb->red;
-		if (dc_fixpt_lt(rgb_plus_1->green, rgb->green))
-			rgb_plus_1->green = rgb->green;
-		if (dc_fixpt_lt(rgb_plus_1->blue, rgb->blue))
-			rgb_plus_1->blue = rgb->blue;
+		if (i >= hw_points - 1) {
+			if (dc_fixpt_lt(rgb_plus_1->red, rgb->red))
+				rgb_plus_1->red = dc_fixpt_add(rgb->red, rgb_minus_1->delta_red);
+			if (dc_fixpt_lt(rgb_plus_1->green, rgb->green))
+				rgb_plus_1->green = dc_fixpt_add(rgb->green, rgb_minus_1->delta_green);
+			if (dc_fixpt_lt(rgb_plus_1->blue, rgb->blue))
+				rgb_plus_1->blue = dc_fixpt_add(rgb->blue, rgb_minus_1->delta_blue);
+		}
 
 		rgb->delta_red   = dc_fixpt_sub(rgb_plus_1->red,   rgb->red);
 		rgb->delta_green = dc_fixpt_sub(rgb_plus_1->green, rgb->green);
@@ -283,6 +292,7 @@ bool cm3_helper_translate_curve_to_hw_fo
 		}
 
 		++rgb_plus_1;
+		rgb_minus_1 = rgb;
 		++rgb;
 		++i;
 	}


