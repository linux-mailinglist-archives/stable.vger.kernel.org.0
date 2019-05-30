Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDB172EBFC
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731066AbfE3DRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731046AbfE3DRQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:16 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8EEA24694;
        Thu, 30 May 2019 03:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186234;
        bh=rjiZQtVEGxLF545EP9VMYjvfOugaFs3S0oQvGjB+e2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dt2fdtAUFMVFfV9+BGgfvj8BnrsZi0AsI1AtGNaj5FSb5PaHqunKKyAQAKHKeRG4r
         j4wSJkrOXqthBZemXkonSounpQZcbfTOwTH290jGZuxFiL4fuMuzkwFD5/wIkTAlWd
         bdUqIliPOFadIF0meOEN5zL8mSFhfLz0XT6ho0UI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 142/276] thunderbolt: Take domain lock in switch sysfs attribute callbacks
Date:   Wed, 29 May 2019 20:05:00 -0700
Message-Id: <20190530030534.550265406@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 09f11b6c99feaf86a26444bca85dc693b3f58f8b ]

switch_lock was introduced because it allowed serialization of device
authorization requests from userspace without need to take the big
domain lock (tb->lock). This was fine because device authorization with
ICM is just one command that is sent to the firmware. Now that we start
to handle all tunneling in the driver switch_lock is not enough because
we need to walk over the topology to establish paths.

For this reason drop switch_lock from the driver completely in favour of
big domain lock.

There is one complication, though. If userspace is waiting for the lock
in tb_switch_set_authorized(), it keeps the device_del() from removing
the sysfs attribute because it waits for active users to release the
attribute first which leads into following splat:

    INFO: task kworker/u8:3:73 blocked for more than 61 seconds.
          Tainted: G        W         5.1.0-rc1+ #244
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    kworker/u8:3    D12976    73      2 0x80000000
    Workqueue: thunderbolt0 tb_handle_hotplug [thunderbolt]
    Call Trace:
     ? __schedule+0x2e5/0x740
     ? _raw_spin_lock_irqsave+0x12/0x40
     ? prepare_to_wait_event+0xc5/0x160
     schedule+0x2d/0x80
     __kernfs_remove.part.17+0x183/0x1f0
     ? finish_wait+0x80/0x80
     kernfs_remove_by_name_ns+0x4a/0x90
     remove_files.isra.1+0x2b/0x60
     sysfs_remove_group+0x38/0x80
     sysfs_remove_groups+0x24/0x40
     device_remove_attrs+0x3d/0x70
     device_del+0x14c/0x360
     device_unregister+0x15/0x50
     tb_switch_remove+0x9e/0x1d0 [thunderbolt]
     tb_handle_hotplug+0x119/0x5a0 [thunderbolt]
     ? process_one_work+0x1b7/0x420
     process_one_work+0x1b7/0x420
     worker_thread+0x37/0x380
     ? _raw_spin_unlock_irqrestore+0xf/0x30
     ? process_one_work+0x420/0x420
     kthread+0x118/0x130
     ? kthread_create_on_node+0x60/0x60
     ret_from_fork+0x35/0x40

We deal this by following what network stack did for some of their
attributes and use mutex_trylock() with restart_syscall(). This makes
userspace release the attribute allowing sysfs attribute removal to
progress before the write is restarted and eventually fail when the
attribute is removed.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/switch.c | 45 +++++++++++++++---------------------
 drivers/thunderbolt/tb.h     |  3 +--
 2 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index dd9ae6f5d19ce..ed572c82a91be 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -9,15 +9,13 @@
 #include <linux/idr.h>
 #include <linux/nvmem-provider.h>
 #include <linux/pm_runtime.h>
+#include <linux/sched/signal.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
 #include "tb.h"
 
-/* Switch authorization from userspace is serialized by this lock */
-static DEFINE_MUTEX(switch_lock);
-
 /* Switch NVM support */
 
 #define NVM_DEVID		0x05
@@ -253,8 +251,8 @@ static int tb_switch_nvm_write(void *priv, unsigned int offset, void *val,
 	struct tb_switch *sw = priv;
 	int ret = 0;
 
-	if (mutex_lock_interruptible(&switch_lock))
-		return -ERESTARTSYS;
+	if (!mutex_trylock(&sw->tb->lock))
+		return restart_syscall();
 
 	/*
 	 * Since writing the NVM image might require some special steps,
@@ -274,7 +272,7 @@ static int tb_switch_nvm_write(void *priv, unsigned int offset, void *val,
 	memcpy(sw->nvm->buf + offset, val, bytes);
 
 unlock:
-	mutex_unlock(&switch_lock);
+	mutex_unlock(&sw->tb->lock);
 
 	return ret;
 }
@@ -363,10 +361,7 @@ static int tb_switch_nvm_add(struct tb_switch *sw)
 	}
 	nvm->non_active = nvm_dev;
 
-	mutex_lock(&switch_lock);
 	sw->nvm = nvm;
-	mutex_unlock(&switch_lock);
-
 	return 0;
 
 err_nvm_active:
@@ -383,10 +378,8 @@ static void tb_switch_nvm_remove(struct tb_switch *sw)
 {
 	struct tb_switch_nvm *nvm;
 
-	mutex_lock(&switch_lock);
 	nvm = sw->nvm;
 	sw->nvm = NULL;
-	mutex_unlock(&switch_lock);
 
 	if (!nvm)
 		return;
@@ -717,8 +710,8 @@ static int tb_switch_set_authorized(struct tb_switch *sw, unsigned int val)
 {
 	int ret = -EINVAL;
 
-	if (mutex_lock_interruptible(&switch_lock))
-		return -ERESTARTSYS;
+	if (!mutex_trylock(&sw->tb->lock))
+		return restart_syscall();
 
 	if (sw->authorized)
 		goto unlock;
@@ -761,7 +754,7 @@ static int tb_switch_set_authorized(struct tb_switch *sw, unsigned int val)
 	}
 
 unlock:
-	mutex_unlock(&switch_lock);
+	mutex_unlock(&sw->tb->lock);
 	return ret;
 }
 
@@ -818,15 +811,15 @@ static ssize_t key_show(struct device *dev, struct device_attribute *attr,
 	struct tb_switch *sw = tb_to_switch(dev);
 	ssize_t ret;
 
-	if (mutex_lock_interruptible(&switch_lock))
-		return -ERESTARTSYS;
+	if (!mutex_trylock(&sw->tb->lock))
+		return restart_syscall();
 
 	if (sw->key)
 		ret = sprintf(buf, "%*phN\n", TB_SWITCH_KEY_SIZE, sw->key);
 	else
 		ret = sprintf(buf, "\n");
 
-	mutex_unlock(&switch_lock);
+	mutex_unlock(&sw->tb->lock);
 	return ret;
 }
 
@@ -843,8 +836,8 @@ static ssize_t key_store(struct device *dev, struct device_attribute *attr,
 	else if (hex2bin(key, buf, sizeof(key)))
 		return -EINVAL;
 
-	if (mutex_lock_interruptible(&switch_lock))
-		return -ERESTARTSYS;
+	if (!mutex_trylock(&sw->tb->lock))
+		return restart_syscall();
 
 	if (sw->authorized) {
 		ret = -EBUSY;
@@ -859,7 +852,7 @@ static ssize_t key_store(struct device *dev, struct device_attribute *attr,
 		}
 	}
 
-	mutex_unlock(&switch_lock);
+	mutex_unlock(&sw->tb->lock);
 	return ret;
 }
 static DEVICE_ATTR(key, 0600, key_show, key_store);
@@ -905,8 +898,8 @@ static ssize_t nvm_authenticate_store(struct device *dev,
 	bool val;
 	int ret;
 
-	if (mutex_lock_interruptible(&switch_lock))
-		return -ERESTARTSYS;
+	if (!mutex_trylock(&sw->tb->lock))
+		return restart_syscall();
 
 	/* If NVMem devices are not yet added */
 	if (!sw->nvm) {
@@ -954,7 +947,7 @@ static ssize_t nvm_authenticate_store(struct device *dev,
 	}
 
 exit_unlock:
-	mutex_unlock(&switch_lock);
+	mutex_unlock(&sw->tb->lock);
 
 	if (ret)
 		return ret;
@@ -968,8 +961,8 @@ static ssize_t nvm_version_show(struct device *dev,
 	struct tb_switch *sw = tb_to_switch(dev);
 	int ret;
 
-	if (mutex_lock_interruptible(&switch_lock))
-		return -ERESTARTSYS;
+	if (!mutex_trylock(&sw->tb->lock))
+		return restart_syscall();
 
 	if (sw->safe_mode)
 		ret = -ENODATA;
@@ -978,7 +971,7 @@ static ssize_t nvm_version_show(struct device *dev,
 	else
 		ret = sprintf(buf, "%x.%x\n", sw->nvm->major, sw->nvm->minor);
 
-	mutex_unlock(&switch_lock);
+	mutex_unlock(&sw->tb->lock);
 
 	return ret;
 }
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index 5067d69d05018..7a0ee9836a8a7 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -79,8 +79,7 @@ struct tb_switch_nvm {
  * @depth: Depth in the chain this switch is connected (ICM only)
  *
  * When the switch is being added or removed to the domain (other
- * switches) you need to have domain lock held. For switch authorization
- * internal switch_lock is enough.
+ * switches) you need to have domain lock held.
  */
 struct tb_switch {
 	struct device dev;
-- 
2.20.1



