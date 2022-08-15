Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08AC59460A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348867AbiHOW3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351104AbiHOW1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:27:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7A46DF85;
        Mon, 15 Aug 2022 12:47:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39C4FB81136;
        Mon, 15 Aug 2022 19:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BC9C433B5;
        Mon, 15 Aug 2022 19:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592838;
        bh=rFrCVLc72DPGbHT/rqudyydWwpDsJi9Vyl0HwKKnEwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CdkwOp9yafDbwn2CCR7Vg3LoTlIOTYGy3JR5zAFaSKZAI5Wro9NoZNLDVKXRcfEjn
         88ui2qF68mKuKZqr7QVECsTI/vyUVl0I5JJzE5oISAPGxqVixkYOYW7c1LTVR/3Hjk
         bBtysC0Mofycu90S+Y93mAcZnffGOs0NXcpg94GI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0852/1095] vfio/pci: Have all VFIO PCI drivers store the vfio_pci_core_device in drvdata
Date:   Mon, 15 Aug 2022 20:04:11 +0200
Message-Id: <20220815180504.574664484@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

[ Upstream commit 91be0bd6c6cf21328017e990d3ceeb00f03821fd ]

Having a consistent pointer in the drvdata will allow the next patch to
make use of the drvdata from some of the core code helpers.

Use a WARN_ON inside vfio_pci_core_register_device() to detect drivers
that miss this.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/1-v4-c841817a0349+8f-vfio_get_from_dev_jgg@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 15 +++++++++++----
 drivers/vfio/pci/mlx5/main.c                   | 15 +++++++++++----
 drivers/vfio/pci/vfio_pci.c                    |  2 +-
 drivers/vfio/pci/vfio_pci_core.c               |  4 ++++
 4 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 767b5d47631a..e92376837b29 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -337,6 +337,14 @@ static int vf_qm_cache_wb(struct hisi_qm *qm)
 	return 0;
 }
 
+static struct hisi_acc_vf_core_device *hssi_acc_drvdata(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+
+	return container_of(core_device, struct hisi_acc_vf_core_device,
+			    core_device);
+}
+
 static void vf_qm_fun_reset(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 			    struct hisi_qm *qm)
 {
@@ -962,7 +970,7 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
 
 static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
 {
-	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
 
 	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
 				VFIO_MIGRATION_STOP_COPY)
@@ -1274,11 +1282,10 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 					  &hisi_acc_vfio_pci_ops);
 	}
 
+	dev_set_drvdata(&pdev->dev, &hisi_acc_vdev->core_device);
 	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
 	if (ret)
 		goto out_free;
-
-	dev_set_drvdata(&pdev->dev, hisi_acc_vdev);
 	return 0;
 
 out_free:
@@ -1289,7 +1296,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 
 static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
 {
-	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
 
 	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
 	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index bbec5d288fee..9f59f5807b8a 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -39,6 +39,14 @@ struct mlx5vf_pci_core_device {
 	struct mlx5_vf_migration_file *saving_migf;
 };
 
+static struct mlx5vf_pci_core_device *mlx5vf_drvdata(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+
+	return container_of(core_device, struct mlx5vf_pci_core_device,
+			    core_device);
+}
+
 static struct page *
 mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
 			  unsigned long offset)
@@ -505,7 +513,7 @@ static int mlx5vf_pci_get_device_state(struct vfio_device *vdev,
 
 static void mlx5vf_pci_aer_reset_done(struct pci_dev *pdev)
 {
-	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
+	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
 
 	if (!mvdev->migrate_cap)
 		return;
@@ -614,11 +622,10 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 		}
 	}
 
+	dev_set_drvdata(&pdev->dev, &mvdev->core_device);
 	ret = vfio_pci_core_register_device(&mvdev->core_device);
 	if (ret)
 		goto out_free;
-
-	dev_set_drvdata(&pdev->dev, mvdev);
 	return 0;
 
 out_free:
@@ -629,7 +636,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 
 static void mlx5vf_pci_remove(struct pci_dev *pdev)
 {
-	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
+	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
 
 	vfio_pci_core_unregister_device(&mvdev->core_device);
 	vfio_pci_core_uninit_device(&mvdev->core_device);
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 2b047469e02f..8c990a1a7def 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -151,10 +151,10 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENOMEM;
 	vfio_pci_core_init_device(vdev, pdev, &vfio_pci_ops);
 
+	dev_set_drvdata(&pdev->dev, vdev);
 	ret = vfio_pci_core_register_device(vdev);
 	if (ret)
 		goto out_free;
-	dev_set_drvdata(&pdev->dev, vdev);
 	return 0;
 
 out_free:
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 06b6f3594a13..65587fd5c021 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1821,6 +1821,10 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
 
+	/* Drivers must set the vfio_pci_core_device to their drvdata */
+	if (WARN_ON(vdev != dev_get_drvdata(&vdev->pdev->dev)))
+		return -EINVAL;
+
 	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
 		return -EINVAL;
 
-- 
2.35.1



