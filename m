Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF7B48AF40
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 15:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238763AbiAKOPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 09:15:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43394 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241404AbiAKOPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 09:15:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EB89B81ACE;
        Tue, 11 Jan 2022 14:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712CDC36AE3;
        Tue, 11 Jan 2022 14:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641910502;
        bh=Xj3RHwX+XKl8Be3IAhdiTUFGCPdAjkkj1D0srkPUXA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qm/pggS2WoGdfERYrQDr9yuFWP2ATVvqG3rLHf2HdHT8jlnr4Xrxt14nFlxD1FSXv
         QYpl2QWFOBzteQmK6X7vkg+r7IFuLM5Y8eFMZ/2h4gqY60fp+y9pqxixVLdcx/VwnW
         xFngGb23y5GhWWPhMn/1/RYL4US5j1rW6/Bnvgpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.262
Date:   Tue, 11 Jan 2022 15:14:54 +0100
Message-Id: <1641910493102190@kroah.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <16419104934282@kroah.com>
References: <16419104934282@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 38e64d636717..33ffaa163c2b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 261
+SUBLEVEL = 262
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index f2e84e09c970..40db5c400519 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2548,11 +2548,9 @@ static const struct qca_device_info qca_devices_table[] = {
 	{ 0x00000302, 28, 4, 18 }, /* Rome 3.2 */
 };
 
-static int btusb_qca_send_vendor_req(struct hci_dev *hdev, u8 request,
+static int btusb_qca_send_vendor_req(struct usb_device *udev, u8 request,
 				     void *data, u16 size)
 {
-	struct btusb_data *btdata = hci_get_drvdata(hdev);
-	struct usb_device *udev = btdata->udev;
 	int pipe, err;
 	u8 *buf;
 
@@ -2567,7 +2565,7 @@ static int btusb_qca_send_vendor_req(struct hci_dev *hdev, u8 request,
 	err = usb_control_msg(udev, pipe, request, USB_TYPE_VENDOR | USB_DIR_IN,
 			      0, 0, buf, size, USB_CTRL_SET_TIMEOUT);
 	if (err < 0) {
-		BT_ERR("%s: Failed to access otp area (%d)", hdev->name, err);
+		dev_err(&udev->dev, "Failed to access otp area (%d)", err);
 		goto done;
 	}
 
@@ -2723,20 +2721,38 @@ static int btusb_setup_qca_load_nvm(struct hci_dev *hdev,
 	return err;
 }
 
+/* identify the ROM version and check whether patches are needed */
+static bool btusb_qca_need_patch(struct usb_device *udev)
+{
+	struct qca_version ver;
+
+	if (btusb_qca_send_vendor_req(udev, QCA_GET_TARGET_VERSION, &ver,
+				      sizeof(ver)) < 0)
+		return false;
+	/* only low ROM versions need patches */
+	return !(le32_to_cpu(ver.rom_version) & ~0xffffU);
+}
+
 static int btusb_setup_qca(struct hci_dev *hdev)
 {
+	struct btusb_data *btdata = hci_get_drvdata(hdev);
+	struct usb_device *udev = btdata->udev;
 	const struct qca_device_info *info = NULL;
 	struct qca_version ver;
 	u32 ver_rom;
 	u8 status;
 	int i, err;
 
-	err = btusb_qca_send_vendor_req(hdev, QCA_GET_TARGET_VERSION, &ver,
+	err = btusb_qca_send_vendor_req(udev, QCA_GET_TARGET_VERSION, &ver,
 					sizeof(ver));
 	if (err < 0)
 		return err;
 
 	ver_rom = le32_to_cpu(ver.rom_version);
+	/* Don't care about high ROM versions */
+	if (ver_rom & ~0xffffU)
+		return 0;
+
 	for (i = 0; i < ARRAY_SIZE(qca_devices_table); i++) {
 		if (ver_rom == qca_devices_table[i].rom_version)
 			info = &qca_devices_table[i];
@@ -2747,7 +2763,7 @@ static int btusb_setup_qca(struct hci_dev *hdev)
 		return -ENODEV;
 	}
 
-	err = btusb_qca_send_vendor_req(hdev, QCA_CHECK_STATUS, &status,
+	err = btusb_qca_send_vendor_req(udev, QCA_CHECK_STATUS, &status,
 					sizeof(status));
 	if (err < 0)
 		return err;
@@ -2974,7 +2990,8 @@ static int btusb_probe(struct usb_interface *intf,
 		/* Old firmware would otherwise let ath3k driver load
 		 * patch and sysconfig files
 		 */
-		if (le16_to_cpu(udev->descriptor.bcdDevice) <= 0x0001)
+		if (le16_to_cpu(udev->descriptor.bcdDevice) <= 0x0001 &&
+		    !btusb_qca_need_patch(udev))
 			return -ENODEV;
 	}
 
@@ -3136,6 +3153,7 @@ static int btusb_probe(struct usb_interface *intf,
 	}
 
 	if (id->driver_info & BTUSB_ATH3012) {
+		data->setup_on_usb = btusb_setup_qca;
 		hdev->set_bdaddr = btusb_set_bdaddr_ath3012;
 		set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
 		set_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks);
diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index bd0acf376af0..9eb1cff57353 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -66,7 +66,7 @@ void ib_copy_ah_attr_to_user(struct ib_device *device,
 	struct rdma_ah_attr *src = ah_attr;
 	struct rdma_ah_attr conv_ah;
 
-	memset(&dst->grh.reserved, 0, sizeof(dst->grh.reserved));
+	memset(&dst->grh, 0, sizeof(dst->grh));
 
 	if ((ah_attr->type == RDMA_AH_ATTR_TYPE_OPA) &&
 	    (rdma_ah_get_dlid(ah_attr) >=
diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
index faf505462a4f..f5a06a6fb297 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -390,7 +390,7 @@ mISDNInit(void)
 	err = mISDN_inittimer(&debug);
 	if (err)
 		goto error2;
-	err = l1_init(&debug);
+	err = Isdnl1_Init(&debug);
 	if (err)
 		goto error3;
 	err = Isdnl2_Init(&debug);
@@ -404,7 +404,7 @@ mISDNInit(void)
 error5:
 	Isdnl2_cleanup();
 error4:
-	l1_cleanup();
+	Isdnl1_cleanup();
 error3:
 	mISDN_timer_cleanup();
 error2:
@@ -417,7 +417,7 @@ static void mISDN_cleanup(void)
 {
 	misdn_sock_cleanup();
 	Isdnl2_cleanup();
-	l1_cleanup();
+	Isdnl1_cleanup();
 	mISDN_timer_cleanup();
 	class_unregister(&mISDN_class);
 
diff --git a/drivers/isdn/mISDN/core.h b/drivers/isdn/mISDN/core.h
index 52695bb81ee7..3c039b6ade2e 100644
--- a/drivers/isdn/mISDN/core.h
+++ b/drivers/isdn/mISDN/core.h
@@ -69,8 +69,8 @@ struct Bprotocol	*get_Bprotocol4id(u_int);
 extern int	mISDN_inittimer(u_int *);
 extern void	mISDN_timer_cleanup(void);
 
-extern int	l1_init(u_int *);
-extern void	l1_cleanup(void);
+extern int	Isdnl1_Init(u_int *);
+extern void	Isdnl1_cleanup(void);
 extern int	Isdnl2_Init(u_int *);
 extern void	Isdnl2_cleanup(void);
 
diff --git a/drivers/isdn/mISDN/layer1.c b/drivers/isdn/mISDN/layer1.c
index 3192b0eb3944..284d3a9c7df7 100644
--- a/drivers/isdn/mISDN/layer1.c
+++ b/drivers/isdn/mISDN/layer1.c
@@ -407,7 +407,7 @@ create_l1(struct dchannel *dch, dchannel_l1callback *dcb) {
 EXPORT_SYMBOL(create_l1);
 
 int
-l1_init(u_int *deb)
+Isdnl1_Init(u_int *deb)
 {
 	debug = deb;
 	l1fsm_s.state_count = L1S_STATE_COUNT;
@@ -418,7 +418,7 @@ l1_init(u_int *deb)
 }
 
 void
-l1_cleanup(void)
+Isdnl1_cleanup(void)
 {
 	mISDN_FsmFree(&l1fsm_s);
 }
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 44a9c8aa3067..5b5434976698 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -114,6 +114,24 @@ MODULE_VERSION(DRV_VERSION);
 
 static struct workqueue_struct *i40e_wq;
 
+static void netdev_hw_addr_refcnt(struct i40e_mac_filter *f,
+				  struct net_device *netdev, int delta)
+{
+	struct netdev_hw_addr *ha;
+
+	if (!f || !netdev)
+		return;
+
+	netdev_for_each_mc_addr(ha, netdev) {
+		if (ether_addr_equal(ha->addr, f->macaddr)) {
+			ha->refcount += delta;
+			if (ha->refcount <= 0)
+				ha->refcount = 1;
+			break;
+		}
+	}
+}
+
 /**
  * i40e_allocate_dma_mem_d - OS specific memory alloc for shared code
  * @hw:   pointer to the HW structure
@@ -1827,6 +1845,7 @@ static void i40e_undo_add_filter_entries(struct i40e_vsi *vsi,
 	hlist_for_each_entry_safe(new, h, from, hlist) {
 		/* We can simply free the wrapper structure */
 		hlist_del(&new->hlist);
+		netdev_hw_addr_refcnt(new->f, vsi->netdev, -1);
 		kfree(new);
 	}
 }
@@ -2093,6 +2112,10 @@ int i40e_sync_vsi_filters(struct i40e_vsi *vsi)
 						       &tmp_add_list,
 						       &tmp_del_list,
 						       vlan_filters);
+
+		hlist_for_each_entry(new, &tmp_add_list, hlist)
+			netdev_hw_addr_refcnt(new->f, vsi->netdev, 1);
+
 		if (retval)
 			goto err_no_memory_locked;
 
@@ -2232,6 +2255,7 @@ int i40e_sync_vsi_filters(struct i40e_vsi *vsi)
 			if (new->f->state == I40E_FILTER_NEW)
 				new->f->state = new->state;
 			hlist_del(&new->hlist);
+			netdev_hw_addr_refcnt(new->f, vsi->netdev, -1);
 			kfree(new);
 		}
 		spin_unlock_bh(&vsi->mac_filter_hash_lock);
@@ -5705,6 +5729,27 @@ int i40e_open(struct net_device *netdev)
 	return 0;
 }
 
+/**
+ * i40e_netif_set_realnum_tx_rx_queues - Update number of tx/rx queues
+ * @vsi: vsi structure
+ *
+ * This updates netdev's number of tx/rx queues
+ *
+ * Returns status of setting tx/rx queues
+ **/
+static int i40e_netif_set_realnum_tx_rx_queues(struct i40e_vsi *vsi)
+{
+	int ret;
+
+	ret = netif_set_real_num_rx_queues(vsi->netdev,
+					   vsi->num_queue_pairs);
+	if (ret)
+		return ret;
+
+	return netif_set_real_num_tx_queues(vsi->netdev,
+					    vsi->num_queue_pairs);
+}
+
 /**
  * i40e_vsi_open -
  * @vsi: the VSI to open
@@ -5741,13 +5786,7 @@ int i40e_vsi_open(struct i40e_vsi *vsi)
 			goto err_setup_rx;
 
 		/* Notify the stack of the actual queue counts. */
-		err = netif_set_real_num_tx_queues(vsi->netdev,
-						   vsi->num_queue_pairs);
-		if (err)
-			goto err_set_queues;
-
-		err = netif_set_real_num_rx_queues(vsi->netdev,
-						   vsi->num_queue_pairs);
+		err = i40e_netif_set_realnum_tx_rx_queues(vsi);
 		if (err)
 			goto err_set_queues;
 
@@ -10429,6 +10468,9 @@ struct i40e_vsi *i40e_vsi_setup(struct i40e_pf *pf, u8 type,
 	case I40E_VSI_MAIN:
 	case I40E_VSI_VMDQ2:
 		ret = i40e_config_netdev(vsi);
+		if (ret)
+			goto err_netdev;
+		ret = i40e_netif_set_realnum_tx_rx_queues(vsi);
 		if (ret)
 			goto err_netdev;
 		ret = register_netdev(vsi->netdev);
diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index 2c4274453c15..95510638ebd7 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -84,7 +84,9 @@ static int atusb_control_msg(struct atusb *atusb, unsigned int pipe,
 
 	ret = usb_control_msg(usb_dev, pipe, request, requesttype,
 			      value, index, data, size, timeout);
-	if (ret < 0) {
+	if (ret < size) {
+		ret = ret < 0 ? ret : -ENODATA;
+
 		atusb->err = ret;
 		dev_err(&usb_dev->dev,
 			"atusb_control_msg: req 0x%02x val 0x%x idx 0x%x, error %d\n",
@@ -656,9 +658,9 @@ static int atusb_get_and_show_build(struct atusb *atusb)
 	if (!build)
 		return -ENOMEM;
 
-	ret = atusb_control_msg(atusb, usb_rcvctrlpipe(usb_dev, 0),
-				ATUSB_BUILD, ATUSB_REQ_FROM_DEV, 0, 0,
-				build, ATUSB_BUILD_SIZE, 1000);
+	/* We cannot call atusb_control_msg() here, since this request may read various length data */
+	ret = usb_control_msg(atusb->usb_dev, usb_rcvctrlpipe(usb_dev, 0), ATUSB_BUILD,
+			      ATUSB_REQ_FROM_DEV, 0, 0, build, ATUSB_BUILD_SIZE, 1000);
 	if (ret >= 0) {
 		build[ret] = 0;
 		dev_info(&usb_dev->dev, "Firmware: build %s\n", build);
diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index d3f79a4067e2..ab41a63aa4aa 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -620,6 +620,11 @@ static const struct usb_device_id	products [] = {
 	USB_DEVICE_AND_INTERFACE_INFO(0x1630, 0x0042,
 				      USB_CLASS_COMM, 2 /* ACM */, 0x0ff),
 	.driver_info = (unsigned long) &rndis_poll_status_info,
+}, {
+	/* Hytera Communications DMR radios' "Radio to PC Network" */
+	USB_VENDOR_AND_INTERFACE_INFO(0x238b,
+				      USB_CLASS_COMM, 2 /* ACM */, 0x0ff),
+	.driver_info = (unsigned long)&rndis_info,
 }, {
 	/* RNDIS is MSFT's un-official variant of CDC ACM */
 	USB_INTERFACE_INFO(USB_CLASS_COMM, 2 /* ACM */, 0x0ff),
diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
index bfcd6fba6363..d93b430ca38b 100644
--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -169,8 +169,8 @@ static void ltc2952_poweroff_kill(void)
 
 static void ltc2952_poweroff_default(struct ltc2952_poweroff *data)
 {
-	data->wde_interval = 300L * 1E6L;
-	data->trigger_delay = ktime_set(2, 500L*1E6L);
+	data->wde_interval = 300L * NSEC_PER_MSEC;
+	data->trigger_delay = ktime_set(2, 500L * NSEC_PER_MSEC);
 
 	hrtimer_init(&data->timer_trigger, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	data->timer_trigger.function = ltc2952_poweroff_timer_trigger;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f3dfec02abec..ebf3a277d8bb 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2991,6 +2991,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
+	char *tmp_persistent_address = conn->persistent_address;
+	char *tmp_local_ipaddr = conn->local_ipaddr;
 
 	del_timer_sync(&conn->transport_timer);
 
@@ -3012,8 +3014,6 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	spin_lock_bh(&session->frwd_lock);
 	free_pages((unsigned long) conn->data,
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
-	kfree(conn->persistent_address);
-	kfree(conn->local_ipaddr);
 	/* regular RX path uses back_lock */
 	spin_lock_bh(&session->back_lock);
 	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
@@ -3025,6 +3025,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	mutex_unlock(&session->eh_mutex);
 
 	iscsi_destroy_conn(cls_conn);
+	kfree(tmp_persistent_address);
+	kfree(tmp_local_ipaddr);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_teardown);
 
diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 80a3704939cd..b9c06885de6a 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -575,6 +575,13 @@ static void virtio_pci_remove(struct pci_dev *pci_dev)
 	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
 	struct device *dev = get_device(&vp_dev->vdev.dev);
 
+	/*
+	 * Device is marked broken on surprise removal so that virtio upper
+	 * layers can abort any ongoing operation.
+	 */
+	if (!pci_device_is_present(pci_dev))
+		virtio_break_device(&vp_dev->vdev);
+
 	unregister_virtio_device(&vp_dev->vdev);
 
 	if (vp_dev->ioaddr)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 79a9a0def7db..5b2b223f9285 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -715,7 +715,8 @@ xfs_ioc_space(
 		flags |= XFS_PREALLOC_CLEAR;
 		if (bf->l_start > XFS_ISIZE(ip)) {
 			error = xfs_alloc_file_space(ip, XFS_ISIZE(ip),
-					bf->l_start - XFS_ISIZE(ip), 0);
+					bf->l_start - XFS_ISIZE(ip),
+					XFS_BMAPI_PREALLOC);
 			if (error)
 				goto out_unlock;
 		}
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cb4f6f9e2705..fd8e1ec39c27 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2810,7 +2810,7 @@ struct trace_buffer_struct {
 	char buffer[4][TRACE_BUF_SIZE];
 };
 
-static struct trace_buffer_struct *trace_percpu_buffer;
+static struct trace_buffer_struct __percpu *trace_percpu_buffer;
 
 /*
  * Thise allows for lockless recording.  If we're nested too deeply, then
@@ -2820,7 +2820,7 @@ static char *get_trace_buf(void)
 {
 	struct trace_buffer_struct *buffer = this_cpu_ptr(trace_percpu_buffer);
 
-	if (!buffer || buffer->nesting >= 4)
+	if (!trace_percpu_buffer || buffer->nesting >= 4)
 		return NULL;
 
 	buffer->nesting++;
@@ -2839,7 +2839,7 @@ static void put_trace_buf(void)
 
 static int alloc_percpu_trace_buffer(void)
 {
-	struct trace_buffer_struct *buffers;
+	struct trace_buffer_struct __percpu *buffers;
 
 	buffers = alloc_percpu(struct trace_buffer_struct);
 	if (WARN(!buffers, "Could not allocate percpu trace_printk buffer"))
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 4faeb698c33c..fee1cdcc224e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2777,7 +2777,7 @@ int udp4_seq_show(struct seq_file *seq, void *v)
 {
 	seq_setwidth(seq, 127);
 	if (v == SEQ_START_TOKEN)
-		seq_puts(seq, "  sl  local_address rem_address   st tx_queue "
+		seq_puts(seq, "   sl  local_address rem_address   st tx_queue "
 			   "rx_queue tr tm->when retrnsmt   uid  timeout "
 			   "inode ref pointer drops");
 	else {
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 299226b57ba5..a4ba47018648 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -775,6 +775,8 @@ vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	struct net *net = dev_net(dev);
 	struct vti6_net *ip6n = net_generic(net, vti6_net_id);
 
+	memset(&p1, 0, sizeof(p1));
+
 	switch (cmd) {
 	case SIOCGETTUNNEL:
 		if (dev == ip6n->fb_tnl_dev) {
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 76e10019a0e9..79b67f8048b5 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3183,6 +3183,19 @@ static void ip6_route_mpath_notify(struct rt6_info *rt,
 		inet6_rt_notify(RTM_NEWROUTE, rt, info, nlflags);
 }
 
+static int fib6_gw_from_attr(struct in6_addr *gw, struct nlattr *nla,
+			     struct netlink_ext_ack *extack)
+{
+	if (nla_len(nla) < sizeof(*gw)) {
+		NL_SET_ERR_MSG(extack, "Invalid IPv6 address in RTA_GATEWAY");
+		return -EINVAL;
+	}
+
+	*gw = nla_get_in6_addr(nla);
+
+	return 0;
+}
+
 static int ip6_route_multipath_add(struct fib6_config *cfg,
 				   struct netlink_ext_ack *extack)
 {
@@ -3223,7 +3236,11 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
 			if (nla) {
-				r_cfg.fc_gateway = nla_get_in6_addr(nla);
+				err = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
+							extack);
+				if (err)
+					goto cleanup;
+
 				r_cfg.fc_flags |= RTF_GATEWAY;
 			}
 			r_cfg.fc_encap = nla_find(attrs, attrlen, RTA_ENCAP);
@@ -3346,7 +3363,13 @@ static int ip6_route_multipath_del(struct fib6_config *cfg,
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
 			if (nla) {
-				nla_memcpy(&r_cfg.fc_gateway, nla, 16);
+				err = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
+							extack);
+				if (err) {
+					last_err = err;
+					goto next_rtnh;
+				}
+
 				r_cfg.fc_flags |= RTF_GATEWAY;
 			}
 		}
@@ -3354,6 +3377,7 @@ static int ip6_route_multipath_del(struct fib6_config *cfg,
 		if (err)
 			last_err = err;
 
+next_rtnh:
 		rtnh = rtnh_next(rtnh, &remaining);
 	}
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a3ec3b1bb324..fb554ca20dc8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4501,7 +4501,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 	 */
 	if (new_sta) {
 		u32 rates = 0, basic_rates = 0;
-		bool have_higher_than_11mbit;
+		bool have_higher_than_11mbit = false;
 		int min_rate = INT_MAX, min_rate_index = -1;
 		const struct cfg80211_bss_ies *ies;
 		int shift = ieee80211_vif_get_shift(&sdata->vif);
diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index b0d958cd1823..4c4a8a42ee88 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -881,6 +881,7 @@ static struct sock *pep_sock_accept(struct sock *sk, int flags, int *errp,
 
 	err = pep_accept_conn(newsk, skb);
 	if (err) {
+		__sock_put(sk);
 		sock_put(newsk);
 		newsk = NULL;
 		goto drop;
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 1e1d6146189f..470101976895 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -1425,10 +1425,8 @@ static int qfq_init_qdisc(struct Qdisc *sch, struct nlattr *opt)
 	if (err < 0)
 		return err;
 
-	if (qdisc_dev(sch)->tx_queue_len + 1 > QFQ_MAX_AGG_CLASSES)
-		max_classes = QFQ_MAX_AGG_CLASSES;
-	else
-		max_classes = qdisc_dev(sch)->tx_queue_len + 1;
+	max_classes = min_t(u64, (u64)qdisc_dev(sch)->tx_queue_len + 1,
+			    QFQ_MAX_AGG_CLASSES);
 	/* max_cl_shift = floor(log_2(max_classes)) */
 	max_cl_shift = __fls(max_classes);
 	q->max_agg_classes = 1<<max_cl_shift;
