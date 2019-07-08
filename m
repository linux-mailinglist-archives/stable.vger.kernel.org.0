Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B37B622A1
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389008AbfGHP1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:27:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389028AbfGHP1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:27:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AE9921537;
        Mon,  8 Jul 2019 15:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599639;
        bh=sG0Foj3U+q11NH5M5t+rxF9XnnjNxtXcNZYDCEbC3YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaT1T3BLA8Zs542Ano+gq5a3Mhjf/Hw0uw0DvkJqREDasr/m1PEeTRHJAO3QAJRn4
         tSHdboSOecPhZ6IBma2nQsedIwvdBccMhs8rSPQW6cZ12TQbmaUiPujd+V73W9ATYv
         KZSU91M1J40iWC7ICVyRvOYoOTsj/jRI/q9ZpkbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jurgen Kramer <gtmkramer@xs4all.nl>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/90] drm: panel-orientation-quirks: Add quirk for GPD pocket2
Date:   Mon,  8 Jul 2019 17:12:54 +0200
Message-Id: <20190708150523.979357450@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 15abc7110a77555d3bf72aaef46d1557db0a4ac5 ]

GPD has done it again, make a nice device (good), use way too generic
DMI strings (bad) and use a portrait screen rotated 90 degrees (ugly).

Because of the too generic DMI strings this entry is also doing bios-date
matching, so the gpd_pocket2 data struct may very well need to be updated
with some extra bios-dates in the future.

Changes in v2:
-Add one more known BIOS date to the list of BIOS dates

Cc: Jurgen Kramer <gtmkramer@xs4all.nl>
Reported-by: Jurgen Kramer <gtmkramer@xs4all.nl>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190524125759.14131-1-hdegoede@redhat.com
(cherry picked from commit 6dab9102dd7b144e5723915438e0d6c473018cd0)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index ee4a5e1221f1..088363675940 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -50,6 +50,14 @@ static const struct drm_dmi_panel_orientation_data gpd_pocket = {
 	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
 };
 
+static const struct drm_dmi_panel_orientation_data gpd_pocket2 = {
+	.width = 1200,
+	.height = 1920,
+	.bios_dates = (const char * const []){ "06/28/2018", "08/28/2018",
+		"12/07/2018", NULL },
+	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
+};
+
 static const struct drm_dmi_panel_orientation_data gpd_win = {
 	.width = 720,
 	.height = 1280,
@@ -98,6 +106,14 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Default string"),
 		},
 		.driver_data = (void *)&gpd_pocket,
+	}, {	/* GPD Pocket 2 (generic strings, also match on bios date) */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Default string"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Default string"),
+		  DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Default string"),
+		  DMI_EXACT_MATCH(DMI_BOARD_NAME, "Default string"),
+		},
+		.driver_data = (void *)&gpd_pocket2,
 	}, {	/* GPD Win (same note on DMI match as GPD Pocket) */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
-- 
2.20.1



