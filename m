Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A1DD2542
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388103AbfJJI4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387775AbfJJIrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:47:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AB2C218AC;
        Thu, 10 Oct 2019 08:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697266;
        bh=g1EwKsoWRrIPN9pIi5JHek7BXpKp8hPNF+sPHViPCJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yVFgVeqHqVSBHaMMMVcSgBK6NCukrRb9+DfGN6vD2PX09qP0weYwYmJ/PL2U4vNaw
         y+b9Kv0D/+naohLSXzVUF4euTKge86RaeEbw5LQ47rs3yLo0qkmI6a0trI3Lsj2Odn
         c3uHV/YJJiho52LzyjDEhvfLRA0tUTKkSOr5ffvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/114] drm/radeon: Bail earlier when radeon.cik_/si_support=0 is passed
Date:   Thu, 10 Oct 2019 10:36:24 +0200
Message-Id: <20191010083612.035029947@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 25b5407c74b5a..d83310751a8e4 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -340,8 +340,39 @@ static int radeon_kick_out_firmware_fb(struct pci_dev *pdev)
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
index 6a8fb6fd183c3..3ff835767ac58 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -95,31 +95,6 @@ int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags)
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



