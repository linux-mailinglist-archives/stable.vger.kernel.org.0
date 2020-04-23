Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010E61B6799
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgDWXIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:08:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51042 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728678AbgDWXHB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:07:01 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvl-0004zd-K6; Fri, 24 Apr 2020 00:06:53 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvi-00E732-Rj; Fri, 24 Apr 2020 00:06:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        "Hans Verkuil" <hans.verkuil@cisco.com>,
        "Logan Gunthorpe" <logang@deltatee.com>
Date:   Fri, 24 Apr 2020 00:07:40 +0100
Message-ID: <lsq.1587683028.878431546@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 233/245] chardev: add helper function to register
 char devs with a struct device
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

From: Logan Gunthorpe <logang@deltatee.com>

commit 233ed09d7fdacf592ee91e6c97ce5f4364fbe7c0 upstream.

Credit for this patch goes is shared with Dan Williams [1]. I've
taken things one step further to make the helper function more
useful and clean up calling code.

There's a common pattern in the kernel whereby a struct cdev is placed
in a structure along side a struct device which manages the life-cycle
of both. In the naive approach, the reference counting is broken and
the struct device can free everything before the chardev code
is entirely released.

Many developers have solved this problem by linking the internal kobjs
in this fashion:

cdev.kobj.parent = &parent_dev.kobj;

The cdev code explicitly gets and puts a reference to it's kobj parent.
So this seems like it was intended to be used this way. Dmitrty Torokhov
first put this in place in 2012 with this commit:

2f0157f char_dev: pin parent kobject

and the first instance of the fix was then done in the input subsystem
in the following commit:

4a215aa Input: fix use-after-free introduced with dynamic minor changes

Subsequently over the years, however, this issue seems to have tripped
up multiple developers independently. For example, see these commits:

0d5b7da iio: Prevent race between IIO chardev opening and IIO device
(by Lars-Peter Clausen in 2013)

ba0ef85 tpm: Fix initialization of the cdev
(by Jason Gunthorpe in 2015)

5b28dde [media] media: fix use-after-free in cdev_put() when app exits
after driver unbind
(by Shauh Khan in 2016)

This technique is similarly done in at least 15 places within the kernel
and probably should have been done so in another, at least, 5 places.
The kobj line also looks very suspect in that one would not expect
drivers to have to mess with kobject internals in this way.
Even highly experienced kernel developers can be surprised by this
code, as seen in [2].

To help alleviate this situation, and hopefully prevent future
wasted effort on this problem, this patch introduces a helper function
to register a char device along with its parent struct device.
This creates a more regular API for tying a char device to its parent
without the developer having to set members in the underlying kobject.

This patch introduce cdev_device_add and cdev_device_del which
replaces a common pattern including setting the kobj parent, calling
cdev_add and then calling device_add. It also introduces cdev_set_parent
for the few cases that set the kobject parent without using device_add.

[1] https://lkml.org/lkml/2017/2/13/700
[2] https://lkml.org/lkml/2017/2/10/370

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/char_dev.c        | 86 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cdev.h |  5 +++
 2 files changed, 91 insertions(+)

--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -488,6 +488,85 @@ int cdev_add(struct cdev *p, dev_t dev,
 	return 0;
 }
 
+/**
+ * cdev_set_parent() - set the parent kobject for a char device
+ * @p: the cdev structure
+ * @kobj: the kobject to take a reference to
+ *
+ * cdev_set_parent() sets a parent kobject which will be referenced
+ * appropriately so the parent is not freed before the cdev. This
+ * should be called before cdev_add.
+ */
+void cdev_set_parent(struct cdev *p, struct kobject *kobj)
+{
+	WARN_ON(!kobj->state_initialized);
+	p->kobj.parent = kobj;
+}
+
+/**
+ * cdev_device_add() - add a char device and it's corresponding
+ *	struct device, linkink
+ * @dev: the device structure
+ * @cdev: the cdev structure
+ *
+ * cdev_device_add() adds the char device represented by @cdev to the system,
+ * just as cdev_add does. It then adds @dev to the system using device_add
+ * The dev_t for the char device will be taken from the struct device which
+ * needs to be initialized first. This helper function correctly takes a
+ * reference to the parent device so the parent will not get released until
+ * all references to the cdev are released.
+ *
+ * This helper uses dev->devt for the device number. If it is not set
+ * it will not add the cdev and it will be equivalent to device_add.
+ *
+ * This function should be used whenever the struct cdev and the
+ * struct device are members of the same structure whose lifetime is
+ * managed by the struct device.
+ *
+ * NOTE: Callers must assume that userspace was able to open the cdev and
+ * can call cdev fops callbacks at any time, even if this function fails.
+ */
+int cdev_device_add(struct cdev *cdev, struct device *dev)
+{
+	int rc = 0;
+
+	if (dev->devt) {
+		cdev_set_parent(cdev, &dev->kobj);
+
+		rc = cdev_add(cdev, dev->devt, 1);
+		if (rc)
+			return rc;
+	}
+
+	rc = device_add(dev);
+	if (rc)
+		cdev_del(cdev);
+
+	return rc;
+}
+
+/**
+ * cdev_device_del() - inverse of cdev_device_add
+ * @dev: the device structure
+ * @cdev: the cdev structure
+ *
+ * cdev_device_del() is a helper function to call cdev_del and device_del.
+ * It should be used whenever cdev_device_add is used.
+ *
+ * If dev->devt is not set it will not remove the cdev and will be equivalent
+ * to device_del.
+ *
+ * NOTE: This guarantees that associated sysfs callbacks are not running
+ * or runnable, however any cdevs already open will remain and their fops
+ * will still be callable even after this function returns.
+ */
+void cdev_device_del(struct cdev *cdev, struct device *dev)
+{
+	device_del(dev);
+	if (dev->devt)
+		cdev_del(cdev);
+}
+
 static void cdev_unmap(dev_t dev, unsigned count)
 {
 	kobj_unmap(cdev_map, dev, count);
@@ -499,6 +578,10 @@ static void cdev_unmap(dev_t dev, unsign
  *
  * cdev_del() removes @p from the system, possibly freeing the structure
  * itself.
+ *
+ * NOTE: This guarantees that cdev device will no longer be able to be
+ * opened, however any cdevs already open will remain and their fops will
+ * still be callable even after cdev_del returns.
  */
 void cdev_del(struct cdev *p)
 {
@@ -589,6 +672,9 @@ EXPORT_SYMBOL(cdev_init);
 EXPORT_SYMBOL(cdev_alloc);
 EXPORT_SYMBOL(cdev_del);
 EXPORT_SYMBOL(cdev_add);
+EXPORT_SYMBOL(cdev_set_parent);
+EXPORT_SYMBOL(cdev_device_add);
+EXPORT_SYMBOL(cdev_device_del);
 EXPORT_SYMBOL(__register_chrdev);
 EXPORT_SYMBOL(__unregister_chrdev);
 EXPORT_SYMBOL(directly_mappable_cdev_bdi);
--- a/include/linux/cdev.h
+++ b/include/linux/cdev.h
@@ -4,6 +4,7 @@
 #include <linux/kobject.h>
 #include <linux/kdev_t.h>
 #include <linux/list.h>
+#include <linux/device.h>
 
 struct file_operations;
 struct inode;
@@ -26,6 +27,10 @@ void cdev_put(struct cdev *p);
 
 int cdev_add(struct cdev *, dev_t, unsigned);
 
+void cdev_set_parent(struct cdev *p, struct kobject *kobj);
+int cdev_device_add(struct cdev *cdev, struct device *dev);
+void cdev_device_del(struct cdev *cdev, struct device *dev);
+
 void cdev_del(struct cdev *);
 
 void cd_forget(struct inode *);

