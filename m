Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84F8E10EAC8
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 14:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfLBNY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 08:24:57 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35266 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbfLBNY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 08:24:57 -0500
Received: from hades.home (unknown [IPv6:2a00:23c5:582:9d00:2d93:25f:7679:a491])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: martyn)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id B2F3B28FD57;
        Mon,  2 Dec 2019 13:24:55 +0000 (GMT)
From:   Martyn Welch <martyn.welch@collabora.com>
To:     stable@vger.kernel.org
Cc:     kernel@collabora.com, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Yi Zhang <yi.zhang@redhat.com>,
        syzbot+b9d0d56867048c7bcfde@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>,
        Martyn Welch <martyn.welch@collabora.com>
Subject: [PATCH 3/3] blk-mq: remove WARN_ON(!q->elevator) from blk_mq_sched_free_requests
Date:   Mon,  2 Dec 2019 13:24:46 +0000
Message-Id: <20191202132446.3623809-4-martyn.welch@collabora.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202132446.3623809-1-martyn.welch@collabora.com>
References: <20191202132446.3623809-1-martyn.welch@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit c326f846ebc2a30eca386b85dffba96e23803d81 upstream.

blk_mq_sched_free_requests() may be called in failure path in which
q->elevator may not be setup yet, so remove WARN_ON(!q->elevator) from
blk_mq_sched_free_requests for avoiding the false positive.

This function is actually safe to call in case of !q->elevator because
hctx->sched_tags is checked.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Yi Zhang <yi.zhang@redhat.com>
Fixes: c3e2219216c9 ("block: free sched's request pool in blk_cleanup_queue")
Reported-by: syzbot+b9d0d56867048c7bcfde@syzkaller.appspotmail.com
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit c326f846ebc2a30eca386b85dffba96e23803d81)
Signed-off-by: Martyn Welch <martyn.welch@collabora.com>
---
 block/blk-mq-sched.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 105f8c124604..156e6444dc8f 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -533,7 +533,6 @@ void blk_mq_sched_free_requests(struct request_queue *q)
 	int i;
 
 	lockdep_assert_held(&q->sysfs_lock);
-	WARN_ON(!q->elevator);
 
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (hctx->sched_tags)
-- 
2.24.0

