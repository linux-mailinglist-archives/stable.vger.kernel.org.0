Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E21715609A
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfFZDnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:43:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbfFZDnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:43:01 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB897214DA;
        Wed, 26 Jun 2019 03:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520580;
        bh=1wsHi0IjxJ2SXkpBDh58k2aubv8o1tUvhUoqVssLEJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXv8rGuNoZ501JQflWwaMaq6iyWowk/oByByptS1Kww306Fee2McKCN7ZYwH2xfQ4
         XPaynL+9rofpaq9pSfJRLhu7B/SVCayzcxRU/vtIoT2s37n7ynNWeakpLFz8qriJJE
         SQR4RnPVeDuXNpk4lcnn1maGVJ97qNp4R7V3QRsA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 37/51] drm: panel-orientation-quirks: Add quirk for GPD MicroPC
Date:   Tue, 25 Jun 2019 23:40:53 -0400
Message-Id: <20190626034117.23247-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 652b8b086538c8a10de5aa5cbdaef79333b46358 ]

GPD has done it again, make a nice device (good), use way too generic
DMI strings (bad) and use a portrait screen rotated 90 degrees (ugly).

Because of the too generic DMI strings this entry is also doing bios-date
matching, so the gpd_micropc data struct may very well need to be updated
with some extra bios-dates in the future.

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190524125759.14131-2-hdegoede@redhat.com
(cherry picked from commit f2f2bb60d998abde10de7e483ef9e17639892450)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 019f148d5a78..dd982563304d 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -42,6 +42,14 @@ static const struct drm_dmi_panel_orientation_data asus_t100ha = {
 	.orientation = DRM_MODE_PANEL_ORIENTATION_LEFT_UP,
 };
 
+static const struct drm_dmi_panel_orientation_data gpd_micropc = {
+	.width = 720,
+	.height = 1280,
+	.bios_dates = (const char * const []){ "04/26/2019",
+		NULL },
+	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
+};
+
 static const struct drm_dmi_panel_orientation_data gpd_pocket = {
 	.width = 1200,
 	.height = 1920,
@@ -101,6 +109,14 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "T100HAN"),
 		},
 		.driver_data = (void *)&asus_t100ha,
+	}, {	/* GPD MicroPC (generic strings, also match on bios date) */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Default string"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Default string"),
+		  DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Default string"),
+		  DMI_EXACT_MATCH(DMI_BOARD_NAME, "Default string"),
+		},
+		.driver_data = (void *)&gpd_micropc,
 	}, {	/*
 		 * GPD Pocket, note that the the DMI data is less generic then
 		 * it seems, devices with a board-vendor of "AMI Corporation"
-- 
2.20.1

