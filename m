Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C0F33B884
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbhCOODq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:03:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229921AbhCON72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C4D864EF0;
        Mon, 15 Mar 2021 13:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816744;
        bh=06ZtyBjxsJP3AMFbEfc/g4O17r9BXDPGkX0QoBvbe7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCJcBBqRYSPfHcEfcc1zelGUIhsHcMVjY5PSLwK6lnhb/NSkqMpcQiM0tki0Y8XT+
         jUyeSAQq4seGtViig4E9E7oTz8VPVq8KqYIFRFsr+ZIzFAuVWjKA4TJ6SlXhmQCHGI
         bq141UhzJev3DeycV39eVRYyHxKKWxFWAtrnDuMU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 089/290] drm/amdgpu/display: simplify backlight setting
Date:   Mon, 15 Mar 2021 14:53:02 +0100
Message-Id: <20210315135544.926379220@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Alex Deucher <alexander.deucher@amd.com>

commit a2f8d988698d7d3645b045f4940415b045140b81 upstream.

Avoid the extra wrapper function.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3043,19 +3043,6 @@ static void amdgpu_dm_update_backlight_c
 #endif
 }
 
-static int set_backlight_via_aux(struct dc_link *link, uint32_t brightness)
-{
-	bool rc;
-
-	if (!link)
-		return 1;
-
-	rc = dc_link_set_backlight_level_nits(link, true, brightness,
-					      AUX_BL_DEFAULT_TRANSITION_TIME_MS);
-
-	return rc ? 0 : 1;
-}
-
 static int get_brightness_range(const struct amdgpu_dm_backlight_caps *caps,
 				unsigned *min, unsigned *max)
 {
@@ -3118,9 +3105,10 @@ static int amdgpu_dm_backlight_update_st
 	brightness = convert_brightness_from_user(&caps, bd->props.brightness);
 	// Change brightness based on AUX property
 	if (caps.aux_support)
-		return set_backlight_via_aux(link, brightness);
-
-	rc = dc_link_set_backlight_level(dm->backlight_link, brightness, 0);
+		rc = dc_link_set_backlight_level_nits(link, true, brightness,
+						      AUX_BL_DEFAULT_TRANSITION_TIME_MS);
+	else
+		rc = dc_link_set_backlight_level(dm->backlight_link, brightness, 0);
 
 	return rc ? 0 : 1;
 }


