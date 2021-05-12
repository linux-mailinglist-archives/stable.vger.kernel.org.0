Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB45D37C521
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhELPiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:38:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233953AbhELP3R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:29:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEC3D61944;
        Wed, 12 May 2021 15:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832530;
        bh=3Pk2lkgWh10vXwhyJrqeHJbz72WF0ZStbKGVtucrE6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHVYHXK1TCdJSbvgEazJ5jTUnucAV1kKX1j6fKKCooMj4cpzcz1d51AtnZKU3BP6a
         +PoiuXBVuzONvxSIukHL+AFmpfgE9lQp6SD5Pw75U7RwzaKT9+9L0l2FA2isu1BPTq
         +XAAk1lqB29V8QYEb2FeyKB+jUbYWxnad/r0/2as=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 317/530] vfio/pci: Move VGA and VF initialization to functions
Date:   Wed, 12 May 2021 16:47:07 +0200
Message-Id: <20210512144830.223580086@linuxfoundation.org>
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

[ Upstream commit 61e90817482871b614133c0f20feb1aba2faec86 ]

vfio_pci_probe() is quite complicated, with optional VF and VGA sub
components. Move these into clear init/uninit functions and have a linear
flow in probe/remove.

This fixes a few little buglets:
 - vfio_pci_remove() is in the wrong order, vga_client_register() removes
   a notifier and is after kfree(vdev), but the notifier refers to vdev,
   so it can use after free in a race.
 - vga_client_register() can fail but was ignored

Organize things so destruction order is the reverse of creation order.

Fixes: ecaa1f6a0154 ("vfio-pci: Add VGA arbiter client")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Message-Id: <7-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci.c | 116 +++++++++++++++++++++++-------------
 1 file changed, 74 insertions(+), 42 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 465f646e3329..f31aa25f361c 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1926,6 +1926,68 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
 	return 0;
 }
 
+static int vfio_pci_vf_init(struct vfio_pci_device *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int ret;
+
+	if (!pdev->is_physfn)
+		return 0;
+
+	vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
+	if (!vdev->vf_token)
+		return -ENOMEM;
+
+	mutex_init(&vdev->vf_token->lock);
+	uuid_gen(&vdev->vf_token->uuid);
+
+	vdev->nb.notifier_call = vfio_pci_bus_notifier;
+	ret = bus_register_notifier(&pci_bus_type, &vdev->nb);
+	if (ret) {
+		kfree(vdev->vf_token);
+		return ret;
+	}
+	return 0;
+}
+
+static void vfio_pci_vf_uninit(struct vfio_pci_device *vdev)
+{
+	if (!vdev->vf_token)
+		return;
+
+	bus_unregister_notifier(&pci_bus_type, &vdev->nb);
+	WARN_ON(vdev->vf_token->users);
+	mutex_destroy(&vdev->vf_token->lock);
+	kfree(vdev->vf_token);
+}
+
+static int vfio_pci_vga_init(struct vfio_pci_device *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int ret;
+
+	if (!vfio_pci_is_vga(pdev))
+		return 0;
+
+	ret = vga_client_register(pdev, vdev, NULL, vfio_pci_set_vga_decode);
+	if (ret)
+		return ret;
+	vga_set_legacy_decoding(pdev, vfio_pci_set_vga_decode(vdev, false));
+	return 0;
+}
+
+static void vfio_pci_vga_uninit(struct vfio_pci_device *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+
+	if (!vfio_pci_is_vga(pdev))
+		return;
+	vga_client_register(pdev, NULL, NULL, NULL);
+	vga_set_legacy_decoding(pdev, VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
+					      VGA_RSRC_LEGACY_IO |
+					      VGA_RSRC_LEGACY_MEM);
+}
+
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct vfio_pci_device *vdev;
@@ -1979,28 +2041,12 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = vfio_pci_reflck_attach(vdev);
 	if (ret)
 		goto out_del_group_dev;
-
-	if (pdev->is_physfn) {
-		vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
-		if (!vdev->vf_token) {
-			ret = -ENOMEM;
-			goto out_reflck;
-		}
-
-		mutex_init(&vdev->vf_token->lock);
-		uuid_gen(&vdev->vf_token->uuid);
-
-		vdev->nb.notifier_call = vfio_pci_bus_notifier;
-		ret = bus_register_notifier(&pci_bus_type, &vdev->nb);
-		if (ret)
-			goto out_vf_token;
-	}
-
-	if (vfio_pci_is_vga(pdev)) {
-		vga_client_register(pdev, vdev, NULL, vfio_pci_set_vga_decode);
-		vga_set_legacy_decoding(pdev,
-					vfio_pci_set_vga_decode(vdev, false));
-	}
+	ret = vfio_pci_vf_init(vdev);
+	if (ret)
+		goto out_reflck;
+	ret = vfio_pci_vga_init(vdev);
+	if (ret)
+		goto out_vf;
 
 	vfio_pci_probe_power_state(vdev);
 
@@ -2020,8 +2066,8 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return ret;
 
-out_vf_token:
-	kfree(vdev->vf_token);
+out_vf:
+	vfio_pci_vf_uninit(vdev);
 out_reflck:
 	vfio_pci_reflck_put(vdev->reflck);
 out_del_group_dev:
@@ -2043,33 +2089,19 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 	if (!vdev)
 		return;
 
-	if (vdev->vf_token) {
-		WARN_ON(vdev->vf_token->users);
-		mutex_destroy(&vdev->vf_token->lock);
-		kfree(vdev->vf_token);
-	}
-
-	if (vdev->nb.notifier_call)
-		bus_unregister_notifier(&pci_bus_type, &vdev->nb);
-
+	vfio_pci_vf_uninit(vdev);
 	vfio_pci_reflck_put(vdev->reflck);
+	vfio_pci_vga_uninit(vdev);
 
 	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
-	kfree(vdev->region);
-	mutex_destroy(&vdev->ioeventfds_lock);
 
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 
+	mutex_destroy(&vdev->ioeventfds_lock);
+	kfree(vdev->region);
 	kfree(vdev->pm_save);
 	kfree(vdev);
-
-	if (vfio_pci_is_vga(pdev)) {
-		vga_client_register(pdev, NULL, NULL, NULL);
-		vga_set_legacy_decoding(pdev,
-				VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
-				VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM);
-	}
 }
 
 static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
-- 
2.30.2



