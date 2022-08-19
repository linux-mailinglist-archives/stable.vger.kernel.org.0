Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9A759A228
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353048AbiHSQcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353277AbiHSQbP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:31:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F8111D53D;
        Fri, 19 Aug 2022 09:05:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FF1F617A7;
        Fri, 19 Aug 2022 16:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5F6C433D6;
        Fri, 19 Aug 2022 16:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925122;
        bh=CoyVJtwg9ctu+hBq7iN19MRxOzU0gJtVQG/ygasficY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5wEsfWjytUkPCGvhh4ydaxPainr4x2y0V3SvJJjt1d8cbqc5TM0chUEJX3L/SghO
         74dPX90CrZAjXQif/MCm9utN0WTZq3vRioVjDafRPb5ytFLfVykYwZ3k+ktOMsBejG
         uiUlCy3y3jHJD6JuN9UDEP8zaynXBF5ukqTtV9YU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Liu Yi L <yi.l.liu@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 391/545] vfio: Split creation of a vfio_device into init and register ops
Date:   Fri, 19 Aug 2022 17:42:41 +0200
Message-Id: <20220819153846.906280077@linuxfoundation.org>
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

[ Upstream commit 0bfc6a4ea63c2adac71a824397ef48f28dbc5e47 ]

This makes the struct vfio_device part of the public interface so it
can be used with container_of and so forth, as is typical for a Linux
subystem.

This is the first step to bring some type-safety to the vfio interface by
allowing the replacement of 'void *' and 'struct device *' inputs with a
simple and clear 'struct vfio_device *'

For now the self-allocating vfio_add_group_dev() interface is kept so each
user can be updated as a separate patch.

The expected usage pattern is

  driver core probe() function:
     my_device = kzalloc(sizeof(*mydevice));
     vfio_init_group_dev(&my_device->vdev, dev, ops, mydevice);
     /* other driver specific prep */
     vfio_register_group_dev(&my_device->vdev);
     dev_set_drvdata(dev, my_device);

  driver core remove() function:
     my_device = dev_get_drvdata(dev);
     vfio_unregister_group_dev(&my_device->vdev);
     /* other driver specific tear down */
     kfree(my_device);

Allowing the driver to be able to use the drvdata and vfio_device to go
to/from its own data.

The pattern also makes it clear that vfio_register_group_dev() must be
last in the sequence, as once it is called the core code can immediately
start calling ops. The init/register gap is provided to allow for the
driver to do setup before ops can be called and thus avoid races.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Message-Id: <3-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/vfio.rst |  31 ++++----
 drivers/vfio/vfio.c               | 125 ++++++++++++++++--------------
 include/linux/vfio.h              |  16 ++++
 3 files changed, 99 insertions(+), 73 deletions(-)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index f1a4d3c3ba0b..d3a02300913a 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -249,18 +249,23 @@ VFIO bus driver API
 
 VFIO bus drivers, such as vfio-pci make use of only a few interfaces
 into VFIO core.  When devices are bound and unbound to the driver,
-the driver should call vfio_add_group_dev() and vfio_del_group_dev()
-respectively::
-
-	extern int vfio_add_group_dev(struct device *dev,
-				      const struct vfio_device_ops *ops,
-				      void *device_data);
-
-	extern void *vfio_del_group_dev(struct device *dev);
-
-vfio_add_group_dev() indicates to the core to begin tracking the
-iommu_group of the specified dev and register the dev as owned by
-a VFIO bus driver.  The driver provides an ops structure for callbacks
+the driver should call vfio_register_group_dev() and
+vfio_unregister_group_dev() respectively::
+
+	void vfio_init_group_dev(struct vfio_device *device,
+				struct device *dev,
+				const struct vfio_device_ops *ops,
+				void *device_data);
+	int vfio_register_group_dev(struct vfio_device *device);
+	void vfio_unregister_group_dev(struct vfio_device *device);
+
+The driver should embed the vfio_device in its own structure and call
+vfio_init_group_dev() to pre-configure it before going to registration.
+vfio_register_group_dev() indicates to the core to begin tracking the
+iommu_group of the specified dev and register the dev as owned by a VFIO bus
+driver. Once vfio_register_group_dev() returns it is possible for userspace to
+start accessing the driver, thus the driver should ensure it is completely
+ready before calling it. The driver provides an ops structure for callbacks
 similar to a file operations structure::
 
 	struct vfio_device_ops {
@@ -276,7 +281,7 @@ similar to a file operations structure::
 	};
 
 Each function is passed the device_data that was originally registered
-in the vfio_add_group_dev() call above.  This allows the bus driver
+in the vfio_register_group_dev() call above.  This allows the bus driver
 an easy place to store its opaque, private data.  The open/release
 callbacks are issued when a new file descriptor is created for a
 device (via VFIO_GROUP_GET_DEVICE_FD).  The ioctl interface provides
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index b5fa2ae3116d..f886f2db8153 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -89,16 +89,6 @@ struct vfio_group {
 	struct blocking_notifier_head	notifier;
 };
 
-struct vfio_device {
-	refcount_t			refcount;
-	struct completion		comp;
-	struct device			*dev;
-	const struct vfio_device_ops	*ops;
-	struct vfio_group		*group;
-	struct list_head		group_next;
-	void				*device_data;
-};
-
 #ifdef CONFIG_VFIO_NOIOMMU
 static bool noiommu __read_mostly;
 module_param_named(enable_unsafe_noiommu_mode,
@@ -532,35 +522,6 @@ static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
 /**
  * Device objects - create, release, get, put, search
  */
-static
-struct vfio_device *vfio_group_create_device(struct vfio_group *group,
-					     struct device *dev,
-					     const struct vfio_device_ops *ops,
-					     void *device_data)
-{
-	struct vfio_device *device;
-
-	device = kzalloc(sizeof(*device), GFP_KERNEL);
-	if (!device)
-		return ERR_PTR(-ENOMEM);
-
-	refcount_set(&device->refcount, 1);
-	init_completion(&device->comp);
-	device->dev = dev;
-	/* Our reference on group is moved to the device */
-	device->group = group;
-	device->ops = ops;
-	device->device_data = device_data;
-	dev_set_drvdata(dev, device);
-
-	mutex_lock(&group->device_lock);
-	list_add(&device->group_next, &group->device_list);
-	group->dev_counter++;
-	mutex_unlock(&group->device_lock);
-
-	return device;
-}
-
 /* Device reference always implies a group reference */
 void vfio_device_put(struct vfio_device *device)
 {
@@ -779,14 +740,23 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
 /**
  * VFIO driver API
  */
-int vfio_add_group_dev(struct device *dev,
-		       const struct vfio_device_ops *ops, void *device_data)
+void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
+			 const struct vfio_device_ops *ops, void *device_data)
+{
+	init_completion(&device->comp);
+	device->dev = dev;
+	device->ops = ops;
+	device->device_data = device_data;
+}
+EXPORT_SYMBOL_GPL(vfio_init_group_dev);
+
+int vfio_register_group_dev(struct vfio_device *device)
 {
+	struct vfio_device *existing_device;
 	struct iommu_group *iommu_group;
 	struct vfio_group *group;
-	struct vfio_device *device;
 
-	iommu_group = iommu_group_get(dev);
+	iommu_group = iommu_group_get(device->dev);
 	if (!iommu_group)
 		return -EINVAL;
 
@@ -805,21 +775,50 @@ int vfio_add_group_dev(struct device *dev,
 		iommu_group_put(iommu_group);
 	}
 
-	device = vfio_group_get_device(group, dev);
-	if (device) {
-		dev_WARN(dev, "Device already exists on group %d\n",
+	existing_device = vfio_group_get_device(group, device->dev);
+	if (existing_device) {
+		dev_WARN(device->dev, "Device already exists on group %d\n",
 			 iommu_group_id(iommu_group));
-		vfio_device_put(device);
+		vfio_device_put(existing_device);
 		vfio_group_put(group);
 		return -EBUSY;
 	}
 
-	device = vfio_group_create_device(group, dev, ops, device_data);
-	if (IS_ERR(device)) {
-		vfio_group_put(group);
-		return PTR_ERR(device);
-	}
+	/* Our reference on group is moved to the device */
+	device->group = group;
+
+	/* Refcounting can't start until the driver calls register */
+	refcount_set(&device->refcount, 1);
+
+	mutex_lock(&group->device_lock);
+	list_add(&device->group_next, &group->device_list);
+	group->dev_counter++;
+	mutex_unlock(&group->device_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_register_group_dev);
+
+int vfio_add_group_dev(struct device *dev, const struct vfio_device_ops *ops,
+		       void *device_data)
+{
+	struct vfio_device *device;
+	int ret;
+
+	device = kzalloc(sizeof(*device), GFP_KERNEL);
+	if (!device)
+		return -ENOMEM;
+
+	vfio_init_group_dev(device, dev, ops, device_data);
+	ret = vfio_register_group_dev(device);
+	if (ret)
+		goto err_kfree;
+	dev_set_drvdata(dev, device);
 	return 0;
+
+err_kfree:
+	kfree(device);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_add_group_dev);
 
@@ -887,11 +886,9 @@ EXPORT_SYMBOL_GPL(vfio_device_data);
 /*
  * Decrement the device reference count and wait for the device to be
  * removed.  Open file descriptors for the device... */
-void *vfio_del_group_dev(struct device *dev)
+void vfio_unregister_group_dev(struct vfio_device *device)
 {
-	struct vfio_device *device = dev_get_drvdata(dev);
 	struct vfio_group *group = device->group;
-	void *device_data = device->device_data;
 	struct vfio_unbound_dev *unbound;
 	unsigned int i = 0;
 	bool interrupted = false;
@@ -908,7 +905,7 @@ void *vfio_del_group_dev(struct device *dev)
 	 */
 	unbound = kzalloc(sizeof(*unbound), GFP_KERNEL);
 	if (unbound) {
-		unbound->dev = dev;
+		unbound->dev = device->dev;
 		mutex_lock(&group->unbound_lock);
 		list_add(&unbound->unbound_next, &group->unbound_list);
 		mutex_unlock(&group->unbound_lock);
@@ -919,7 +916,7 @@ void *vfio_del_group_dev(struct device *dev)
 	rc = try_wait_for_completion(&device->comp);
 	while (rc <= 0) {
 		if (device->ops->request)
-			device->ops->request(device_data, i++);
+			device->ops->request(device->device_data, i++);
 
 		if (interrupted) {
 			rc = wait_for_completion_timeout(&device->comp,
@@ -929,7 +926,7 @@ void *vfio_del_group_dev(struct device *dev)
 				&device->comp, HZ * 10);
 			if (rc < 0) {
 				interrupted = true;
-				dev_warn(dev,
+				dev_warn(device->dev,
 					 "Device is currently in use, task"
 					 " \"%s\" (%d) "
 					 "blocked until device is released",
@@ -960,11 +957,19 @@ void *vfio_del_group_dev(struct device *dev)
 	if (list_empty(&group->device_list))
 		wait_event(group->container_q, !group->container);
 
-	/* Matches the get in vfio_group_create_device() */
+	/* Matches the get in vfio_register_group_dev() */
 	vfio_group_put(group);
+}
+EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
+
+void *vfio_del_group_dev(struct device *dev)
+{
+	struct vfio_device *device = dev_get_drvdata(dev);
+	void *device_data = device->device_data;
+
+	vfio_unregister_group_dev(device);
 	dev_set_drvdata(dev, NULL);
 	kfree(device);
-
 	return device_data;
 }
 EXPORT_SYMBOL_GPL(vfio_del_group_dev);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 38d3c6a8dc7e..f479c5d7f2c3 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -15,6 +15,18 @@
 #include <linux/poll.h>
 #include <uapi/linux/vfio.h>
 
+struct vfio_device {
+	struct device *dev;
+	const struct vfio_device_ops *ops;
+	struct vfio_group *group;
+
+	/* Members below here are private, not for driver use */
+	refcount_t refcount;
+	struct completion comp;
+	struct list_head group_next;
+	void *device_data;
+};
+
 /**
  * struct vfio_device_ops - VFIO bus driver device callbacks
  *
@@ -48,11 +60,15 @@ struct vfio_device_ops {
 extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
 extern void vfio_iommu_group_put(struct iommu_group *group, struct device *dev);
 
+void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
+			 const struct vfio_device_ops *ops, void *device_data);
+int vfio_register_group_dev(struct vfio_device *device);
 extern int vfio_add_group_dev(struct device *dev,
 			      const struct vfio_device_ops *ops,
 			      void *device_data);
 
 extern void *vfio_del_group_dev(struct device *dev);
+void vfio_unregister_group_dev(struct vfio_device *device);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
 extern void *vfio_device_data(struct vfio_device *device);
-- 
2.35.1



