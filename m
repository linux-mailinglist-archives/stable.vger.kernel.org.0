Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591D51E2E8D
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390792AbgEZTAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390802AbgEZTAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:00:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB1B420849;
        Tue, 26 May 2020 19:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519644;
        bh=gwkqAzjGrhQwjEY4Kl61JQADH910vNWzOGnYmmZvHsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mX8RZCykvll2uWTvvLOV7dPjt+MuPd3Ubf6K0/kdNeteHuukOv1PDYkr9v1bqiueU
         W45QZsmukaqbitvNCn/PQo/FS7OUDPwJVSUR6YvKcGMJBhXhfdshMVzz7KEMh/4i5g
         zv4t4iVtSPYhmJ4h+cCFNkiRE17peQdLG4kNaIkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Hao <haokexin@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 02/59] watchdog: Fix the race between the release of watchdog_core_data and cdev
Date:   Tue, 26 May 2020 20:52:47 +0200
Message-Id: <20200526183907.854621404@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183907.123822792@linuxfoundation.org>
References: <20200526183907.123822792@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

commit 72139dfa2464e43957d330266994740bb7be2535 upstream.

The struct cdev is embedded in the struct watchdog_core_data. In the
current code, we manage the watchdog_core_data with a kref, but the
cdev is manged by a kobject. There is no any relationship between
this kref and kobject. So it is possible that the watchdog_core_data is
freed before the cdev is entirely released. We can easily get the
following call trace with CONFIG_DEBUG_KOBJECT_RELEASE and
CONFIG_DEBUG_OBJECTS_TIMERS enabled.
  ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x38
  WARNING: CPU: 23 PID: 1028 at lib/debugobjects.c:481 debug_print_object+0xb0/0xf0
  Modules linked in: softdog(-) deflate ctr twofish_generic twofish_common camellia_generic serpent_generic blowfish_generic blowfish_common cast5_generic cast_common cmac xcbc af_key sch_fq_codel openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
  CPU: 23 PID: 1028 Comm: modprobe Not tainted 5.3.0-next-20190924-yoctodev-standard+ #180
  Hardware name: Marvell OcteonTX CN96XX board (DT)
  pstate: 00400009 (nzcv daif +PAN -UAO)
  pc : debug_print_object+0xb0/0xf0
  lr : debug_print_object+0xb0/0xf0
  sp : ffff80001cbcfc70
  x29: ffff80001cbcfc70 x28: ffff800010ea2128
  x27: ffff800010bad000 x26: 0000000000000000
  x25: ffff80001103c640 x24: ffff80001107b268
  x23: ffff800010bad9e8 x22: ffff800010ea2128
  x21: ffff000bc2c62af8 x20: ffff80001103c600
  x19: ffff800010e867d8 x18: 0000000000000060
  x17: 0000000000000000 x16: 0000000000000000
  x15: ffff000bd7240470 x14: 6e6968207473696c
  x13: 5f72656d6974203a x12: 6570797420746365
  x11: 6a626f2029302065 x10: 7461747320657669
  x9 : 7463612820657669 x8 : 3378302f3078302b
  x7 : 0000000000001d7a x6 : ffff800010fd5889
  x5 : 0000000000000000 x4 : 0000000000000000
  x3 : 0000000000000000 x2 : ffff000bff948548
  x1 : 276a1c9e1edc2300 x0 : 0000000000000000
  Call trace:
   debug_print_object+0xb0/0xf0
   debug_check_no_obj_freed+0x1e8/0x210
   kfree+0x1b8/0x368
   watchdog_cdev_unregister+0x88/0xc8
   watchdog_dev_unregister+0x38/0x48
   watchdog_unregister_device+0xa8/0x100
   softdog_exit+0x18/0xfec4 [softdog]
   __arm64_sys_delete_module+0x174/0x200
   el0_svc_handler+0xd0/0x1c8
   el0_svc+0x8/0xc

This is a common issue when using cdev embedded in a struct.
Fortunately, we already have a mechanism to solve this kind of issue.
Please see commit 233ed09d7fda ("chardev: add helper function to
register char devs with a struct device") for more detail.

In this patch, we choose to embed the struct device into the
watchdog_core_data, and use the API provided by the commit 233ed09d7fda
to make sure that the release of watchdog_core_data and cdev are
in sequence.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20191008112934.29669-1-haokexin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
[bwh: Backported to 4.14:
 - There's no reboot notifier here
 - Adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/watchdog_dev.c |   67 +++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 37 deletions(-)

--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -38,7 +38,6 @@
 #include <linux/init.h>		/* For __init/__exit/... */
 #include <linux/jiffies.h>	/* For timeout functions */
 #include <linux/kernel.h>	/* For printk/panic/... */
-#include <linux/kref.h>		/* For data references */
 #include <linux/miscdevice.h>	/* For handling misc devices */
 #include <linux/module.h>	/* For module stuff/... */
 #include <linux/mutex.h>	/* For mutexes */
@@ -53,14 +52,14 @@
 
 /*
  * struct watchdog_core_data - watchdog core internal data
- * @kref:	Reference count.
+ * @dev:	The watchdog's internal device
  * @cdev:	The watchdog's Character device.
  * @wdd:	Pointer to watchdog device.
  * @lock:	Lock for watchdog core.
  * @status:	Watchdog core internal status bits.
  */
 struct watchdog_core_data {
-	struct kref kref;
+	struct device dev;
 	struct cdev cdev;
 	struct watchdog_device *wdd;
 	struct mutex lock;
@@ -802,7 +801,7 @@ static int watchdog_open(struct inode *i
 	file->private_data = wd_data;
 
 	if (!hw_running)
-		kref_get(&wd_data->kref);
+		get_device(&wd_data->dev);
 
 	/* dev/watchdog is a virtual (and thus non-seekable) filesystem */
 	return nonseekable_open(inode, file);
@@ -814,11 +813,11 @@ out_clear:
 	return err;
 }
 
-static void watchdog_core_data_release(struct kref *kref)
+static void watchdog_core_data_release(struct device *dev)
 {
 	struct watchdog_core_data *wd_data;
 
-	wd_data = container_of(kref, struct watchdog_core_data, kref);
+	wd_data = container_of(dev, struct watchdog_core_data, dev);
 
 	kfree(wd_data);
 }
@@ -878,7 +877,7 @@ done:
 	 */
 	if (!running) {
 		module_put(wd_data->cdev.owner);
-		kref_put(&wd_data->kref, watchdog_core_data_release);
+		put_device(&wd_data->dev);
 	}
 	return 0;
 }
@@ -897,17 +896,22 @@ static struct miscdevice watchdog_miscde
 	.fops		= &watchdog_fops,
 };
 
+static struct class watchdog_class = {
+	.name =		"watchdog",
+	.owner =	THIS_MODULE,
+	.dev_groups =	wdt_groups,
+};
+
 /*
  *	watchdog_cdev_register: register watchdog character device
  *	@wdd: watchdog device
- *	@devno: character device number
  *
  *	Register a watchdog character device including handling the legacy
  *	/dev/watchdog node. /dev/watchdog is actually a miscdevice and
  *	thus we set it up like that.
  */
 
-static int watchdog_cdev_register(struct watchdog_device *wdd, dev_t devno)
+static int watchdog_cdev_register(struct watchdog_device *wdd)
 {
 	struct watchdog_core_data *wd_data;
 	int err;
@@ -915,7 +919,6 @@ static int watchdog_cdev_register(struct
 	wd_data = kzalloc(sizeof(struct watchdog_core_data), GFP_KERNEL);
 	if (!wd_data)
 		return -ENOMEM;
-	kref_init(&wd_data->kref);
 	mutex_init(&wd_data->lock);
 
 	wd_data->wdd = wdd;
@@ -942,23 +945,33 @@ static int watchdog_cdev_register(struct
 		}
 	}
 
+	device_initialize(&wd_data->dev);
+	wd_data->dev.devt = MKDEV(MAJOR(watchdog_devt), wdd->id);
+	wd_data->dev.class = &watchdog_class;
+	wd_data->dev.parent = wdd->parent;
+	wd_data->dev.groups = wdd->groups;
+	wd_data->dev.release = watchdog_core_data_release;
+	dev_set_drvdata(&wd_data->dev, wdd);
+	dev_set_name(&wd_data->dev, "watchdog%d", wdd->id);
+
 	/* Fill in the data structures */
 	cdev_init(&wd_data->cdev, &watchdog_fops);
-	wd_data->cdev.owner = wdd->ops->owner;
 
 	/* Add the device */
-	err = cdev_add(&wd_data->cdev, devno, 1);
+	err = cdev_device_add(&wd_data->cdev, &wd_data->dev);
 	if (err) {
 		pr_err("watchdog%d unable to add device %d:%d\n",
 			wdd->id,  MAJOR(watchdog_devt), wdd->id);
 		if (wdd->id == 0) {
 			misc_deregister(&watchdog_miscdev);
 			old_wd_data = NULL;
-			kref_put(&wd_data->kref, watchdog_core_data_release);
+			put_device(&wd_data->dev);
 		}
 		return err;
 	}
 
+	wd_data->cdev.owner = wdd->ops->owner;
+
 	/* Record time of most recent heartbeat as 'just before now'. */
 	wd_data->last_hw_keepalive = jiffies - 1;
 
@@ -968,7 +981,7 @@ static int watchdog_cdev_register(struct
 	 */
 	if (watchdog_hw_running(wdd)) {
 		__module_get(wdd->ops->owner);
-		kref_get(&wd_data->kref);
+		get_device(&wd_data->dev);
 		if (handle_boot_enabled)
 			queue_delayed_work(watchdog_wq, &wd_data->work, 0);
 		else
@@ -991,7 +1004,7 @@ static void watchdog_cdev_unregister(str
 {
 	struct watchdog_core_data *wd_data = wdd->wd_data;
 
-	cdev_del(&wd_data->cdev);
+	cdev_device_del(&wd_data->cdev, &wd_data->dev);
 	if (wdd->id == 0) {
 		misc_deregister(&watchdog_miscdev);
 		old_wd_data = NULL;
@@ -1009,15 +1022,9 @@ static void watchdog_cdev_unregister(str
 
 	cancel_delayed_work_sync(&wd_data->work);
 
-	kref_put(&wd_data->kref, watchdog_core_data_release);
+	put_device(&wd_data->dev);
 }
 
-static struct class watchdog_class = {
-	.name =		"watchdog",
-	.owner =	THIS_MODULE,
-	.dev_groups =	wdt_groups,
-};
-
 /*
  *	watchdog_dev_register: register a watchdog device
  *	@wdd: watchdog device
@@ -1029,27 +1036,14 @@ static struct class watchdog_class = {
 
 int watchdog_dev_register(struct watchdog_device *wdd)
 {
-	struct device *dev;
-	dev_t devno;
 	int ret;
 
-	devno = MKDEV(MAJOR(watchdog_devt), wdd->id);
-
-	ret = watchdog_cdev_register(wdd, devno);
+	ret = watchdog_cdev_register(wdd);
 	if (ret)
 		return ret;
 
-	dev = device_create_with_groups(&watchdog_class, wdd->parent,
-					devno, wdd, wdd->groups,
-					"watchdog%d", wdd->id);
-	if (IS_ERR(dev)) {
-		watchdog_cdev_unregister(wdd);
-		return PTR_ERR(dev);
-	}
-
 	ret = watchdog_register_pretimeout(wdd);
 	if (ret) {
-		device_destroy(&watchdog_class, devno);
 		watchdog_cdev_unregister(wdd);
 	}
 
@@ -1067,7 +1061,6 @@ int watchdog_dev_register(struct watchdo
 void watchdog_dev_unregister(struct watchdog_device *wdd)
 {
 	watchdog_unregister_pretimeout(wdd);
-	device_destroy(&watchdog_class, wdd->wd_data->cdev.dev);
 	watchdog_cdev_unregister(wdd);
 }
 


