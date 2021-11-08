Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E83D44A1CA
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241877AbhKIBMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:40458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241716AbhKIBKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:10:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6502561A82;
        Tue,  9 Nov 2021 01:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419872;
        bh=PR04EHp9ht0KlBfyLYWXUAQEfCqZRW6C1ZK/BOuewmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSr5dmAHE10ngCOf87BKQAUeTBf00ykCmWBPG0wnIpK+vh69+tYrP99NbrekQGlFH
         l7mXDwKOYTitQbZdiJIUlqqMh7/MzJ/dJFyf2OQXIyvn8XCOS4CzJ7YahbaSIOHHnq
         IWwszGDJeJZKlFTQEIOKCfP7WjBTKoSO36pKYiv3CJk3u95WHJ3sjHOW8DMLPYDFu5
         rO0QcXr88hiWwp576UPeyVh7Wqix0ggo9T7WezkJr2Cwg+23mtny5l0rlPMWf4KfGj
         Yaz1BlBN9cHAGPbsWqmE9ZMpYK9dNw3UfMcAiWzfeZwFJxI1ox4OS3vzfTHFVzhOEQ
         GeaNIpAno2IZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Simon Ser <contact@emersion.fr>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 04/74] drm: panel-orientation-quirks: Add quirk for the Samsung Galaxy Book 10.6
Date:   Mon,  8 Nov 2021 12:48:31 -0500
Message-Id: <20211108174942.1189927-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174942.1189927-1-sashal@kernel.org>
References: <20211108174942.1189927-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d662292560c73..b2a650674cd36 100644
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
@@ -237,6 +243,12 @@ static const struct dmi_system_id orientation_data[] = {
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

