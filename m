Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF4D537ECE
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238399AbiE3Nxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239317AbiE3Nv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:51:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11BD87236;
        Mon, 30 May 2022 06:36:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D49AB80D89;
        Mon, 30 May 2022 13:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114D7C3411C;
        Mon, 30 May 2022 13:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917785;
        bh=o882i/Fwuefe4ZEUm5K6yWjxmkM/x190IqhzUQdH+N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCHVqvztgyyQHQn/864GVTk+jGM860mm2Z/9+278CAWokv7foc50QlG1h5h+xQhM0
         Wa16T+DnCSxr0izBvp/1jLQw6mHbXz17Vi7DYqhNnPq9cIjrLQDyDOh7h759jiNQ6R
         onY6clnFFRghpYONsMAW0jBDfU14IcwLsgJGb90EGjpFIXLBYnJU5KpAs/pwf05HIk
         gxVs7PkrbjEU1l/aowFVF3MjBHWdu+X2ZZlzVfF3xZ2uwwaiBeR2tn4plKaTllfvMO
         dAH5oaDEXvK0kmgXo/Z3tsNdLBwUGasxwUTzUL3ttyE71ycuwOr0vmsPzr+JsGf+aB
         ElrErgofX4RVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+c558267ad910fc494497@syzkaller.appspotmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 097/135] media: imon: reorganize serialization
Date:   Mon, 30 May 2022 09:30:55 -0400
Message-Id: <20220530133133.1931716-97-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit db264d4c66c0fe007b5d19fd007707cd0697603d ]

Since usb_register_dev() from imon_init_display() from imon_probe() holds
minor_rwsem while display_open() which holds driver_lock and ictx->lock is
called with minor_rwsem held from usb_open(), holding driver_lock or
ictx->lock when calling usb_register_dev() causes circular locking
dependency problem.

Since usb_deregister_dev() from imon_disconnect() holds minor_rwsem while
display_open() which holds driver_lock is called with minor_rwsem held,
holding driver_lock when calling usb_deregister_dev() also causes circular
locking dependency problem.

Sean Young explained that the problem is there are imon devices which have
two usb interfaces, even though it is one device. The probe and disconnect
function of both usb interfaces can run concurrently.

Alan Stern responded that the driver and USB cores guarantee that when an
interface is probed, both the interface and its USB device are locked.
Ditto for when the disconnect callback gets run. So concurrent probing/
disconnection of multiple interfaces on the same device is not possible.

Therefore, we don't need locks for handling race between imon_probe() and
imon_disconnect(). But we still need to handle race between display_open()
/vfd_write()/lcd_write()/display_close() and imon_disconnect(), for
disconnect event can happen while file descriptors are in use.

Since "struct file"->private_data is set by display_open(), vfd_write()/
lcd_write()/display_close() can assume that "struct file"->private_data
is not NULL even after usb_set_intfdata(interface, NULL) was called.

Replace insufficiently held driver_lock with refcount_t based management.
Add a boolean flag for recording whether imon_disconnect() was already
called. Use RCU for accessing this boolean flag and refcount_t.

Since the boolean flag for imon_disconnect() is shared, disconnect event
on either intf0 or intf1 affects both interfaces. But I assume that this
change does not matter, for usually disconnect event would not happen
while interfaces are in use.

Link: https://syzkaller.appspot.com/bug?extid=c558267ad910fc494497

Reported-by: syzbot <syzbot+c558267ad910fc494497@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+c558267ad910fc494497@syzkaller.appspotmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/imon.c | 99 +++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 52 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 54da6f60079b..ab090663f975 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -153,6 +153,24 @@ struct imon_context {
 	const struct imon_usb_dev_descr *dev_descr;
 					/* device description with key */
 					/* table for front panels */
+	/*
+	 * Fields for deferring free_imon_context().
+	 *
+	 * Since reference to "struct imon_context" is stored into
+	 * "struct file"->private_data, we need to remember
+	 * how many file descriptors might access this "struct imon_context".
+	 */
+	refcount_t users;
+	/*
+	 * Use a flag for telling display_open()/vfd_write()/lcd_write() that
+	 * imon_disconnect() was already called.
+	 */
+	bool disconnected;
+	/*
+	 * We need to wait for RCU grace period in order to allow
+	 * display_open() to safely check ->disconnected and increment ->users.
+	 */
+	struct rcu_head rcu;
 };
 
 #define TOUCH_TIMEOUT	(HZ/30)
@@ -160,18 +178,18 @@ struct imon_context {
 /* vfd character device file operations */
 static const struct file_operations vfd_fops = {
 	.owner		= THIS_MODULE,
-	.open		= &display_open,
-	.write		= &vfd_write,
-	.release	= &display_close,
+	.open		= display_open,
+	.write		= vfd_write,
+	.release	= display_close,
 	.llseek		= noop_llseek,
 };
 
 /* lcd character device file operations */
 static const struct file_operations lcd_fops = {
 	.owner		= THIS_MODULE,
-	.open		= &display_open,
-	.write		= &lcd_write,
-	.release	= &display_close,
+	.open		= display_open,
+	.write		= lcd_write,
+	.release	= display_close,
 	.llseek		= noop_llseek,
 };
 
@@ -439,9 +457,6 @@ static struct usb_driver imon_driver = {
 	.id_table	= imon_usb_id_table,
 };
 
-/* to prevent races between open() and disconnect(), probing, etc */
-static DEFINE_MUTEX(driver_lock);
-
 /* Module bookkeeping bits */
 MODULE_AUTHOR(MOD_AUTHOR);
 MODULE_DESCRIPTION(MOD_DESC);
@@ -481,9 +496,11 @@ static void free_imon_context(struct imon_context *ictx)
 	struct device *dev = ictx->dev;
 
 	usb_free_urb(ictx->tx_urb);
+	WARN_ON(ictx->dev_present_intf0);
 	usb_free_urb(ictx->rx_urb_intf0);
+	WARN_ON(ictx->dev_present_intf1);
 	usb_free_urb(ictx->rx_urb_intf1);
-	kfree(ictx);
+	kfree_rcu(ictx, rcu);
 
 	dev_dbg(dev, "%s: iMON context freed\n", __func__);
 }
@@ -499,9 +516,6 @@ static int display_open(struct inode *inode, struct file *file)
 	int subminor;
 	int retval = 0;
 
-	/* prevent races with disconnect */
-	mutex_lock(&driver_lock);
-
 	subminor = iminor(inode);
 	interface = usb_find_interface(&imon_driver, subminor);
 	if (!interface) {
@@ -509,13 +523,16 @@ static int display_open(struct inode *inode, struct file *file)
 		retval = -ENODEV;
 		goto exit;
 	}
-	ictx = usb_get_intfdata(interface);
 
-	if (!ictx) {
+	rcu_read_lock();
+	ictx = usb_get_intfdata(interface);
+	if (!ictx || ictx->disconnected || !refcount_inc_not_zero(&ictx->users)) {
+		rcu_read_unlock();
 		pr_err("no context found for minor %d\n", subminor);
 		retval = -ENODEV;
 		goto exit;
 	}
+	rcu_read_unlock();
 
 	mutex_lock(&ictx->lock);
 
@@ -533,8 +550,10 @@ static int display_open(struct inode *inode, struct file *file)
 
 	mutex_unlock(&ictx->lock);
 
+	if (retval && refcount_dec_and_test(&ictx->users))
+		free_imon_context(ictx);
+
 exit:
-	mutex_unlock(&driver_lock);
 	return retval;
 }
 
@@ -544,16 +563,9 @@ static int display_open(struct inode *inode, struct file *file)
  */
 static int display_close(struct inode *inode, struct file *file)
 {
-	struct imon_context *ictx = NULL;
+	struct imon_context *ictx = file->private_data;
 	int retval = 0;
 
-	ictx = file->private_data;
-
-	if (!ictx) {
-		pr_err("no context for device\n");
-		return -ENODEV;
-	}
-
 	mutex_lock(&ictx->lock);
 
 	if (!ictx->display_supported) {
@@ -568,6 +580,8 @@ static int display_close(struct inode *inode, struct file *file)
 	}
 
 	mutex_unlock(&ictx->lock);
+	if (refcount_dec_and_test(&ictx->users))
+		free_imon_context(ictx);
 	return retval;
 }
 
@@ -934,15 +948,12 @@ static ssize_t vfd_write(struct file *file, const char __user *buf,
 	int offset;
 	int seq;
 	int retval = 0;
-	struct imon_context *ictx;
+	struct imon_context *ictx = file->private_data;
 	static const unsigned char vfd_packet6[] = {
 		0x01, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF };
 
-	ictx = file->private_data;
-	if (!ictx) {
-		pr_err_ratelimited("no context for device\n");
+	if (ictx->disconnected)
 		return -ENODEV;
-	}
 
 	mutex_lock(&ictx->lock);
 
@@ -1018,13 +1029,10 @@ static ssize_t lcd_write(struct file *file, const char __user *buf,
 			 size_t n_bytes, loff_t *pos)
 {
 	int retval = 0;
-	struct imon_context *ictx;
+	struct imon_context *ictx = file->private_data;
 
-	ictx = file->private_data;
-	if (!ictx) {
-		pr_err_ratelimited("no context for device\n");
+	if (ictx->disconnected)
 		return -ENODEV;
-	}
 
 	mutex_lock(&ictx->lock);
 
@@ -2404,7 +2412,6 @@ static int imon_probe(struct usb_interface *interface,
 	int ifnum, sysfs_err;
 	int ret = 0;
 	struct imon_context *ictx = NULL;
-	struct imon_context *first_if_ctx = NULL;
 	u16 vendor, product;
 
 	usbdev     = usb_get_dev(interface_to_usbdev(interface));
@@ -2416,17 +2423,12 @@ static int imon_probe(struct usb_interface *interface,
 	dev_dbg(dev, "%s: found iMON device (%04x:%04x, intf%d)\n",
 		__func__, vendor, product, ifnum);
 
-	/* prevent races probing devices w/multiple interfaces */
-	mutex_lock(&driver_lock);
-
 	first_if = usb_ifnum_to_if(usbdev, 0);
 	if (!first_if) {
 		ret = -ENODEV;
 		goto fail;
 	}
 
-	first_if_ctx = usb_get_intfdata(first_if);
-
 	if (ifnum == 0) {
 		ictx = imon_init_intf0(interface, id);
 		if (!ictx) {
@@ -2434,9 +2436,11 @@ static int imon_probe(struct usb_interface *interface,
 			ret = -ENODEV;
 			goto fail;
 		}
+		refcount_set(&ictx->users, 1);
 
 	} else {
 		/* this is the secondary interface on the device */
+		struct imon_context *first_if_ctx = usb_get_intfdata(first_if);
 
 		/* fail early if first intf failed to register */
 		if (!first_if_ctx) {
@@ -2450,14 +2454,13 @@ static int imon_probe(struct usb_interface *interface,
 			ret = -ENODEV;
 			goto fail;
 		}
+		refcount_inc(&ictx->users);
 
 	}
 
 	usb_set_intfdata(interface, ictx);
 
 	if (ifnum == 0) {
-		mutex_lock(&ictx->lock);
-
 		if (product == 0xffdc && ictx->rf_device) {
 			sysfs_err = sysfs_create_group(&interface->dev.kobj,
 						       &imon_rf_attr_group);
@@ -2468,21 +2471,17 @@ static int imon_probe(struct usb_interface *interface,
 
 		if (ictx->display_supported)
 			imon_init_display(ictx, interface);
-
-		mutex_unlock(&ictx->lock);
 	}
 
 	dev_info(dev, "iMON device (%04x:%04x, intf%d) on usb<%d:%d> initialized\n",
 		 vendor, product, ifnum,
 		 usbdev->bus->busnum, usbdev->devnum);
 
-	mutex_unlock(&driver_lock);
 	usb_put_dev(usbdev);
 
 	return 0;
 
 fail:
-	mutex_unlock(&driver_lock);
 	usb_put_dev(usbdev);
 	dev_err(dev, "unable to register, err %d\n", ret);
 
@@ -2498,10 +2497,8 @@ static void imon_disconnect(struct usb_interface *interface)
 	struct device *dev;
 	int ifnum;
 
-	/* prevent races with multi-interface device probing and display_open */
-	mutex_lock(&driver_lock);
-
 	ictx = usb_get_intfdata(interface);
+	ictx->disconnected = true;
 	dev = ictx->dev;
 	ifnum = interface->cur_altsetting->desc.bInterfaceNumber;
 
@@ -2542,11 +2539,9 @@ static void imon_disconnect(struct usb_interface *interface)
 		}
 	}
 
-	if (!ictx->dev_present_intf0 && !ictx->dev_present_intf1)
+	if (refcount_dec_and_test(&ictx->users))
 		free_imon_context(ictx);
 
-	mutex_unlock(&driver_lock);
-
 	dev_dbg(dev, "%s: iMON device (intf%d) disconnected\n",
 		__func__, ifnum);
 }
-- 
2.35.1

