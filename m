Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50C144A1BC
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241945AbhKIBL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:11:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242185AbhKIBJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:09:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FAB061A6F;
        Tue,  9 Nov 2021 01:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419869;
        bh=x8J2gIrW8uI3T2QvaNjVhOCRiVSsbbBRWDZBYz0GvM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pbgbs2WLG4hFcLwSj+ueIThqXMWSyu2ULOqrh4c+bIrqValIcbzBUIyDgpI4Orshh
         AL50WNA2bEw67BsbQv2n4dQaSnrR/14Stx01Gp6w0PeHLmciW0oAPckTVU8mJXYjSs
         yGF420saXUFtcQJmW5kirCmtBBBOnxBYN1xiJDvfSho1iMntapHzbc8vlJXoPYKgHF
         xs+tCuUzq2e6Lhq5dhIITzxBkyOMYXyvRKTL4mWUf6a4fjRHTSZqZR0NPzxsSoO5wu
         3EgKD1MWdp+Sr0qxSsVNMQlaeXviBagCvKBIEjOwyr663r457J413v4/cGXCfNIz9K
         OczK7dnVAUd6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Simon Ser <contact@emersion.fr>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 02/74] drm: panel-orientation-quirks: Update the Lenovo Ideapad D330 quirk (v2)
Date:   Mon,  8 Nov 2021 12:48:29 -0500
Message-Id: <20211108174942.1189927-2-sashal@kernel.org>
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

[ Upstream commit 820a2ab23d5eab4ccfb82581eda8ad4acf18458f ]

2 improvements to the Lenovo Ideapad D330 panel-orientation quirks:

1. Some versions of the Lenovo Ideapad D330 have a DMI_PRODUCT_NAME of
"81H3" and others have "81MD". Testing has shown that the "81MD" also has
a 90 degree mounted panel. Drop the DMI_PRODUCT_NAME from the existing
quirk so that the existing quirk matches both variants.

2. Some of the Lenovo Ideapad D330 models have a HD (800x1280) screen
instead of a FHD (1200x1920) screen (both are mounted right-side-up) add
a second Lenovo Ideapad D330 quirk for the HD version.

Changes in v2:
- Add a new quirk for Lenovo Ideapad D330 models with a HD screen instead
  of a FHD screen

Link: https://github.com/systemd/systemd/pull/18884
Acked-by: Simon Ser <contact@emersion.fr>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210530110428.12994-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index f6bdec7fa9253..604535b1c3a95 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -211,10 +211,15 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo MIIX 320-10ICR"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
-	}, {	/* Lenovo Ideapad D330 */
+	}, {	/* Lenovo Ideapad D330-10IGM (HD) */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad D330-10IGM"),
+		},
+		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* Lenovo Ideapad D330-10IGM (FHD) */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "81H3"),
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad D330-10IGM"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
-- 
2.33.0

