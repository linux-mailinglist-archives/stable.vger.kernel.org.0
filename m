Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D25159A229
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353052AbiHSQcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353310AbiHSQbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:31:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E74211DD59;
        Fri, 19 Aug 2022 09:05:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EC83B8280D;
        Fri, 19 Aug 2022 16:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D03C433D6;
        Fri, 19 Aug 2022 16:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925118;
        bh=r4SjIXV0vPQptdx6BSQGIS5YqMDc+H6jckduAqTwm4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eO0Ol/26LS+AsmhyQ/7TOA5QKupOt70pt5+5Qg4TNRtMCUmsaNwbwJKoFG39dsWDi
         cx2/HzuY8G5clKhngp4NPUl6FIahCiF5gdK/AnhcLcvia/ta4FW5FSOTkHZSHpyd/p
         w24uQ283Od8EJVZLVdsn+dpZEhQbNSdOwR9QfI84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 390/545] vfio: Simplify the lifetime logic for vfio_device
Date:   Fri, 19 Aug 2022 17:42:40 +0200
Message-Id: <20220819153846.861899008@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 5e42c999445bd0ae86e35affeb3e7c473d74a893 ]

The vfio_device is using a 'sleep until all refs go to zero' pattern for
its lifetime, but it is indirectly coded by repeatedly scanning the group
list waiting for the device to be removed on its own.

Switch this around to be a direct representation, use a refcount to count
the number of places that are blocking destruction and sleep directly on a
completion until that counter goes to zero. kfree the device after other
accesses have been excluded in vfio_del_group_dev(). This is a fairly
common Linux idiom.

Due to this we can now remove kref_put_mutex(), which is very rarely used
in the kernel. Here it is being used to prevent a zero ref device from
being seen in the group list. Instead allow the zero ref device to
continue to exist in the device_list and use refcount_inc_not_zero() to
exclude it once refs go to zero.

This patch is organized so the next patch will be able to alter the API to
allow drivers to provide the kfree.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Message-Id: <2-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio.c | 79 ++++++++++++++-------------------------------
 1 file changed, 25 insertions(+), 54 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index e1b6e1b51d41..b5fa2ae3116d 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -46,7 +46,6 @@ static struct vfio {
 	struct mutex			group_lock;
 	struct cdev			group_cdev;
 	dev_t				group_devt;
-	wait_queue_head_t		release_q;
 } vfio;
 
 struct vfio_iommu_driver {
@@ -91,7 +90,8 @@ struct vfio_group {
 };
 
 struct vfio_device {
-	struct kref			kref;
+	refcount_t			refcount;
+	struct completion		comp;
 	struct device			*dev;
 	const struct vfio_device_ops	*ops;
 	struct vfio_group		*group;
@@ -544,7 +544,8 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
 	if (!device)
 		return ERR_PTR(-ENOMEM);
 
-	kref_init(&device->kref);
+	refcount_set(&device->refcount, 1);
+	init_completion(&device->comp);
 	device->dev = dev;
 	/* Our reference on group is moved to the device */
 	device->group = group;
@@ -560,35 +561,17 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
 	return device;
 }
 
-static void vfio_device_release(struct kref *kref)
-{
-	struct vfio_device *device = container_of(kref,
-						  struct vfio_device, kref);
-	struct vfio_group *group = device->group;
-
-	list_del(&device->group_next);
-	group->dev_counter--;
-	mutex_unlock(&group->device_lock);
-
-	dev_set_drvdata(device->dev, NULL);
-
-	kfree(device);
-
-	/* vfio_del_group_dev may be waiting for this device */
-	wake_up(&vfio.release_q);
-}
-
 /* Device reference always implies a group reference */
 void vfio_device_put(struct vfio_device *device)
 {
-	struct vfio_group *group = device->group;
-	kref_put_mutex(&device->kref, vfio_device_release, &group->device_lock);
+	if (refcount_dec_and_test(&device->refcount))
+		complete(&device->comp);
 }
 EXPORT_SYMBOL_GPL(vfio_device_put);
 
-static void vfio_device_get(struct vfio_device *device)
+static bool vfio_device_try_get(struct vfio_device *device)
 {
-	kref_get(&device->kref);
+	return refcount_inc_not_zero(&device->refcount);
 }
 
 static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
@@ -598,8 +581,7 @@ static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
 
 	mutex_lock(&group->device_lock);
 	list_for_each_entry(device, &group->device_list, group_next) {
-		if (device->dev == dev) {
-			vfio_device_get(device);
+		if (device->dev == dev && vfio_device_try_get(device)) {
 			mutex_unlock(&group->device_lock);
 			return device;
 		}
@@ -883,9 +865,8 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 			ret = !strcmp(dev_name(it->dev), buf);
 		}
 
-		if (ret) {
+		if (ret && vfio_device_try_get(it)) {
 			device = it;
-			vfio_device_get(device);
 			break;
 		}
 	}
@@ -908,13 +889,13 @@ EXPORT_SYMBOL_GPL(vfio_device_data);
  * removed.  Open file descriptors for the device... */
 void *vfio_del_group_dev(struct device *dev)
 {
-	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct vfio_device *device = dev_get_drvdata(dev);
 	struct vfio_group *group = device->group;
 	void *device_data = device->device_data;
 	struct vfio_unbound_dev *unbound;
 	unsigned int i = 0;
 	bool interrupted = false;
+	long rc;
 
 	/*
 	 * When the device is removed from the group, the group suddenly
@@ -935,32 +916,18 @@ void *vfio_del_group_dev(struct device *dev)
 	WARN_ON(!unbound);
 
 	vfio_device_put(device);
-
-	/*
-	 * If the device is still present in the group after the above
-	 * 'put', then it is in use and we need to request it from the
-	 * bus driver.  The driver may in turn need to request the
-	 * device from the user.  We send the request on an arbitrary
-	 * interval with counter to allow the driver to take escalating
-	 * measures to release the device if it has the ability to do so.
-	 */
-	add_wait_queue(&vfio.release_q, &wait);
-
-	do {
-		device = vfio_group_get_device(group, dev);
-		if (!device)
-			break;
-
+	rc = try_wait_for_completion(&device->comp);
+	while (rc <= 0) {
 		if (device->ops->request)
 			device->ops->request(device_data, i++);
 
-		vfio_device_put(device);
-
 		if (interrupted) {
-			wait_woken(&wait, TASK_UNINTERRUPTIBLE, HZ * 10);
+			rc = wait_for_completion_timeout(&device->comp,
+							 HZ * 10);
 		} else {
-			wait_woken(&wait, TASK_INTERRUPTIBLE, HZ * 10);
-			if (signal_pending(current)) {
+			rc = wait_for_completion_interruptible_timeout(
+				&device->comp, HZ * 10);
+			if (rc < 0) {
 				interrupted = true;
 				dev_warn(dev,
 					 "Device is currently in use, task"
@@ -969,10 +936,13 @@ void *vfio_del_group_dev(struct device *dev)
 					 current->comm, task_pid_nr(current));
 			}
 		}
+	}
 
-	} while (1);
+	mutex_lock(&group->device_lock);
+	list_del(&device->group_next);
+	group->dev_counter--;
+	mutex_unlock(&group->device_lock);
 
-	remove_wait_queue(&vfio.release_q, &wait);
 	/*
 	 * In order to support multiple devices per group, devices can be
 	 * plucked from the group while other devices in the group are still
@@ -992,6 +962,8 @@ void *vfio_del_group_dev(struct device *dev)
 
 	/* Matches the get in vfio_group_create_device() */
 	vfio_group_put(group);
+	dev_set_drvdata(dev, NULL);
+	kfree(device);
 
 	return device_data;
 }
@@ -2339,7 +2311,6 @@ static int __init vfio_init(void)
 	mutex_init(&vfio.iommu_drivers_lock);
 	INIT_LIST_HEAD(&vfio.group_list);
 	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
-	init_waitqueue_head(&vfio.release_q);
 
 	ret = misc_register(&vfio_dev);
 	if (ret) {
-- 
2.35.1



