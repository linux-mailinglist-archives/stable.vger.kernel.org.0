Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2FFC3D59
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbfJAQlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730814AbfJAQlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:41:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F37EF21924;
        Tue,  1 Oct 2019 16:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948078;
        bh=o4RGWiH6oPbtLY4bWIZ3b6R3x0ifsch3zIJ7Q8PddEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1UW0umKNCLdIAYsqgDUQa1vl1/R9zovs6WELw51y4nH4z+xP81ePP+yQN3qlr+z2
         avUFx9VUSxSjoEXVpxt0KzVIY+zt6ytxg+POx8U3hqahEP6utgcvVLCbF8TMSzq3+/
         1ptXtmSoIw9NrdGBenAPtfFgt6M2hvzFLuESC0v8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 68/71] drm/radeon: Bail earlier when radeon.cik_/si_support=0 is passed
Date:   Tue,  1 Oct 2019 12:39:18 -0400
Message-Id: <20191001163922.14735-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 9dbc88d013b79c62bd845cb9e7c0256e660967c5 ]

Bail from the pci_driver probe function instead of from the drm_driver
load function.

This avoid /dev/dri/card0 temporarily getting registered and then
unregistered again, sending unwanted add / remove udev events to
userspace.

Specifically this avoids triggering the (userspace) bug fixed by this
plymouth merge-request:
https://gitlab.freedesktop.org/plymouth/plymouth/merge_requests/59

Note that despite that being an userspace bug, not sending unnecessary
udev events is a good idea in general.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1490490
Reviewed-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_drv.c | 31 +++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_kms.c | 25 -----------------------
 2 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index a6cbe11f79c61..7033f3a38c878 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -325,8 +325,39 @@ bool radeon_device_is_virtual(void);
 static int radeon_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *ent)
 {
+	unsigned long flags = 0;
 	int ret;
 
+	if (!ent)
+		return -ENODEV; /* Avoid NULL-ptr deref in drm_get_pci_dev */
+
+	flags = ent->driver_data;
+
+	if (!radeon_si_support) {
+		switch (flags & RADEON_FAMILY_MASK) {
+		case CHIP_TAHITI:
+		case CHIP_PITCAIRN:
+		case CHIP_VERDE:
+		case CHIP_OLAND:
+		case CHIP_HAINAN:
+			dev_info(&pdev->dev,
+				 "SI support disabled by module param\n");
+			return -ENODEV;
+		}
+	}
+	if (!radeon_cik_support) {
+		switch (flags & RADEON_FAMILY_MASK) {
+		case CHIP_KAVERI:
+		case CHIP_BONAIRE:
+		case CHIP_HAWAII:
+		case CHIP_KABINI:
+		case CHIP_MULLINS:
+			dev_info(&pdev->dev,
+				 "CIK support disabled by module param\n");
+			return -ENODEV;
+		}
+	}
+
 	if (vga_switcheroo_client_probe_defer(pdev))
 		return -EPROBE_DEFER;
 
diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 07f7ace42c4ba..e85c554eeaa94 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -100,31 +100,6 @@ int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags)
 	struct radeon_device *rdev;
 	int r, acpi_status;
 
-	if (!radeon_si_support) {
-		switch (flags & RADEON_FAMILY_MASK) {
-		case CHIP_TAHITI:
-		case CHIP_PITCAIRN:
-		case CHIP_VERDE:
-		case CHIP_OLAND:
-		case CHIP_HAINAN:
-			dev_info(dev->dev,
-				 "SI support disabled by module param\n");
-			return -ENODEV;
-		}
-	}
-	if (!radeon_cik_support) {
-		switch (flags & RADEON_FAMILY_MASK) {
-		case CHIP_KAVERI:
-		case CHIP_BONAIRE:
-		case CHIP_HAWAII:
-		case CHIP_KABINI:
-		case CHIP_MULLINS:
-			dev_info(dev->dev,
-				 "CIK support disabled by module param\n");
-			return -ENODEV;
-		}
-	}
-
 	rdev = kzalloc(sizeof(struct radeon_device), GFP_KERNEL);
 	if (rdev == NULL) {
 		return -ENOMEM;
-- 
2.20.1

