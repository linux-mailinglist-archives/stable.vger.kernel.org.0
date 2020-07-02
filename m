Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2474121196A
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgGBBey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:34:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728410AbgGBBXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE7212088E;
        Thu,  2 Jul 2020 01:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653017;
        bh=YTaFIXKUgmcdP1e9IE1EuXcT+y6FsRB2iZKzwevw40I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFE+0cW5RBNlPt8/ttmNZhznXFnqv/ynMlpUqZTnr1AglOFUZaDkKpdVSiBjjV0CU
         JhHtnSUuYOl2B31rWtemc9tBoCcbQ6nUo98GLFZJHXShbidS0tlaCeh6GzSsQtsF5y
         D3gWAVZDG72s8kLjUSamgGYBT5ZhQ+FX0KH6m8Tw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 34/53] drm: panel-orientation-quirks: Use generic orientation-data for Acer S1003
Date:   Wed,  1 Jul 2020 21:21:43 -0400
Message-Id: <20200702012202.2700645-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a05caf9e62a85d12da27e814ac13195f4683f21c ]

The Acer S1003 has proper DMI strings for sys-vendor and product-name,
so we do not need to match by BIOS-date.

This means that the Acer S1003 can use the generic lcd800x1280_rightside_up
drm_dmi_panel_orientation_data struct which is also used by other quirks.

Reviewed-by: Emil Velikov <emil.l.velikov@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200531093025.28050-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index d11d83703931e..d00ea384dcbfe 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -30,12 +30,6 @@ struct drm_dmi_panel_orientation_data {
 	int orientation;
 };
 
-static const struct drm_dmi_panel_orientation_data acer_s1003 = {
-	.width = 800,
-	.height = 1280,
-	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
-};
-
 static const struct drm_dmi_panel_orientation_data asus_t100ha = {
 	.width = 800,
 	.height = 1280,
@@ -114,7 +108,7 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Acer"),
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "One S1003"),
 		},
-		.driver_data = (void *)&acer_s1003,
+		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/* Asus T100HA */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-- 
2.25.1

