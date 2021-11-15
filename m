Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D913450FD9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242464AbhKOShB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:37:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:42400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242356AbhKOSfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:35:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A53D61C14;
        Mon, 15 Nov 2021 18:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999313;
        bh=h/Qv0gdg233kt+NKGH31/IuhY5AlguPK5AGf8Iou0SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXA8prWlatt0tYNRGEBv4rhgAlaKVXTEp1sWzkrlg5AuYGJ0nNo6/HmfbC0JQ8T18
         U1nqWLfq/16LZ30dabMqRj9VLBQVXMH2TobZvf01RSrzFzdBFXalDCujLYuKm2RXv2
         opbJCDoT99b6Y0Lmw+KAj9gTYtAGnUz8TocZsx4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Simon Ser <contact@emersion.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 208/849] drm: panel-orientation-quirks: Add quirk for the Samsung Galaxy Book 10.6
Date:   Mon, 15 Nov 2021 17:54:51 +0100
Message-Id: <20211115165427.248114165@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 88fa1fde918951c175ae5ea0f31efc4bb1736ab9 ]

The Samsung Galaxy Book 10.6 uses a panel which has been mounted
90 degrees rotated. Add a quirk for this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20210530110428.12994-4-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index cf4db2cdebbbd..926094b83e2f4 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -109,6 +109,12 @@ static const struct drm_dmi_panel_orientation_data lcd1200x1920_rightside_up = {
 	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
 };
 
+static const struct drm_dmi_panel_orientation_data lcd1280x1920_rightside_up = {
+	.width = 1280,
+	.height = 1920,
+	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
+};
+
 static const struct dmi_system_id orientation_data[] = {
 	{	/* Acer One 10 (S1003) */
 		.matches = {
@@ -249,6 +255,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Default string"),
 		},
 		.driver_data = (void *)&onegx1_pro,
+	}, {	/* Samsung GalaxyBook 10.6 */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Galaxy Book 10.6"),
+		},
+		.driver_data = (void *)&lcd1280x1920_rightside_up,
 	}, {	/* VIOS LTH17 */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "VIOS"),
-- 
2.33.0



