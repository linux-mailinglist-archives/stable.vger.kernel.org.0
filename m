Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD353783D6
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbhEJKrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:47:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233291AbhEJKpf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A0D161995;
        Mon, 10 May 2021 10:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642942;
        bh=GECd6ZWGOLxXk6I6RpW1NsCGUbeOBhdBjmOBiu+231s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BdQQXm696/fkFJ2hC6YFQO0d78Z2ZoEB7OL8Rd48HlTqcumBV7VkoBFRP+VtcWFZP
         i0dMhHRnFoERNpkbamanhPrI2Q64LzmivkDey0JrI0+1v9Y0FWjyvttoM0bDdhJmxt
         e1vbSZX/CtyomF8tjrItV2ppgBUqB62rDcMwv8x8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jared Baldridge <jrb@expunge.us>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/299] drm: Added orientation quirk for OneGX1 Pro
Date:   Mon, 10 May 2021 12:18:30 +0200
Message-Id: <20210510102008.694395810@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



