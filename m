Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA7844E872
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 15:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbhKLOVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 09:21:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235220AbhKLOVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 09:21:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FF5C60C4A;
        Fri, 12 Nov 2021 14:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636726701;
        bh=9tzRzxpww6neV1RoO2reXvd2YH/Tbc3zLseFPsDKBuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYSgpUXGsmRCgA8BkfhT2mRCRcpI2NwSIaLvLn6HH/eP4BlzRfdP3/3SixBUlmeHy
         mpFbHrl/GUpVzE0D1RMfwz81sOpvEXoQPdyR31I15bANogRvK9sYZ9ttBo5CvuTQWu
         ccqLdSqaM8CC3UcsP3fvb6V3xaIAmVcGqn8J2xqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.79
Date:   Fri, 12 Nov 2021 15:18:13 +0100
Message-Id: <1636726692180114@kroah.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <16367266927877@kroah.com>
References: <16367266927877@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 288fb4839253..756479b101f8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 78
+SUBLEVEL = 79
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 8c065da73f8e..4e0f52660842 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -96,7 +96,7 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
 static void rtc_irq_eoi_tracking_reset(struct kvm_ioapic *ioapic)
 {
 	ioapic->rtc_status.pending_eoi = 0;
-	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID + 1);
+	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID);
 }
 
 static void kvm_rtc_eoi_tracking_restore_all(struct kvm_ioapic *ioapic);
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index 11e4065e1617..660401700075 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -43,13 +43,13 @@ struct kvm_vcpu;
 
 struct dest_map {
 	/* vcpu bitmap where IRQ has been sent */
-	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID + 1);
+	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID);
 
 	/*
 	 * Vector sent to a given vcpu, only valid when
 	 * the vcpu's bit in map is set
 	 */
-	u8 vectors[KVM_MAX_VCPU_ID + 1];
+	u8 vectors[KVM_MAX_VCPU_ID];
 };
 
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 060d9a906535..770d18dc4650 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3545,7 +3545,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 		 * reserved bit and EPT's invalid memtype/XWR checks to avoid
 		 * adding a Jcc in the loop.
 		 */
-		reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level - 1]) |
+		reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level - 1]) ||
 			    __is_rsvd_bits_set(rsvd_check, sptes[level - 1],
 					       level);
 	}
diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 65b22b5af51a..d9977ce0be76 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2254,7 +2254,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		binder_dec_node(buffer->target_node, 1, 0);
 
 	off_start_offset = ALIGN(buffer->data_size, sizeof(void *));
-	off_end_offset = is_failure ? failed_at :
+	off_end_offset = is_failure && failed_at ? failed_at :
 				off_start_offset + buffer->offsets_size;
 	for (buffer_offset = off_start_offset; buffer_offset < off_end_offset;
 	     buffer_offset += sizeof(binder_size_t)) {
@@ -2340,9 +2340,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 			binder_size_t fd_buf_size;
 			binder_size_t num_valid;
 
-			if (proc->tsk != current->group_leader) {
+			if (is_failure) {
 				/*
-				 * Nothing to do if running in sender context
 				 * The fd fixups have not been applied so no
 				 * fds need to be closed.
 				 */
@@ -3544,6 +3543,7 @@ static void binder_transaction(struct binder_proc *proc,
  * binder_free_buf() - free the specified buffer
  * @proc:	binder proc that owns buffer
  * @buffer:	buffer to be freed
+ * @is_failure:	failed to send transaction
  *
  * If buffer for an async transaction, enqueue the next async
  * transaction from the node.
@@ -3553,7 +3553,7 @@ static void binder_transaction(struct binder_proc *proc,
 static void
 binder_free_buf(struct binder_proc *proc,
 		struct binder_thread *thread,
-		struct binder_buffer *buffer)
+		struct binder_buffer *buffer, bool is_failure)
 {
 	binder_inner_proc_lock(proc);
 	if (buffer->transaction) {
@@ -3581,7 +3581,7 @@ binder_free_buf(struct binder_proc *proc,
 		binder_node_inner_unlock(buf_node);
 	}
 	trace_binder_transaction_buffer_release(buffer);
-	binder_transaction_buffer_release(proc, thread, buffer, 0, false);
+	binder_transaction_buffer_release(proc, thread, buffer, 0, is_failure);
 	binder_alloc_free_buf(&proc->alloc, buffer);
 }
 
@@ -3782,7 +3782,7 @@ static int binder_thread_write(struct binder_proc *proc,
 				     proc->pid, thread->pid, (u64)data_ptr,
 				     buffer->debug_id,
 				     buffer->transaction ? "active" : "finished");
-			binder_free_buf(proc, thread, buffer);
+			binder_free_buf(proc, thread, buffer, false);
 			break;
 		}
 
@@ -4470,7 +4470,7 @@ static int binder_thread_read(struct binder_proc *proc,
 			buffer->transaction = NULL;
 			binder_cleanup_transaction(t, "fd fixups failed",
 						   BR_FAILED_REPLY);
-			binder_free_buf(proc, thread, buffer);
+			binder_free_buf(proc, thread, buffer, true);
 			binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
 				     "%d:%d %stransaction %d fd fixups failed %d/%d, line %d\n",
 				     proc->pid, thread->pid,
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 3b13de59605e..983045ad79dc 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -61,7 +61,7 @@ static int rsi_usb_card_write(struct rsi_hw *adapter,
 			      (void *)seg,
 			      (int)len,
 			      &transfer,
-			      HZ * 5);
+			      USB_CTRL_SET_TIMEOUT);
 
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE,
diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 634f57730c1e..704b04d2980d 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -32,6 +32,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/slab.h>
 #include <linux/uaccess.h>
 
 #include "../comedi_usb.h"
@@ -237,22 +238,42 @@ static int dt9812_read_info(struct comedi_device *dev,
 {
 	struct usb_device *usb = comedi_to_usb_dev(dev);
 	struct dt9812_private *devpriv = dev->private;
-	struct dt9812_usb_cmd cmd;
+	struct dt9812_usb_cmd *cmd;
+	size_t tbuf_size;
 	int count, ret;
+	void *tbuf;
 
-	cmd.cmd = cpu_to_le32(DT9812_R_FLASH_DATA);
-	cmd.u.flash_data_info.address =
+	tbuf_size = max(sizeof(*cmd), buf_size);
+
+	tbuf = kzalloc(tbuf_size, GFP_KERNEL);
+	if (!tbuf)
+		return -ENOMEM;
+
+	cmd = tbuf;
+
+	cmd->cmd = cpu_to_le32(DT9812_R_FLASH_DATA);
+	cmd->u.flash_data_info.address =
 	    cpu_to_le16(DT9812_DIAGS_BOARD_INFO_ADDR + offset);
-	cmd.u.flash_data_info.numbytes = cpu_to_le16(buf_size);
+	cmd->u.flash_data_info.numbytes = cpu_to_le16(buf_size);
 
 	/* DT9812 only responds to 32 byte writes!! */
 	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
-			   &cmd, 32, &count, DT9812_USB_TIMEOUT);
+			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
 	if (ret)
-		return ret;
+		goto out;
+
+	ret = usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
+			   tbuf, buf_size, &count, DT9812_USB_TIMEOUT);
+	if (!ret) {
+		if (count == buf_size)
+			memcpy(buf, tbuf, buf_size);
+		else
+			ret = -EREMOTEIO;
+	}
+out:
+	kfree(tbuf);
 
-	return usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
-			    buf, buf_size, &count, DT9812_USB_TIMEOUT);
+	return ret;
 }
 
 static int dt9812_read_multiple_registers(struct comedi_device *dev,
@@ -261,22 +282,42 @@ static int dt9812_read_multiple_registers(struct comedi_device *dev,
 {
 	struct usb_device *usb = comedi_to_usb_dev(dev);
 	struct dt9812_private *devpriv = dev->private;
-	struct dt9812_usb_cmd cmd;
+	struct dt9812_usb_cmd *cmd;
 	int i, count, ret;
+	size_t buf_size;
+	void *buf;
 
-	cmd.cmd = cpu_to_le32(DT9812_R_MULTI_BYTE_REG);
-	cmd.u.read_multi_info.count = reg_count;
+	buf_size = max_t(size_t, sizeof(*cmd), reg_count);
+
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	cmd = buf;
+
+	cmd->cmd = cpu_to_le32(DT9812_R_MULTI_BYTE_REG);
+	cmd->u.read_multi_info.count = reg_count;
 	for (i = 0; i < reg_count; i++)
-		cmd.u.read_multi_info.address[i] = address[i];
+		cmd->u.read_multi_info.address[i] = address[i];
 
 	/* DT9812 only responds to 32 byte writes!! */
 	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
-			   &cmd, 32, &count, DT9812_USB_TIMEOUT);
+			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
 	if (ret)
-		return ret;
+		goto out;
+
+	ret = usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
+			   buf, reg_count, &count, DT9812_USB_TIMEOUT);
+	if (!ret) {
+		if (count == reg_count)
+			memcpy(value, buf, reg_count);
+		else
+			ret = -EREMOTEIO;
+	}
+out:
+	kfree(buf);
 
-	return usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
-			    value, reg_count, &count, DT9812_USB_TIMEOUT);
+	return ret;
 }
 
 static int dt9812_write_multiple_registers(struct comedi_device *dev,
@@ -285,19 +326,27 @@ static int dt9812_write_multiple_registers(struct comedi_device *dev,
 {
 	struct usb_device *usb = comedi_to_usb_dev(dev);
 	struct dt9812_private *devpriv = dev->private;
-	struct dt9812_usb_cmd cmd;
+	struct dt9812_usb_cmd *cmd;
 	int i, count;
+	int ret;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
 
-	cmd.cmd = cpu_to_le32(DT9812_W_MULTI_BYTE_REG);
-	cmd.u.read_multi_info.count = reg_count;
+	cmd->cmd = cpu_to_le32(DT9812_W_MULTI_BYTE_REG);
+	cmd->u.read_multi_info.count = reg_count;
 	for (i = 0; i < reg_count; i++) {
-		cmd.u.write_multi_info.write[i].address = address[i];
-		cmd.u.write_multi_info.write[i].value = value[i];
+		cmd->u.write_multi_info.write[i].address = address[i];
+		cmd->u.write_multi_info.write[i].value = value[i];
 	}
 
 	/* DT9812 only responds to 32 byte writes!! */
-	return usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
-			    &cmd, 32, &count, DT9812_USB_TIMEOUT);
+	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
+			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
+	kfree(cmd);
+
+	return ret;
 }
 
 static int dt9812_rmw_multiple_registers(struct comedi_device *dev,
@@ -306,17 +355,25 @@ static int dt9812_rmw_multiple_registers(struct comedi_device *dev,
 {
 	struct usb_device *usb = comedi_to_usb_dev(dev);
 	struct dt9812_private *devpriv = dev->private;
-	struct dt9812_usb_cmd cmd;
+	struct dt9812_usb_cmd *cmd;
 	int i, count;
+	int ret;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
 
-	cmd.cmd = cpu_to_le32(DT9812_RMW_MULTI_BYTE_REG);
-	cmd.u.rmw_multi_info.count = reg_count;
+	cmd->cmd = cpu_to_le32(DT9812_RMW_MULTI_BYTE_REG);
+	cmd->u.rmw_multi_info.count = reg_count;
 	for (i = 0; i < reg_count; i++)
-		cmd.u.rmw_multi_info.rmw[i] = rmw[i];
+		cmd->u.rmw_multi_info.rmw[i] = rmw[i];
 
 	/* DT9812 only responds to 32 byte writes!! */
-	return usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
-			    &cmd, 32, &count, DT9812_USB_TIMEOUT);
+	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
+			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
+	kfree(cmd);
+
+	return ret;
 }
 
 static int dt9812_digital_in(struct comedi_device *dev, u8 *bits)
diff --git a/drivers/staging/comedi/drivers/ni_usb6501.c b/drivers/staging/comedi/drivers/ni_usb6501.c
index 5b6d9d783b2f..c42987b74b1d 100644
--- a/drivers/staging/comedi/drivers/ni_usb6501.c
+++ b/drivers/staging/comedi/drivers/ni_usb6501.c
@@ -144,6 +144,10 @@ static const u8 READ_COUNTER_RESPONSE[]	= {0x00, 0x01, 0x00, 0x10,
 					   0x00, 0x00, 0x00, 0x02,
 					   0x00, 0x00, 0x00, 0x00};
 
+/* Largest supported packets */
+static const size_t TX_MAX_SIZE	= sizeof(SET_PORT_DIR_REQUEST);
+static const size_t RX_MAX_SIZE	= sizeof(READ_PORT_RESPONSE);
+
 enum commands {
 	READ_PORT,
 	WRITE_PORT,
@@ -501,6 +505,12 @@ static int ni6501_find_endpoints(struct comedi_device *dev)
 	if (!devpriv->ep_rx || !devpriv->ep_tx)
 		return -ENODEV;
 
+	if (usb_endpoint_maxp(devpriv->ep_rx) < RX_MAX_SIZE)
+		return -ENODEV;
+
+	if (usb_endpoint_maxp(devpriv->ep_tx) < TX_MAX_SIZE)
+		return -ENODEV;
+
 	return 0;
 }
 
diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 7956abcbae22..7769eadfaf61 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -90,6 +90,9 @@ enum {
 #define IC3_VERSION		BIT(0)
 #define IC6_VERSION		BIT(1)
 
+#define MIN_BUF_SIZE		64
+#define PACKET_TIMEOUT		10000	/* ms */
+
 enum vmk80xx_model {
 	VMK8055_MODEL,
 	VMK8061_MODEL
@@ -157,22 +160,21 @@ static void vmk80xx_do_bulk_msg(struct comedi_device *dev)
 	__u8 rx_addr;
 	unsigned int tx_pipe;
 	unsigned int rx_pipe;
-	size_t size;
+	size_t tx_size;
+	size_t rx_size;
 
 	tx_addr = devpriv->ep_tx->bEndpointAddress;
 	rx_addr = devpriv->ep_rx->bEndpointAddress;
 	tx_pipe = usb_sndbulkpipe(usb, tx_addr);
 	rx_pipe = usb_rcvbulkpipe(usb, rx_addr);
+	tx_size = usb_endpoint_maxp(devpriv->ep_tx);
+	rx_size = usb_endpoint_maxp(devpriv->ep_rx);
 
-	/*
-	 * The max packet size attributes of the K8061
-	 * input/output endpoints are identical
-	 */
-	size = usb_endpoint_maxp(devpriv->ep_tx);
+	usb_bulk_msg(usb, tx_pipe, devpriv->usb_tx_buf, tx_size, NULL,
+		     PACKET_TIMEOUT);
 
-	usb_bulk_msg(usb, tx_pipe, devpriv->usb_tx_buf,
-		     size, NULL, devpriv->ep_tx->bInterval);
-	usb_bulk_msg(usb, rx_pipe, devpriv->usb_rx_buf, size, NULL, HZ * 10);
+	usb_bulk_msg(usb, rx_pipe, devpriv->usb_rx_buf, rx_size, NULL,
+		     PACKET_TIMEOUT);
 }
 
 static int vmk80xx_read_packet(struct comedi_device *dev)
@@ -191,7 +193,7 @@ static int vmk80xx_read_packet(struct comedi_device *dev)
 	pipe = usb_rcvintpipe(usb, ep->bEndpointAddress);
 	return usb_interrupt_msg(usb, pipe, devpriv->usb_rx_buf,
 				 usb_endpoint_maxp(ep), NULL,
-				 HZ * 10);
+				 PACKET_TIMEOUT);
 }
 
 static int vmk80xx_write_packet(struct comedi_device *dev, int cmd)
@@ -212,7 +214,7 @@ static int vmk80xx_write_packet(struct comedi_device *dev, int cmd)
 	pipe = usb_sndintpipe(usb, ep->bEndpointAddress);
 	return usb_interrupt_msg(usb, pipe, devpriv->usb_tx_buf,
 				 usb_endpoint_maxp(ep), NULL,
-				 HZ * 10);
+				 PACKET_TIMEOUT);
 }
 
 static int vmk80xx_reset_device(struct comedi_device *dev)
@@ -678,12 +680,12 @@ static int vmk80xx_alloc_usb_buffers(struct comedi_device *dev)
 	struct vmk80xx_private *devpriv = dev->private;
 	size_t size;
 
-	size = usb_endpoint_maxp(devpriv->ep_rx);
+	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
 	devpriv->usb_rx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_rx_buf)
 		return -ENOMEM;
 
-	size = usb_endpoint_maxp(devpriv->ep_tx);
+	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
 	devpriv->usb_tx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_tx_buf)
 		return -ENOMEM;
diff --git a/drivers/staging/media/ipu3/ipu3-css-fw.c b/drivers/staging/media/ipu3/ipu3-css-fw.c
index 45aff76198e2..981693eed815 100644
--- a/drivers/staging/media/ipu3/ipu3-css-fw.c
+++ b/drivers/staging/media/ipu3/ipu3-css-fw.c
@@ -124,12 +124,11 @@ int imgu_css_fw_init(struct imgu_css *css)
 	/* Check and display fw header info */
 
 	css->fwp = (struct imgu_fw_header *)css->fw->data;
-	if (css->fw->size < sizeof(struct imgu_fw_header *) ||
+	if (css->fw->size < struct_size(css->fwp, binary_header, 1) ||
 	    css->fwp->file_header.h_size != sizeof(struct imgu_fw_bi_file_h))
 		goto bad_fw;
-	if (sizeof(struct imgu_fw_bi_file_h) +
-	    css->fwp->file_header.binary_nr * sizeof(struct imgu_fw_info) >
-	    css->fw->size)
+	if (struct_size(css->fwp, binary_header,
+			css->fwp->file_header.binary_nr) > css->fw->size)
 		goto bad_fw;
 
 	dev_info(dev, "loaded firmware version %.64s, %u binaries, %zu bytes\n",
diff --git a/drivers/staging/media/ipu3/ipu3-css-fw.h b/drivers/staging/media/ipu3/ipu3-css-fw.h
index 79ffa7045139..650fd25fc79e 100644
--- a/drivers/staging/media/ipu3/ipu3-css-fw.h
+++ b/drivers/staging/media/ipu3/ipu3-css-fw.h
@@ -170,7 +170,7 @@ struct imgu_fw_bi_file_h {
 
 struct imgu_fw_header {
 	struct imgu_fw_bi_file_h file_header;
-	struct imgu_fw_info binary_header[1];	/* binary_nr items */
+	struct imgu_fw_info binary_header[];	/* binary_nr items */
 };
 
 /******************* Firmware functions *******************/
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 4523e825a61a..7f90af8a7c7c 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -229,7 +229,7 @@ int write_nic_byte_E(struct net_device *dev, int indx, u8 data)
 
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
-				 indx | 0xfe00, 0, usbdata, 1, HZ / 2);
+				 indx | 0xfe00, 0, usbdata, 1, 500);
 	kfree(usbdata);
 
 	if (status < 0) {
@@ -251,7 +251,7 @@ int read_nic_byte_E(struct net_device *dev, int indx, u8 *data)
 
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
-				 indx | 0xfe00, 0, usbdata, 1, HZ / 2);
+				 indx | 0xfe00, 0, usbdata, 1, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
@@ -279,7 +279,7 @@ int write_nic_byte(struct net_device *dev, int indx, u8 data)
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 1, HZ / 2);
+				 usbdata, 1, 500);
 	kfree(usbdata);
 
 	if (status < 0) {
@@ -305,7 +305,7 @@ int write_nic_word(struct net_device *dev, int indx, u16 data)
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 2, HZ / 2);
+				 usbdata, 2, 500);
 	kfree(usbdata);
 
 	if (status < 0) {
@@ -331,7 +331,7 @@ int write_nic_dword(struct net_device *dev, int indx, u32 data)
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 4, HZ / 2);
+				 usbdata, 4, 500);
 	kfree(usbdata);
 
 	if (status < 0) {
@@ -355,7 +355,7 @@ int read_nic_byte(struct net_device *dev, int indx, u8 *data)
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 1, HZ / 2);
+				 usbdata, 1, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
@@ -380,7 +380,7 @@ int read_nic_word(struct net_device *dev, int indx, u16 *data)
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 2, HZ / 2);
+				 usbdata, 2, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
@@ -404,7 +404,7 @@ static int read_nic_word_E(struct net_device *dev, int indx, u16 *data)
 
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
-				 indx | 0xfe00, 0, usbdata, 2, HZ / 2);
+				 indx | 0xfe00, 0, usbdata, 2, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
@@ -430,7 +430,7 @@ int read_nic_dword(struct net_device *dev, int indx, u32 *data)
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 4, HZ / 2);
+				 usbdata, 4, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 17d28af0d086..fed96d4251bf 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -598,12 +598,12 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 
 	/* never exit with a firmware callback pending */
 	wait_for_completion(&padapter->rtl8712_fw_ready);
+	if (pnetdev->reg_state != NETREG_UNINITIALIZED)
+		unregister_netdev(pnetdev); /* will call netdev_close() */
 	usb_set_intfdata(pusb_intf, NULL);
 	release_firmware(padapter->fw);
 	if (drvpriv.drv_registered)
 		padapter->surprise_removed = true;
-	if (pnetdev->reg_state != NETREG_UNINITIALIZED)
-		unregister_netdev(pnetdev); /* will call netdev_close() */
 	r8712_flush_rwctrl_works(padapter);
 	r8712_flush_led_works(padapter);
 	udelay(1);
diff --git a/drivers/staging/rtl8712/usb_ops_linux.c b/drivers/staging/rtl8712/usb_ops_linux.c
index 655497cead12..f984a5ab2c6f 100644
--- a/drivers/staging/rtl8712/usb_ops_linux.c
+++ b/drivers/staging/rtl8712/usb_ops_linux.c
@@ -494,7 +494,7 @@ int r8712_usbctrl_vendorreq(struct intf_priv *pintfpriv, u8 request, u16 value,
 		memcpy(pIo_buf, pdata, len);
 	}
 	status = usb_control_msg(udev, pipe, request, reqtype, value, index,
-				 pIo_buf, len, HZ / 2);
+				 pIo_buf, len, 500);
 	if (status > 0) {  /* Success this control transfer. */
 		if (requesttype == 0x01) {
 			/* For Control read transfer, we have to copy the read
diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kconfig
index 1a12aab208b4..933e80d5053a 100644
--- a/drivers/usb/gadget/udc/Kconfig
+++ b/drivers/usb/gadget/udc/Kconfig
@@ -330,6 +330,7 @@ config USB_AMD5536UDC
 config USB_FSL_QE
 	tristate "Freescale QE/CPM USB Device Controller"
 	depends on FSL_SOC && (QUICC_ENGINE || CPM)
+	depends on !64BIT || BROKEN
 	help
 	   Some of Freescale PowerPC processors have a Full Speed
 	   QE/CPM2 USB controller, which support device mode with 4
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 6793fd99c1cb..8aff19ff8e8f 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -634,7 +634,16 @@ static int ehci_run (struct usb_hcd *hcd)
 	/* Wait until HC become operational */
 	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
 	msleep(5);
-	rc = ehci_handshake(ehci, &ehci->regs->status, STS_HALT, 0, 100 * 1000);
+
+	/* For Aspeed, STS_HALT also depends on ASS/PSS status.
+	 * Check CMD_RUN instead.
+	 */
+	if (ehci->is_aspeed)
+		rc = ehci_handshake(ehci, &ehci->regs->command, CMD_RUN,
+				    1, 100 * 1000);
+	else
+		rc = ehci_handshake(ehci, &ehci->regs->status, STS_HALT,
+				    0, 100 * 1000);
 
 	up_write(&ehci_cf_port_reset_rwsem);
 
diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index a48dd3fac153..2dcfc67f2ba8 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -294,6 +294,12 @@ static int ehci_platform_probe(struct platform_device *dev)
 					  "has-transaction-translator"))
 			hcd->has_tt = 1;
 
+		if (of_device_is_compatible(dev->dev.of_node,
+					    "aspeed,ast2500-ehci") ||
+		    of_device_is_compatible(dev->dev.of_node,
+					    "aspeed,ast2600-ehci"))
+			ehci->is_aspeed = 1;
+
 		if (soc_device_match(quirk_poll_match))
 			priv->quirk_poll = true;
 
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index eabf22a78eae..59fd523c55f3 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -218,6 +218,7 @@ struct ehci_hcd {			/* one per controller */
 	unsigned		frame_index_bug:1; /* MosChip (AKA NetMos) */
 	unsigned		need_oc_pp_cycle:1; /* MPC834X port power */
 	unsigned		imx28_write_fix:1; /* For Freescale i.MX28 */
+	unsigned		is_aspeed:1;
 
 	/* required for usb32 quirk */
 	#define OHCI_CTRL_HCFS          (3 << 6)
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index f62ffaede1ab..fb806b33178a 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1247,9 +1247,11 @@ static int musb_gadget_queue(struct usb_ep *ep, struct usb_request *req,
 		status = musb_queue_resume_work(musb,
 						musb_ep_restart_resume_work,
 						request);
-		if (status < 0)
+		if (status < 0) {
 			dev_err(musb->controller, "%s resume work: %i\n",
 				__func__, status);
+			list_del(&request->list);
+		}
 	}
 
 unlock:
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index c6b3fcf90180..29191d33c0e3 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -406,6 +406,16 @@ UNUSUAL_DEV(  0x04b8, 0x0602, 0x0110, 0x0110,
 		"785EPX Storage",
 		USB_SC_SCSI, USB_PR_BULK, NULL, US_FL_SINGLE_LUN),
 
+/*
+ * Reported by James Buren <braewoods+lkml@braewoods.net>
+ * Virtual ISOs cannot be remounted if ejected while the device is locked
+ * Disable locking to mimic Windows behavior that bypasses the issue
+ */
+UNUSUAL_DEV(  0x04c5, 0x2028, 0x0001, 0x0001,
+		"iODD",
+		"2531/2541",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_NOT_LOCKABLE),
+
 /*
  * Not sure who reported this originally but
  * Pavel Machek <pavel@ucw.cz> reported that the extra US_FL_SINGLE_LUN
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 35675a1065be..f62b5a501566 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1321,6 +1321,8 @@ static int isofs_read_inode(struct inode *inode, int relocated)
 
 	de = (struct iso_directory_record *) (bh->b_data + offset);
 	de_len = *(unsigned char *) de;
+	if (de_len < sizeof(struct iso_directory_record))
+		goto fail;
 
 	if (offset + de_len > bufsize) {
 		int frag1 = bufsize - offset;
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index d0df95346ab3..85351a12c85d 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2213,8 +2213,15 @@ static int __init console_setup(char *str)
 	char *s, *options, *brl_options = NULL;
 	int idx;
 
-	if (str[0] == 0)
+	/*
+	 * console="" or console=null have been suggested as a way to
+	 * disable console output. Use ttynull that has been created
+	 * for exacly this purpose.
+	 */
+	if (str[0] == 0 || strcmp(str, "null") == 0) {
+		__add_preferred_console("ttynull", 0, NULL, NULL, true);
 		return 1;
+	}
 
 	if (_braille_console_setup(&str, &brl_options))
 		return 1;
