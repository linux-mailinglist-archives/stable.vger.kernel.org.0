Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2346E3C451D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhGLGXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:23:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232613AbhGLGWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCE3361132;
        Mon, 12 Jul 2021 06:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070750;
        bh=hEXybyKNzNQh9GIrfXSwiHb+N8bB+QE1nn7cGPVvTAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHxDyGJLNP6nAq/OO7+GfOZHQ2UV+aLbee3rpw1m6Pnpi71Mq2cSh+vuEVKb7Isr4
         56RJUU/hTZCySXd/cYsfjrogFM+fFk4yqHUBMrqMLtI9ZIe9axg+76dQwMCtSfdT1H
         IY33H3nerHiJbR+5ida14tqSKZbcGvi02oX/3ld8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/348] block: fix race between adding/removing rq qos and normal IO
Date:   Mon, 12 Jul 2021 08:08:29 +0200
Message-Id: <20210712060717.966682262@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



