Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FCF4A8E16
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355067AbiBCUep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:34:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36028 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354857AbiBCUdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:33:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E8D0B835A4;
        Thu,  3 Feb 2022 20:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D347C36AE3;
        Thu,  3 Feb 2022 20:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920398;
        bh=HIPORMFuV//Hr3CiBeB8KOpD7vvvwHqgFISVkSXSIQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6wdKuWck+rRAmYeAQEGIEAyMHlQgQQJVfRfL3wYOPaVw9IjVbvMA/KQqKRnY9GRK
         RBEFJy8R4GESALsUtn4N+x7/YWFOgAF9VrC0k5jgRn0ySdZDI3IKBU8H41VOdQzb4j
         eLLktDL8NeMoo+frDvO3RIYTE9JVuPDd3u8F6CkVSePwx4eYMX5uUh6rKAspLghGHW
         1LtLSdM4l+9LLFFpR5sOhpl2+XIs1hxaGHYTnSiT4rvKf9weQyt0ArZ+1XKtKBaHG0
         H4rfPeocxLHqRviF9GVV+V60EfoyXfIq6H75rsHE2CRD5ei/Qj6IY3hrLV8zIktxfH
         gvnCaopV4oKog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raymond Jay Golo <rjgolo@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 20/41] drm: panel-orientation-quirks: Add quirk for the 1Netbook OneXPlayer
Date:   Thu,  3 Feb 2022 15:32:24 -0500
Message-Id: <20220203203245.3007-20-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raymond Jay Golo <rjgolo@gmail.com>

[ Upstream commit d3cbc6e323c9299d10c8d2e4127c77c7d05d07b1 ]

The 1Netbook OneXPlayer uses a panel which has been mounted
90 degrees rotated. Add a quirk for this.

Signed-off-by: Raymond Jay Golo <rjgolo@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20220113000619.90988-1-rjgolo@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 9d1bd8f491ad7..448c2f2d803a6 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -115,6 +115,12 @@ static const struct drm_dmi_panel_orientation_data lcd1280x1920_rightside_up = {
 	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
 };
 
+static const struct drm_dmi_panel_orientation_data lcd1600x2560_leftside_up = {
+	.width = 1600,
+	.height = 2560,
+	.orientation = DRM_MODE_PANEL_ORIENTATION_LEFT_UP,
+};
+
 static const struct dmi_system_id orientation_data[] = {
 	{	/* Acer One 10 (S1003) */
 		.matches = {
@@ -261,6 +267,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Default string"),
 		},
 		.driver_data = (void *)&onegx1_pro,
+	}, {	/* OneXPlayer */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ONE-NETBOOK TECHNOLOGY CO., LTD."),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "ONE XPLAYER"),
+		},
+		.driver_data = (void *)&lcd1600x2560_leftside_up,
 	}, {	/* Samsung GalaxyBook 10.6 */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-- 
2.34.1

