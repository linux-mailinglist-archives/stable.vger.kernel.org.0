Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41957156692
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgBHS3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33904 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727801AbgBHS3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrH-0003dc-Gm; Sat, 08 Feb 2020 18:29:35 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrG-000CM3-6e; Sat, 08 Feb 2020 18:29:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jens Axboe" <axboe@fb.com>, "Ming Lei" <tom.leiming@gmail.com>,
        "Akinobu Mita" <akinobu.mita@gmail.com>,
        "Christoph Hellwig" <hch@lst.de>,
        "Wanpeng Li" <wanpeng.li@hotmail.com>
Date:   Sat, 08 Feb 2020 18:19:44 +0000
Message-ID: <lsq.1581185940.432706977@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 045/148] blk-mq: fix deadlock when reading cpu_list
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Akinobu Mita <akinobu.mita@gmail.com>

commit 60de074ba1e8f327db19bc33d8530131ac01695d upstream.

CPU hotplug handling for blk-mq (blk_mq_queue_reinit) acquires
all_q_mutex in blk_mq_queue_reinit_notify() and then removes sysfs
entries by blk_mq_sysfs_unregister().  Removing sysfs entry needs to
be blocked until the active reference of the kernfs_node to be zero.

On the other hand, reading blk_mq_hw_sysfs_cpu sysfs entry (e.g.
/sys/block/nullb0/mq/0/cpu_list) acquires all_q_mutex in
blk_mq_hw_sysfs_cpus_show().

If these happen at the same time, a deadlock can happen.  Because one
can wait for the active reference to be zero with holding all_q_mutex,
and the other tries to acquire all_q_mutex with holding the active
reference.

The reason that all_q_mutex is acquired in blk_mq_hw_sysfs_cpus_show()
is to avoid reading an imcomplete hctx->cpumask.  Since reading sysfs
entry for blk-mq needs to acquire q->sysfs_lock, we can avoid deadlock
and reading an imcomplete hctx->cpumask by protecting q->sysfs_lock
while hctx->cpumask is being updated.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Wanpeng Li <wanpeng.li@hotmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 block/blk-mq-sysfs.c | 4 ----
 block/blk-mq.c       | 7 +++++++
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -229,8 +229,6 @@ static ssize_t blk_mq_hw_sysfs_cpus_show
 	unsigned int i, first = 1;
 	ssize_t ret = 0;
 
-	blk_mq_disable_hotplug();
-
 	for_each_cpu(i, hctx->cpumask) {
 		if (first)
 			ret += sprintf(ret + page, "%u", i);
@@ -240,8 +238,6 @@ static ssize_t blk_mq_hw_sysfs_cpus_show
 		first = 0;
 	}
 
-	blk_mq_enable_hotplug();
-
 	ret += sprintf(ret + page, "\n");
 	return ret;
 }
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1645,6 +1645,11 @@ static void blk_mq_map_swqueue(struct re
 	struct blk_mq_ctx *ctx;
 	struct blk_mq_tag_set *set = q->tag_set;
 
+	/*
+	 * Avoid others reading imcomplete hctx->cpumask through sysfs
+	 */
+	mutex_lock(&q->sysfs_lock);
+
 	queue_for_each_hw_ctx(q, hctx, i) {
 		cpumask_clear(hctx->cpumask);
 		hctx->nr_ctx = 0;
@@ -1664,6 +1669,8 @@ static void blk_mq_map_swqueue(struct re
 		hctx->ctxs[hctx->nr_ctx++] = ctx;
 	}
 
+	mutex_unlock(&q->sysfs_lock);
+
 	queue_for_each_hw_ctx(q, hctx, i) {
 		/*
 		 * If not software queues are mapped to this hardware queue,

