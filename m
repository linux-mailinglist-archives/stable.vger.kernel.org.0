Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112A2485225
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 12:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbiAEL6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 06:58:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33606 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235517AbiAEL6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 06:58:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A401EB81A62;
        Wed,  5 Jan 2022 11:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5B2C36AEB;
        Wed,  5 Jan 2022 11:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641383898;
        bh=nm6KaY1YqsFMq9frmoehve+z+PPShG7TwUZPQbT8aKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsAGCVBRm2mpFBVqGCneRr3YarAVwD4HM8DaK6UMmEJVdfwo8JxM7IvmdBUjvNd8y
         nMMs2KbstovqE9mPOMDEnrBNzgnWxF3eKjjtl9ek8iw5bxIAPnhQVtsyeKpTZ+ZULH
         AaJ2KvhnL8A4zQ8JcWFgLhMaYgF3fUl1Ji4LWltA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.261
Date:   Wed,  5 Jan 2022 12:58:10 +0100
Message-Id: <1641383889144220@kroah.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <164138388915177@kroah.com>
References: <164138388915177@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 8a87f5c06a83..38e64d636717 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 260
+SUBLEVEL = 261
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index f89ea0866892..1687368ea71f 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -619,7 +619,7 @@ static void binder_free_buf_locked(struct binder_alloc *alloc,
 	BUG_ON(buffer->data > alloc->buffer + alloc->buffer_size);
 
 	if (buffer->async_transaction) {
-		alloc->free_async_space += size + sizeof(struct binder_buffer);
+		alloc->free_async_space += buffer_size + sizeof(struct binder_buffer);
 
 		binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC_ASYNC,
 			     "%d: binder_free_buf size %zd async free %zd\n",
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 5f5580fbd351..a4fb3fccf1b2 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -148,6 +148,7 @@ config HID_APPLEIR
 
 config HID_ASUS
 	tristate "Asus"
+	depends on USB_HID
 	depends on LEDS_CLASS
 	---help---
 	Support for Asus notebook built-in keyboard and touchpad via i2c, and
diff --git a/drivers/input/joystick/spaceball.c b/drivers/input/joystick/spaceball.c
index e9712a1b7cad..43bc432e1d3a 100644
--- a/drivers/input/joystick/spaceball.c
+++ b/drivers/input/joystick/spaceball.c
@@ -35,6 +35,7 @@
 #include <linux/module.h>
 #include <linux/input.h>
 #include <linux/serio.h>
+#include <asm/unaligned.h>
 
 #define DRIVER_DESC	"SpaceTec SpaceBall 2003/3003/4000 FLX driver"
 
@@ -91,9 +92,15 @@ static void spaceball_process_packet(struct spaceball* spaceball)
 
 		case 'D':					/* Ball data */
 			if (spaceball->idx != 15) return;
-			for (i = 0; i < 6; i++)
+			/*
+			 * Skip first three bytes; read six axes worth of data.
+			 * Axis values are signed 16-bit big-endian.
+			 */
+			data += 3;
+			for (i = 0; i < ARRAY_SIZE(spaceball_axes); i++) {
 				input_report_abs(dev, spaceball_axes[i],
-					(__s16)((data[2 * i + 3] << 8) | data[2 * i + 2]));
+					(__s16)get_unaligned_be16(&data[i * 2]));
+			}
 			break;
 
 		case 'K':					/* Button data */
diff --git a/drivers/input/mouse/appletouch.c b/drivers/input/mouse/appletouch.c
index 81a695d0b4e0..5b4f15a23293 100644
--- a/drivers/input/mouse/appletouch.c
+++ b/drivers/input/mouse/appletouch.c
@@ -929,6 +929,8 @@ static int atp_probe(struct usb_interface *iface,
 	set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
 	set_bit(BTN_LEFT, input_dev->keybit);
 
+	INIT_WORK(&dev->work, atp_reinit);
+
 	error = input_register_device(dev->input);
 	if (error)
 		goto err_free_buffer;
@@ -936,8 +938,6 @@ static int atp_probe(struct usb_interface *iface,
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(iface, dev);
 
-	INIT_WORK(&dev->work, atp_reinit);
-
 	return 0;
 
  err_free_buffer:
diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
index ac3d791f5282..b7295f21aa58 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -1779,7 +1779,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 	fman = dev_get_drvdata(&fm_pdev->dev);
 	if (!fman) {
 		err = -EINVAL;
-		goto return_err;
+		goto put_device;
 	}
 
 	err = of_property_read_u32(port_node, "cell-index", &val);
@@ -1787,7 +1787,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 		dev_err(port->dev, "%s: reading cell-index for %pOF failed\n",
 			__func__, port_node);
 		err = -EINVAL;
-		goto return_err;
+		goto put_device;
 	}
 	port_id = (u8)val;
 	port->dts_params.id = port_id;
@@ -1821,7 +1821,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 	}  else {
 		dev_err(port->dev, "%s: Illegal port type\n", __func__);
 		err = -EINVAL;
-		goto return_err;
+		goto put_device;
 	}
 
 	port->dts_params.type = port_type;
@@ -1835,7 +1835,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 			dev_err(port->dev, "%s: incorrect qman-channel-id\n",
 				__func__);
 			err = -EINVAL;
-			goto return_err;
+			goto put_device;
 		}
 		port->dts_params.qman_channel_id = qman_channel_id;
 	}
@@ -1845,7 +1845,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 		dev_err(port->dev, "%s: of_address_to_resource() failed\n",
 			__func__);
 		err = -ENOMEM;
-		goto return_err;
+		goto put_device;
 	}
 
 	port->dts_params.fman = fman;
@@ -1870,6 +1870,8 @@ static int fman_port_probe(struct platform_device *of_dev)
 
 	return 0;
 
+put_device:
+	put_device(&fm_pdev->dev);
 return_err:
 	of_node_put(port_node);
 free_port:
diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index d18a283a0ccf..408b996ff4df 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -498,11 +498,11 @@ static void read_bulk_callback(struct urb *urb)
 		goto goon;
 
 	rx_status = buf[count - 2];
-	if (rx_status & 0x1e) {
+	if (rx_status & 0x1c) {
 		netif_dbg(pegasus, rx_err, net,
 			  "RX packet error %x\n", rx_status);
 		net->stats.rx_errors++;
-		if (rx_status & 0x06)	/* long or runt	*/
+		if (rx_status & 0x04)	/* runt	*/
 			net->stats.rx_length_errors++;
 		if (rx_status & 0x08)
 			net->stats.rx_crc_errors++;
diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index cd1f7bfa75eb..dc9dd66cf673 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -544,7 +544,8 @@ static int st21nfca_hci_i2c_probe(struct i2c_client *client,
 	phy->gpiod_ena = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(phy->gpiod_ena)) {
 		nfc_err(dev, "Unable to get ENABLE GPIO\n");
-		return PTR_ERR(phy->gpiod_ena);
+		r = PTR_ERR(phy->gpiod_ena);
+		goto out_free;
 	}
 
 	phy->se_status.is_ese_present =
@@ -555,7 +556,7 @@ static int st21nfca_hci_i2c_probe(struct i2c_client *client,
 	r = st21nfca_hci_platform_init(phy);
 	if (r < 0) {
 		nfc_err(&client->dev, "Unable to reboot st21nfca\n");
-		return r;
+		goto out_free;
 	}
 
 	r = devm_request_threaded_irq(&client->dev, client->irq, NULL,
@@ -564,15 +565,23 @@ static int st21nfca_hci_i2c_probe(struct i2c_client *client,
 				ST21NFCA_HCI_DRIVER_NAME, phy);
 	if (r < 0) {
 		nfc_err(&client->dev, "Unable to register IRQ handler\n");
-		return r;
+		goto out_free;
 	}
 
-	return st21nfca_hci_probe(phy, &i2c_phy_ops, LLC_SHDLC_NAME,
-					ST21NFCA_FRAME_HEADROOM,
-					ST21NFCA_FRAME_TAILROOM,
-					ST21NFCA_HCI_LLC_MAX_PAYLOAD,
-					&phy->hdev,
-					&phy->se_status);
+	r = st21nfca_hci_probe(phy, &i2c_phy_ops, LLC_SHDLC_NAME,
+			       ST21NFCA_FRAME_HEADROOM,
+			       ST21NFCA_FRAME_TAILROOM,
+			       ST21NFCA_HCI_LLC_MAX_PAYLOAD,
+			       &phy->hdev,
+			       &phy->se_status);
+	if (r)
+		goto out_free;
+
+	return 0;
+
+out_free:
+	kfree_skb(phy->pending_skb);
+	return r;
 }
 
 static int st21nfca_hci_i2c_remove(struct i2c_client *client)
@@ -585,6 +594,8 @@ static int st21nfca_hci_i2c_remove(struct i2c_client *client)
 
 	if (phy->powered)
 		st21nfca_hci_i2c_disable(phy);
+	if (phy->pending_skb)
+		kfree_skb(phy->pending_skb);
 
 	return 0;
 }
diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
index 7c4eb86c851e..5463d740f352 100644
--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -628,7 +628,7 @@ static int gmux_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 	}
 
 	gmux_data->iostart = res->start;
-	gmux_data->iolen = res->end - res->start;
+	gmux_data->iolen = resource_size(res);
 
 	if (gmux_data->iolen < GMUX_MIN_IO_LEN) {
 		pr_err("gmux I/O region too small (%lu < %u)\n",
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index c77ad2b78ce4..39a1c9e18c0e 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2177,8 +2177,8 @@ lpfc_debugfs_nvmeio_trc_write(struct file *file, const char __user *buf,
 	char mybuf[64];
 	char *pbuf;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > 63)
+		nbytes = 63;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 2c707b5c7b0b..68b5177bf09d 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -578,9 +578,12 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 			 * Commands like INQUIRY may transfer less data than
 			 * requested by the initiator via bufflen. Set residual
 			 * count to make upper layer aware of the actual amount
-			 * of data returned.
+			 * of data returned. There are cases when controller
+			 * returns zero dataLen with non zero data - do not set
+			 * residual count in that case.
 			 */
-			scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);
+			if (e->dataLen && (e->dataLen < scsi_bufflen(cmd)))
+				scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);
 			cmd->result = (DID_OK << 16);
 			break;
 
diff --git a/drivers/tee/tee_private.h b/drivers/tee/tee_private.h
index 21cb6be8bce9..4ef325f782d1 100644
--- a/drivers/tee/tee_private.h
+++ b/drivers/tee/tee_private.h
@@ -31,7 +31,7 @@ struct tee_device;
  * @paddr:	physical address of the shared memory
  * @kaddr:	virtual address of the shared memory
  * @size:	size of shared memory
- * @dmabuf:	dmabuf used to for exporting to user space
+ * @refcount:	reference counter
  * @flags:	defined by TEE_SHM_* in tee_drv.h
  * @id:		unique id of a shared memory object on this device
  */
@@ -42,7 +42,7 @@ struct tee_shm {
 	phys_addr_t paddr;
 	void *kaddr;
 	size_t size;
-	struct dma_buf *dmabuf;
+	refcount_t refcount;
 	u32 flags;
 	int id;
 };
diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index ea3ce4e17b85..b8f171b9658b 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2015-2016, Linaro Limited
+ * Copyright (c) 2015-2017, 2019-2021 Linaro Limited
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -11,26 +11,19 @@
  * GNU General Public License for more details.
  *
  */
+#include <linux/anon_inodes.h>
 #include <linux/device.h>
-#include <linux/dma-buf.h>
-#include <linux/fdtable.h>
 #include <linux/idr.h>
+#include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/tee_drv.h>
 #include "tee_private.h"
 
-static void tee_shm_release(struct tee_shm *shm)
+static void tee_shm_release(struct tee_device *teedev, struct tee_shm *shm)
 {
-	struct tee_device *teedev = shm->teedev;
 	struct tee_shm_pool_mgr *poolm;
 
-	mutex_lock(&teedev->mutex);
-	idr_remove(&teedev->idr, shm->id);
-	if (shm->ctx)
-		list_del(&shm->link);
-	mutex_unlock(&teedev->mutex);
-
 	if (shm->flags & TEE_SHM_DMA_BUF)
 		poolm = &teedev->pool->dma_buf_mgr;
 	else
@@ -42,53 +35,6 @@ static void tee_shm_release(struct tee_shm *shm)
 	tee_device_put(teedev);
 }
 
-static struct sg_table *tee_shm_op_map_dma_buf(struct dma_buf_attachment
-			*attach, enum dma_data_direction dir)
-{
-	return NULL;
-}
-
-static void tee_shm_op_unmap_dma_buf(struct dma_buf_attachment *attach,
-				     struct sg_table *table,
-				     enum dma_data_direction dir)
-{
-}
-
-static void tee_shm_op_release(struct dma_buf *dmabuf)
-{
-	struct tee_shm *shm = dmabuf->priv;
-
-	tee_shm_release(shm);
-}
-
-static void *tee_shm_op_map_atomic(struct dma_buf *dmabuf, unsigned long pgnum)
-{
-	return NULL;
-}
-
-static void *tee_shm_op_map(struct dma_buf *dmabuf, unsigned long pgnum)
-{
-	return NULL;
-}
-
-static int tee_shm_op_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
-{
-	struct tee_shm *shm = dmabuf->priv;
-	size_t size = vma->vm_end - vma->vm_start;
-
-	return remap_pfn_range(vma, vma->vm_start, shm->paddr >> PAGE_SHIFT,
-			       size, vma->vm_page_prot);
-}
-
-static const struct dma_buf_ops tee_shm_dma_buf_ops = {
-	.map_dma_buf = tee_shm_op_map_dma_buf,
-	.unmap_dma_buf = tee_shm_op_unmap_dma_buf,
-	.release = tee_shm_op_release,
-	.map_atomic = tee_shm_op_map_atomic,
-	.map = tee_shm_op_map,
-	.mmap = tee_shm_op_mmap,
-};
-
 /**
  * tee_shm_alloc() - Allocate shared memory
  * @ctx:	Context that allocates the shared memory
@@ -135,6 +81,7 @@ struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
 		goto err_dev_put;
 	}
 
+	refcount_set(&shm->refcount, 1);
 	shm->flags = flags;
 	shm->teedev = teedev;
 	shm->ctx = ctx;
@@ -157,29 +104,11 @@ struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
 		goto err_pool_free;
 	}
 
-	if (flags & TEE_SHM_DMA_BUF) {
-		DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
-
-		exp_info.ops = &tee_shm_dma_buf_ops;
-		exp_info.size = shm->size;
-		exp_info.flags = O_RDWR;
-		exp_info.priv = shm;
-
-		shm->dmabuf = dma_buf_export(&exp_info);
-		if (IS_ERR(shm->dmabuf)) {
-			ret = ERR_CAST(shm->dmabuf);
-			goto err_rem;
-		}
-	}
 	mutex_lock(&teedev->mutex);
 	list_add_tail(&shm->link, &ctx->list_shm);
 	mutex_unlock(&teedev->mutex);
 
 	return shm;
-err_rem:
-	mutex_lock(&teedev->mutex);
-	idr_remove(&teedev->idr, shm->id);
-	mutex_unlock(&teedev->mutex);
 err_pool_free:
 	poolm->ops->free(poolm, shm);
 err_kfree:
@@ -190,6 +119,31 @@ struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
 }
 EXPORT_SYMBOL_GPL(tee_shm_alloc);
 
+static int tee_shm_fop_release(struct inode *inode, struct file *filp)
+{
+	tee_shm_put(filp->private_data);
+	return 0;
+}
+
+static int tee_shm_fop_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct tee_shm *shm = filp->private_data;
+	size_t size = vma->vm_end - vma->vm_start;
+
+	/* check for overflowing the buffer's size */
+	if (vma->vm_pgoff + vma_pages(vma) > shm->size >> PAGE_SHIFT)
+		return -EINVAL;
+
+	return remap_pfn_range(vma, vma->vm_start, shm->paddr >> PAGE_SHIFT,
+			       size, vma->vm_page_prot);
+}
+
+static const struct file_operations tee_shm_fops = {
+	.owner = THIS_MODULE,
+	.release = tee_shm_fop_release,
+	.mmap = tee_shm_fop_mmap,
+};
+
 /**
  * tee_shm_get_fd() - Increase reference count and return file descriptor
  * @shm:	Shared memory handle
@@ -203,10 +157,11 @@ int tee_shm_get_fd(struct tee_shm *shm)
 	if ((shm->flags & req_flags) != req_flags)
 		return -EINVAL;
 
-	get_dma_buf(shm->dmabuf);
-	fd = dma_buf_fd(shm->dmabuf, O_CLOEXEC);
+	/* matched by tee_shm_put() in tee_shm_op_release() */
+	refcount_inc(&shm->refcount);
+	fd = anon_inode_getfd("tee_shm", &tee_shm_fops, shm, O_RDWR);
 	if (fd < 0)
-		dma_buf_put(shm->dmabuf);
+		tee_shm_put(shm);
 	return fd;
 }
 
@@ -216,17 +171,7 @@ int tee_shm_get_fd(struct tee_shm *shm)
  */
 void tee_shm_free(struct tee_shm *shm)
 {
-	/*
-	 * dma_buf_put() decreases the dmabuf reference counter and will
-	 * call tee_shm_release() when the last reference is gone.
-	 *
-	 * In the case of driver private memory we call tee_shm_release
-	 * directly instead as it doesn't have a reference counter.
-	 */
-	if (shm->flags & TEE_SHM_DMA_BUF)
-		dma_buf_put(shm->dmabuf);
-	else
-		tee_shm_release(shm);
+	tee_shm_put(shm);
 }
 EXPORT_SYMBOL_GPL(tee_shm_free);
 
@@ -327,10 +272,15 @@ struct tee_shm *tee_shm_get_from_id(struct tee_context *ctx, int id)
 	teedev = ctx->teedev;
 	mutex_lock(&teedev->mutex);
 	shm = idr_find(&teedev->idr, id);
+	/*
+	 * If the tee_shm was found in the IDR it must have a refcount
+	 * larger than 0 due to the guarantee in tee_shm_put() below. So
+	 * it's safe to use refcount_inc().
+	 */
 	if (!shm || shm->ctx != ctx)
 		shm = ERR_PTR(-EINVAL);
-	else if (shm->flags & TEE_SHM_DMA_BUF)
-		get_dma_buf(shm->dmabuf);
+	else
+		refcount_inc(&shm->refcount);
 	mutex_unlock(&teedev->mutex);
 	return shm;
 }
@@ -353,7 +303,24 @@ EXPORT_SYMBOL_GPL(tee_shm_get_id);
  */
 void tee_shm_put(struct tee_shm *shm)
 {
-	if (shm->flags & TEE_SHM_DMA_BUF)
-		dma_buf_put(shm->dmabuf);
+	struct tee_device *teedev = shm->teedev;
+	bool do_release = false;
+
+	mutex_lock(&teedev->mutex);
+	if (refcount_dec_and_test(&shm->refcount)) {
+		/*
+		 * refcount has reached 0, we must now remove it from the
+		 * IDR before releasing the mutex.  This will guarantee
+		 * that the refcount_inc() in tee_shm_get_from_id() never
+		 * starts from 0.
+		 */
+		if (shm->ctx)
+			list_del(&shm->link);
+		do_release = true;
+	}
+	mutex_unlock(&teedev->mutex);
+
+	if (do_release)
+		tee_shm_release(teedev, shm);
 }
 EXPORT_SYMBOL_GPL(tee_shm_put);
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 5dfe926c251a..6029f9b00b4a 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1688,11 +1688,15 @@ static void ffs_data_clear(struct ffs_data *ffs)
 
 	BUG_ON(ffs->gadget);
 
-	if (ffs->epfiles)
+	if (ffs->epfiles) {
 		ffs_epfiles_destroy(ffs->epfiles, ffs->eps_count);
+		ffs->epfiles = NULL;
+	}
 
-	if (ffs->ffs_eventfd)
+	if (ffs->ffs_eventfd) {
 		eventfd_ctx_put(ffs->ffs_eventfd);
+		ffs->ffs_eventfd = NULL;
+	}
 
 	kfree(ffs->raw_descs_data);
 	kfree(ffs->raw_strings);
@@ -1705,7 +1709,6 @@ static void ffs_data_reset(struct ffs_data *ffs)
 
 	ffs_data_clear(ffs);
 
-	ffs->epfiles = NULL;
 	ffs->raw_descs_data = NULL;
 	ffs->raw_descs = NULL;
 	ffs->raw_strings = NULL;
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 0e419cb53de4..bf649af49cbd 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -100,7 +100,6 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	/* Look for vendor-specific quirks */
 	if (pdev->vendor == PCI_VENDOR_ID_FRESCO_LOGIC &&
 			(pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK ||
-			 pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1100 ||
 			 pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1400)) {
 		if (pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK &&
 				pdev->revision == 0x0) {
@@ -135,6 +134,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 			pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1009)
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 
+	if (pdev->vendor == PCI_VENDOR_ID_FRESCO_LOGIC &&
+			pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1100)
+		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
+
 	if (pdev->vendor == PCI_VENDOR_ID_NEC)
 		xhci->quirks |= XHCI_NEC_HOST;
 
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index c713bd62428f..6c20a08a54ae 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -118,6 +118,7 @@ extern struct percpu_counter sctp_sockets_allocated;
 int sctp_asconf_mgmt(struct sctp_sock *, struct sctp_sockaddr_entry *);
 struct sk_buff *sctp_skb_recv_datagram(struct sock *, int, int, int *);
 
+typedef int (*sctp_callback_t)(struct sctp_endpoint *, struct sctp_transport *, void *);
 int sctp_transport_walk_start(struct rhashtable_iter *iter);
 void sctp_transport_walk_stop(struct rhashtable_iter *iter);
 struct sctp_transport *sctp_transport_get_next(struct net *net,
@@ -128,9 +129,8 @@ int sctp_transport_lookup_process(int (*cb)(struct sctp_transport *, void *),
 				  struct net *net,
 				  const union sctp_addr *laddr,
 				  const union sctp_addr *paddr, void *p);
-int sctp_for_each_transport(int (*cb)(struct sctp_transport *, void *),
-			    int (*cb_done)(struct sctp_transport *, void *),
-			    struct net *net, int *pos, void *p);
+int sctp_transport_traverse_process(sctp_callback_t cb, sctp_callback_t cb_done,
+				    struct net *net, int *pos, void *p);
 int sctp_for_each_endpoint(int (*cb)(struct sctp_endpoint *, void *), void *p);
 int sctp_get_sctp_info(struct sock *sk, struct sctp_association *asoc,
 		       struct sctp_info *info);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 5831a304e61b..adbd8ad778f4 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1272,6 +1272,7 @@ struct sctp_endpoint {
 	      reconf_enable:1;
 
 	__u8  strreset_enable;
+	struct rcu_head rcu;
 };
 
 /* Recover the outter endpoint structure. */
@@ -1287,7 +1288,7 @@ static inline struct sctp_endpoint *sctp_ep(struct sctp_ep_common *base)
 struct sctp_endpoint *sctp_endpoint_new(struct sock *, gfp_t);
 void sctp_endpoint_free(struct sctp_endpoint *);
 void sctp_endpoint_put(struct sctp_endpoint *);
-void sctp_endpoint_hold(struct sctp_endpoint *);
+int sctp_endpoint_hold(struct sctp_endpoint *ep);
 void sctp_endpoint_add_asoc(struct sctp_endpoint *, struct sctp_association *);
 struct sctp_association *sctp_endpoint_lookup_assoc(
 	const struct sctp_endpoint *ep,
diff --git a/include/uapi/linux/nfc.h b/include/uapi/linux/nfc.h
index 399f39ff8048..1b6d54a328ba 100644
--- a/include/uapi/linux/nfc.h
+++ b/include/uapi/linux/nfc.h
@@ -261,7 +261,7 @@ enum nfc_sdp_attr {
 #define NFC_SE_ENABLED  0x1
 
 struct sockaddr_nfc {
-	sa_family_t sa_family;
+	__kernel_sa_family_t sa_family;
 	__u32 dev_idx;
 	__u32 target_idx;
 	__u32 nfc_protocol;
@@ -269,14 +269,14 @@ struct sockaddr_nfc {
 
 #define NFC_LLCP_MAX_SERVICE_NAME 63
 struct sockaddr_nfc_llcp {
-	sa_family_t sa_family;
+	__kernel_sa_family_t sa_family;
 	__u32 dev_idx;
 	__u32 target_idx;
 	__u32 nfc_protocol;
 	__u8 dsap; /* Destination SAP, if known */
 	__u8 ssap; /* Source SAP to be bound to */
 	char service_name[NFC_LLCP_MAX_SERVICE_NAME]; /* Service name URI */;
-	size_t service_name_len;
+	__kernel_size_t service_name_len;
 };
 
 /* NFC socket protocols */
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index f31c09873d0f..d0ef51d49f8a 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1883,6 +1883,10 @@ static int __init inet_init(void)
 
 	ip_init();
 
+	/* Initialise per-cpu ipv4 mibs */
+	if (init_ipv4_mibs())
+		panic("%s: Cannot init ipv4 mibs\n", __func__);
+
 	/* Setup TCP slab cache for open requests. */
 	tcp_init();
 
@@ -1911,12 +1915,6 @@ static int __init inet_init(void)
 
 	if (init_inet_pernet_ops())
 		pr_crit("%s: Cannot init ipv4 inet pernet ops\n", __func__);
-	/*
-	 *	Initialise per-cpu ipv4 mibs
-	 */
-
-	if (init_ipv4_mibs())
-		pr_crit("%s: Cannot init ipv4 mibs\n", __func__);
 
 	ipv4_proc_init();
 
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index c71b4191df1e..8d3ee8bb6181 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -242,6 +242,18 @@ void sctp_endpoint_free(struct sctp_endpoint *ep)
 }
 
 /* Final destructor for endpoint.  */
+static void sctp_endpoint_destroy_rcu(struct rcu_head *head)
+{
+	struct sctp_endpoint *ep = container_of(head, struct sctp_endpoint, rcu);
+	struct sock *sk = ep->base.sk;
+
+	sctp_sk(sk)->ep = NULL;
+	sock_put(sk);
+
+	kfree(ep);
+	SCTP_DBG_OBJCNT_DEC(ep);
+}
+
 static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
 {
 	struct sock *sk;
@@ -275,18 +287,13 @@ static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
 	if (sctp_sk(sk)->bind_hash)
 		sctp_put_port(sk);
 
-	sctp_sk(sk)->ep = NULL;
-	/* Give up our hold on the sock */
-	sock_put(sk);
-
-	kfree(ep);
-	SCTP_DBG_OBJCNT_DEC(ep);
+	call_rcu(&ep->rcu, sctp_endpoint_destroy_rcu);
 }
 
 /* Hold a reference to an endpoint. */
-void sctp_endpoint_hold(struct sctp_endpoint *ep)
+int sctp_endpoint_hold(struct sctp_endpoint *ep)
 {
-	refcount_inc(&ep->base.refcnt);
+	return refcount_inc_not_zero(&ep->base.refcnt);
 }
 
 /* Release a reference to an endpoint and clean up if there are
diff --git a/net/sctp/sctp_diag.c b/net/sctp/sctp_diag.c
index 6a5a3dfa6c8d..7c7b476bad31 100644
--- a/net/sctp/sctp_diag.c
+++ b/net/sctp/sctp_diag.c
@@ -276,9 +276,8 @@ static int sctp_tsp_dump_one(struct sctp_transport *tsp, void *p)
 	return err;
 }
 
-static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
+static int sctp_sock_dump(struct sctp_endpoint *ep, struct sctp_transport *tsp, void *p)
 {
-	struct sctp_endpoint *ep = tsp->asoc->ep;
 	struct sctp_comm_param *commp = p;
 	struct sock *sk = ep->base.sk;
 	struct sk_buff *skb = commp->skb;
@@ -288,6 +287,8 @@ static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
 	int err = 0;
 
 	lock_sock(sk);
+	if (ep != tsp->asoc->ep)
+		goto release;
 	list_for_each_entry(assoc, &ep->asocs, asocs) {
 		if (cb->args[4] < cb->args[1])
 			goto next;
@@ -330,9 +331,8 @@ static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
 	return err;
 }
 
-static int sctp_sock_filter(struct sctp_transport *tsp, void *p)
+static int sctp_sock_filter(struct sctp_endpoint *ep, struct sctp_transport *tsp, void *p)
 {
-	struct sctp_endpoint *ep = tsp->asoc->ep;
 	struct sctp_comm_param *commp = p;
 	struct sock *sk = ep->base.sk;
 	const struct inet_diag_req_v2 *r = commp->r;
@@ -490,8 +490,8 @@ static void sctp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	if (!(idiag_states & ~(TCPF_LISTEN | TCPF_CLOSE)))
 		goto done;
 
-	sctp_for_each_transport(sctp_sock_filter, sctp_sock_dump,
-				net, &pos, &commp);
+	sctp_transport_traverse_process(sctp_sock_filter, sctp_sock_dump,
+					net, &pos, &commp);
 	cb->args[2] = pos;
 
 done:
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 8d64caa72cba..fac24f329c1d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4738,11 +4738,12 @@ int sctp_transport_lookup_process(int (*cb)(struct sctp_transport *, void *),
 }
 EXPORT_SYMBOL_GPL(sctp_transport_lookup_process);
 
-int sctp_for_each_transport(int (*cb)(struct sctp_transport *, void *),
-			    int (*cb_done)(struct sctp_transport *, void *),
-			    struct net *net, int *pos, void *p) {
+int sctp_transport_traverse_process(sctp_callback_t cb, sctp_callback_t cb_done,
+				    struct net *net, int *pos, void *p)
+{
 	struct rhashtable_iter hti;
 	struct sctp_transport *tsp;
+	struct sctp_endpoint *ep;
 	int ret;
 
 again:
@@ -4752,26 +4753,32 @@ int sctp_for_each_transport(int (*cb)(struct sctp_transport *, void *),
 
 	tsp = sctp_transport_get_idx(net, &hti, *pos + 1);
 	for (; !IS_ERR_OR_NULL(tsp); tsp = sctp_transport_get_next(net, &hti)) {
-		ret = cb(tsp, p);
-		if (ret)
-			break;
+		ep = tsp->asoc->ep;
+		if (sctp_endpoint_hold(ep)) { /* asoc can be peeled off */
+			ret = cb(ep, tsp, p);
+			if (ret)
+				break;
+			sctp_endpoint_put(ep);
+		}
 		(*pos)++;
 		sctp_transport_put(tsp);
 	}
 	sctp_transport_walk_stop(&hti);
 
 	if (ret) {
-		if (cb_done && !cb_done(tsp, p)) {
+		if (cb_done && !cb_done(ep, tsp, p)) {
 			(*pos)++;
+			sctp_endpoint_put(ep);
 			sctp_transport_put(tsp);
 			goto again;
 		}
+		sctp_endpoint_put(ep);
 		sctp_transport_put(tsp);
 	}
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(sctp_for_each_transport);
+EXPORT_SYMBOL_GPL(sctp_transport_traverse_process);
 
 /* 7.2.1 Association Status (SCTP_STATUS)
 
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index ebc78cb3bc7d..5a5916fe5692 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -252,7 +252,7 @@ if ($arch eq "x86_64") {
 
 } elsif ($arch eq "s390" && $bits == 64) {
     if ($cc =~ /-DCC_USING_HOTPATCH/) {
-	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*c0 04 00 00 00 00\\s*(bcrl\\s*0,|jgnop\\s*)[0-9a-f]+ <([^\+]*)>\$";
+	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*c0 04 00 00 00 00\\s*(brcl\\s*0,|jgnop\\s*)[0-9a-f]+ <([^\+]*)>\$";
 	$mcount_adjust = 0;
     } else {
 	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_(PC|PLT)32DBL\\s+_mcount\\+0x2\$";
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9bb1d492f704..38a4db1f3aaa 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5321,7 +5321,7 @@ static unsigned int selinux_ip_postroute_compat(struct sk_buff *skb,
 	struct common_audit_data ad;
 	struct lsm_network_audit net = {0,};
 	char *addrp;
-	u8 proto;
+	u8 proto = 0;
 
 	if (sk == NULL)
 		return NF_ACCEPT;
