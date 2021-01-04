Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8342E99BB
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbhADQDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:03:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728249AbhADQDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:03:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76D5322519;
        Mon,  4 Jan 2021 16:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776166;
        bh=eKCoLzrwcvJfZEJPxdbw6hs0kwNlAfV2WmIbhNMSVDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5g1opx4J4EYhSsIj2zlOn1W74MRs+iwEFDcII6cQtybtlxLrvdyBlQUI/gKd3eD0
         4dJ9ovjPTEFJLAMNdnKN/et54S1D6RrS36l8nRfzlevWeabgQwIpu/0PSb1bNYtnGU
         YtDrKkcyRYqI+VzNYoLkhQit/NAlzA7xaMXwV/7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Neville <dark@volatile.bz>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Christopher Obbard <chris.obbard@collabora.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 52/63] um: random: Register random as hwrng-core device
Date:   Mon,  4 Jan 2021 16:57:45 +0100
Message-Id: <20210104155711.335379250@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christopher Obbard <chris.obbard@collabora.com>

[ Upstream commit 72d3e093afae79611fa38f8f2cfab9a888fe66f2 ]

The UML random driver creates a dummy device under the guest,
/dev/hw_random. When this file is read from the guest, the driver
reads from the host machine's /dev/random, in-turn reading from
the host kernel's entropy pool. This entropy pool could have been
filled by a hardware random number generator or just the host
kernel's internal software entropy generator.

Currently the driver does not fill the guests kernel entropy pool,
this requires a userspace tool running inside the guest (like
rng-tools) to read from the dummy device provided by this driver,
which then would fill the guest's internal entropy pool.

This all seems quite pointless when we are already reading from an
entropy pool, so this patch aims to register the device as a hwrng
device using the hwrng-core framework. This not only improves and
cleans up the driver, but also fills the guest's entropy pool
without having to resort to using extra userspace tools in the guest.

This is typically a nuisance when booting a guest: the random pool
takes a long time (~200s) to build up enough entropy since the dummy
hwrng is not used to fill the guest's pool.

This port was originally attempted by Alexander Neville "dark" (in CC,
discussion in Link), but the conversation there stalled since the
handling of -EAGAIN errors were no removed and longer handled by the
driver. This patch attempts to use the existing method of error
handling but utilises the new hwrng core.

The issue can be noticed when booting a UML guest:

    [    2.560000] random: fast init done
    [  214.000000] random: crng init done

With the patch applied, filling the pool becomes a lot quicker:

    [    2.560000] random: fast init done
    [   12.000000] random: crng init done

Cc: Alexander Neville <dark@volatile.bz>
Link: https://lore.kernel.org/lkml/20190828204609.02a7ff70@TheDarkness/
Link: https://lore.kernel.org/lkml/20190829135001.6a5ff940@TheDarkness.local/
Cc: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Signed-off-by: Christopher Obbard <chris.obbard@collabora.com>
Acked-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/random.c       | 101 ++++++++-------------------------
 drivers/char/hw_random/Kconfig |  16 +++---
 2 files changed, 33 insertions(+), 84 deletions(-)

diff --git a/arch/um/drivers/random.c b/arch/um/drivers/random.c
index ce115fce52f02..e4b9b2ce9abf4 100644
--- a/arch/um/drivers/random.c
+++ b/arch/um/drivers/random.c
@@ -11,6 +11,7 @@
 #include <linux/fs.h>
 #include <linux/interrupt.h>
 #include <linux/miscdevice.h>
+#include <linux/hw_random.h>
 #include <linux/delay.h>
 #include <linux/uaccess.h>
 #include <init.h>
@@ -18,9 +19,8 @@
 #include <os.h>
 
 /*
- * core module and version information
+ * core module information
  */
-#define RNG_VERSION "1.0.0"
 #define RNG_MODULE_NAME "hw_random"
 
 /* Changed at init time, in the non-modular case, and at module load
@@ -28,88 +28,36 @@
  * protects against a module being loaded twice at the same time.
  */
 static int random_fd = -1;
-static DECLARE_WAIT_QUEUE_HEAD(host_read_wait);
+static struct hwrng hwrng = { 0, };
+static DECLARE_COMPLETION(have_data);
 
-static int rng_dev_open (struct inode *inode, struct file *filp)
+static int rng_dev_read(struct hwrng *rng, void *buf, size_t max, bool block)
 {
-	/* enforce read-only access to this chrdev */
-	if ((filp->f_mode & FMODE_READ) == 0)
-		return -EINVAL;
-	if ((filp->f_mode & FMODE_WRITE) != 0)
-		return -EINVAL;
+	int ret;
 
-	return 0;
-}
-
-static atomic_t host_sleep_count = ATOMIC_INIT(0);
-
-static ssize_t rng_dev_read (struct file *filp, char __user *buf, size_t size,
-			     loff_t *offp)
-{
-	u32 data;
-	int n, ret = 0, have_data;
-
-	while (size) {
-		n = os_read_file(random_fd, &data, sizeof(data));
-		if (n > 0) {
-			have_data = n;
-			while (have_data && size) {
-				if (put_user((u8) data, buf++)) {
-					ret = ret ? : -EFAULT;
-					break;
-				}
-				size--;
-				ret++;
-				have_data--;
-				data >>= 8;
-			}
-		}
-		else if (n == -EAGAIN) {
-			DECLARE_WAITQUEUE(wait, current);
-
-			if (filp->f_flags & O_NONBLOCK)
-				return ret ? : -EAGAIN;
-
-			atomic_inc(&host_sleep_count);
+	for (;;) {
+		ret = os_read_file(random_fd, buf, max);
+		if (block && ret == -EAGAIN) {
 			add_sigio_fd(random_fd);
 
-			add_wait_queue(&host_read_wait, &wait);
-			set_current_state(TASK_INTERRUPTIBLE);
+			ret = wait_for_completion_killable(&have_data);
 
-			schedule();
-			remove_wait_queue(&host_read_wait, &wait);
+			ignore_sigio_fd(random_fd);
+			deactivate_fd(random_fd, RANDOM_IRQ);
 
-			if (atomic_dec_and_test(&host_sleep_count)) {
-				ignore_sigio_fd(random_fd);
-				deactivate_fd(random_fd, RANDOM_IRQ);
-			}
+			if (ret < 0)
+				break;
+		} else {
+			break;
 		}
-		else
-			return n;
-
-		if (signal_pending (current))
-			return ret ? : -ERESTARTSYS;
 	}
-	return ret;
-}
 
-static const struct file_operations rng_chrdev_ops = {
-	.owner		= THIS_MODULE,
-	.open		= rng_dev_open,
-	.read		= rng_dev_read,
-	.llseek		= noop_llseek,
-};
-
-/* rng_init shouldn't be called more than once at boot time */
-static struct miscdevice rng_miscdev = {
-	HWRNG_MINOR,
-	RNG_MODULE_NAME,
-	&rng_chrdev_ops,
-};
+	return ret != -EAGAIN ? ret : 0;
+}
 
 static irqreturn_t random_interrupt(int irq, void *data)
 {
-	wake_up(&host_read_wait);
+	complete(&have_data);
 
 	return IRQ_HANDLED;
 }
@@ -126,18 +74,19 @@ static int __init rng_init (void)
 		goto out;
 
 	random_fd = err;
-
 	err = um_request_irq(RANDOM_IRQ, random_fd, IRQ_READ, random_interrupt,
 			     0, "random", NULL);
 	if (err)
 		goto err_out_cleanup_hw;
 
 	sigio_broken(random_fd, 1);
+	hwrng.name = RNG_MODULE_NAME;
+	hwrng.read = rng_dev_read;
+	hwrng.quality = 1024;
 
-	err = misc_register (&rng_miscdev);
+	err = hwrng_register(&hwrng);
 	if (err) {
-		printk (KERN_ERR RNG_MODULE_NAME ": misc device register "
-			"failed\n");
+		pr_err(RNG_MODULE_NAME " registering failed (%d)\n", err);
 		goto err_out_cleanup_hw;
 	}
 out:
@@ -161,8 +110,8 @@ static void cleanup(void)
 
 static void __exit rng_cleanup(void)
 {
+	hwrng_unregister(&hwrng);
 	os_close_file(random_fd);
-	misc_deregister (&rng_miscdev);
 }
 
 module_init (rng_init);
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index e92c4d9469d82..5952210526aaa 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -540,15 +540,15 @@ endif # HW_RANDOM
 
 config UML_RANDOM
 	depends on UML
-	tristate "Hardware random number generator"
+	select HW_RANDOM
+	tristate "UML Random Number Generator support"
 	help
 	  This option enables UML's "hardware" random number generator.  It
 	  attaches itself to the host's /dev/random, supplying as much entropy
 	  as the host has, rather than the small amount the UML gets from its
-	  own drivers.  It registers itself as a standard hardware random number
-	  generator, major 10, minor 183, and the canonical device name is
-	  /dev/hwrng.
-	  The way to make use of this is to install the rng-tools package
-	  (check your distro, or download from
-	  http://sourceforge.net/projects/gkernel/).  rngd periodically reads
-	  /dev/hwrng and injects the entropy into /dev/random.
+	  own drivers. It registers itself as a rng-core driver thus providing
+	  a device which is usually called /dev/hwrng. This hardware random
+	  number generator does feed into the kernel's random number generator
+	  entropy pool.
+
+	  If unsure, say Y.
-- 
2.27.0



