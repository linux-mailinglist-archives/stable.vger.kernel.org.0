Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527843BC037
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbhGEPe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232438AbhGEPd5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:33:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A17A61983;
        Mon,  5 Jul 2021 15:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499057;
        bh=hEXybyKNzNQh9GIrfXSwiHb+N8bB+QE1nn7cGPVvTAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krBuiS8p+GW/GTXwUgGZhDDps6Hi/DNxbOC9L5DdeVOdBnoXJdlVV1Pqg2MFcgUUD
         mN2NBtu5eJjuhFmwoCkLk7tlJLeOeiK2x7L74gZNi5qwM8DS47EOJApXWOK9+/54Y/
         RBau/Nq79e1TS5tMV00ONKkVty8RREfmhrI/UDNqzpIbRnCpkTxdkfGedVL3ycUi2n
         5qHgiPV16/utWZcmi3RRU55DCwOFege9LAzBfXESYc47if06YXFJ0TBlrac2kSXEdH
         0RNOUFzCtAx9P2yLCIlz/1uVJTkq6D1kXkw+wiXxDLrNcWCXQCM98VwebzN4j9LDtl
         u+H10PdwVldeg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Yi Zhang <yi.zhang@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/26] block: fix race between adding/removing rq qos and normal IO
Date:   Mon,  5 Jul 2021 11:30:27 -0400
Message-Id: <20210705153039.1521781-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153039.1521781-1-sashal@kernel.org>
References: <20210705153039.1521781-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 2cafe29a8d03f02a3d16193bdaae2f3e82a423f9 ]

Yi reported several kernel panics on:

[16687.001777] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
...
[16687.163549] pc : __rq_qos_track+0x38/0x60

or

[  997.690455] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
...
[  997.850347] pc : __rq_qos_done+0x2c/0x50

Turns out it is caused by race between adding rq qos(wbt) and normal IO
because rq_qos_add can be run when IO is being submitted, fix this issue
by freezing queue before adding/deleting rq qos to queue.

rq_qos_exit() needn't to freeze queue because it is called after queue
has been frozen.

iolatency calls rq_qos_add() during allocating queue, so freezing won't
add delay because queue usage refcount works at atomic mode at that
time.

iocost calls rq_qos_add() when writing cgroup attribute file, that is
fine to freeze queue at that time since we usually freeze queue when
storing to queue sysfs attribute, meantime iocost only exists on the
root cgroup.

wbt_init calls it in blk_register_queue() and queue sysfs attribute
store(queue_wb_lat_store() when write it 1st time in case of !BLK_WBT_MQ),
the following patch will speedup the queue freezing in wbt_init.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Link: https://lore.kernel.org/r/20210609015822.103433-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-rq-qos.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index 2bc43e94f4c4..2bcb3495e376 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -7,6 +7,7 @@
 #include <linux/blk_types.h>
 #include <linux/atomic.h>
 #include <linux/wait.h>
+#include <linux/blk-mq.h>
 
 #include "blk-mq-debugfs.h"
 
@@ -99,8 +100,21 @@ static inline void rq_wait_init(struct rq_wait *rq_wait)
 
 static inline void rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 {
+	/*
+	 * No IO can be in-flight when adding rqos, so freeze queue, which
+	 * is fine since we only support rq_qos for blk-mq queue.
+	 *
+	 * Reuse ->queue_lock for protecting against other concurrent
+	 * rq_qos adding/deleting
+	 */
+	blk_mq_freeze_queue(q);
+
+	spin_lock_irq(&q->queue_lock);
 	rqos->next = q->rq_qos;
 	q->rq_qos = rqos;
+	spin_unlock_irq(&q->queue_lock);
+
+	blk_mq_unfreeze_queue(q);
 
 	if (rqos->ops->debugfs_attrs)
 		blk_mq_debugfs_register_rqos(rqos);
@@ -110,12 +124,22 @@ static inline void rq_qos_del(struct request_queue *q, struct rq_qos *rqos)
 {
 	struct rq_qos **cur;
 
+	/*
+	 * See comment in rq_qos_add() about freezing queue & using
+	 * ->queue_lock.
+	 */
+	blk_mq_freeze_queue(q);
+
+	spin_lock_irq(&q->queue_lock);
 	for (cur = &q->rq_qos; *cur; cur = &(*cur)->next) {
 		if (*cur == rqos) {
 			*cur = rqos->next;
 			break;
 		}
 	}
+	spin_unlock_irq(&q->queue_lock);
+
+	blk_mq_unfreeze_queue(q);
 
 	blk_mq_debugfs_unregister_rqos(rqos);
 }
-- 
2.30.2

