Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5C32E794F
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbgL3NEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:04:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:53866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbgL3NEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:04:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AAA122472;
        Wed, 30 Dec 2020 13:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333419;
        bh=eKCoLzrwcvJfZEJPxdbw6hs0kwNlAfV2WmIbhNMSVDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UaCchE9rUcvB7WQPSKPvKH1wGAjvP2fm9RMqSxNE5+OMldEcSON37AxIQXDPgrJWi
         Gfg22PZwCfpCsBO1eYx5P83OodxfRmcYhx7lnJVcFwiReZTlo9QPAmdVZ+5VTvwpd2
         zLEm23j7FOX6Kb59S0FNTsK1TjNBn++g+DwICBNgLXglIs1K3+RHxaa8PBbG/m4osz
         EEBkkEiucCwa0jZNn1KIk7yq7kFRKT0bwg8w1HMrjq6zLKSKtSxG50W9bGsPLHjNG+
         rEyTWQhtyJKx+Rrsm3mg8nwJQ8Ad8bSlDkNu1TVFbR+i2UTjqhQzIfCFPIyOZC5N9J
         nC4yzxsJxdTsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christopher Obbard <chris.obbard@collabora.com>,
        Alexander Neville <dark@volatile.bz>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-um@lists.infradead.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 18/31] um: random: Register random as hwrng-core device
Date:   Wed, 30 Dec 2020 08:03:00 -0500
Message-Id: <20201230130314.3636961-18-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130314.3636961-1-sashal@kernel.org>
References: <20201230130314.3636961-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

