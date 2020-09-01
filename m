Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F81225950A
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731189AbgIAPqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731916AbgIAPqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:46:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2405E2064B;
        Tue,  1 Sep 2020 15:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975159;
        bh=a5zetCsPr03/v7ZDAl30v4VSrPGe+nBSLBcgpDozsvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gf1jd2xRu5zaw8DY/qc/ucrcMaYRT8aRU1l6C4hvMNd89ssZeLFj01eRfb7VrdItg
         gOMaqvU559T5a7Z6eI8tyB67gcfOphHeGapwdMOrqKWDLRz33yDhuhPDT/Br6j42Lb
         bvHsyXSDXpOwn2303+5u5EXhhDzLGrdbevP9bP04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alexander Monakov <amonakov@ispras.ru>
Subject: [PATCH 5.8 215/255] drm/amd/display: use correct scale for actual_brightness
Date:   Tue,  1 Sep 2020 17:11:11 +0200
Message-Id: <20200901151011.006767904@linuxfoundation.org>
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

From: Alexander Monakov <amonakov@ispras.ru>

commit 69d9f4278d0f9d24607645f10e5ac5c59c77a4ac upstream.

Documentation for sysfs backlight level interface requires that
values in both 'brightness' and 'actual_brightness' files are
interpreted to be in range from 0 to the value given in the
'max_brightness' file.

With amdgpu, max_brightness gives 255, and values written by the user
into 'brightness' are internally rescaled to a wider range. However,
reading from 'actual_brightness' gives the raw register value without
inverse rescaling. This causes issues for various userspace tools such
as PowerTop and systemd that expect the value to be in the correct
range.

Introduce a helper to retrieve internal backlight range. Use it to
reimplement 'convert_brightness' as 'convert_brightness_from_user' and
introduce 'convert_brightness_to_user'.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=203905
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1242
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alexander Monakov <amonakov@ispras.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   81 ++++++++++------------
 1 file changed, 40 insertions(+), 41 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2882,51 +2882,50 @@ static int set_backlight_via_aux(struct
 	return rc ? 0 : 1;
 }
 
-static u32 convert_brightness(const struct amdgpu_dm_backlight_caps *caps,
-			      const uint32_t user_brightness)
+static int get_brightness_range(const struct amdgpu_dm_backlight_caps *caps,
+				unsigned *min, unsigned *max)
 {
-	u32 min, max, conversion_pace;
-	u32 brightness = user_brightness;
-
 	if (!caps)
-		goto out;
+		return 0;
 
-	if (!caps->aux_support) {
-		max = caps->max_input_signal;
-		min = caps->min_input_signal;
-		/*
-		 * The brightness input is in the range 0-255
-		 * It needs to be rescaled to be between the
-		 * requested min and max input signal
-		 * It also needs to be scaled up by 0x101 to
-		 * match the DC interface which has a range of
-		 * 0 to 0xffff
-		 */
-		conversion_pace = 0x101;
-		brightness =
-			user_brightness
-			* conversion_pace
-			* (max - min)
-			/ AMDGPU_MAX_BL_LEVEL
-			+ min * conversion_pace;
+	if (caps->aux_support) {
+		// Firmware limits are in nits, DC API wants millinits.
+		*max = 1000 * caps->aux_max_input_signal;
+		*min = 1000 * caps->aux_min_input_signal;
 	} else {
-		/* TODO
-		 * We are doing a linear interpolation here, which is OK but
-		 * does not provide the optimal result. We probably want
-		 * something close to the Perceptual Quantizer (PQ) curve.
-		 */
-		max = caps->aux_max_input_signal;
-		min = caps->aux_min_input_signal;
-
-		brightness = (AMDGPU_MAX_BL_LEVEL - user_brightness) * min
-			       + user_brightness * max;
-		// Multiple the value by 1000 since we use millinits
-		brightness *= 1000;
-		brightness = DIV_ROUND_CLOSEST(brightness, AMDGPU_MAX_BL_LEVEL);
+		// Firmware limits are 8-bit, PWM control is 16-bit.
+		*max = 0x101 * caps->max_input_signal;
+		*min = 0x101 * caps->min_input_signal;
 	}
+	return 1;
+}
+
+static u32 convert_brightness_from_user(const struct amdgpu_dm_backlight_caps *caps,
+					uint32_t brightness)
+{
+	unsigned min, max;
+
+	if (!get_brightness_range(caps, &min, &max))
+		return brightness;
+
+	// Rescale 0..255 to min..max
+	return min + DIV_ROUND_CLOSEST((max - min) * brightness,
+				       AMDGPU_MAX_BL_LEVEL);
+}
+
+static u32 convert_brightness_to_user(const struct amdgpu_dm_backlight_caps *caps,
+				      uint32_t brightness)
+{
+	unsigned min, max;
+
+	if (!get_brightness_range(caps, &min, &max))
+		return brightness;
 
-out:
-	return brightness;
+	if (brightness < min)
+		return 0;
+	// Rescale min..max to 0..255
+	return DIV_ROUND_CLOSEST(AMDGPU_MAX_BL_LEVEL * (brightness - min),
+				 max - min);
 }
 
 static int amdgpu_dm_backlight_update_status(struct backlight_device *bd)
@@ -2942,7 +2941,7 @@ static int amdgpu_dm_backlight_update_st
 
 	link = (struct dc_link *)dm->backlight_link;
 
-	brightness = convert_brightness(&caps, bd->props.brightness);
+	brightness = convert_brightness_from_user(&caps, bd->props.brightness);
 	// Change brightness based on AUX property
 	if (caps.aux_support)
 		return set_backlight_via_aux(link, brightness);
@@ -2959,7 +2958,7 @@ static int amdgpu_dm_backlight_get_brigh
 
 	if (ret == DC_ERROR_UNEXPECTED)
 		return bd->props.brightness;
-	return ret;
+	return convert_brightness_to_user(&dm->backlight_caps, ret);
 }
 
 static const struct backlight_ops amdgpu_dm_backlight_ops = {


