Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF58F657C6C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbiL1Pcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbiL1PcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:32:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2514815827
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:32:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A88BC6154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6526C433D2;
        Wed, 28 Dec 2022 15:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241533;
        bh=IRtR2z1epeC/MSEGfQda3jfqagBT2QCgyqvbkPNsES8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RI9v8ONzK0uOnAcxnt+jpAza8rGk9UvzwGr+f5h2L+ROhsiLMB4L5G/Wo/fEhopOI
         Katz/iMupAbLLf22OlwZYnJJimNloBQeicPYPId0q76Sdi3PEuXsldRM5ToKzVrGxr
         hqv87h9DMBKrO4M2eYtUokJF+GN1UmgNCQahhFaU=
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
Subject: [PATCH 5.15 493/731] gpiolib: protect the GPIO device against being dropped while in use by user-space
Date:   Wed, 28 Dec 2022 15:40:00 +0100
Message-Id: <20221228144310.837907034@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 64e37618216f..2a2e0691462b 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -54,6 +54,50 @@ static_assert(IS_ALIGNED(sizeof(struct gpio_v2_line_values), 8));
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
@@ -190,8 +234,8 @@ static long linehandle_set_config(struct linehandle_state *lh,
 	return 0;
 }
 
-static long linehandle_ioctl(struct file *file, unsigned int cmd,
-			     unsigned long arg)
+static long linehandle_ioctl_unlocked(struct file *file, unsigned int cmd,
+				      unsigned long arg)
 {
 	struct linehandle_state *lh = file->private_data;
 	void __user *ip = (void __user *)arg;
@@ -249,6 +293,15 @@ static long linehandle_ioctl(struct file *file, unsigned int cmd,
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
@@ -1185,8 +1238,8 @@ static long linereq_set_config(struct linereq *lr, void __user *ip)
 	return ret;
 }
 
-static long linereq_ioctl(struct file *file, unsigned int cmd,
-			  unsigned long arg)
+static long linereq_ioctl_unlocked(struct file *file, unsigned int cmd,
+				   unsigned long arg)
 {
 	struct linereq *lr = file->private_data;
 	void __user *ip = (void __user *)arg;
@@ -1206,6 +1259,15 @@ static long linereq_ioctl(struct file *file, unsigned int cmd,
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
@@ -1214,8 +1276,8 @@ static long linereq_ioctl_compat(struct file *file, unsigned int cmd,
 }
 #endif
 
-static __poll_t linereq_poll(struct file *file,
-			    struct poll_table_struct *wait)
+static __poll_t linereq_poll_unlocked(struct file *file,
+				      struct poll_table_struct *wait)
 {
 	struct linereq *lr = file->private_data;
 	__poll_t events = 0;
@@ -1232,10 +1294,16 @@ static __poll_t linereq_poll(struct file *file,
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
@@ -1289,6 +1357,15 @@ static ssize_t linereq_read(struct file *file,
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
@@ -1504,8 +1581,8 @@ struct lineevent_state {
 	(GPIOEVENT_REQUEST_RISING_EDGE | \
 	GPIOEVENT_REQUEST_FALLING_EDGE)
 
-static __poll_t lineevent_poll(struct file *file,
-			       struct poll_table_struct *wait)
+static __poll_t lineevent_poll_unlocked(struct file *file,
+					struct poll_table_struct *wait)
 {
 	struct lineevent_state *le = file->private_data;
 	__poll_t events = 0;
@@ -1521,15 +1598,21 @@ static __poll_t lineevent_poll(struct file *file,
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
@@ -1597,6 +1680,15 @@ static ssize_t lineevent_read(struct file *file,
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
@@ -1614,8 +1706,8 @@ static int lineevent_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static long lineevent_ioctl(struct file *file, unsigned int cmd,
-			    unsigned long arg)
+static long lineevent_ioctl_unlocked(struct file *file, unsigned int cmd,
+				     unsigned long arg)
 {
 	struct lineevent_state *le = file->private_data;
 	void __user *ip = (void __user *)arg;
@@ -1646,6 +1738,15 @@ static long lineevent_ioctl(struct file *file, unsigned int cmd,
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
@@ -2202,8 +2303,8 @@ static int lineinfo_changed_notify(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-static __poll_t lineinfo_watch_poll(struct file *file,
-				    struct poll_table_struct *pollt)
+static __poll_t lineinfo_watch_poll_unlocked(struct file *file,
+					     struct poll_table_struct *pollt)
 {
 	struct gpio_chardev_data *cdev = file->private_data;
 	__poll_t events = 0;
@@ -2220,8 +2321,17 @@ static __poll_t lineinfo_watch_poll(struct file *file,
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
@@ -2299,6 +2409,15 @@ static ssize_t lineinfo_watch_read(struct file *file, char __user *buf,
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
@@ -2312,13 +2431,17 @@ static int gpio_chrdev_open(struct inode *inode, struct file *file)
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
@@ -2341,6 +2464,8 @@ static int gpio_chrdev_open(struct inode *inode, struct file *file)
 	if (ret)
 		goto out_unregister_notifier;
 
+	up_read(&gdev->sem);
+
 	return ret;
 
 out_unregister_notifier:
@@ -2350,6 +2475,8 @@ static int gpio_chrdev_open(struct inode *inode, struct file *file)
 	bitmap_free(cdev->watched_lines);
 out_free_cdev:
 	kfree(cdev);
+out_unlock:
+	up_read(&gdev->sem);
 	return ret;
 }
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index fdca300f6003..8c041a8dd9d8 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -727,6 +727,7 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
 	BLOCKING_INIT_NOTIFIER_HEAD(&gdev->notifier);
+	init_rwsem(&gdev->sem);
 
 #ifdef CONFIG_PINCTRL
 	INIT_LIST_HEAD(&gdev->pin_ranges);
@@ -865,6 +866,8 @@ void gpiochip_remove(struct gpio_chip *gc)
 	unsigned long	flags;
 	unsigned int	i;
 
+	down_write(&gdev->sem);
+
 	/* FIXME: should the legacy sysfs handling be moved to gpio_device? */
 	gpiochip_sysfs_unregister(gdev);
 	gpiochip_free_hogs(gc);
@@ -899,6 +902,7 @@ void gpiochip_remove(struct gpio_chip *gc)
 	 * gone.
 	 */
 	gcdev_unregister(gdev);
+	up_write(&gdev->sem);
 	put_device(&gdev->dev);
 }
 EXPORT_SYMBOL_GPL(gpiochip_remove);
diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
index d77be9d1da80..73b732a1d9c9 100644
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



