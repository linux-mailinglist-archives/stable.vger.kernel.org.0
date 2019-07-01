Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9C243FF7
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387680AbfFMQBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731411AbfFMIsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:48:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B98D2147A;
        Thu, 13 Jun 2019 08:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415683;
        bh=N8ACM1DFYnNts9wdOatsvGPHvKobHRaV8DL0G4MQcZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBSM7H1NhwJ8rIi2IKItomh9Q8IkYySbeHLlJ5lKBRS7XkDBfrGAQHSD8Ok1dqHP1
         gnk/UxFCr+Ek9fE49isKmpV9vc1opUwXyTog9gyGl0DVi5J5Rzk4lXdv/tODqSwq3J
         9S644F10QfzqzTP5G8zbcxOTpJosrMfkcYdLc4/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Farhan Ali <alifm@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 088/155] vfio: Fix WARNING "do not call blocking ops when !TASK_RUNNING"
Date:   Thu, 13 Jun 2019 10:33:20 +0200
Message-Id: <20190613075658.024902313@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 41be3e2618174fdf3361e49e64f2bf530f40c6b0 ]

vfio_dev_present() which is the condition to
wait_event_interruptible_timeout(), will call vfio_group_get_device
and try to acquire the mutex group->device_lock.

wait_event_interruptible_timeout() will set the state of the current
task to TASK_INTERRUPTIBLE, before doing the condition check. This
means that we will try to acquire the mutex while already in a
sleeping state. The scheduler warns us by giving the following
warning:

[ 4050.264464] ------------[ cut here ]------------
[ 4050.264508] do not call blocking ops when !TASK_RUNNING; state=1 set at [<00000000b33c00e2>] prepare_to_wait_event+0x14a/0x188
[ 4050.264529] WARNING: CPU: 12 PID: 35924 at kernel/sched/core.c:6112 __might_sleep+0x76/0x90
....

 4050.264756] Call Trace:
[ 4050.264765] ([<000000000017bbaa>] __might_sleep+0x72/0x90)
[ 4050.264774]  [<0000000000b97edc>] __mutex_lock+0x44/0x8c0
[ 4050.264782]  [<0000000000b9878a>] mutex_lock_nested+0x32/0x40
[ 4050.264793]  [<000003ff800d7abe>] vfio_group_get_device+0x36/0xa8 [vfio]
[ 4050.264803]  [<000003ff800d87c0>] vfio_del_group_dev+0x238/0x378 [vfio]
[ 4050.264813]  [<000003ff8015f67c>] mdev_remove+0x3c/0x68 [mdev]
[ 4050.264825]  [<00000000008e01b0>] device_release_driver_internal+0x168/0x268
[ 4050.264834]  [<00000000008de692>] bus_remove_device+0x162/0x190
[ 4050.264843]  [<00000000008daf42>] device_del+0x1e2/0x368
[ 4050.264851]  [<00000000008db12c>] device_unregister+0x64/0x88
[ 4050.264862]  [<000003ff8015ed84>] mdev_device_remove+0xec/0x130 [mdev]
[ 4050.264872]  [<000003ff8015f074>] remove_store+0x6c/0xa8 [mdev]
[ 4050.264881]  [<000000000046f494>] kernfs_fop_write+0x14c/0x1f8
[ 4050.264890]  [<00000000003c1530>] __vfs_write+0x38/0x1a8
[ 4050.264899]  [<00000000003c187c>] vfs_write+0xb4/0x198
[ 4050.264908]  [<00000000003c1af2>] ksys_write+0x5a/0xb0
[ 4050.264916]  [<0000000000b9e270>] system_call+0xdc/0x2d8
[ 4050.264925] 4 locks held by sh/35924:
[ 4050.264933]  #0: 000000001ef90325 (sb_writers#4){.+.+}, at: vfs_write+0x9e/0x198
[ 4050.264948]  #1: 000000005c1ab0b3 (&of->mutex){+.+.}, at: kernfs_fop_write+0x1cc/0x1f8
[ 4050.264963]  #2: 0000000034831ab8 (kn->count#297){++++}, at: kernfs_remove_self+0x12e/0x150
[ 4050.264979]  #3: 00000000e152484f (&dev->mutex){....}, at: device_release_driver_internal+0x5c/0x268
[ 4050.264993] Last Breaking-Event-Address:
[ 4050.265002]  [<000000000017bbaa>] __might_sleep+0x72/0x90
[ 4050.265010] irq event stamp: 7039
[ 4050.265020] hardirqs last  enabled at (7047): [<00000000001cee7a>] console_unlock+0x6d2/0x740
[ 4050.265029] hardirqs last disabled at (7054): [<00000000001ce87e>] console_unlock+0xd6/0x740
[ 4050.265040] softirqs last  enabled at (6416): [<0000000000b8fe26>] __udelay+0xb6/0x100
[ 4050.265049] softirqs last disabled at (6415): [<0000000000b8fe06>] __udelay+0x96/0x100
[ 4050.265057] ---[ end trace d04a07d39d99a9f9 ]---

Let's fix this as described in the article
https://lwn.net/Articles/628628/.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
[remove now redundant vfio_dev_present()]
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index a3030cdf3c18..aa0e14d25ac3 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -34,6 +34,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/wait.h>
+#include <linux/sched/signal.h>
 
 #define DRIVER_VERSION	"0.3"
 #define DRIVER_AUTHOR	"Alex Williamson <alex.williamson@redhat.com>"
@@ -904,30 +905,17 @@ void *vfio_device_data(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_device_data);
 
-/* Given a referenced group, check if it contains the device */
-static bool vfio_dev_present(struct vfio_group *group, struct device *dev)
-{
-	struct vfio_device *device;
-
-	device = vfio_group_get_device(group, dev);
-	if (!device)
-		return false;
-
-	vfio_device_put(device);
-	return true;
-}
-
 /*
  * Decrement the device reference count and wait for the device to be
  * removed.  Open file descriptors for the device... */
 void *vfio_del_group_dev(struct device *dev)
 {
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct vfio_device *device = dev_get_drvdata(dev);
 	struct vfio_group *group = device->group;
 	void *device_data = device->device_data;
 	struct vfio_unbound_dev *unbound;
 	unsigned int i = 0;
-	long ret;
 	bool interrupted = false;
 
 	/*
@@ -964,6 +952,8 @@ void *vfio_del_group_dev(struct device *dev)
 	 * interval with counter to allow the driver to take escalating
 	 * measures to release the device if it has the ability to do so.
 	 */
+	add_wait_queue(&vfio.release_q, &wait);
+
 	do {
 		device = vfio_group_get_device(group, dev);
 		if (!device)
@@ -975,12 +965,10 @@ void *vfio_del_group_dev(struct device *dev)
 		vfio_device_put(device);
 
 		if (interrupted) {
-			ret = wait_event_timeout(vfio.release_q,
-					!vfio_dev_present(group, dev), HZ * 10);
+			wait_woken(&wait, TASK_UNINTERRUPTIBLE, HZ * 10);
 		} else {
-			ret = wait_event_interruptible_timeout(vfio.release_q,
-					!vfio_dev_present(group, dev), HZ * 10);
-			if (ret == -ERESTARTSYS) {
+			wait_woken(&wait, TASK_INTERRUPTIBLE, HZ * 10);
+			if (signal_pending(current)) {
 				interrupted = true;
 				dev_warn(dev,
 					 "Device is currently in use, task"
@@ -989,8 +977,10 @@ void *vfio_del_group_dev(struct device *dev)
 					 current->comm, task_pid_nr(current));
 			}
 		}
-	} while (ret <= 0);
 
+	} while (1);
+
+	remove_wait_queue(&vfio.release_q, &wait);
 	/*
 	 * In order to support multiple devices per group, devices can be
 	 * plucked from the group while other devices in the group are still
-- 
2.20.1



