Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4481973F2A
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388022AbfGXUa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388547AbfGXTbz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:31:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D683120659;
        Wed, 24 Jul 2019 19:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996714;
        bh=WcCVYRDX/sahTDnivKvgqr6CRxaBSsQwoWpxlxtNiW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VeDeig3Jyxu1VdFVGmTAuyNiORowObcZnRYZLN1PFH1Z1B6i/MreptJHmKzYWEvlR
         mf1aW6XGSMfh4lcJjINTZFAHCgnJNDOu6u70u8VP90vl3zFe3YUjdY8ctYAb54Z9EA
         dZxUH8+sd+EQQR1/lInuYPxCG3DS2yBKfWZV+3u0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 191/413] bcache: avoid a deadlock in bcache_reboot()
Date:   Wed, 24 Jul 2019 21:18:02 +0200
Message-Id: <20190724191748.333553799@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a59ff6ccc2bf2e2934b31bbf734f0bc04b5ec78a ]

It is quite frequently to observe deadlock in bcache_reboot() happens
and hang the system reboot process. The reason is, in bcache_reboot()
when calling bch_cache_set_stop() and bcache_device_stop() the mutex
bch_register_lock is held. But in the process to stop cache set and
bcache device, bch_register_lock will be acquired again. If this mutex
is held here, deadlock will happen inside the stopping process. The
aftermath of the deadlock is, whole system reboot gets hung.

The fix is to avoid holding bch_register_lock for the following loops
in bcache_reboot(),
       list_for_each_entry_safe(c, tc, &bch_cache_sets, list)
                bch_cache_set_stop(c);

        list_for_each_entry_safe(dc, tdc, &uncached_devices, list)
                bcache_device_stop(&dc->disk);

A module range variable 'bcache_is_reboot' is added, it sets to true
in bcache_reboot(). In register_bcache(), if bcache_is_reboot is checked
to be true, reject the registration by returning -EBUSY immediately.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 40 ++++++++++++++++++++++++++++++++++++++-
 drivers/md/bcache/sysfs.c | 26 +++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 4cc8a300a557..dcd8b319a01e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -40,6 +40,7 @@ static const char invalid_uuid[] = {
 
 static struct kobject *bcache_kobj;
 struct mutex bch_register_lock;
+bool bcache_is_reboot;
 LIST_HEAD(bch_cache_sets);
 static LIST_HEAD(uncached_devices);
 
@@ -49,6 +50,7 @@ static wait_queue_head_t unregister_wait;
 struct workqueue_struct *bcache_wq;
 struct workqueue_struct *bch_journal_wq;
 
+
 #define BTREE_MAX_PAGES		(256 * 1024 / PAGE_SIZE)
 /* limitation of partitions number on single bcache device */
 #define BCACHE_MINORS		128
@@ -2301,6 +2303,11 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	if (!try_module_get(THIS_MODULE))
 		return -EBUSY;
 
+	/* For latest state of bcache_is_reboot */
+	smp_mb();
+	if (bcache_is_reboot)
+		return -EBUSY;
+
 	path = kstrndup(buffer, size, GFP_KERNEL);
 	if (!path)
 		goto err;
@@ -2380,6 +2387,9 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 
 static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 {
+	if (bcache_is_reboot)
+		return NOTIFY_DONE;
+
 	if (code == SYS_DOWN ||
 	    code == SYS_HALT ||
 	    code == SYS_POWER_OFF) {
@@ -2392,19 +2402,45 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 
 		mutex_lock(&bch_register_lock);
 
+		if (bcache_is_reboot)
+			goto out;
+
+		/* New registration is rejected since now */
+		bcache_is_reboot = true;
+		/*
+		 * Make registering caller (if there is) on other CPU
+		 * core know bcache_is_reboot set to true earlier
+		 */
+		smp_mb();
+
 		if (list_empty(&bch_cache_sets) &&
 		    list_empty(&uncached_devices))
 			goto out;
 
+		mutex_unlock(&bch_register_lock);
+
 		pr_info("Stopping all devices:");
 
+		/*
+		 * The reason bch_register_lock is not held to call
+		 * bch_cache_set_stop() and bcache_device_stop() is to
+		 * avoid potential deadlock during reboot, because cache
+		 * set or bcache device stopping process will acqurie
+		 * bch_register_lock too.
+		 *
+		 * We are safe here because bcache_is_reboot sets to
+		 * true already, register_bcache() will reject new
+		 * registration now. bcache_is_reboot also makes sure
+		 * bcache_reboot() won't be re-entered on by other thread,
+		 * so there is no race in following list iteration by
+		 * list_for_each_entry_safe().
+		 */
 		list_for_each_entry_safe(c, tc, &bch_cache_sets, list)
 			bch_cache_set_stop(c);
 
 		list_for_each_entry_safe(dc, tdc, &uncached_devices, list)
 			bcache_device_stop(&dc->disk);
 
-		mutex_unlock(&bch_register_lock);
 
 		/*
 		 * Give an early chance for other kthreads and
@@ -2531,6 +2567,8 @@ static int __init bcache_init(void)
 	bch_debug_init();
 	closure_debug_init();
 
+	bcache_is_reboot = false;
+
 	return 0;
 err:
 	bcache_exit();
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index bfb437ffb13c..327493f634bb 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -16,6 +16,8 @@
 #include <linux/sort.h>
 #include <linux/sched/clock.h>
 
+extern bool bcache_is_reboot;
+
 /* Default is 0 ("writethrough") */
 static const char * const bch_cache_modes[] = {
 	"writethrough",
@@ -271,6 +273,10 @@ STORE(__cached_dev)
 	struct cache_set *c;
 	struct kobj_uevent_env *env;
 
+	/* no user space access if system is rebooting */
+	if (bcache_is_reboot)
+		return -EBUSY;
+
 #define d_strtoul(var)		sysfs_strtoul(var, dc->var)
 #define d_strtoul_nonzero(var)	sysfs_strtoul_clamp(var, dc->var, 1, INT_MAX)
 #define d_strtoi_h(var)		sysfs_hatoi(var, dc->var)
@@ -408,6 +414,10 @@ STORE(bch_cached_dev)
 	struct cached_dev *dc = container_of(kobj, struct cached_dev,
 					     disk.kobj);
 
+	/* no user space access if system is rebooting */
+	if (bcache_is_reboot)
+		return -EBUSY;
+
 	mutex_lock(&bch_register_lock);
 	size = __cached_dev_store(kobj, attr, buf, size);
 
@@ -511,6 +521,10 @@ STORE(__bch_flash_dev)
 					       kobj);
 	struct uuid_entry *u = &d->c->uuids[d->id];
 
+	/* no user space access if system is rebooting */
+	if (bcache_is_reboot)
+		return -EBUSY;
+
 	sysfs_strtoul(data_csum,	d->data_csum);
 
 	if (attr == &sysfs_size) {
@@ -746,6 +760,10 @@ STORE(__bch_cache_set)
 	struct cache_set *c = container_of(kobj, struct cache_set, kobj);
 	ssize_t v;
 
+	/* no user space access if system is rebooting */
+	if (bcache_is_reboot)
+		return -EBUSY;
+
 	if (attr == &sysfs_unregister)
 		bch_cache_set_unregister(c);
 
@@ -865,6 +883,10 @@ STORE(bch_cache_set_internal)
 {
 	struct cache_set *c = container_of(kobj, struct cache_set, internal);
 
+	/* no user space access if system is rebooting */
+	if (bcache_is_reboot)
+		return -EBUSY;
+
 	return bch_cache_set_store(&c->kobj, attr, buf, size);
 }
 
@@ -1050,6 +1072,10 @@ STORE(__bch_cache)
 	struct cache *ca = container_of(kobj, struct cache, kobj);
 	ssize_t v;
 
+	/* no user space access if system is rebooting */
+	if (bcache_is_reboot)
+		return -EBUSY;
+
 	if (attr == &sysfs_discard) {
 		bool v = strtoul_or_return(buf);
 
-- 
2.20.1



