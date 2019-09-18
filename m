Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB6EB5C82
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730446AbfIRG1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730440AbfIRG1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:27:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBABB21906;
        Wed, 18 Sep 2019 06:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788022;
        bh=nyESctKceLsbDVg6I6pgiTVoXe/TTiMVf7zjOgfy6Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGorqigC/JPYJjEFMmbK2Qm4BD7upCmvQPs4kiwplJifhbvTShpSVNrnQv22b7XeN
         ffh4z9Ak+wTKkx4ORxhmhobRm3lHt87EmAn+76aAj8U5PTx6Z73tRxI9wSso806+UK
         vb/vzWwQB3mxNFm9qk7TvY2gGXDRY4z9/HgWIfo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.2 70/85] drm: panel-orientation-quirks: Add extra quirk table entry for GPD MicroPC
Date:   Wed, 18 Sep 2019 08:19:28 +0200
Message-Id: <20190918061237.623948876@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit dae1ccee012ea7514af8e4a88429844157aca7dc upstream.

Newer GPD MicroPC BIOS versions have proper DMI strings, add an extra quirk
table entry for these new strings. This is good news, as this means that we
no longer have to update the BIOS dates list with every BIOS update.

Fixes: 652b8b086538("drm: panel-orientation-quirks: Add quirk for GPD MicroPC")
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190624154014.8557-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_panel_orientation_quirks.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -90,6 +90,12 @@ static const struct drm_dmi_panel_orient
 	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
 };
 
+static const struct drm_dmi_panel_orientation_data lcd720x1280_rightside_up = {
+	.width = 720,
+	.height = 1280,
+	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
+};
+
 static const struct drm_dmi_panel_orientation_data lcd800x1280_rightside_up = {
 	.width = 800,
 	.height = 1280,
@@ -123,6 +129,12 @@ static const struct dmi_system_id orient
 		  DMI_EXACT_MATCH(DMI_BOARD_NAME, "Default string"),
 		},
 		.driver_data = (void *)&gpd_micropc,
+	}, {	/* GPD MicroPC (later BIOS versions with proper DMI strings) */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "GPD"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "MicroPC"),
+		},
+		.driver_data = (void *)&lcd720x1280_rightside_up,
 	}, {	/*
 		 * GPD Pocket, note that the the DMI data is less generic then
 		 * it seems, devices with a board-vendor of "AMI Corporation"


