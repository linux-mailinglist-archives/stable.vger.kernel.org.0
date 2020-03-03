Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6F7178038
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732716AbgCCRz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:55:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732713AbgCCRz1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:55:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C58D2072D;
        Tue,  3 Mar 2020 17:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258126;
        bh=4tOmSmVMe3mvmllK6G1Y4slRC9SU/jQaGPx0xsYACAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YqLUnBvv6HYLLlkhZ78QE9kVYC3uJiUyKvcAgiGzzmeYfZYCALdZtLK5kluerNcga
         ZMjIqGIkZhYsl7xL59bzxi2peo5JePRklkZ4xn3tM1njblFoh40QzfTaVOgItRtMKP
         IuDqkPcJWlO50aDvhFLyYtjozK0DZ7P6OLsT+yS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "David (ChunMing) Zhou" <David1.Zhou@amd.com>,
        amd-gfx@lists.freedesktop.org,
        Emil Velikov <emil.velikov@collabora.com>
Subject: [PATCH 5.4 080/152] drm/radeon: Inline drm_get_pci_dev
Date:   Tue,  3 Mar 2020 18:42:58 +0100
Message-Id: <20200303174311.613425292@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit eb12c957735b582607e5842a06d1f4c62e185c1d upstream.

It's the last user, and more importantly, it's the last non-legacy
user of anything in drm_pci.c.

The only tricky bit is the agp initialization. But a close look shows
that radeon does not use the drm_agp midlayer (the main use of that is
drm_bufs for legacy drivers), and instead could use the agp subsystem
directly (like nouveau does already). Hence we can just pull this in
too.

A further step would be to entirely drop the use of drm_device->agp,
but feels like too much churn just for this patch.

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: "David (ChunMing) Zhou" <David1.Zhou@amd.com>
Cc: amd-gfx@lists.freedesktop.org
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Emil Velikov <emil.velikov@collabora.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_drv.c |   43 ++++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/radeon/radeon_kms.c |    6 +++++
 2 files changed, 47 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -37,6 +37,7 @@
 #include <linux/vga_switcheroo.h>
 #include <linux/mmu_notifier.h>
 
+#include <drm/drm_agpsupport.h>
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_fb_helper.h>
@@ -325,6 +326,7 @@ static int radeon_pci_probe(struct pci_d
 			    const struct pci_device_id *ent)
 {
 	unsigned long flags = 0;
+	struct drm_device *dev;
 	int ret;
 
 	if (!ent)
@@ -365,7 +367,44 @@ static int radeon_pci_probe(struct pci_d
 	if (ret)
 		return ret;
 
-	return drm_get_pci_dev(pdev, ent, &kms_driver);
+	dev = drm_dev_alloc(&kms_driver, &pdev->dev);
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		goto err_free;
+
+	dev->pdev = pdev;
+#ifdef __alpha__
+	dev->hose = pdev->sysdata;
+#endif
+
+	pci_set_drvdata(pdev, dev);
+
+	if (pci_find_capability(dev->pdev, PCI_CAP_ID_AGP))
+		dev->agp = drm_agp_init(dev);
+	if (dev->agp) {
+		dev->agp->agp_mtrr = arch_phys_wc_add(
+			dev->agp->agp_info.aper_base,
+			dev->agp->agp_info.aper_size *
+			1024 * 1024);
+	}
+
+	ret = drm_dev_register(dev, ent->driver_data);
+	if (ret)
+		goto err_agp;
+
+	return 0;
+
+err_agp:
+	if (dev->agp)
+		arch_phys_wc_del(dev->agp->agp_mtrr);
+	kfree(dev->agp);
+	pci_disable_device(pdev);
+err_free:
+	drm_dev_put(dev);
+	return ret;
 }
 
 static void
@@ -578,7 +617,7 @@ radeon_get_crtc_scanout_position(struct
 
 static struct drm_driver kms_driver = {
 	.driver_features =
-	    DRIVER_USE_AGP | DRIVER_GEM | DRIVER_RENDER,
+	    DRIVER_GEM | DRIVER_RENDER,
 	.load = radeon_driver_load_kms,
 	.open = radeon_driver_open_kms,
 	.postclose = radeon_driver_postclose_kms,
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -31,6 +31,7 @@
 #include <linux/uaccess.h>
 #include <linux/vga_switcheroo.h>
 
+#include <drm/drm_agpsupport.h>
 #include <drm/drm_fb_helper.h>
 #include <drm/drm_file.h>
 #include <drm/drm_ioctl.h>
@@ -77,6 +78,11 @@ void radeon_driver_unload_kms(struct drm
 	radeon_modeset_fini(rdev);
 	radeon_device_fini(rdev);
 
+	if (dev->agp)
+		arch_phys_wc_del(dev->agp->agp_mtrr);
+	kfree(dev->agp);
+	dev->agp = NULL;
+
 done_free:
 	kfree(rdev);
 	dev->dev_private = NULL;


