Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4043F648B
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238789AbhHXRFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:05:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234553AbhHXRDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:03:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDE6161502;
        Tue, 24 Aug 2021 16:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824359;
        bh=DNILWLHR3GpO1NAlXEpJNb+dCpYl49tPi66ndGiwOA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jqyzvLVkBaLChJxrQ6BQjuj7wec1EHyZ4JqKgNpFz5Pfu8qYRuXtIOPMIzLjOjvwD
         tsB3Vkh34bWgVFyKXRbnnl1XUIR3Mny7GeNLDKYgbKLSfGvcqXiycYSdrkk5MODwWU
         ODbN1cClCFaA4zPh6cfwSbayh4/uIWLUUuHCqBFtB0bUx9J7zhNpuP70qP36+xAd44
         dwK6y/WHYnYHRUFMj49D6HxqrtFGpfrtiU7MVoSHkh9ZpCTKebvN5d5REoDrrJNpOL
         bcDzv0WjdAOPCQW2w+AYVLy6hTxVCEUVr80qaKcryzZR4MyxeZhMhV4uBogfgxNVO8
         WLT0cmv+FMQgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/98] vdpa: Extend routine to accept vdpa device name
Date:   Tue, 24 Aug 2021 12:57:39 -0400
Message-Id: <20210824165908.709932-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit fd70a406a344e084ac680c3f14e71d37d6023883 ]

In a subsequent patch, when user initiated command creates a vdpa device,
the user chooses the name of the vdpa device.
To support it, extend the device allocation API to consider this name
specified by the caller driver.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20210105103203.82508-3-parav@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c   |  2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c |  2 +-
 drivers/vdpa/vdpa.c               | 36 +++++++++++++++++++++++++++----
 drivers/vdpa/vdpa_sim/vdpa_sim.c  |  2 +-
 include/linux/vdpa.h              |  7 +++---
 5 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 8b4028556cb6..23474af7da40 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -439,7 +439,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
 				    dev, &ifc_vdpa_ops,
-				    IFCVF_MAX_QUEUE_PAIRS * 2);
+				    IFCVF_MAX_QUEUE_PAIRS * 2, NULL);
 	if (adapter == NULL) {
 		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
 		return -ENOMEM;
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index fbdc9468818d..b15d8552832a 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1982,7 +1982,7 @@ void *mlx5_vdpa_add_dev(struct mlx5_core_dev *mdev)
 	max_vqs = min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
 
 	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
-				 2 * mlx5_vdpa_max_qps(max_vqs));
+				 2 * mlx5_vdpa_max_qps(max_vqs), NULL);
 	if (IS_ERR(ndev))
 		return ndev;
 
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index a69ffc991e13..b3408cc8c63b 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -12,6 +12,8 @@
 #include <linux/slab.h>
 #include <linux/vdpa.h>
 
+/* A global mutex that protects vdpa management device and device level operations. */
+static DEFINE_MUTEX(vdpa_dev_mutex);
 static DEFINE_IDA(vdpa_index_ida);
 
 static int vdpa_dev_probe(struct device *d)
@@ -63,6 +65,7 @@ static void vdpa_release_dev(struct device *d)
  * @config: the bus operations that is supported by this device
  * @nvqs: number of virtqueues supported by this device
  * @size: size of the parent structure that contains private data
+ * @name: name of the vdpa device; optional.
  *
  * Driver should use vdpa_alloc_device() wrapper macro instead of
  * using this directly.
@@ -72,8 +75,7 @@ static void vdpa_release_dev(struct device *d)
  */
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
-					int nvqs,
-					size_t size)
+					int nvqs, size_t size, const char *name)
 {
 	struct vdpa_device *vdev;
 	int err = -EINVAL;
@@ -101,7 +103,10 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 	vdev->features_valid = false;
 	vdev->nvqs = nvqs;
 
-	err = dev_set_name(&vdev->dev, "vdpa%u", vdev->index);
+	if (name)
+		err = dev_set_name(&vdev->dev, "%s", name);
+	else
+		err = dev_set_name(&vdev->dev, "vdpa%u", vdev->index);
 	if (err)
 		goto err_name;
 
@@ -118,6 +123,13 @@ err:
 }
 EXPORT_SYMBOL_GPL(__vdpa_alloc_device);
 
+static int vdpa_name_match(struct device *dev, const void *data)
+{
+	struct vdpa_device *vdev = container_of(dev, struct vdpa_device, dev);
+
+	return (strcmp(dev_name(&vdev->dev), data) == 0);
+}
+
 /**
  * vdpa_register_device - register a vDPA device
  * Callers must have a succeed call of vdpa_alloc_device() before.
@@ -127,7 +139,21 @@ EXPORT_SYMBOL_GPL(__vdpa_alloc_device);
  */
 int vdpa_register_device(struct vdpa_device *vdev)
 {
-	return device_add(&vdev->dev);
+	struct device *dev;
+	int err;
+
+	mutex_lock(&vdpa_dev_mutex);
+	dev = bus_find_device(&vdpa_bus, NULL, dev_name(&vdev->dev), vdpa_name_match);
+	if (dev) {
+		put_device(dev);
+		err = -EEXIST;
+		goto name_err;
+	}
+
+	err = device_add(&vdev->dev);
+name_err:
+	mutex_unlock(&vdpa_dev_mutex);
+	return err;
 }
 EXPORT_SYMBOL_GPL(vdpa_register_device);
 
@@ -137,7 +163,9 @@ EXPORT_SYMBOL_GPL(vdpa_register_device);
  */
 void vdpa_unregister_device(struct vdpa_device *vdev)
 {
+	mutex_lock(&vdpa_dev_mutex);
 	device_unregister(&vdev->dev);
+	mutex_unlock(&vdpa_dev_mutex);
 }
 EXPORT_SYMBOL_GPL(vdpa_unregister_device);
 
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index f2ad450db547..df1f585e08dc 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -370,7 +370,7 @@ static struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
 		ops = &vdpasim_net_config_ops;
 
 	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
-				    dev_attr->nvqs);
+				    dev_attr->nvqs, NULL);
 	if (!vdpasim)
 		goto err_alloc;
 
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 30bc7a7223bb..ac58462e8aed 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -244,15 +244,14 @@ struct vdpa_config_ops {
 
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
-					int nvqs,
-					size_t size);
+					int nvqs, size_t size, const char *name);
 
-#define vdpa_alloc_device(dev_struct, member, parent, config, nvqs)   \
+#define vdpa_alloc_device(dev_struct, member, parent, config, nvqs, name)   \
 			  container_of(__vdpa_alloc_device( \
 				       parent, config, nvqs, \
 				       sizeof(dev_struct) + \
 				       BUILD_BUG_ON_ZERO(offsetof( \
-				       dev_struct, member))), \
+				       dev_struct, member)), name), \
 				       dev_struct, member)
 
 int vdpa_register_device(struct vdpa_device *vdev);
-- 
2.30.2

