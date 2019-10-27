Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEECE67A4
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfJ0VW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728802AbfJ0VW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:22:56 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 742772070B;
        Sun, 27 Oct 2019 21:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211375;
        bh=TYgk3jFPZOvKToNOdidpupw5qei3AAmg3k+MAjGFO4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Six2DzsNAboUL8wQCFMJJjMduc5GcYa+Vz7GJf3GJ3KzqM+JsuuPoj5TErzliUppg
         rZmSWT6/jhpiGYvt/5pSpOZiI1CoufCaCu3LGLNbcsONZ3lgulF+/AZnTRQ+I/Ly/R
         KusNuWvo4hqKE22Dren+s/7jsgySz/jmcQFqflOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.3 127/197] drm/amdgpu: Bail earlier when amdgpu.cik_/si_support is not set to 1
Date:   Sun, 27 Oct 2019 22:00:45 +0100
Message-Id: <20191027203358.587004930@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 984d7a929ad68b7be9990fc9c5cfa5d5c9fc7942 upstream.

Bail from the pci_driver probe function instead of from the drm_driver
load function.

This avoid /dev/dri/card0 temporarily getting registered and then
unregistered again, sending unwanted add / remove udev events to
userspace.

Specifically this avoids triggering the (userspace) bug fixed by this
plymouth merge-request:
https://gitlab.freedesktop.org/plymouth/plymouth/merge_requests/59

Note that despite that being a userspace bug, not sending unnecessary
udev events is a good idea in general.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1490490
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |   35 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c |   35 --------------------------------
 2 files changed, 35 insertions(+), 35 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1030,6 +1030,41 @@ static int amdgpu_pci_probe(struct pci_d
 		return -ENODEV;
 	}
 
+#ifdef CONFIG_DRM_AMDGPU_SI
+	if (!amdgpu_si_support) {
+		switch (flags & AMD_ASIC_MASK) {
+		case CHIP_TAHITI:
+		case CHIP_PITCAIRN:
+		case CHIP_VERDE:
+		case CHIP_OLAND:
+		case CHIP_HAINAN:
+			dev_info(&pdev->dev,
+				 "SI support provided by radeon.\n");
+			dev_info(&pdev->dev,
+				 "Use radeon.si_support=0 amdgpu.si_support=1 to override.\n"
+				);
+			return -ENODEV;
+		}
+	}
+#endif
+#ifdef CONFIG_DRM_AMDGPU_CIK
+	if (!amdgpu_cik_support) {
+		switch (flags & AMD_ASIC_MASK) {
+		case CHIP_KAVERI:
+		case CHIP_BONAIRE:
+		case CHIP_HAWAII:
+		case CHIP_KABINI:
+		case CHIP_MULLINS:
+			dev_info(&pdev->dev,
+				 "CIK support provided by radeon.\n");
+			dev_info(&pdev->dev,
+				 "Use radeon.cik_support=0 amdgpu.cik_support=1 to override.\n"
+				);
+			return -ENODEV;
+		}
+	}
+#endif
+
 	/* Get rid of things like offb */
 	ret = drm_fb_helper_remove_conflicting_pci_framebuffers(pdev, 0, "amdgpudrmfb");
 	if (ret)
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -144,41 +144,6 @@ int amdgpu_driver_load_kms(struct drm_de
 	struct amdgpu_device *adev;
 	int r, acpi_status;
 
-#ifdef CONFIG_DRM_AMDGPU_SI
-	if (!amdgpu_si_support) {
-		switch (flags & AMD_ASIC_MASK) {
-		case CHIP_TAHITI:
-		case CHIP_PITCAIRN:
-		case CHIP_VERDE:
-		case CHIP_OLAND:
-		case CHIP_HAINAN:
-			dev_info(dev->dev,
-				 "SI support provided by radeon.\n");
-			dev_info(dev->dev,
-				 "Use radeon.si_support=0 amdgpu.si_support=1 to override.\n"
-				);
-			return -ENODEV;
-		}
-	}
-#endif
-#ifdef CONFIG_DRM_AMDGPU_CIK
-	if (!amdgpu_cik_support) {
-		switch (flags & AMD_ASIC_MASK) {
-		case CHIP_KAVERI:
-		case CHIP_BONAIRE:
-		case CHIP_HAWAII:
-		case CHIP_KABINI:
-		case CHIP_MULLINS:
-			dev_info(dev->dev,
-				 "CIK support provided by radeon.\n");
-			dev_info(dev->dev,
-				 "Use radeon.cik_support=0 amdgpu.cik_support=1 to override.\n"
-				);
-			return -ENODEV;
-		}
-	}
-#endif
-
 	adev = kzalloc(sizeof(struct amdgpu_device), GFP_KERNEL);
 	if (adev == NULL) {
 		return -ENOMEM;


