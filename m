Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC1F6A9603
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 12:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjCCLYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 06:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjCCLXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 06:23:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143DE231DE;
        Fri,  3 Mar 2023 03:23:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD816B8184D;
        Fri,  3 Mar 2023 11:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFE4C4339B;
        Fri,  3 Mar 2023 11:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677842626;
        bh=7ZHEiXV/LN4LCHgFqQPu0GLiJdaXHWaRMzmaqW4ggYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dw36ovgYwpyxUmb7aspYssuRe4f6wnKjYwEEKwnRzwyo0NZSs9ih+1Ubj3NFTAhbu
         Wtul8c5eV3CvDXuIOp/cp8+pCVSCp8lBPdrDVxzQXI/oIRIq7B/Hxg0ogT+cijsTsM
         Q9r0J48eWX9HGYrhDoCRf+aBagG3nIJYK9MKAbZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.275
Date:   Fri,  3 Mar 2023 12:23:39 +0100
Message-Id: <1677842618231119@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <1677842618121251@kroah.com>
References: <1677842618121251@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 273379e3f477..684987d4984b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 274
+SUBLEVEL = 275
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index e442bf7427ae..402b5e0fd616 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -1172,6 +1172,7 @@
 		clock-names = "dp", "pclk";
 		phys = <&edp_phy>;
 		phy-names = "dp";
+		power-domains = <&power RK3288_PD_VIO>;
 		resets = <&cru SRST_EDP>;
 		reset-names = "dp";
 		rockchip,grf = <&grf>;
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 58a756ca14d8..c2863eec0f24 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3442,8 +3442,8 @@ void acpi_nfit_shutdown(void *data)
 
 	mutex_lock(&acpi_desc->init_mutex);
 	set_bit(ARS_CANCEL, &acpi_desc->scrub_flags);
-	cancel_delayed_work_sync(&acpi_desc->dwork);
 	mutex_unlock(&acpi_desc->init_mutex);
+	cancel_delayed_work_sync(&acpi_desc->dwork);
 
 	/*
 	 * Bounce the nvdimm bus lock to make sure any in-flight
diff --git a/drivers/dma/sh/rcar-dmac.c b/drivers/dma/sh/rcar-dmac.c
index 29c51762336d..e18d4116d9ab 100644
--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1816,7 +1816,10 @@ static int rcar_dmac_probe(struct platform_device *pdev)
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
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index dab823aac95e..2619a7a9f27c 100644
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
index 03fe692d940b..5b5e800ab154 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -266,10 +266,11 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
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
index af9fe76745c3..619e80783866 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2345,9 +2345,8 @@ static int usb_enumerate_device_otg(struct usb_device *udev)
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
index b93b18ba89df..7e88fdfe3cf5 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -888,11 +888,7 @@ read_descriptors(struct file *filp, struct kobject *kobj,
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
@@ -917,7 +913,6 @@ read_descriptors(struct file *filp, struct kobject *kobj,
 			off -= srclen;
 		}
 	}
-	usb_unlock_device(udev);
 	return count - nleft;
 }
 
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 48b66656dca8..17cfa0fd6175 100644
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
index 80d248e88761..1f535cd990d3 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6826,10 +6826,10 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
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
index 348b8cb0bc24..cab0b239f96a 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -1022,6 +1022,7 @@ static void caif_sock_destructor(struct sock *sk)
 		return;
 	}
 	sk_stream_kill_queues(&cf_sk->sk);
+	WARN_ON(sk->sk_forward_alloc);
 	caif_free_client(&cf_sk->layer);
 }
 
diff --git a/net/core/stream.c b/net/core/stream.c
index 58755528d39e..23e6669d3f8d 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -209,7 +209,6 @@ void sk_stream_kill_queues(struct sock *sk)
 	sk_mem_reclaim(sk);
 
 	WARN_ON(sk->sk_wmem_queued);
-	WARN_ON(sk->sk_forward_alloc);
 
 	/* It is _impossible_ for the backlog to contain anything
 	 * when we get here.  All user references to this socket
