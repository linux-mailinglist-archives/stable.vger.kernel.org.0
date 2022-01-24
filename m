Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0CD49A56E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370843AbiAYAGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1848498AbiAXXeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:34:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7ADC075D15;
        Mon, 24 Jan 2022 13:36:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F3E6614DD;
        Mon, 24 Jan 2022 21:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1515FC340EC;
        Mon, 24 Jan 2022 21:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060184;
        bh=5JMG1VAIrUzkfh+/zGkCKSkeyXs9MnukOsGvjmTpIbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QiHnLEChcfub+XWNHIJ/kF8A1lqMFdvoiadm+lRoRZJg+XyqsomBm7Q+OjbnXhPKs
         Rak/YB9oh5Vu8MuruK62Mu3qdPAj6gfCfC7HJvQRGxWm3M6Kh9ZAJuVXe10DkQGXNZ
         zHtiydQ+jI/M9yRn/9Z4cNe/8Ncqw9/kif9M5Lf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.16 0835/1039] ifcvf/vDPA: fix misuse virtio-net device config size for blk dev
Date:   Mon, 24 Jan 2022 19:43:44 +0100
Message-Id: <20220124184153.360622213@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhu Lingshan <lingshan.zhu@intel.com>

commit 0f420c383a2bb414ebccedf9289b5b815f1295fe upstream.

This commit fixes a misuse of virtio-net device config size issue
for virtio-block devices.

A new member config_size in struct ifcvf_hw is introduced and would
be initialized through vdpa_dev_add() to record correct device
config size.

To be more generic, rename ifcvf_hw.net_config to ifcvf_hw.dev_config,
the helpers ifcvf_read/write_net_config() to ifcvf_read/write_dev_config()

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Reported-and-suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Fixes: 6ad31d162a4e ("vDPA/ifcvf: enable Intel C5000X-PL virtio-block for vDPA")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211201081255.60187-1-lingshan.zhu@intel.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/ifcvf/ifcvf_base.c |   41 ++++++++++++++++++++++++++++++----------
 drivers/vdpa/ifcvf/ifcvf_base.h |    9 +++++---
 drivers/vdpa/ifcvf/ifcvf_main.c |   24 +++--------------------
 3 files changed, 41 insertions(+), 33 deletions(-)

--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -143,8 +143,8 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, s
 			IFCVF_DBG(pdev, "hw->isr = %p\n", hw->isr);
 			break;
 		case VIRTIO_PCI_CAP_DEVICE_CFG:
-			hw->net_cfg = get_cap_addr(hw, &cap);
-			IFCVF_DBG(pdev, "hw->net_cfg = %p\n", hw->net_cfg);
+			hw->dev_cfg = get_cap_addr(hw, &cap);
+			IFCVF_DBG(pdev, "hw->dev_cfg = %p\n", hw->dev_cfg);
 			break;
 		}
 
@@ -153,7 +153,7 @@ next:
 	}
 
 	if (hw->common_cfg == NULL || hw->notify_base == NULL ||
-	    hw->isr == NULL || hw->net_cfg == NULL) {
+	    hw->isr == NULL || hw->dev_cfg == NULL) {
 		IFCVF_ERR(pdev, "Incomplete PCI capabilities\n");
 		return -EIO;
 	}
@@ -174,7 +174,7 @@ next:
 	IFCVF_DBG(pdev,
 		  "PCI capability mapping: common cfg: %p, notify base: %p\n, isr cfg: %p, device cfg: %p, multiplier: %u\n",
 		  hw->common_cfg, hw->notify_base, hw->isr,
-		  hw->net_cfg, hw->notify_off_multiplier);
+		  hw->dev_cfg, hw->notify_off_multiplier);
 
 	return 0;
 }
@@ -242,33 +242,54 @@ int ifcvf_verify_min_features(struct ifc
 	return 0;
 }
 
-void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
+u32 ifcvf_get_config_size(struct ifcvf_hw *hw)
+{
+	struct ifcvf_adapter *adapter;
+	u32 config_size;
+
+	adapter = vf_to_adapter(hw);
+	switch (hw->dev_type) {
+	case VIRTIO_ID_NET:
+		config_size = sizeof(struct virtio_net_config);
+		break;
+	case VIRTIO_ID_BLOCK:
+		config_size = sizeof(struct virtio_blk_config);
+		break;
+	default:
+		config_size = 0;
+		IFCVF_ERR(adapter->pdev, "VIRTIO ID %u not supported\n", hw->dev_type);
+	}
+
+	return config_size;
+}
+
+void ifcvf_read_dev_config(struct ifcvf_hw *hw, u64 offset,
 			   void *dst, int length)
 {
 	u8 old_gen, new_gen, *p;
 	int i;
 
-	WARN_ON(offset + length > sizeof(struct virtio_net_config));
+	WARN_ON(offset + length > hw->config_size);
 	do {
 		old_gen = ifc_ioread8(&hw->common_cfg->config_generation);
 		p = dst;
 		for (i = 0; i < length; i++)
-			*p++ = ifc_ioread8(hw->net_cfg + offset + i);
+			*p++ = ifc_ioread8(hw->dev_cfg + offset + i);
 
 		new_gen = ifc_ioread8(&hw->common_cfg->config_generation);
 	} while (old_gen != new_gen);
 }
 
-void ifcvf_write_net_config(struct ifcvf_hw *hw, u64 offset,
+void ifcvf_write_dev_config(struct ifcvf_hw *hw, u64 offset,
 			    const void *src, int length)
 {
 	const u8 *p;
 	int i;
 
 	p = src;
-	WARN_ON(offset + length > sizeof(struct virtio_net_config));
+	WARN_ON(offset + length > hw->config_size);
 	for (i = 0; i < length; i++)
-		ifc_iowrite8(*p++, hw->net_cfg + offset + i);
+		ifc_iowrite8(*p++, hw->dev_cfg + offset + i);
 }
 
 static void ifcvf_set_features(struct ifcvf_hw *hw, u64 features)
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -71,12 +71,14 @@ struct ifcvf_hw {
 	u64 hw_features;
 	u32 dev_type;
 	struct virtio_pci_common_cfg __iomem *common_cfg;
-	void __iomem *net_cfg;
+	void __iomem *dev_cfg;
 	struct vring_info vring[IFCVF_MAX_QUEUES];
 	void __iomem * const *base;
 	char config_msix_name[256];
 	struct vdpa_callback config_cb;
 	unsigned int config_irq;
+	/* virtio-net or virtio-blk device config size */
+	u32 config_size;
 };
 
 struct ifcvf_adapter {
@@ -105,9 +107,9 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, s
 int ifcvf_start_hw(struct ifcvf_hw *hw);
 void ifcvf_stop_hw(struct ifcvf_hw *hw);
 void ifcvf_notify_queue(struct ifcvf_hw *hw, u16 qid);
-void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
+void ifcvf_read_dev_config(struct ifcvf_hw *hw, u64 offset,
 			   void *dst, int length);
-void ifcvf_write_net_config(struct ifcvf_hw *hw, u64 offset,
+void ifcvf_write_dev_config(struct ifcvf_hw *hw, u64 offset,
 			    const void *src, int length);
 u8 ifcvf_get_status(struct ifcvf_hw *hw);
 void ifcvf_set_status(struct ifcvf_hw *hw, u8 status);
@@ -120,4 +122,5 @@ u16 ifcvf_get_vq_state(struct ifcvf_hw *
 int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
 struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
 int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
+u32 ifcvf_get_config_size(struct ifcvf_hw *hw);
 #endif /* _IFCVF_H_ */
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -366,24 +366,9 @@ static u32 ifcvf_vdpa_get_vq_align(struc
 
 static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
 {
-	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
-	struct pci_dev *pdev = adapter->pdev;
-	size_t size;
 
-	switch (vf->dev_type) {
-	case VIRTIO_ID_NET:
-		size = sizeof(struct virtio_net_config);
-		break;
-	case VIRTIO_ID_BLOCK:
-		size = sizeof(struct virtio_blk_config);
-		break;
-	default:
-		size = 0;
-		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", vf->dev_type);
-	}
-
-	return size;
+	return  vf->config_size;
 }
 
 static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
@@ -392,8 +377,7 @@ static void ifcvf_vdpa_get_config(struct
 {
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
 
-	WARN_ON(offset + len > sizeof(struct virtio_net_config));
-	ifcvf_read_net_config(vf, offset, buf, len);
+	ifcvf_read_dev_config(vf, offset, buf, len);
 }
 
 static void ifcvf_vdpa_set_config(struct vdpa_device *vdpa_dev,
@@ -402,8 +386,7 @@ static void ifcvf_vdpa_set_config(struct
 {
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
 
-	WARN_ON(offset + len > sizeof(struct virtio_net_config));
-	ifcvf_write_net_config(vf, offset, buf, len);
+	ifcvf_write_dev_config(vf, offset, buf, len);
 }
 
 static void ifcvf_vdpa_set_config_cb(struct vdpa_device *vdpa_dev,
@@ -542,6 +525,7 @@ static int ifcvf_vdpa_dev_add(struct vdp
 		vf->vring[i].irq = -EINVAL;
 
 	vf->hw_features = ifcvf_get_hw_features(vf);
+	vf->config_size = ifcvf_get_config_size(vf);
 
 	adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
 	ret = _vdpa_register_device(&adapter->vdpa, vf->nr_vring);


