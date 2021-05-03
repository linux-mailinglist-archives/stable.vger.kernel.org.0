Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C21D371BF2
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbhECQu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:50:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232267AbhECQrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:47:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69E646162D;
        Mon,  3 May 2021 16:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059984;
        bh=GECd6ZWGOLxXk6I6RpW1NsCGUbeOBhdBjmOBiu+231s=;
        h=From:To:Cc:Subject:Date:From;
        b=XH42oCXmHdWcoOy1Im77xDZfHcHtqLKTWqEzjw3ryI4cIgBN9u5tHZTmLiOSeKdCN
         zkt9AODXgmxeGz5zDtxqsBybXKdesNFlzeVtejefARvgVgYP6eJsaXL/ojJlzePVdi
         1f6XJ3Cz2d6hoMp5QVDKiOH9S1In1j3Ky/pSxQei28VVuLezytaUXAiAcJbFR6z6sQ
         ywqWsXICyLrT9V8KZm5oWtjUcB1tCJehSTSAoIVrhVRZRlze1sxpbBjIMw8xJn/5gs
         EzUKtcJ0QO/Ad7pgl2jNwMTvlAhL1e/aHqcOo5jUGzwcTEm/CxFHQvLR7xIgSC9lq3
         WhBcyexyaiTfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jared Baldridge <jrb@expunge.us>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 01/57] drm: Added orientation quirk for OneGX1 Pro
Date:   Mon,  3 May 2021 12:38:45 -0400
Message-Id: <20210503163941.2853291-1-sashal@kernel.org>
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

