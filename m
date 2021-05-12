Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4D637C51C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhELPiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233830AbhELP3P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:29:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C3E361943;
        Wed, 12 May 2021 15:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832527;
        bh=tphvhTzPs2mQoPf0LroDP7r77qvJbG8SL36O/m5brLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBKM4iSoiJL3bEKxEB3FobTJH7V8/sbLZGxB+E6mrazCW7FCmIFjiBMuV+bWPF9Py
         03F22raWMTZzjRLxB5CzL6h+w1JrkG+jODjkvgz9BtuRmZjGaZqKKHTVCDvXWDv07h
         uOzZNUU0G4o2lgN0/6v+82zbl4u06voxBYcSh6J8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Diana Craciun OSS <diana.craciun@oss.nxp.com>
Subject: [PATCH 5.10 316/530] vfio/fsl-mc: Re-order vfio_fsl_mc_probe()
Date:   Wed, 12 May 2021 16:47:06 +0200
Message-Id: <20210512144830.192793379@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 2b1fe162e584a88ec7f12a651a2a50f94dd8cfac ]

vfio_add_group_dev() must be called only after all of the private data in
vdev is fully setup and ready, otherwise there could be races with user
space instantiating a device file descriptor and starting to call ops.

For instance vfio_fsl_mc_reflck_attach() sets vdev->reflck and
vfio_fsl_mc_open(), called by fops open, unconditionally derefs it, which
will crash if things get out of order.

This driver started life with the right sequence, but two commits added
stuff after vfio_add_group_dev().

Fixes: 2e0d29561f59 ("vfio/fsl-mc: Add irq infrastructure for fsl-mc devices")
Fixes: f2ba7e8c947b ("vfio/fsl-mc: Added lock support in preparation for interrupt handling")
Co-developed-by: Diana Craciun OSS <diana.craciun@oss.nxp.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Message-Id: <5-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 74 ++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 27 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index f27e25112c40..8722f5effacd 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -568,23 +568,39 @@ static int vfio_fsl_mc_init_device(struct vfio_fsl_mc_device *vdev)
 		dev_err(&mc_dev->dev, "VFIO_FSL_MC: Failed to setup DPRC (%d)\n", ret);
 		goto out_nc_unreg;
 	}
+	return 0;
+
+out_nc_unreg:
+	bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
+	return ret;
+}
 
+static int vfio_fsl_mc_scan_container(struct fsl_mc_device *mc_dev)
+{
+	int ret;
+
+	/* non dprc devices do not scan for other devices */
+	if (!is_fsl_mc_bus_dprc(mc_dev))
+		return 0;
 	ret = dprc_scan_container(mc_dev, false);
 	if (ret) {
-		dev_err(&mc_dev->dev, "VFIO_FSL_MC: Container scanning failed (%d)\n", ret);
-		goto out_dprc_cleanup;
+		dev_err(&mc_dev->dev,
+			"VFIO_FSL_MC: Container scanning failed (%d)\n", ret);
+		dprc_remove_devices(mc_dev, NULL, 0);
+		return ret;
 	}
-
 	return 0;
+}
+
+static void vfio_fsl_uninit_device(struct vfio_fsl_mc_device *vdev)
+{
+	struct fsl_mc_device *mc_dev = vdev->mc_dev;
+
+	if (!is_fsl_mc_bus_dprc(mc_dev))
+		return;
 
-out_dprc_cleanup:
-	dprc_remove_devices(mc_dev, NULL, 0);
 	dprc_cleanup(mc_dev);
-out_nc_unreg:
 	bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
-	vdev->nb.notifier_call = NULL;
-
-	return ret;
 }
 
 static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
@@ -607,29 +623,39 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 	}
 
 	vdev->mc_dev = mc_dev;
-
-	ret = vfio_add_group_dev(dev, &vfio_fsl_mc_ops, vdev);
-	if (ret) {
-		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
-		goto out_group_put;
-	}
+	mutex_init(&vdev->igate);
 
 	ret = vfio_fsl_mc_reflck_attach(vdev);
 	if (ret)
-		goto out_group_dev;
+		goto out_group_put;
 
 	ret = vfio_fsl_mc_init_device(vdev);
 	if (ret)
 		goto out_reflck;
 
-	mutex_init(&vdev->igate);
+	ret = vfio_add_group_dev(dev, &vfio_fsl_mc_ops, vdev);
+	if (ret) {
+		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
+		goto out_device;
+	}
 
+	/*
+	 * This triggers recursion into vfio_fsl_mc_probe() on another device
+	 * and the vfio_fsl_mc_reflck_attach() must succeed, which relies on the
+	 * vfio_add_group_dev() above. It has no impact on this vdev, so it is
+	 * safe to be after the vfio device is made live.
+	 */
+	ret = vfio_fsl_mc_scan_container(mc_dev);
+	if (ret)
+		goto out_group_dev;
 	return 0;
 
-out_reflck:
-	vfio_fsl_mc_reflck_put(vdev->reflck);
 out_group_dev:
 	vfio_del_group_dev(dev);
+out_device:
+	vfio_fsl_uninit_device(vdev);
+out_reflck:
+	vfio_fsl_mc_reflck_put(vdev->reflck);
 out_group_put:
 	vfio_iommu_group_put(group, dev);
 	return ret;
@@ -646,16 +672,10 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 
 	mutex_destroy(&vdev->igate);
 
+	dprc_remove_devices(mc_dev, NULL, 0);
+	vfio_fsl_uninit_device(vdev);
 	vfio_fsl_mc_reflck_put(vdev->reflck);
 
-	if (is_fsl_mc_bus_dprc(mc_dev)) {
-		dprc_remove_devices(mc_dev, NULL, 0);
-		dprc_cleanup(mc_dev);
-	}
-
-	if (vdev->nb.notifier_call)
-		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
-
 	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
 
 	return 0;
-- 
2.30.2



