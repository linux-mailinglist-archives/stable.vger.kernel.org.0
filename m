Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2764F2EDC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238019AbiDEInm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241172AbiDEIcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4207DDFB3;
        Tue,  5 Apr 2022 01:29:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D29AA609D0;
        Tue,  5 Apr 2022 08:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AD9C385A1;
        Tue,  5 Apr 2022 08:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147343;
        bh=I/i7T7HEoLFH2UMaMusK0AA1SCLAgIME1qWj9t4fiAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIxLnlswB1lafuXxbvJyIvaq5yUr+38uSEp0SxjqE3ljTGsXhnkZIJstA59FfPxFW
         jv12Fjf/R5ZiyF+nR9v0JuY1KP6Pv49mGyaiEotOAqHFXiD31E+5l0pLp2iKf61iNc
         eexf8JCUyi1v5osdeJZA1kHmw6d+SdT0UJWPnL4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.17 1052/1126] Revert "virtio_pci: harden MSI-X interrupts"
Date:   Tue,  5 Apr 2022 09:29:59 +0200
Message-Id: <20220405070438.346499190@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jason Wang <jasowang@redhat.com>

commit eb4cecb453a19b34d5454b49532e09e9cb0c1529 upstream.

This reverts commit 9e35276a5344f74d4a3600fc4100b3dd251d5c56. Issue
were reported for the drivers that are using affinity managed IRQ
where manually toggling IRQ status is not expected. And we forget to
enable the interrupts in the restore path as well.

In the future, we will rework on the interrupt hardening.

Fixes: 9e35276a5344 ("virtio_pci: harden MSI-X interrupts")
Reported-by: Marc Zyngier <maz@kernel.org>
Reported-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20220323031524.6555-2-jasowang@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio_pci_common.c |   27 ++++++---------------------
 drivers/virtio/virtio_pci_common.h |    6 ++----
 drivers/virtio/virtio_pci_legacy.c |    5 ++---
 drivers/virtio/virtio_pci_modern.c |    6 ++----
 4 files changed, 12 insertions(+), 32 deletions(-)

--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -24,8 +24,8 @@ MODULE_PARM_DESC(force_legacy,
 		 "Force legacy mode for transitional virtio 1 devices");
 #endif
 
-/* disable irq handlers */
-void vp_disable_cbs(struct virtio_device *vdev)
+/* wait for pending irq handlers */
+void vp_synchronize_vectors(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	int i;
@@ -34,20 +34,7 @@ void vp_disable_cbs(struct virtio_device
 		synchronize_irq(vp_dev->pci_dev->irq);
 
 	for (i = 0; i < vp_dev->msix_vectors; ++i)
-		disable_irq(pci_irq_vector(vp_dev->pci_dev, i));
-}
-
-/* enable irq handlers */
-void vp_enable_cbs(struct virtio_device *vdev)
-{
-	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-	int i;
-
-	if (vp_dev->intx_enabled)
-		return;
-
-	for (i = 0; i < vp_dev->msix_vectors; ++i)
-		enable_irq(pci_irq_vector(vp_dev->pci_dev, i));
+		synchronize_irq(pci_irq_vector(vp_dev->pci_dev, i));
 }
 
 /* the notify function used when creating a virt queue */
@@ -154,8 +141,7 @@ static int vp_request_msix_vectors(struc
 	snprintf(vp_dev->msix_names[v], sizeof *vp_dev->msix_names,
 		 "%s-config", name);
 	err = request_irq(pci_irq_vector(vp_dev->pci_dev, v),
-			  vp_config_changed, IRQF_NO_AUTOEN,
-			  vp_dev->msix_names[v],
+			  vp_config_changed, 0, vp_dev->msix_names[v],
 			  vp_dev);
 	if (err)
 		goto error;
@@ -174,8 +160,7 @@ static int vp_request_msix_vectors(struc
 		snprintf(vp_dev->msix_names[v], sizeof *vp_dev->msix_names,
 			 "%s-virtqueues", name);
 		err = request_irq(pci_irq_vector(vp_dev->pci_dev, v),
-				  vp_vring_interrupt, IRQF_NO_AUTOEN,
-				  vp_dev->msix_names[v],
+				  vp_vring_interrupt, 0, vp_dev->msix_names[v],
 				  vp_dev);
 		if (err)
 			goto error;
@@ -352,7 +337,7 @@ static int vp_find_vqs_msix(struct virti
 			 "%s-%s",
 			 dev_name(&vp_dev->vdev.dev), names[i]);
 		err = request_irq(pci_irq_vector(vp_dev->pci_dev, msix_vec),
-				  vring_interrupt, IRQF_NO_AUTOEN,
+				  vring_interrupt, 0,
 				  vp_dev->msix_names[msix_vec],
 				  vqs[i]);
 		if (err)
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -101,10 +101,8 @@ static struct virtio_pci_device *to_vp_d
 	return container_of(vdev, struct virtio_pci_device, vdev);
 }
 
-/* disable irq handlers */
-void vp_disable_cbs(struct virtio_device *vdev);
-/* enable irq handlers */
-void vp_enable_cbs(struct virtio_device *vdev);
+/* wait for pending irq handlers */
+void vp_synchronize_vectors(struct virtio_device *vdev);
 /* the notify function used when creating a virt queue */
 bool vp_notify(struct virtqueue *vq);
 /* the config->del_vqs() implementation */
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -98,8 +98,8 @@ static void vp_reset(struct virtio_devic
 	/* Flush out the status write, and flush in device writes,
 	 * including MSi-X interrupts, if any. */
 	vp_legacy_get_status(&vp_dev->ldev);
-	/* Disable VQ/configuration callbacks. */
-	vp_disable_cbs(vdev);
+	/* Flush pending VQ/configuration callbacks. */
+	vp_synchronize_vectors(vdev);
 }
 
 static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
@@ -185,7 +185,6 @@ static void del_vq(struct virtio_pci_vq_
 }
 
 static const struct virtio_config_ops virtio_pci_config_ops = {
-	.enable_cbs	= vp_enable_cbs,
 	.get		= vp_get,
 	.set		= vp_set,
 	.get_status	= vp_get_status,
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -172,8 +172,8 @@ static void vp_reset(struct virtio_devic
 	 */
 	while (vp_modern_get_status(mdev))
 		msleep(1);
-	/* Disable VQ/configuration callbacks. */
-	vp_disable_cbs(vdev);
+	/* Flush pending VQ/configuration callbacks. */
+	vp_synchronize_vectors(vdev);
 }
 
 static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
@@ -380,7 +380,6 @@ static bool vp_get_shm_region(struct vir
 }
 
 static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
-	.enable_cbs	= vp_enable_cbs,
 	.get		= NULL,
 	.set		= NULL,
 	.generation	= vp_generation,
@@ -398,7 +397,6 @@ static const struct virtio_config_ops vi
 };
 
 static const struct virtio_config_ops virtio_pci_config_ops = {
-	.enable_cbs	= vp_enable_cbs,
 	.get		= vp_get,
 	.set		= vp_set,
 	.generation	= vp_generation,


