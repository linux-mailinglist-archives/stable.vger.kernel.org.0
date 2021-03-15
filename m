Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCF133B976
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhCOODl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:03:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232682AbhCON73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FDEE64F16;
        Mon, 15 Mar 2021 13:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816747;
        bh=UWwf6mHVLs6wGSUeMLjotUEF1oBPx5mwMHImwqMUhF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g44IHujYxePsdvCPVTIu+75Raix2NlFepBCO5gDm41WalR4nnlAKS8GbgpzyV3OpH
         k4miZ05Kj15iEG6lhmoVE14JjQWMksUpCxUpewuEojhev8aVS9UZATExTyJUoSjJr4
         rd42ieDiNuIGyiRhK9+gY14vAAGDNnqGvLgHY+ck=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 091/290] drm/amdgpu/display: handle aux backlight in backlight_get_brightness
Date:   Mon, 15 Mar 2021 14:53:04 +0100
Message-Id: <20210315135544.988823073@linuxfoundation.org>
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

commit 0ad3e64eb46d8c47de3af552e282894e3893e973 upstream.

Need to fetch it via aux.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   24 ++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3116,11 +3116,27 @@ static int amdgpu_dm_backlight_update_st
 static int amdgpu_dm_backlight_get_brightness(struct backlight_device *bd)
 {
 	struct amdgpu_display_manager *dm = bl_get_data(bd);
-	int ret = dc_link_get_backlight_level(dm->backlight_link);
+	struct amdgpu_dm_backlight_caps caps;
 
-	if (ret == DC_ERROR_UNEXPECTED)
-		return bd->props.brightness;
-	return convert_brightness_to_user(&dm->backlight_caps, ret);
+	amdgpu_dm_update_backlight_caps(dm);
+	caps = dm->backlight_caps;
+
+	if (caps.aux_support) {
+		struct dc_link *link = (struct dc_link *)dm->backlight_link;
+		u32 avg, peak;
+		bool rc;
+
+		rc = dc_link_get_backlight_level_nits(link, &avg, &peak);
+		if (!rc)
+			return bd->props.brightness;
+		return convert_brightness_to_user(&caps, avg);
+	} else {
+		int ret = dc_link_get_backlight_level(dm->backlight_link);
+
+		if (ret == DC_ERROR_UNEXPECTED)
+			return bd->props.brightness;
+		return convert_brightness_to_user(&caps, ret);
+	}
 }
 
 static const struct backlight_ops amdgpu_dm_backlight_ops = {


