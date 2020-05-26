Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8502C1E2AB0
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389501AbgEZS6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390244AbgEZS6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:58:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0BF2208B6;
        Tue, 26 May 2020 18:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519482;
        bh=JCdrpn7Sx061zCqoVm7uU9wOH1V8zYERJTamQrgoxHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mpt+BNZzlJYkutAHF86iiFSxuC+GdZnYIrMXUdqo03e5vQEPvY6jTeE/TquFLL2zh
         9Zoe2TztNq2KY1bpmXggdfYuwtuPaEz+VgUgiGNRBpVxs7UJFAwQWJ9bpq2Ayj6Kjh
         r7BG/3oQhYFpkGPmuxtnNEjIbICrmKpIT7EsHDKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Hao <haokexin@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 20/64] i2c: dev: Fix the race between the release of i2c_dev and cdev
Date:   Tue, 26 May 2020 20:52:49 +0200
Message-Id: <20200526183919.454859054@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

[ Upstream commit 1413ef638abae4ab5621901cf4d8ef08a4a48ba6 ]

The struct cdev is embedded in the struct i2c_dev. In the current code,
we would free the i2c_dev struct directly in put_i2c_dev(), but the
cdev is manged by a kobject, and the release of it is not predictable.
So it is very possible that the i2c_dev is freed before the cdev is
entirely released. We can easily get the following call trace with
CONFIG_DEBUG_KOBJECT_RELEASE and CONFIG_DEBUG_OBJECTS_TIMERS enabled.
  ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x38
  WARNING: CPU: 19 PID: 1 at lib/debugobjects.c:325 debug_print_object+0xb0/0xf0
  Modules linked in:
  CPU: 19 PID: 1 Comm: swapper/0 Tainted: G        W         5.2.20-yocto-standard+ #120
  Hardware name: Marvell OcteonTX CN96XX board (DT)
  pstate: 80c00089 (Nzcv daIf +PAN +UAO)
  pc : debug_print_object+0xb0/0xf0
  lr : debug_print_object+0xb0/0xf0
  sp : ffff00001292f7d0
  x29: ffff00001292f7d0 x28: ffff800b82151788
  x27: 0000000000000001 x26: ffff800b892c0000
  x25: ffff0000124a2558 x24: 0000000000000000
  x23: ffff00001107a1d8 x22: ffff0000116b5088
  x21: ffff800bdc6afca8 x20: ffff000012471ae8
  x19: ffff00001168f2c8 x18: 0000000000000010
  x17: 00000000fd6f304b x16: 00000000ee79de43
  x15: ffff800bc0e80568 x14: 79616c6564203a74
  x13: 6e6968207473696c x12: 5f72656d6974203a
  x11: ffff0000113f0018 x10: 0000000000000000
  x9 : 000000000000001f x8 : 0000000000000000
  x7 : ffff0000101294cc x6 : 0000000000000000
  x5 : 0000000000000000 x4 : 0000000000000001
  x3 : 00000000ffffffff x2 : 0000000000000000
  x1 : 387fc15c8ec0f200 x0 : 0000000000000000
  Call trace:
   debug_print_object+0xb0/0xf0
   __debug_check_no_obj_freed+0x19c/0x228
   debug_check_no_obj_freed+0x1c/0x28
   kfree+0x250/0x440
   put_i2c_dev+0x68/0x78
   i2cdev_detach_adapter+0x60/0xc8
   i2cdev_notifier_call+0x3c/0x70
   notifier_call_chain+0x8c/0xe8
   blocking_notifier_call_chain+0x64/0x88
   device_del+0x74/0x380
   device_unregister+0x54/0x78
   i2c_del_adapter+0x278/0x2d0
   unittest_i2c_bus_remove+0x3c/0x80
   platform_drv_remove+0x30/0x50
   device_release_driver_internal+0xf4/0x1c0
   driver_detach+0x58/0xa0
   bus_remove_driver+0x84/0xd8
   driver_unregister+0x34/0x60
   platform_driver_unregister+0x20/0x30
   of_unittest_overlay+0x8d4/0xbe0
   of_unittest+0xae8/0xb3c
   do_one_initcall+0xac/0x450
   do_initcall_level+0x208/0x224
   kernel_init_freeable+0x2d8/0x36c
   kernel_init+0x18/0x108
   ret_from_fork+0x10/0x1c
  irq event stamp: 3934661
  hardirqs last  enabled at (3934661): [<ffff00001009fa04>] debug_exception_exit+0x4c/0x58
  hardirqs last disabled at (3934660): [<ffff00001009fb14>] debug_exception_enter+0xa4/0xe0
  softirqs last  enabled at (3934654): [<ffff000010081d94>] __do_softirq+0x46c/0x628
  softirqs last disabled at (3934649): [<ffff0000100b4a1c>] irq_exit+0x104/0x118

This is a common issue when using cdev embedded in a struct.
Fortunately, we already have a mechanism to solve this kind of issue.
Please see commit 233ed09d7fda ("chardev: add helper function to
register char devs with a struct device") for more detail.

In this patch, we choose to embed the struct device into the i2c_dev,
and use the API provided by the commit 233ed09d7fda to make sure that
the release of i2c_dev and cdev are in sequence.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-dev.c | 48 +++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index eaa312bc3a3c..c4066276eb7b 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -47,7 +47,7 @@
 struct i2c_dev {
 	struct list_head list;
 	struct i2c_adapter *adap;
-	struct device *dev;
+	struct device dev;
 	struct cdev cdev;
 };
 
@@ -91,12 +91,14 @@ static struct i2c_dev *get_free_i2c_dev(struct i2c_adapter *adap)
 	return i2c_dev;
 }
 
-static void put_i2c_dev(struct i2c_dev *i2c_dev)
+static void put_i2c_dev(struct i2c_dev *i2c_dev, bool del_cdev)
 {
 	spin_lock(&i2c_dev_list_lock);
 	list_del(&i2c_dev->list);
 	spin_unlock(&i2c_dev_list_lock);
-	kfree(i2c_dev);
+	if (del_cdev)
+		cdev_device_del(&i2c_dev->cdev, &i2c_dev->dev);
+	put_device(&i2c_dev->dev);
 }
 
 static ssize_t name_show(struct device *dev,
@@ -542,6 +544,14 @@ static const struct file_operations i2cdev_fops = {
 
 static struct class *i2c_dev_class;
 
+static void i2cdev_dev_release(struct device *dev)
+{
+	struct i2c_dev *i2c_dev;
+
+	i2c_dev = container_of(dev, struct i2c_dev, dev);
+	kfree(i2c_dev);
+}
+
 static int i2cdev_attach_adapter(struct device *dev, void *dummy)
 {
 	struct i2c_adapter *adap;
@@ -558,27 +568,23 @@ static int i2cdev_attach_adapter(struct device *dev, void *dummy)
 
 	cdev_init(&i2c_dev->cdev, &i2cdev_fops);
 	i2c_dev->cdev.owner = THIS_MODULE;
-	res = cdev_add(&i2c_dev->cdev, MKDEV(I2C_MAJOR, adap->nr), 1);
-	if (res)
-		goto error_cdev;
-
-	/* register this i2c device with the driver core */
-	i2c_dev->dev = device_create(i2c_dev_class, &adap->dev,
-				     MKDEV(I2C_MAJOR, adap->nr), NULL,
-				     "i2c-%d", adap->nr);
-	if (IS_ERR(i2c_dev->dev)) {
-		res = PTR_ERR(i2c_dev->dev);
-		goto error;
+
+	device_initialize(&i2c_dev->dev);
+	i2c_dev->dev.devt = MKDEV(I2C_MAJOR, adap->nr);
+	i2c_dev->dev.class = i2c_dev_class;
+	i2c_dev->dev.parent = &adap->dev;
+	i2c_dev->dev.release = i2cdev_dev_release;
+	dev_set_name(&i2c_dev->dev, "i2c-%d", adap->nr);
+
+	res = cdev_device_add(&i2c_dev->cdev, &i2c_dev->dev);
+	if (res) {
+		put_i2c_dev(i2c_dev, false);
+		return res;
 	}
 
 	pr_debug("i2c-dev: adapter [%s] registered as minor %d\n",
 		 adap->name, adap->nr);
 	return 0;
-error:
-	cdev_del(&i2c_dev->cdev);
-error_cdev:
-	put_i2c_dev(i2c_dev);
-	return res;
 }
 
 static int i2cdev_detach_adapter(struct device *dev, void *dummy)
@@ -594,9 +600,7 @@ static int i2cdev_detach_adapter(struct device *dev, void *dummy)
 	if (!i2c_dev) /* attach_adapter must have failed */
 		return 0;
 
-	cdev_del(&i2c_dev->cdev);
-	put_i2c_dev(i2c_dev);
-	device_destroy(i2c_dev_class, MKDEV(I2C_MAJOR, adap->nr));
+	put_i2c_dev(i2c_dev, true);
 
 	pr_debug("i2c-dev: adapter [%s] unregistered\n", adap->name);
 	return 0;
-- 
2.25.1



