Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53B8658134
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiL1QZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234609AbiL1QZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:25:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C181B1F7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:22:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A6E0B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B02DC433EF;
        Wed, 28 Dec 2022 16:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244547;
        bh=s3S4tIrGDqlx1YevtGWa0nASZEPywBIRIfKJDXxkCjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iGFVBiaKRkEF+nSh5LCF3JbIU0XZ9rGMsgoRr9ozasqVWj8HT7LB2ka2GbKNsrh4X
         qYWVrMGh7T6FQcR0QMJBnb3Pa73u3rFwJVw/SUtBbW8XLLqVLGWJJ+MQrg5Wco2xIL
         AKPAkeFWDHFM1qjVghN2IZp0Ktq8Wbv4OeJJcgxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Kent Gibson <warthog618@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Nick Hainke <vincent@systemli.org>
Subject: [PATCH 6.0 0717/1073] gpiolib: protect the GPIO device against being dropped while in use by user-space
Date:   Wed, 28 Dec 2022 15:38:25 +0100
Message-Id: <20221228144347.502444673@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit bdbbae241a04f387ba910b8609f95fad5f1470c7 ]

While any of the GPIO cdev syscalls is in progress, the kernel can call
gpiochip_remove() (for instance, when a USB GPIO expander is disconnected)
which will set gdev->chip to NULL after which any subsequent access will
cause a crash.

To avoid that: use an RW-semaphore in which the syscalls take it for
reading (so that we don't needlessly prohibit the user-space from calling
syscalls simultaneously) while gpiochip_remove() takes it for writing so
that it can only happen once all syscalls return.

Fixes: d7c51b47ac11 ("gpio: userspace ABI for reading/writing GPIO lines")
Fixes: 3c0d9c635ae2 ("gpiolib: cdev: support GPIO_V2_GET_LINE_IOCTL and GPIO_V2_LINE_GET_VALUES_IOCTL")
Fixes: aad955842d1c ("gpiolib: cdev: support GPIO_V2_GET_LINEINFO_IOCTL and GPIO_V2_GET_LINEINFO_WATCH_IOCTL")
Fixes: a54756cb24ea ("gpiolib: cdev: support GPIO_V2_LINE_SET_CONFIG_IOCTL")
Fixes: 7b8e00d98168 ("gpiolib: cdev: support GPIO_V2_LINE_SET_VALUES_IOCTL")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
[Nick: fixed a build failure with CDEV_V1 disabled]
Co-authored-by: Nick Hainke <vincent@systemli.org>
Reviewed-by: Kent Gibson <warthog618@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 177 +++++++++++++++++++++++++++++++-----
 drivers/gpio/gpiolib.c      |   4 +
 drivers/gpio/gpiolib.h      |   5 +
 3 files changed, 161 insertions(+), 25 deletions(-)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index 5b647327cb7f..12e068dc60bc 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -55,6 +55,50 @@ static_assert(IS_ALIGNED(sizeof(struct gpio_v2_line_values), 8));
  * interface to gpiolib GPIOs via ioctl()s.
  */
 
+typedef __poll_t (*poll_fn)(struct file *, struct poll_table_struct *);
+typedef long (*ioctl_fn)(struct file *, unsigned int, unsigned long);
+typedef ssize_t (*read_fn)(struct file *, char __user *,
+			   size_t count, loff_t *);
+
+static __poll_t call_poll_locked(struct file *file,
+				 struct poll_table_struct *wait,
+				 struct gpio_device *gdev, poll_fn func)
+{
+	__poll_t ret;
+
+	down_read(&gdev->sem);
+	ret = func(file, wait);
+	up_read(&gdev->sem);
+
+	return ret;
+}
+
+static long call_ioctl_locked(struct file *file, unsigned int cmd,
+			      unsigned long arg, struct gpio_device *gdev,
+			      ioctl_fn func)
+{
+	long ret;
+
+	down_read(&gdev->sem);
+	ret = func(file, cmd, arg);
+	up_read(&gdev->sem);
+
+	return ret;
+}
+
+static ssize_t call_read_locked(struct file *file, char __user *buf,
+				size_t count, loff_t *f_ps,
+				struct gpio_device *gdev, read_fn func)
+{
+	ssize_t ret;
+
+	down_read(&gdev->sem);
+	ret = func(file, buf, count, f_ps);
+	up_read(&gdev->sem);
+
+	return ret;
+}
+
 /*
  * GPIO line handle management
  */
@@ -191,8 +235,8 @@ static long linehandle_set_config(struct linehandle_state *lh,
 	return 0;
 }
 
-static long linehandle_ioctl(struct file *file, unsigned int cmd,
-			     unsigned long arg)
+static long linehandle_ioctl_unlocked(struct file *file, unsigned int cmd,
+				      unsigned long arg)
 {
 	struct linehandle_state *lh = file->private_data;
 	void __user *ip = (void __user *)arg;
@@ -250,6 +294,15 @@ static long linehandle_ioctl(struct file *file, unsigned int cmd,
 	}
 }
 
+static long linehandle_ioctl(struct file *file, unsigned int cmd,
+			     unsigned long arg)
+{
+	struct linehandle_state *lh = file->private_data;
+
+	return call_ioctl_locked(file, cmd, arg, lh->gdev,
+				 linehandle_ioctl_unlocked);
+}
+
 #ifdef CONFIG_COMPAT
 static long linehandle_ioctl_compat(struct file *file, unsigned int cmd,
 				    unsigned long arg)
@@ -1381,8 +1434,8 @@ static long linereq_set_config(struct linereq *lr, void __user *ip)
 	return ret;
 }
 
-static long linereq_ioctl(struct file *file, unsigned int cmd,
-			  unsigned long arg)
+static long linereq_ioctl_unlocked(struct file *file, unsigned int cmd,
+				   unsigned long arg)
 {
 	struct linereq *lr = file->private_data;
 	void __user *ip = (void __user *)arg;
@@ -1402,6 +1455,15 @@ static long linereq_ioctl(struct file *file, unsigned int cmd,
 	}
 }
 
+static long linereq_ioctl(struct file *file, unsigned int cmd,
+			  unsigned long arg)
+{
+	struct linereq *lr = file->private_data;
+
+	return call_ioctl_locked(file, cmd, arg, lr->gdev,
+				 linereq_ioctl_unlocked);
+}
+
 #ifdef CONFIG_COMPAT
 static long linereq_ioctl_compat(struct file *file, unsigned int cmd,
 				 unsigned long arg)
@@ -1410,8 +1472,8 @@ static long linereq_ioctl_compat(struct file *file, unsigned int cmd,
 }
 #endif
 
-static __poll_t linereq_poll(struct file *file,
-			    struct poll_table_struct *wait)
+static __poll_t linereq_poll_unlocked(struct file *file,
+				      struct poll_table_struct *wait)
 {
 	struct linereq *lr = file->private_data;
 	__poll_t events = 0;
@@ -1428,10 +1490,16 @@ static __poll_t linereq_poll(struct file *file,
 	return events;
 }
 
-static ssize_t linereq_read(struct file *file,
-			    char __user *buf,
-			    size_t count,
-			    loff_t *f_ps)
+static __poll_t linereq_poll(struct file *file,
+			     struct poll_table_struct *wait)
+{
+	struct linereq *lr = file->private_data;
+
+	return call_poll_locked(file, wait, lr->gdev, linereq_poll_unlocked);
+}
+
+static ssize_t linereq_read_unlocked(struct file *file, char __user *buf,
+				     size_t count, loff_t *f_ps)
 {
 	struct linereq *lr = file->private_data;
 	struct gpio_v2_line_event le;
@@ -1485,6 +1553,15 @@ static ssize_t linereq_read(struct file *file,
 	return bytes_read;
 }
 
+static ssize_t linereq_read(struct file *file, char __user *buf,
+			    size_t count, loff_t *f_ps)
+{
+	struct linereq *lr = file->private_data;
+
+	return call_read_locked(file, buf, count, f_ps, lr->gdev,
+				linereq_read_unlocked);
+}
+
 static void linereq_free(struct linereq *lr)
 {
 	unsigned int i;
@@ -1704,8 +1781,8 @@ struct lineevent_state {
 	(GPIOEVENT_REQUEST_RISING_EDGE | \
 	GPIOEVENT_REQUEST_FALLING_EDGE)
 
-static __poll_t lineevent_poll(struct file *file,
-			       struct poll_table_struct *wait)
+static __poll_t lineevent_poll_unlocked(struct file *file,
+					struct poll_table_struct *wait)
 {
 	struct lineevent_state *le = file->private_data;
 	__poll_t events = 0;
@@ -1721,15 +1798,21 @@ static __poll_t lineevent_poll(struct file *file,
 	return events;
 }
 
+static __poll_t lineevent_poll(struct file *file,
+			       struct poll_table_struct *wait)
+{
+	struct lineevent_state *le = file->private_data;
+
+	return call_poll_locked(file, wait, le->gdev, lineevent_poll_unlocked);
+}
+
 struct compat_gpioeevent_data {
 	compat_u64	timestamp;
 	u32		id;
 };
 
-static ssize_t lineevent_read(struct file *file,
-			      char __user *buf,
-			      size_t count,
-			      loff_t *f_ps)
+static ssize_t lineevent_read_unlocked(struct file *file, char __user *buf,
+				       size_t count, loff_t *f_ps)
 {
 	struct lineevent_state *le = file->private_data;
 	struct gpioevent_data ge;
@@ -1797,6 +1880,15 @@ static ssize_t lineevent_read(struct file *file,
 	return bytes_read;
 }
 
+static ssize_t lineevent_read(struct file *file, char __user *buf,
+			      size_t count, loff_t *f_ps)
+{
+	struct lineevent_state *le = file->private_data;
+
+	return call_read_locked(file, buf, count, f_ps, le->gdev,
+				lineevent_read_unlocked);
+}
+
 static void lineevent_free(struct lineevent_state *le)
 {
 	if (le->irq)
@@ -1814,8 +1906,8 @@ static int lineevent_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static long lineevent_ioctl(struct file *file, unsigned int cmd,
-			    unsigned long arg)
+static long lineevent_ioctl_unlocked(struct file *file, unsigned int cmd,
+				     unsigned long arg)
 {
 	struct lineevent_state *le = file->private_data;
 	void __user *ip = (void __user *)arg;
@@ -1846,6 +1938,15 @@ static long lineevent_ioctl(struct file *file, unsigned int cmd,
 	return -EINVAL;
 }
 
+static long lineevent_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
+{
+	struct lineevent_state *le = file->private_data;
+
+	return call_ioctl_locked(file, cmd, arg, le->gdev,
+				 lineevent_ioctl_unlocked);
+}
+
 #ifdef CONFIG_COMPAT
 static long lineevent_ioctl_compat(struct file *file, unsigned int cmd,
 				   unsigned long arg)
@@ -2404,8 +2505,8 @@ static int lineinfo_changed_notify(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-static __poll_t lineinfo_watch_poll(struct file *file,
-				    struct poll_table_struct *pollt)
+static __poll_t lineinfo_watch_poll_unlocked(struct file *file,
+					     struct poll_table_struct *pollt)
 {
 	struct gpio_chardev_data *cdev = file->private_data;
 	__poll_t events = 0;
@@ -2422,8 +2523,17 @@ static __poll_t lineinfo_watch_poll(struct file *file,
 	return events;
 }
 
-static ssize_t lineinfo_watch_read(struct file *file, char __user *buf,
-				   size_t count, loff_t *off)
+static __poll_t lineinfo_watch_poll(struct file *file,
+				    struct poll_table_struct *pollt)
+{
+	struct gpio_chardev_data *cdev = file->private_data;
+
+	return call_poll_locked(file, pollt, cdev->gdev,
+				lineinfo_watch_poll_unlocked);
+}
+
+static ssize_t lineinfo_watch_read_unlocked(struct file *file, char __user *buf,
+					    size_t count, loff_t *off)
 {
 	struct gpio_chardev_data *cdev = file->private_data;
 	struct gpio_v2_line_info_changed event;
@@ -2501,6 +2611,15 @@ static ssize_t lineinfo_watch_read(struct file *file, char __user *buf,
 	return bytes_read;
 }
 
+static ssize_t lineinfo_watch_read(struct file *file, char __user *buf,
+				   size_t count, loff_t *off)
+{
+	struct gpio_chardev_data *cdev = file->private_data;
+
+	return call_read_locked(file, buf, count, off, cdev->gdev,
+				lineinfo_watch_read_unlocked);
+}
+
 /**
  * gpio_chrdev_open() - open the chardev for ioctl operations
  * @inode: inode for this chardev
@@ -2514,13 +2633,17 @@ static int gpio_chrdev_open(struct inode *inode, struct file *file)
 	struct gpio_chardev_data *cdev;
 	int ret = -ENOMEM;
 
+	down_read(&gdev->sem);
+
 	/* Fail on open if the backing gpiochip is gone */
-	if (!gdev->chip)
-		return -ENODEV;
+	if (!gdev->chip) {
+		ret = -ENODEV;
+		goto out_unlock;
+	}
 
 	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
 	if (!cdev)
-		return -ENOMEM;
+		goto out_unlock;
 
 	cdev->watched_lines = bitmap_zalloc(gdev->chip->ngpio, GFP_KERNEL);
 	if (!cdev->watched_lines)
@@ -2543,6 +2666,8 @@ static int gpio_chrdev_open(struct inode *inode, struct file *file)
 	if (ret)
 		goto out_unregister_notifier;
 
+	up_read(&gdev->sem);
+
 	return ret;
 
 out_unregister_notifier:
@@ -2552,6 +2677,8 @@ static int gpio_chrdev_open(struct inode *inode, struct file *file)
 	bitmap_free(cdev->watched_lines);
 out_free_cdev:
 	kfree(cdev);
+out_unlock:
+	up_read(&gdev->sem);
 	return ret;
 }
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index eb7d00608c7f..2adca7c2dd5c 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -735,6 +735,7 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
 	BLOCKING_INIT_NOTIFIER_HEAD(&gdev->notifier);
+	init_rwsem(&gdev->sem);
 
 #ifdef CONFIG_PINCTRL
 	INIT_LIST_HEAD(&gdev->pin_ranges);
@@ -875,6 +876,8 @@ void gpiochip_remove(struct gpio_chip *gc)
 	unsigned long	flags;
 	unsigned int	i;
 
+	down_write(&gdev->sem);
+
 	/* FIXME: should the legacy sysfs handling be moved to gpio_device? */
 	gpiochip_sysfs_unregister(gdev);
 	gpiochip_free_hogs(gc);
@@ -909,6 +912,7 @@ void gpiochip_remove(struct gpio_chip *gc)
 	 * gone.
 	 */
 	gcdev_unregister(gdev);
+	up_write(&gdev->sem);
 	put_device(&gdev->dev);
 }
 EXPORT_SYMBOL_GPL(gpiochip_remove);
diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
index d900ecdbac46..9ad68a0adf4a 100644
--- a/drivers/gpio/gpiolib.h
+++ b/drivers/gpio/gpiolib.h
@@ -15,6 +15,7 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/cdev.h>
+#include <linux/rwsem.h>
 
 #define GPIOCHIP_NAME	"gpiochip"
 
@@ -39,6 +40,9 @@
  * @list: links gpio_device:s together for traversal
  * @notifier: used to notify subscribers about lines being requested, released
  *            or reconfigured
+ * @sem: protects the structure from a NULL-pointer dereference of @chip by
+ *       user-space operations when the device gets unregistered during
+ *       a hot-unplug event
  * @pin_ranges: range of pins served by the GPIO driver
  *
  * This state container holds most of the runtime variable data
@@ -60,6 +64,7 @@ struct gpio_device {
 	void			*data;
 	struct list_head        list;
 	struct blocking_notifier_head notifier;
+	struct rw_semaphore	sem;
 
 #ifdef CONFIG_PINCTRL
 	/*
-- 
2.35.1



