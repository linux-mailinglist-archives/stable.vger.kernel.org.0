Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4764635914
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236562AbiKWKHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbiKWKGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:06:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9300D1165A0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:56:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F0B1B81EF0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BE7C433D7;
        Wed, 23 Nov 2022 09:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197407;
        bh=72+UI+ShCGzRSSfVYFVEB550oGrxiU/USo3+v9GyINs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHaBjpjN7jkw8IvuwTUE/tWA5pUWc8TZg56Dq3KvXCDDMm1AqDAuZtx/ShPWM15em
         CUcV9B52uXSSW4wPyb4ZwxoZmiUjPJ1bq8YZTbouuqPGwHvrugypYPM0mL7YT7qCr0
         Ml4pHRMtFCC2uLvsMtD3A5oDtulO4up1T5iUhfFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 286/314] vfio: Split the register_device ops call into functions
Date:   Wed, 23 Nov 2022 09:52:11 +0100
Message-Id: <20221123084638.498345686@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 9446162e740aefff95c324ac0887f0b68c739695 ]

This is a container item.

A following patch will move the vfio_container functions to their own .c
file.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/7-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Stable-dep-of: 7fdba0011157 ("vfio: Fix container device registration life cycle")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_main.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index c555d497e9e8..48ceca04d9b8 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1086,9 +1086,28 @@ static void vfio_device_unassign_container(struct vfio_device *device)
 	up_write(&device->group->group_rwsem);
 }
 
+static void vfio_device_container_register(struct vfio_device *device)
+{
+	struct vfio_iommu_driver *iommu_driver =
+		device->group->container->iommu_driver;
+
+	if (iommu_driver && iommu_driver->ops->register_device)
+		iommu_driver->ops->register_device(
+			device->group->container->iommu_data, device);
+}
+
+static void vfio_device_container_unregister(struct vfio_device *device)
+{
+	struct vfio_iommu_driver *iommu_driver =
+		device->group->container->iommu_driver;
+
+	if (iommu_driver && iommu_driver->ops->unregister_device)
+		iommu_driver->ops->unregister_device(
+			device->group->container->iommu_data, device);
+}
+
 static struct file *vfio_device_open(struct vfio_device *device)
 {
-	struct vfio_iommu_driver *iommu_driver;
 	struct file *filep;
 	int ret;
 
@@ -1119,12 +1138,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 			if (ret)
 				goto err_undo_count;
 		}
-
-		iommu_driver = device->group->container->iommu_driver;
-		if (iommu_driver && iommu_driver->ops->register_device)
-			iommu_driver->ops->register_device(
-				device->group->container->iommu_data, device);
-
+		vfio_device_container_register(device);
 		up_read(&device->group->group_rwsem);
 	}
 	mutex_unlock(&device->dev_set->lock);
@@ -1162,10 +1176,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	if (device->open_count == 1 && device->ops->close_device) {
 		device->ops->close_device(device);
 
-		iommu_driver = device->group->container->iommu_driver;
-		if (iommu_driver && iommu_driver->ops->unregister_device)
-			iommu_driver->ops->unregister_device(
-				device->group->container->iommu_data, device);
+		vfio_device_container_unregister(device);
 	}
 err_undo_count:
 	up_read(&device->group->group_rwsem);
@@ -1361,7 +1372,6 @@ static const struct file_operations vfio_group_fops = {
 static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_device *device = filep->private_data;
-	struct vfio_iommu_driver *iommu_driver;
 
 	mutex_lock(&device->dev_set->lock);
 	vfio_assert_device_open(device);
@@ -1369,10 +1379,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	if (device->open_count == 1 && device->ops->close_device)
 		device->ops->close_device(device);
 
-	iommu_driver = device->group->container->iommu_driver;
-	if (iommu_driver && iommu_driver->ops->unregister_device)
-		iommu_driver->ops->unregister_device(
-			device->group->container->iommu_data, device);
+	vfio_device_container_unregister(device);
 	up_read(&device->group->group_rwsem);
 	device->open_count--;
 	if (device->open_count == 0)
-- 
2.35.1



