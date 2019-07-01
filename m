Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAEE2F2AF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbfE3EYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:24:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730037AbfE3DOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:55 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B136E2449A;
        Thu, 30 May 2019 03:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186094;
        bh=ywf1nuG7kMfD5ctTdkXYQCTqMgoIsl1j0TPUzIGUXX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKfmL7S7Y0kbrfuKhkqrjUfQZdAANM3FdGXmPpNb3eRSXDqpXvEUzCK80734bj8oY
         o3I9Oyx1VY1B9JnSmxQvt9mt1sixt9kXCliEXXDQ+Gh+ZnsyJ59CtWLZrDq6YFCMOJ
         W5EfBdZ+EHfxSM30V9r1KCxDKo4lHYb4QoJpgtbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Piotr Figiel <p.figiel@camlintechnologies.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 227/346] brcmfmac: convert dev_init_lock mutex to completion
Date:   Wed, 29 May 2019 20:05:00 -0700
Message-Id: <20190530030552.560299127@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a9fd0953fa4a62887306be28641b4b0809f3b2fd ]

Leaving dev_init_lock mutex locked in probe causes BUG and a WARNING when
kernel is compiled with CONFIG_PROVE_LOCKING. Convert mutex to completion
which silences those warnings and improves code readability.

Fix below errors when connecting the USB WiFi dongle:

brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43143 for chip BCM43143/2
BUG: workqueue leaked lock or atomic: kworker/0:2/0x00000000/434
     last function: hub_event
1 lock held by kworker/0:2/434:
 #0: 18d5dcdf (&devinfo->dev_init_lock){+.+.}, at: brcmf_usb_probe+0x78/0x550 [brcmfmac]
CPU: 0 PID: 434 Comm: kworker/0:2 Not tainted 4.19.23-00084-g454a789-dirty #123
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Workqueue: usb_hub_wq hub_event
[<8011237c>] (unwind_backtrace) from [<8010d74c>] (show_stack+0x10/0x14)
[<8010d74c>] (show_stack) from [<809c4324>] (dump_stack+0xa8/0xd4)
[<809c4324>] (dump_stack) from [<8014195c>] (process_one_work+0x710/0x808)
[<8014195c>] (process_one_work) from [<80141a80>] (worker_thread+0x2c/0x564)
[<80141a80>] (worker_thread) from [<80147bcc>] (kthread+0x13c/0x16c)
[<80147bcc>] (kthread) from [<801010b4>] (ret_from_fork+0x14/0x20)
Exception stack(0xed1d9fb0 to 0xed1d9ff8)
9fa0:                                     00000000 00000000 00000000 00000000
9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9fe0: 00000000 00000000 00000000 00000000 00000013 00000000

======================================================
WARNING: possible circular locking dependency detected
4.19.23-00084-g454a789-dirty #123 Not tainted
------------------------------------------------------
kworker/0:2/434 is trying to acquire lock:
e29cf799 ((wq_completion)"events"){+.+.}, at: process_one_work+0x174/0x808

but task is already holding lock:
18d5dcdf (&devinfo->dev_init_lock){+.+.}, at: brcmf_usb_probe+0x78/0x550 [brcmfmac]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&devinfo->dev_init_lock){+.+.}:
       mutex_lock_nested+0x1c/0x24
       brcmf_usb_probe+0x78/0x550 [brcmfmac]
       usb_probe_interface+0xc0/0x1bc
       really_probe+0x228/0x2c0
       __driver_attach+0xe4/0xe8
       bus_for_each_dev+0x68/0xb4
       bus_add_driver+0x19c/0x214
       driver_register+0x78/0x110
       usb_register_driver+0x84/0x148
       process_one_work+0x228/0x808
       worker_thread+0x2c/0x564
       kthread+0x13c/0x16c
       ret_from_fork+0x14/0x20
         (null)

-> #1 (brcmf_driver_work){+.+.}:
       worker_thread+0x2c/0x564
       kthread+0x13c/0x16c
       ret_from_fork+0x14/0x20
         (null)

-> #0 ((wq_completion)"events"){+.+.}:
       process_one_work+0x1b8/0x808
       worker_thread+0x2c/0x564
       kthread+0x13c/0x16c
       ret_from_fork+0x14/0x20
         (null)

other info that might help us debug this:

Chain exists of:
  (wq_completion)"events" --> brcmf_driver_work --> &devinfo->dev_init_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&devinfo->dev_init_lock);
                               lock(brcmf_driver_work);
                               lock(&devinfo->dev_init_lock);
  lock((wq_completion)"events");

 *** DEADLOCK ***

1 lock held by kworker/0:2/434:
 #0: 18d5dcdf (&devinfo->dev_init_lock){+.+.}, at: brcmf_usb_probe+0x78/0x550 [brcmfmac]

stack backtrace:
CPU: 0 PID: 434 Comm: kworker/0:2 Not tainted 4.19.23-00084-g454a789-dirty #123
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Workqueue: events request_firmware_work_func
[<8011237c>] (unwind_backtrace) from [<8010d74c>] (show_stack+0x10/0x14)
[<8010d74c>] (show_stack) from [<809c4324>] (dump_stack+0xa8/0xd4)
[<809c4324>] (dump_stack) from [<80172838>] (print_circular_bug+0x210/0x330)
[<80172838>] (print_circular_bug) from [<80175940>] (__lock_acquire+0x160c/0x1a30)
[<80175940>] (__lock_acquire) from [<8017671c>] (lock_acquire+0xe0/0x268)
[<8017671c>] (lock_acquire) from [<80141404>] (process_one_work+0x1b8/0x808)
[<80141404>] (process_one_work) from [<80141a80>] (worker_thread+0x2c/0x564)
[<80141a80>] (worker_thread) from [<80147bcc>] (kthread+0x13c/0x16c)
[<80147bcc>] (kthread) from [<801010b4>] (ret_from_fork+0x14/0x20)
Exception stack(0xed1d9fb0 to 0xed1d9ff8)
9fa0:                                     00000000 00000000 00000000 00000000
9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9fe0: 00000000 00000000 00000000 00000000 00000013 00000000

Signed-off-by: Piotr Figiel <p.figiel@camlintechnologies.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/broadcom/brcm80211/brcmfmac/usb.c  | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index a4308c6e72d79..5aeb401d9a024 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -160,7 +160,7 @@ struct brcmf_usbdev_info {
 
 	struct usb_device *usbdev;
 	struct device *dev;
-	struct mutex dev_init_lock;
+	struct completion dev_init_done;
 
 	int ctl_in_pipe, ctl_out_pipe;
 	struct urb *ctl_urb; /* URB for control endpoint */
@@ -1195,11 +1195,11 @@ static void brcmf_usb_probe_phase2(struct device *dev, int ret,
 	if (ret)
 		goto error;
 
-	mutex_unlock(&devinfo->dev_init_lock);
+	complete(&devinfo->dev_init_done);
 	return;
 error:
 	brcmf_dbg(TRACE, "failed: dev=%s, err=%d\n", dev_name(dev), ret);
-	mutex_unlock(&devinfo->dev_init_lock);
+	complete(&devinfo->dev_init_done);
 	device_release_driver(dev);
 }
 
@@ -1267,7 +1267,7 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 		if (ret)
 			goto fail;
 		/* we are done */
-		mutex_unlock(&devinfo->dev_init_lock);
+		complete(&devinfo->dev_init_done);
 		return 0;
 	}
 	bus->chip = bus_pub->devid;
@@ -1327,11 +1327,10 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	devinfo->usbdev = usb;
 	devinfo->dev = &usb->dev;
-	/* Take an init lock, to protect for disconnect while still loading.
+	/* Init completion, to protect for disconnect while still loading.
 	 * Necessary because of the asynchronous firmware load construction
 	 */
-	mutex_init(&devinfo->dev_init_lock);
-	mutex_lock(&devinfo->dev_init_lock);
+	init_completion(&devinfo->dev_init_done);
 
 	usb_set_intfdata(intf, devinfo);
 
@@ -1409,7 +1408,7 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	return 0;
 
 fail:
-	mutex_unlock(&devinfo->dev_init_lock);
+	complete(&devinfo->dev_init_done);
 	kfree(devinfo);
 	usb_set_intfdata(intf, NULL);
 	return ret;
@@ -1424,7 +1423,7 @@ brcmf_usb_disconnect(struct usb_interface *intf)
 	devinfo = (struct brcmf_usbdev_info *)usb_get_intfdata(intf);
 
 	if (devinfo) {
-		mutex_lock(&devinfo->dev_init_lock);
+		wait_for_completion(&devinfo->dev_init_done);
 		/* Make sure that devinfo still exists. Firmware probe routines
 		 * may have released the device and cleared the intfdata.
 		 */
-- 
2.20.1



