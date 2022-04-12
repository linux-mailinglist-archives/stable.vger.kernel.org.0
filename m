Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE1C4FD397
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 11:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352991AbiDLHqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356750AbiDLHjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422D352B12;
        Tue, 12 Apr 2022 00:10:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73991616B2;
        Tue, 12 Apr 2022 07:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DFBC385A5;
        Tue, 12 Apr 2022 07:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747407;
        bh=smfjITSV1YHK4/bfAMDR+H6NLc2WvBO/3LmrqMnJXJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbSTray6srJJXYmltFOYyt55lObJ/qypjDtiR2R5nLxIrbtKz6uGE9ElSkXdNEp2Z
         9G46+ZKdrypFxf3VlEDWeIjKQuW32/U5phcUw0EpwUKft96aqlex3ZXWSmrFI4PLYK
         Fz1LvSFZDC6ys4y4TIx5kl2e7zuT6K2ypVgsKP9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <philipp.zabel@gmail.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 018/343] drm/edid: improve non-desktop quirk logging
Date:   Tue, 12 Apr 2022 08:27:16 +0200
Message-Id: <20220412062951.631036259@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a71b82668a98..83e5c115e754 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5325,17 +5325,13 @@ u32 drm_add_display_info(struct drm_connector *connector, const struct edid *edi
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
@@ -5356,7 +5352,7 @@ u32 drm_add_display_info(struct drm_connector *connector, const struct edid *edi
 
 	/* Only defined for 1.4 with digital displays */
 	if (edid->revision < 4)
-		return quirks;
+		goto out;
 
 	switch (edid->input & DRM_EDID_DIGITAL_DEPTH_MASK) {
 	case DRM_EDID_DIGITAL_DEPTH_6:
@@ -5393,6 +5389,13 @@ u32 drm_add_display_info(struct drm_connector *connector, const struct edid *edi
 
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
2.35.1



