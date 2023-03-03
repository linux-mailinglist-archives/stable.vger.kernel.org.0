Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E226A9609
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 12:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbjCCLYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 06:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjCCLYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 06:24:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5515D44F;
        Fri,  3 Mar 2023 03:23:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB5F2B818A0;
        Fri,  3 Mar 2023 11:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1CEC433D2;
        Fri,  3 Mar 2023 11:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677842634;
        bh=1JF+Ig9vYVff04qEtiL8P3I4+PwhaT3lEQeKSp1fF+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ShtDxHErScYQg3LCLxk+86HPSCLnCqlB6sW8W3LOi+HFa8s//k+XY2nI4zNwFXtBm
         SqqIQ4RzeBY5OOBFdlMIuYhqUQMwG0eVS8A9Rzre3sI/sHwHLIVH7BBUie2qLIGRy/
         AWWGgiHbhGV8pG3GKO3skzTO9uvHMHOuuXZabLkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.4.234
Date:   Fri,  3 Mar 2023 12:23:43 +0100
Message-Id: <1677842623227224@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <16778426233458@kroah.com>
References: <16778426233458@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 900a2864bfb7..7688832a51d2 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 233
+SUBLEVEL = 234
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 7dcafd0833ba..3a7d375389d0 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -1188,6 +1188,7 @@
 		clock-names = "dp", "pclk";
 		phys = <&edp_phy>;
 		phy-names = "dp";
+		power-domains = <&power RK3288_PD_VIO>;
 		resets = <&cru SRST_EDP>;
 		reset-names = "dp";
 		rockchip,grf = <&grf>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts b/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
index 6c3368f795ca..fbd942b46c54 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
@@ -90,7 +90,6 @@
 			linux,default-trigger = "heartbeat";
 			gpios = <&rk805 1 GPIO_ACTIVE_LOW>;
 			default-state = "on";
-			mode = <0x23>;
 		};
 
 		user {
@@ -98,7 +97,6 @@
 			linux,default-trigger = "mmc1";
 			gpios = <&rk805 0 GPIO_ACTIVE_LOW>;
 			default-state = "off";
-			mode = <0x05>;
 		};
 	};
 };
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 0fe4f3ed72ca..793b8d9d749a 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3599,8 +3599,8 @@ void acpi_nfit_shutdown(void *data)
 
 	mutex_lock(&acpi_desc->init_mutex);
 	set_bit(ARS_CANCEL, &acpi_desc->scrub_flags);
-	cancel_delayed_work_sync(&acpi_desc->dwork);
 	mutex_unlock(&acpi_desc->init_mutex);
+	cancel_delayed_work_sync(&acpi_desc->dwork);
 
 	/*
 	 * Bounce the nvdimm bus lock to make sure any in-flight
diff --git a/drivers/dma/sh/rcar-dmac.c b/drivers/dma/sh/rcar-dmac.c
index eba942441e38..10a8a6d4e860 100644
--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1824,7 +1824,10 @@ static int rcar_dmac_probe(struct platform_device *pdev)
 	dmac->dev = &pdev->dev;
 	platform_set_drvdata(pdev, dmac);
 	dmac->dev->dma_parms = &dmac->parms;
-	dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
+	ret = dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
+	if (ret)
+		return ret;
+
 	ret = dma_set_mask_and_coherent(dmac->dev, DMA_BIT_MASK(40));
 	if (ret)
 		return ret;
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 2888bd5502f3..0c8075d9717c 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1190,6 +1190,7 @@ int hid_open_report(struct hid_device *device)
 	__u8 *end;
 	__u8 *next;
 	int ret;
+	int i;
 	static int (*dispatch_type[])(struct hid_parser *parser,
 				      struct hid_item *item) = {
 		hid_parser_main,
@@ -1240,6 +1241,8 @@ int hid_open_report(struct hid_device *device)
 		goto err;
 	}
 	device->collection_size = HID_DEFAULT_NUM_COLLECTIONS;
+	for (i = 0; i < HID_DEFAULT_NUM_COLLECTIONS; i++)
+		device->collection[i].parent_idx = -1;
 
 	ret = -EINVAL;
 	while ((next = fetch_item(start, end, &item)) != NULL) {
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index e7daa65589ab..6c1d36b2e2a7 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -215,16 +215,11 @@ static void unpin_rcv_pages(struct hfi1_filedata *fd,
 static int pin_rcv_pages(struct hfi1_filedata *fd, struct tid_user_buf *tidbuf)
 {
 	int pinned;
-	unsigned int npages;
+	unsigned int npages = tidbuf->npages;
 	unsigned long vaddr = tidbuf->vaddr;
 	struct page **pages = NULL;
 	struct hfi1_devdata *dd = fd->uctxt->dd;
 
-	/* Get the number of pages the user buffer spans */
-	npages = num_user_pages(vaddr, tidbuf->length);
-	if (!npages)
-		return -EINVAL;
-
 	if (npages > fd->uctxt->expected_count) {
 		dd_dev_err(dd, "Expected buffer too big\n");
 		return -EINVAL;
@@ -258,7 +253,6 @@ static int pin_rcv_pages(struct hfi1_filedata *fd, struct tid_user_buf *tidbuf)
 		return pinned;
 	}
 	tidbuf->pages = pages;
-	tidbuf->npages = npages;
 	fd->tid_n_pinned += pinned;
 	return pinned;
 }
@@ -334,6 +328,7 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 
 	tidbuf->vaddr = tinfo->vaddr;
 	tidbuf->length = tinfo->length;
+	tidbuf->npages = num_user_pages(tidbuf->vaddr, tidbuf->length);
 	tidbuf->psets = kcalloc(uctxt->expected_count, sizeof(*tidbuf->psets),
 				GFP_KERNEL);
 	if (!tidbuf->psets) {
diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index e61fd04a0d8d..eb7208f07345 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -284,10 +284,11 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		ssize_t orig_count;
 		long p = pos;
 
-		ret = -ENXIO;
 		vc = vcs_vc(inode, &viewed);
-		if (!vc)
-			goto unlock_out;
+		if (!vc) {
+			ret = -ENXIO;
+			break;
+		}
 
 		/* Check whether we are above size each round,
 		 * as copy_to_user at the end of this loop
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 549bf04f29b2..f787e9771b1f 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2379,9 +2379,8 @@ static int usb_enumerate_device_otg(struct usb_device *udev)
  * usb_enumerate_device - Read device configs/intfs/otg (usbcore-internal)
  * @udev: newly addressed device (in ADDRESS state)
  *
- * This is only called by usb_new_device() and usb_authorize_device()
- * and FIXME -- all comments that apply to them apply here wrt to
- * environment.
+ * This is only called by usb_new_device() -- all comments that apply there
+ * apply here wrt to environment.
  *
  * If the device is WUSB and not authorized, we don't attempt to read
  * the string descriptors, as they will be errored out by the device
diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index 2f594c88d905..f19694e69f5c 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -889,11 +889,7 @@ read_descriptors(struct file *filp, struct kobject *kobj,
 	size_t srclen, n;
 	int cfgno;
 	void *src;
-	int retval;
 
-	retval = usb_lock_device_interruptible(udev);
-	if (retval < 0)
-		return -EINTR;
 	/* The binary attribute begins with the device descriptor.
 	 * Following that are the raw descriptor entries for all the
 	 * configurations (config plus subsidiary descriptors).
@@ -918,7 +914,6 @@ read_descriptors(struct file *filp, struct kobject *kobj,
 			off -= srclen;
 		}
 	}
-	usb_unlock_device(udev);
 	return count - nleft;
 }
 
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 159b01b9e172..c1839091edf5 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -402,6 +402,8 @@ static void option_instat_callback(struct urb *urb);
 #define LONGCHEER_VENDOR_ID			0x1c9e
 
 /* 4G Systems products */
+/* This one was sold as the VW and Skoda "Carstick LTE" */
+#define FOUR_G_SYSTEMS_PRODUCT_CARSTICK_LTE	0x7605
 /* This is the 4G XS Stick W14 a.k.a. Mobilcom Debitel Surf-Stick *
  * It seems to contain a Qualcomm QSC6240/6290 chipset            */
 #define FOUR_G_SYSTEMS_PRODUCT_W14		0x9603
@@ -1976,6 +1978,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(2) },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
+	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_CARSTICK_LTE),
+	  .driver_info = RSVD(0) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
 	  .driver_info = NCTRL(0) | NCTRL(1) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W100),
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index fb1996980d26..97417b5569a9 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -7347,10 +7347,10 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 	/*
 	 * Check that we don't overflow at later allocations, we request
 	 * clone_sources_count + 1 items, and compare to unsigned long inside
-	 * access_ok.
+	 * access_ok. Also set an upper limit for allocation size so this can't
+	 * easily exhaust memory. Max number of clone sources is about 200K.
 	 */
-	if (arg->clone_sources_count >
-	    ULONG_MAX / sizeof(struct clone_root) - 1) {
+	if (arg->clone_sources_count > SZ_8M / sizeof(struct clone_root)) {
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 8fa98c62c4fc..53f19ee5642f 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -1022,6 +1022,7 @@ static void caif_sock_destructor(struct sock *sk)
 		return;
 	}
 	sk_stream_kill_queues(&cf_sk->sk);
+	WARN_ON(sk->sk_forward_alloc);
 	caif_free_client(&cf_sk->layer);
 }
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 051b9710d7b5..d866e1c5970c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4732,7 +4732,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 		neigh = __ipv6_neigh_lookup_noref_stub(dev, dst);
 	}
 
-	if (!neigh)
+	if (!neigh || !(neigh->nud_state & NUD_VALID))
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
 
 	return bpf_fib_set_fwd_params(params, neigh, dev);
@@ -4845,7 +4845,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 	 * not needed here.
 	 */
 	neigh = __ipv6_neigh_lookup_noref_stub(dev, dst);
-	if (!neigh)
+	if (!neigh || !(neigh->nud_state & NUD_VALID))
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
 
 	return bpf_fib_set_fwd_params(params, neigh, dev);
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 67820219e3b6..ed754217cd1c 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -242,7 +242,7 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 			    (n->nud_state == NUD_NOARP) ||
 			    (tbl->is_multicast &&
 			     tbl->is_multicast(n->primary_key)) ||
-			    time_after(tref, n->updated))
+			    !time_in_range(n->updated, tref, jiffies))
 				remove = true;
 			write_unlock(&n->lock);
 
@@ -262,7 +262,17 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 
 static void neigh_add_timer(struct neighbour *n, unsigned long when)
 {
+	/* Use safe distance from the jiffies - LONG_MAX point while timer
+	 * is running in DELAY/PROBE state but still show to user space
+	 * large times in the past.
+	 */
+	unsigned long mint = jiffies - (LONG_MAX - 86400 * HZ);
+
 	neigh_hold(n);
+	if (!time_in_range(n->confirmed, mint, jiffies))
+		n->confirmed = mint;
+	if (time_before(n->used, n->confirmed))
+		n->used = n->confirmed;
 	if (unlikely(mod_timer(&n->timer, when))) {
 		printk("NEIGH: BUG, double timer add, state is %x\n",
 		       n->nud_state);
@@ -948,12 +958,14 @@ static void neigh_periodic_work(struct work_struct *work)
 				goto next_elt;
 			}
 
-			if (time_before(n->used, n->confirmed))
+			if (time_before(n->used, n->confirmed) &&
+			    time_is_before_eq_jiffies(n->confirmed))
 				n->used = n->confirmed;
 
 			if (refcount_read(&n->refcnt) == 1 &&
 			    (state == NUD_FAILED ||
-			     time_after(jiffies, n->used + NEIGH_VAR(n->parms, GC_STALETIME)))) {
+			     !time_in_range_open(jiffies, n->used,
+						 n->used + NEIGH_VAR(n->parms, GC_STALETIME)))) {
 				*np = n->next;
 				neigh_mark_dead(n);
 				write_unlock(&n->lock);
diff --git a/net/core/stream.c b/net/core/stream.c
index d7c5413d16d5..cd60746877b1 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -209,7 +209,6 @@ void sk_stream_kill_queues(struct sock *sk)
 	sk_mem_reclaim(sk);
 
 	WARN_ON(sk->sk_wmem_queued);
-	WARN_ON(sk->sk_forward_alloc);
 
 	/* It is _impossible_ for the backlog to contain anything
 	 * when we get here.  All user references to this socket
