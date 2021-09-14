Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B8640AE1C
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 14:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbhINMp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 08:45:29 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15414 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232613AbhINMp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 08:45:28 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H82xJ20yBzQyM4;
        Tue, 14 Sep 2021 20:40:04 +0800 (CST)
Received: from dggema762-chm.china.huawei.com (10.1.198.204) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 20:44:09 +0800
Received: from huawei.com (10.175.127.227) by dggema762-chm.china.huawei.com
 (10.1.198.204) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.8; Tue, 14
 Sep 2021 20:44:09 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <linux-block@vger.kernel.org>, <stable@vger.kernel.org>,
        <axboe@kernel.dk>, <gregkh@linuxfoundation.org>, <hch@lst.de>
CC:     <yukuai3@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH linux-4.19.y] blk-mq: fix divide by zero crash in tg_may_dispatch()
Date:   Tue, 14 Sep 2021 20:54:02 +0800
Message-ID: <20210914125402.4068844-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema762-chm.china.huawei.com (10.1.198.204)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If blk-throttle is enabled and io is issued before
blk_throtl_register_queue() is done. Divide by zero crash will be
triggered in tg_may_dispatch() because 'throtl_slice' is uninitialized.

The problem is fixed in commit 75f4dca59694 ("block: call
blk_register_queue earlier in device_add_disk") from mainline, however
it's too hard to backport this patch due to lots of refactoring.

Thus introduce a new flag QUEUE_FLAG_THROTL_INIT_DONE. It will be set
after blk_throtl_register_queue() is done, and will be checked before
applying any config.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-sysfs.c      |  2 ++
 block/blk-throttle.c   | 41 +++++++++++++++++++++++++++++++++++++++--
 include/linux/blkdev.h |  1 +
 3 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 07494deb1a26..7d250acf8ece 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -954,6 +954,7 @@ int blk_register_queue(struct gendisk *disk)
 	blk_queue_flag_set(QUEUE_FLAG_REGISTERED, q);
 	wbt_enable_default(q);
 	blk_throtl_register_queue(q);
+	blk_queue_flag_set(QUEUE_FLAG_THROTL_INIT_DONE, q);
 
 	/* Now everything is ready and send out KOBJ_ADD uevent */
 	kobject_uevent(&q->kobj, KOBJ_ADD);
@@ -986,6 +987,7 @@ void blk_unregister_queue(struct gendisk *disk)
 	if (!blk_queue_registered(q))
 		return;
 
+	blk_queue_flag_clear(QUEUE_FLAG_THROTL_INIT_DONE, q);
 	/*
 	 * Since sysfs_remove_dir() prevents adding new directory entries
 	 * before removal of existing entries starts, protect against
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index caee658609d7..b2eeca9a9962 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -11,6 +11,8 @@
 #include <linux/bio.h>
 #include <linux/blktrace_api.h>
 #include <linux/blk-cgroup.h>
+#include <linux/sched/signal.h>
+#include <linux/delay.h>
 #include "blk.h"
 
 /* Max dispatch from a group in 1 round */
@@ -1428,6 +1430,31 @@ static void tg_conf_updated(struct throtl_grp *tg, bool global)
 	}
 }
 
+static inline int throtl_check_init_done(struct request_queue *q)
+{
+	if (test_bit(QUEUE_FLAG_THROTL_INIT_DONE, &q->queue_flags))
+		return 0;
+
+	return blk_queue_dying(q) ? -ENODEV : -EBUSY;
+}
+
+/*
+ * If throtl_check_init_done() return -EBUSY, we should retry after a short
+ * msleep(), since that throttle init will be completed in blk_register_queue()
+ * soon.
+ */
+static inline int throtl_restart_syscall_when_busy(int errno)
+{
+	int ret = errno;
+
+	if (ret == -EBUSY) {
+		msleep(10);
+		ret = restart_syscall();
+	}
+
+	return ret;
+}
+
 static ssize_t tg_set_conf(struct kernfs_open_file *of,
 			   char *buf, size_t nbytes, loff_t off, bool is_u64)
 {
@@ -1441,6 +1468,10 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
 	if (ret)
 		return ret;
 
+	ret = throtl_check_init_done(ctx.disk->queue);
+	if (ret)
+		goto out_finish;
+
 	ret = -EINVAL;
 	if (sscanf(ctx.body, "%llu", &v) != 1)
 		goto out_finish;
@@ -1448,7 +1479,6 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
 		v = U64_MAX;
 
 	tg = blkg_to_tg(ctx.blkg);
-
 	if (is_u64)
 		*(u64 *)((void *)tg + of_cft(of)->private) = v;
 	else
@@ -1458,6 +1488,8 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
 	ret = 0;
 out_finish:
 	blkg_conf_finish(&ctx);
+	ret = throtl_restart_syscall_when_busy(ret);
+
 	return ret ?: nbytes;
 }
 
@@ -1607,8 +1639,11 @@ static ssize_t tg_set_limit(struct kernfs_open_file *of,
 	if (ret)
 		return ret;
 
-	tg = blkg_to_tg(ctx.blkg);
+	ret = throtl_check_init_done(ctx.disk->queue);
+	if (ret)
+		goto out_finish;
 
+	tg = blkg_to_tg(ctx.blkg);
 	v[0] = tg->bps_conf[READ][index];
 	v[1] = tg->bps_conf[WRITE][index];
 	v[2] = tg->iops_conf[READ][index];
@@ -1704,6 +1739,8 @@ static ssize_t tg_set_limit(struct kernfs_open_file *of,
 	ret = 0;
 out_finish:
 	blkg_conf_finish(&ctx);
+	ret = throtl_restart_syscall_when_busy(ret);
+
 	return ret ?: nbytes;
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 209ba8e7bd31..22be9f090bf1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -684,6 +684,7 @@ struct request_queue {
 #define QUEUE_FLAG_NOMERGES     5	/* disable merge attempts */
 #define QUEUE_FLAG_SAME_COMP	6	/* complete on same CPU-group */
 #define QUEUE_FLAG_FAIL_IO	7	/* fake timeout */
+#define QUEUE_FLAG_THROTL_INIT_DONE 8	/* io throttle can be online */
 #define QUEUE_FLAG_NONROT	9	/* non-rotational device (SSD) */
 #define QUEUE_FLAG_VIRT        QUEUE_FLAG_NONROT /* paravirt device */
 #define QUEUE_FLAG_IO_STAT     10	/* do IO stats */
-- 
2.31.1

