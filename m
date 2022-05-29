Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125405370FA
	for <lists+stable@lfdr.de>; Sun, 29 May 2022 14:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiE2MrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 May 2022 08:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiE2MrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 May 2022 08:47:07 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id B981D3B3DD
        for <stable@vger.kernel.org>; Sun, 29 May 2022 05:47:05 -0700 (PDT)
Received: (qmail 146412 invoked by uid 1000); 29 May 2022 08:47:04 -0400
Date:   Sun, 29 May 2022 08:47:04 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     syzbot <syzbot+dc7c3ca638e773db07f6@syzkaller.appspotmail.com>
Cc:     Julia.Lawall@inria.fr, andreyknvl@gmail.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, jannh@google.com,
        jj251510319013@gmail.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, rafael@kernel.org, sashal@kernel.org,
        schspa@gmail.com, stable@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: use-after-free Read in driver_register
Message-ID: <YpNrSABPtB5eDC+m@rowland.harvard.edu>
References: <000000000000e66c2805de55b15a@google.com>
 <000000000000db349d05e01cffa8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000db349d05e01cffa8@google.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 28, 2022 at 07:07:19PM -0700, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    d3fde8ff50ab Add linux-next specific files for 20220527
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=154faf23f00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ccb8d66fc9489ef
> dashboard link: https://syzkaller.appspot.com/bug?extid=dc7c3ca638e773db07f6
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17315ad6f00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12087513f00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+dc7c3ca638e773db07f6@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in driver_find drivers/base/driver.c:293 [inline]
> BUG: KASAN: use-after-free in driver_register+0x352/0x3a0 drivers/base/driver.c:233
> Read of size 8 at addr ffff88807813bec8 by task syz-executor372/10628
> 
> CPU: 1 PID: 10628 Comm: syz-executor372 Not tainted 5.18.0-next-20220527-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
>  print_report mm/kasan/report.c:429 [inline]
>  kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
>  driver_find drivers/base/driver.c:293 [inline]
>  driver_register+0x352/0x3a0 drivers/base/driver.c:233
>  usb_gadget_register_driver_owner+0xfb/0x1e0 drivers/usb/gadget/udc/core.c:1558
>  raw_ioctl_run drivers/usb/gadget/legacy/raw_gadget.c:515 [inline]
>  raw_ioctl+0x188d/0x2730 drivers/usb/gadget/legacy/raw_gadget.c:1222
>  vfs_ioctl fs/ioctl.c:51 [inline]

This sounds a lot like the "WARNING in driver_unregister" bug.  Let's see
if the same fix works.

Alan Stern

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git 97fa5887cf28

Index: usb-devel/drivers/usb/gadget/legacy/raw_gadget.c
===================================================================
--- usb-devel.orig/drivers/usb/gadget/legacy/raw_gadget.c
+++ usb-devel/drivers/usb/gadget/legacy/raw_gadget.c
@@ -11,6 +11,7 @@
 #include <linux/ctype.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
+#include <linux/idr.h>
 #include <linux/kref.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
@@ -36,6 +37,9 @@ MODULE_LICENSE("GPL");
 
 /*----------------------------------------------------------------------*/
 
+static DEFINE_IDA(driver_id_numbers);
+#define DRIVER_DRIVER_NAME_LENGTH_MAX	32
+
 #define RAW_EVENT_QUEUE_SIZE	16
 
 struct raw_event_queue {
@@ -145,6 +149,7 @@ enum dev_state {
 	STATE_DEV_INVALID = 0,
 	STATE_DEV_OPENED,
 	STATE_DEV_INITIALIZED,
+	STATE_DEV_REGISTERING,
 	STATE_DEV_RUNNING,
 	STATE_DEV_CLOSED,
 	STATE_DEV_FAILED
@@ -160,6 +165,9 @@ struct raw_dev {
 	/* Reference to misc device: */
 	struct device			*dev;
 
+	/* Make driver names unique */
+	int				driver_id_number;
+
 	/* Protected by lock: */
 	enum dev_state			state;
 	bool				gadget_registered;
@@ -188,6 +196,7 @@ static struct raw_dev *dev_new(void)
 	spin_lock_init(&dev->lock);
 	init_completion(&dev->ep0_done);
 	raw_event_queue_init(&dev->queue);
+	dev->driver_id_number = -1;
 	return dev;
 }
 
@@ -198,6 +207,9 @@ static void dev_free(struct kref *kref)
 
 	kfree(dev->udc_name);
 	kfree(dev->driver.udc_name);
+	kfree(dev->driver.driver.name);
+	if (dev->driver_id_number >= 0)
+		ida_free(&driver_id_numbers, dev->driver_id_number);
 	if (dev->req) {
 		if (dev->ep0_urb_queued)
 			usb_ep_dequeue(dev->gadget->ep0, dev->req);
@@ -421,6 +433,7 @@ static int raw_ioctl_init(struct raw_dev
 	struct usb_raw_init arg;
 	char *udc_driver_name;
 	char *udc_device_name;
+	char *driver_driver_name;
 	unsigned long flags;
 
 	if (copy_from_user(&arg, (void __user *)value, sizeof(arg)))
@@ -439,36 +452,44 @@ static int raw_ioctl_init(struct raw_dev
 		return -EINVAL;
 	}
 
+	ret = ida_alloc(&driver_id_numbers, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	dev->driver_id_number = ret;
+
+	driver_driver_name = kmalloc(DRIVER_DRIVER_NAME_LENGTH_MAX, GFP_KERNEL);
+	if (!driver_driver_name) {
+		ret = -ENOMEM;
+		goto out_free_driver_id_number;
+	}
+	snprintf(driver_driver_name, DRIVER_DRIVER_NAME_LENGTH_MAX,
+				DRIVER_NAME ".%d", dev->driver_id_number);
+
 	udc_driver_name = kmalloc(UDC_NAME_LENGTH_MAX, GFP_KERNEL);
-	if (!udc_driver_name)
-		return -ENOMEM;
+	if (!udc_driver_name) {
+		ret = -ENOMEM;
+		goto out_free_driver_driver_name;
+	}
 	ret = strscpy(udc_driver_name, &arg.driver_name[0],
 				UDC_NAME_LENGTH_MAX);
-	if (ret < 0) {
-		kfree(udc_driver_name);
-		return ret;
-	}
+	if (ret < 0)
+		goto out_free_udc_driver_name;
 	ret = 0;
 
 	udc_device_name = kmalloc(UDC_NAME_LENGTH_MAX, GFP_KERNEL);
 	if (!udc_device_name) {
-		kfree(udc_driver_name);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_free_udc_driver_name;
 	}
 	ret = strscpy(udc_device_name, &arg.device_name[0],
 				UDC_NAME_LENGTH_MAX);
-	if (ret < 0) {
-		kfree(udc_driver_name);
-		kfree(udc_device_name);
-		return ret;
-	}
+	if (ret < 0)
+		goto out_free_udc_device_name;
 	ret = 0;
 
 	spin_lock_irqsave(&dev->lock, flags);
 	if (dev->state != STATE_DEV_OPENED) {
 		dev_dbg(dev->dev, "fail, device is not opened\n");
-		kfree(udc_driver_name);
-		kfree(udc_device_name);
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -483,14 +504,24 @@ static int raw_ioctl_init(struct raw_dev
 	dev->driver.suspend = gadget_suspend;
 	dev->driver.resume = gadget_resume;
 	dev->driver.reset = gadget_reset;
-	dev->driver.driver.name = DRIVER_NAME;
+	dev->driver.driver.name = driver_driver_name;
 	dev->driver.udc_name = udc_device_name;
 	dev->driver.match_existing_only = 1;
 
 	dev->state = STATE_DEV_INITIALIZED;
+	spin_unlock_irqrestore(&dev->lock, flags);
+	return ret;
 
 out_unlock:
 	spin_unlock_irqrestore(&dev->lock, flags);
+out_free_udc_device_name:
+	kfree(udc_device_name);
+out_free_udc_driver_name:
+	kfree(udc_driver_name);
+out_free_driver_driver_name:
+	kfree(driver_driver_name);
+out_free_driver_id_number:
+	ida_free(&driver_id_numbers, dev->driver_id_number);
 	return ret;
 }
 
@@ -508,6 +539,7 @@ static int raw_ioctl_run(struct raw_dev
 		ret = -EINVAL;
 		goto out_unlock;
 	}
+	dev->state = STATE_DEV_REGISTERING;
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	ret = usb_gadget_register_driver(&dev->driver);

