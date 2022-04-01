Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016224EEF64
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346864AbiDAO1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346904AbiDAO1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:27:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2EB26B381;
        Fri,  1 Apr 2022 07:26:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13D41B82501;
        Fri,  1 Apr 2022 14:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553BFC34113;
        Fri,  1 Apr 2022 14:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823159;
        bh=vwcMnsD7Ok9YwEwegpDLQI4p1s8O9QrAaan6MHoLLos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OR1LQUfVSkCRPU+93E05uFbJ41AXDH3mKidd44P+A+cRCohHDdqwZWKZjbPyAncax
         IC7pqZbZbziY/1PG6xFKg0X7+kqwY85/TQRl6s5o0Rh+3krG0u8K5dh/jilpkiwXNI
         RgNGHPfGNTF9XkdqqW/ADAF0SeumDYuFF2sGJUsrRS8iUEOJOMkYcrcKSBiMNKzd+F
         CRRrl5UBSacdr5jbBXqW04unBBW6JBabQoNUgQi+owQn76ySJqlow7M7i8KBtHmBsZ
         aw3LlWfqll+6z9gwwJ31iBv1SmEiaaudRIM/MlPZbmq2wmYbin4/v2Kwtxzkawymnu
         WyLF4HGuGD3qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jani Nikula <jani.nikula@intel.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 008/149] drm/edid: improve non-desktop quirk logging
Date:   Fri,  1 Apr 2022 10:23:15 -0400
Message-Id: <20220401142536.1948161-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit ce99534e978d4a36787dbe5e5c57749d12e6bf4a ]

Improve non-desktop quirk logging if the EDID indicates non-desktop. If
both are set, note about redundant quirk. If there's no quirk but the
EDID indicates non-desktop, don't log non-desktop is set to 0.

Cc: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Philipp Zabel <philipp.zabel@gmail.com>
Tested-by: Philipp Zabel <philipp.zabel@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211228101051.317989-1-jani.nikula@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index e8adfa90807c..e42a15e3f2ab 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5331,17 +5331,13 @@ u32 drm_add_display_info(struct drm_connector *connector, const struct edid *edi
 	info->width_mm = edid->width_cm * 10;
 	info->height_mm = edid->height_cm * 10;
 
-	info->non_desktop = !!(quirks & EDID_QUIRK_NON_DESKTOP);
-
 	drm_get_monitor_range(connector, edid);
 
-	DRM_DEBUG_KMS("non_desktop set to %d\n", info->non_desktop);
-
 	if (edid->revision < 3)
-		return quirks;
+		goto out;
 
 	if (!(edid->input & DRM_EDID_INPUT_DIGITAL))
-		return quirks;
+		goto out;
 
 	info->color_formats |= DRM_COLOR_FORMAT_RGB444;
 	drm_parse_cea_ext(connector, edid);
@@ -5362,7 +5358,7 @@ u32 drm_add_display_info(struct drm_connector *connector, const struct edid *edi
 
 	/* Only defined for 1.4 with digital displays */
 	if (edid->revision < 4)
-		return quirks;
+		goto out;
 
 	switch (edid->input & DRM_EDID_DIGITAL_DEPTH_MASK) {
 	case DRM_EDID_DIGITAL_DEPTH_6:
@@ -5399,6 +5395,13 @@ u32 drm_add_display_info(struct drm_connector *connector, const struct edid *edi
 
 	drm_update_mso(connector, edid);
 
+out:
+	if (quirks & EDID_QUIRK_NON_DESKTOP) {
+		drm_dbg_kms(connector->dev, "Non-desktop display%s\n",
+			    info->non_desktop ? " (redundant quirk)" : "");
+		info->non_desktop = true;
+	}
+
 	return quirks;
 }
 
-- 
2.34.1

