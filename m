Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F331B67A1
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbgDWXIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:08:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50944 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728664AbgDWXG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvm-0004zi-0s; Fri, 24 Apr 2020 00:06:54 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvj-00E73C-Ag; Fri, 24 Apr 2020 00:06:51 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Richard Cochran" <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Vladis Dronov" <vdronov@redhat.com>
Date:   Fri, 24 Apr 2020 00:07:42 +0100
Message-ID: <lsq.1587683028.705572275@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 235/245] ptp: fix the race between the release of
 ptp_clock and cdev
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vladis Dronov <vdronov@redhat.com>

commit a33121e5487b424339636b25c35d3a180eaa5f5e upstream.

In a case when a ptp chardev (like /dev/ptp0) is open but an underlying
device is removed, closing this file leads to a race. This reproduces
easily in a kvm virtual machine:

ts# cat openptp0.c
int main() { ... fp = fopen("/dev/ptp0", "r"); ... sleep(10); }
ts# uname -r
5.5.0-rc3-46cf053e
ts# cat /proc/cmdline
... slub_debug=FZP
ts# modprobe ptp_kvm
ts# ./openptp0 &
[1] 670
opened /dev/ptp0, sleeping 10s...
ts# rmmod ptp_kvm
ts# ls /dev/ptp*
ls: cannot access '/dev/ptp*': No such file or directory
ts# ...woken up
[   48.010809] general protection fault: 0000 [#1] SMP
[   48.012502] CPU: 6 PID: 658 Comm: openptp0 Not tainted 5.5.0-rc3-46cf053e #25
[   48.014624] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), ...
[   48.016270] RIP: 0010:module_put.part.0+0x7/0x80
[   48.017939] RSP: 0018:ffffb3850073be00 EFLAGS: 00010202
[   48.018339] RAX: 000000006b6b6b6b RBX: 6b6b6b6b6b6b6b6b RCX: ffff89a476c00ad0
[   48.018936] RDX: fffff65a08d3ea08 RSI: 0000000000000247 RDI: 6b6b6b6b6b6b6b6b
[   48.019470] ...                                              ^^^ a slub poison
[   48.023854] Call Trace:
[   48.024050]  __fput+0x21f/0x240
[   48.024288]  task_work_run+0x79/0x90
[   48.024555]  do_exit+0x2af/0xab0
[   48.024799]  ? vfs_write+0x16a/0x190
[   48.025082]  do_group_exit+0x35/0x90
[   48.025387]  __x64_sys_exit_group+0xf/0x10
[   48.025737]  do_syscall_64+0x3d/0x130
[   48.026056]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   48.026479] RIP: 0033:0x7f53b12082f6
[   48.026792] ...
[   48.030945] Modules linked in: ptp i6300esb watchdog [last unloaded: ptp_kvm]
[   48.045001] Fixing recursive fault but reboot is needed!

This happens in:

static void __fput(struct file *file)
{   ...
    if (file->f_op->release)
        file->f_op->release(inode, file); <<< cdev is kfree'd here
    if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL &&
             !(mode & FMODE_PATH))) {
        cdev_put(inode->i_cdev); <<< cdev fields are accessed here

Namely:

__fput()
  posix_clock_release()
    kref_put(&clk->kref, delete_clock) <<< the last reference
      delete_clock()
        delete_ptp_clock()
          kfree(ptp) <<< cdev is embedded in ptp
  cdev_put
    module_put(p->owner) <<< *p is kfree'd, bang!

Here cdev is embedded in posix_clock which is embedded in ptp_clock.
The race happens because ptp_clock's lifetime is controlled by two
refcounts: kref and cdev.kobj in posix_clock. This is wrong.

Make ptp_clock's sysfs device a parent of cdev with cdev_device_add()
created especially for such cases. This way the parent device with its
ptp_clock is not released until all references to the cdev are released.
This adds a requirement that an initialized but not exposed struct
device should be provided to posix_clock_register() by a caller instead
of a simple dev_t.

This approach was adopted from the commit 72139dfa2464 ("watchdog: Fix
the race between the release of watchdog_core_data and cdev"). See
details of the implementation in the commit 233ed09d7fda ("chardev: add
helper function to register char devs with a struct device").

Link: https://lore.kernel.org/linux-fsdevel/20191125125342.6189-1-vdronov@redhat.com/T/#u
Analyzed-by: Stephen Johnston <sjohnsto@redhat.com>
Analyzed-by: Vern Lovejoy <vlovejoy@redhat.com>
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ptp/ptp_clock.c     | 31 ++++++++++++++-----------------
 drivers/ptp/ptp_private.h   |  2 +-
 include/linux/posix-clock.h | 19 +++++++++++--------
 kernel/time/posix-clock.c   | 31 +++++++++++++------------------
 4 files changed, 39 insertions(+), 44 deletions(-)

--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -167,9 +167,9 @@ static struct posix_clock_operations ptp
 	.read		= ptp_read,
 };
 
-static void delete_ptp_clock(struct posix_clock *pc)
+static void ptp_clock_release(struct device *dev)
 {
-	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
+	struct ptp_clock *ptp = container_of(dev, struct ptp_clock, dev);
 
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
@@ -201,7 +201,6 @@ struct ptp_clock *ptp_clock_register(str
 	}
 
 	ptp->clock.ops = ptp_clock_ops;
-	ptp->clock.release = delete_ptp_clock;
 	ptp->info = info;
 	ptp->devid = MKDEV(major, index);
 	ptp->index = index;
@@ -214,15 +213,6 @@ struct ptp_clock *ptp_clock_register(str
 	if (err)
 		goto no_pin_groups;
 
-	/* Create a new device in our class. */
-	ptp->dev = device_create_with_groups(ptp_class, parent, ptp->devid,
-					     ptp, ptp->pin_attr_groups,
-					     "ptp%d", ptp->index);
-	if (IS_ERR(ptp->dev)) {
-		err = PTR_ERR(ptp->dev);
-		goto no_device;
-	}
-
 	/* Register a new PPS source. */
 	if (info->pps) {
 		struct pps_source_info pps;
@@ -238,8 +228,18 @@ struct ptp_clock *ptp_clock_register(str
 		}
 	}
 
-	/* Create a posix clock. */
-	err = posix_clock_register(&ptp->clock, ptp->devid);
+	/* Initialize a new device of our class in our clock structure. */
+	device_initialize(&ptp->dev);
+	ptp->dev.devt = ptp->devid;
+	ptp->dev.class = ptp_class;
+	ptp->dev.parent = parent;
+	ptp->dev.groups = ptp->pin_attr_groups;
+	ptp->dev.release = ptp_clock_release;
+	dev_set_drvdata(&ptp->dev, ptp);
+	dev_set_name(&ptp->dev, "ptp%d", ptp->index);
+
+	/* Create a posix clock and link it to the device. */
+	err = posix_clock_register(&ptp->clock, &ptp->dev);
 	if (err) {
 		pr_err("failed to create posix clock\n");
 		goto no_clock;
@@ -251,8 +251,6 @@ no_clock:
 	if (ptp->pps_source)
 		pps_unregister_source(ptp->pps_source);
 no_pps:
-	device_destroy(ptp_class, ptp->devid);
-no_device:
 	ptp_cleanup_pin_groups(ptp);
 no_pin_groups:
 	mutex_destroy(&ptp->tsevq_mux);
@@ -273,7 +271,6 @@ int ptp_clock_unregister(struct ptp_cloc
 	if (ptp->pps_source)
 		pps_unregister_source(ptp->pps_source);
 
-	device_destroy(ptp_class, ptp->devid);
 	ptp_cleanup_pin_groups(ptp);
 
 	posix_clock_unregister(&ptp->clock);
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -40,7 +40,7 @@ struct timestamp_event_queue {
 
 struct ptp_clock {
 	struct posix_clock clock;
-	struct device *dev;
+	struct device dev;
 	struct ptp_clock_info *info;
 	dev_t devid;
 	int index; /* index into clocks.map */
--- a/include/linux/posix-clock.h
+++ b/include/linux/posix-clock.h
@@ -104,29 +104,32 @@ struct posix_clock_operations {
  *
  * @ops:     Functional interface to the clock
  * @cdev:    Character device instance for this clock
- * @kref:    Reference count.
+ * @dev:     Pointer to the clock's device.
  * @rwsem:   Protects the 'zombie' field from concurrent access.
  * @zombie:  If 'zombie' is true, then the hardware has disappeared.
- * @release: A function to free the structure when the reference count reaches
- *           zero. May be NULL if structure is statically allocated.
  *
  * Drivers should embed their struct posix_clock within a private
  * structure, obtaining a reference to it during callbacks using
  * container_of().
+ *
+ * Drivers should supply an initialized but not exposed struct device
+ * to posix_clock_register(). It is used to manage lifetime of the
+ * driver's private structure. It's 'release' field should be set to
+ * a release function for this private structure.
  */
 struct posix_clock {
 	struct posix_clock_operations ops;
 	struct cdev cdev;
-	struct kref kref;
+	struct device *dev;
 	struct rw_semaphore rwsem;
 	bool zombie;
-	void (*release)(struct posix_clock *clk);
 };
 
 /**
  * posix_clock_register() - register a new clock
- * @clk:   Pointer to the clock. Caller must provide 'ops' and 'release'
- * @devid: Allocated device id
+ * @clk:   Pointer to the clock. Caller must provide 'ops' field
+ * @dev:   Pointer to the initialized device. Caller must provide
+ *         'release' field
  *
  * A clock driver calls this function to register itself with the
  * clock device subsystem. If 'clk' points to dynamically allocated
@@ -135,7 +138,7 @@ struct posix_clock {
  *
  * Returns zero on success, non-zero otherwise.
  */
-int posix_clock_register(struct posix_clock *clk, dev_t devid);
+int posix_clock_register(struct posix_clock *clk, struct device *dev);
 
 /**
  * posix_clock_unregister() - unregister a clock
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -25,8 +25,6 @@
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
 
-static void delete_clock(struct kref *kref);
-
 /*
  * Returns NULL if the posix_clock instance attached to 'fp' is old and stale.
  */
@@ -168,7 +166,7 @@ static int posix_clock_open(struct inode
 		err = 0;
 
 	if (!err) {
-		kref_get(&clk->kref);
+		get_device(clk->dev);
 		fp->private_data = clk;
 	}
 out:
@@ -184,7 +182,7 @@ static int posix_clock_release(struct in
 	if (clk->ops.release)
 		err = clk->ops.release(clk);
 
-	kref_put(&clk->kref, delete_clock);
+	put_device(clk->dev);
 
 	fp->private_data = NULL;
 
@@ -206,38 +204,35 @@ static const struct file_operations posi
 #endif
 };
 
-int posix_clock_register(struct posix_clock *clk, dev_t devid)
+int posix_clock_register(struct posix_clock *clk, struct device *dev)
 {
 	int err;
 
-	kref_init(&clk->kref);
 	init_rwsem(&clk->rwsem);
 
 	cdev_init(&clk->cdev, &posix_clock_file_operations);
+	err = cdev_device_add(&clk->cdev, dev);
+	if (err) {
+		pr_err("%s unable to add device %d:%d\n",
+			dev_name(dev), MAJOR(dev->devt), MINOR(dev->devt));
+		return err;
+	}
 	clk->cdev.owner = clk->ops.owner;
-	err = cdev_add(&clk->cdev, devid, 1);
+	clk->dev = dev;
 
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(posix_clock_register);
 
-static void delete_clock(struct kref *kref)
-{
-	struct posix_clock *clk = container_of(kref, struct posix_clock, kref);
-
-	if (clk->release)
-		clk->release(clk);
-}
-
 void posix_clock_unregister(struct posix_clock *clk)
 {
-	cdev_del(&clk->cdev);
+	cdev_device_del(&clk->cdev, clk->dev);
 
 	down_write(&clk->rwsem);
 	clk->zombie = true;
 	up_write(&clk->rwsem);
 
-	kref_put(&clk->kref, delete_clock);
+	put_device(clk->dev);
 }
 EXPORT_SYMBOL_GPL(posix_clock_unregister);
 

