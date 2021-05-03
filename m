Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD74371B67
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhECQpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232435AbhECQng (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:43:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA6626054E;
        Mon,  3 May 2021 16:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059911;
        bh=GECd6ZWGOLxXk6I6RpW1NsCGUbeOBhdBjmOBiu+231s=;
        h=From:To:Cc:Subject:Date:From;
        b=pzq+/YrTkQXG4EHH+/seJkbOE8ln0XASdtj5ClOUjv6woXX/a00VjVrcGOTJI+0j1
         XlUeSymNYh0fjheEbSsBO5BfplEc94MLqK1tAzizEffYPYEzjTt9BBmn/hqgi84YG9
         Ou9NAmiuk3dk1tIhvYbDWaO1wlJLcyZp2/FRsrUs7bZj66HOw0yjqtyaHLWNLV4Iu1
         NCJHojBRUNoRKByPSfE7KhwORDIRyW70bmexhMSVvDK+6DF121yPehjLNLtrNUKckj
         f+NsbTY26qtpnsmVjNr5Lk48krhZb8fYiuL9oobJeyZAnxtERCrQffEKB+EnBKPvga
         EJOxHUZIqvHUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jared Baldridge <jrb@expunge.us>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 001/100] drm: Added orientation quirk for OneGX1 Pro
Date:   Mon,  3 May 2021 12:36:50 -0400
Message-Id: <20210503163829.2852775-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jared Baldridge <jrb@expunge.us>

[ Upstream commit 81ad7f9f78e4ff80e95be8282423f511b84f1166 ]

The OneGX1 Pro has a fairly unique combination of generic strings,
but we additionally match on the BIOS date just to be safe.

Signed-off-by: Jared Baldridge <jrb@expunge.us>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/41288ccb-1012-486b-81c1-a24c31850c91@www.fastmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 58f5dc2f6dd5..f6bdec7fa925 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -84,6 +84,13 @@ static const struct drm_dmi_panel_orientation_data itworks_tw891 = {
 	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
 };
 
+static const struct drm_dmi_panel_orientation_data onegx1_pro = {
+	.width = 1200,
+	.height = 1920,
+	.bios_dates = (const char * const []){ "12/17/2020", NULL },
+	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
+};
+
 static const struct drm_dmi_panel_orientation_data lcd720x1280_rightside_up = {
 	.width = 720,
 	.height = 1280,
@@ -211,6 +218,13 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad D330-10IGM"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
+	}, {	/* OneGX1 Pro */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "SYSTEM_MANUFACTURER"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "SYSTEM_PRODUCT_NAME"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Default string"),
+		},
+		.driver_data = (void *)&onegx1_pro,
 	}, {	/* VIOS LTH17 */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "VIOS"),
-- 
2.30.2

