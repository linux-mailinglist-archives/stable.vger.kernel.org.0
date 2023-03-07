Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B78E6AEBA1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbjCGRrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbjCGRql (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:46:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E635821A17
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:41:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 656DCCE1C5D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BA0C433D2;
        Tue,  7 Mar 2023 17:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210894;
        bh=s5xNDgT8kC3ed3qLOqVYpAxprENKIvqZW96oK1Jgzes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBTDVSvoDozHKgXOLOW5a4GkWpH+9CgXvwjszWinVxtPi8dJNbZI9YBOm5gyJBVBf
         qk/C1UDhYkLflEf/nYUnHRNwr4iCxdlroHWX1YQArGBmkJbbx8YO6VSXbN/iqLGe8T
         GfMbZhIvE3/NW0GpGsg5FCnmURd14jbLL2l//ckA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Allen Ballway <ballway@chromium.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0687/1001] drm: panel-orientation-quirks: Add quirk for DynaBook K50
Date:   Tue,  7 Mar 2023 17:57:39 +0100
Message-Id: <20230307170051.422779527@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen Ballway <ballway@chromium.org>

[ Upstream commit a3caf7ea0c3d5872ed0f2c51f5476aee0c47a73a ]

Like the ASUS T100HAN for which there is already a quirk,
the DynaBook K50 has a 800x1280 portrait screen mounted
in the tablet part of a landscape oriented 2-in-1.
Update the quirk to be more generic and apply to this device.

Signed-off-by: Allen Ballway <ballway@chromium.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221130170811.1.Iee9a494547541dade9eeee9521cc8b811e76a8a0@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/drm_panel_orientation_quirks.c    | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 23d63a4d42d9c..b409fe256fd0a 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -30,12 +30,6 @@ struct drm_dmi_panel_orientation_data {
 	int orientation;
 };
 
-static const struct drm_dmi_panel_orientation_data asus_t100ha = {
-	.width = 800,
-	.height = 1280,
-	.orientation = DRM_MODE_PANEL_ORIENTATION_LEFT_UP,
-};
-
 static const struct drm_dmi_panel_orientation_data gpd_micropc = {
 	.width = 720,
 	.height = 1280,
@@ -97,6 +91,12 @@ static const struct drm_dmi_panel_orientation_data lcd720x1280_rightside_up = {
 	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
 };
 
+static const struct drm_dmi_panel_orientation_data lcd800x1280_leftside_up = {
+	.width = 800,
+	.height = 1280,
+	.orientation = DRM_MODE_PANEL_ORIENTATION_LEFT_UP,
+};
+
 static const struct drm_dmi_panel_orientation_data lcd800x1280_rightside_up = {
 	.width = 800,
 	.height = 1280,
@@ -157,7 +157,7 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "T100HAN"),
 		},
-		.driver_data = (void *)&asus_t100ha,
+		.driver_data = (void *)&lcd800x1280_leftside_up,
 	}, {	/* Asus T101HA */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
@@ -202,6 +202,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Hi10 pro tablet"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
+	}, {	/* Dynabook K50 */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Dynabook Inc."),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "dynabook K50/FR"),
+		},
+		.driver_data = (void *)&lcd800x1280_leftside_up,
 	}, {	/* GPD MicroPC (generic strings, also match on bios date) */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Default string"),
-- 
2.39.2



