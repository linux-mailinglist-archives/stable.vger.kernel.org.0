Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9EEC3CE3
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732078AbfJAQml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732073AbfJAQmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:42:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E49321D82;
        Tue,  1 Oct 2019 16:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948159;
        bh=+n3gJ1VrqbqNkcBk7vhlCR91tUTb6AximTmpMzZNXhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DO1DrFphJfrg20WyNzAHO84ZNCoAouP7RhpahnK0fICjv1c3ZqqC8r2suMbVH4OLj
         R6+XsZJMGfFu6BnTobks3wyWS0hReWIDPULDX2D5fOZh4QlJNYb/lHJqQTolGD60cp
         /tm8FKVb2k8ZsnCGz0VNICVf94EHRTQ58BqR76ws=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        syzbot+da3b7677bb913dc1b737@syzkaller.appspotmail.com,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 48/63] blk-mq: move lockdep_assert_held() into elevator_exit
Date:   Tue,  1 Oct 2019 12:41:10 -0400
Message-Id: <20191001164125.15398-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164125.15398-1-sashal@kernel.org>
References: <20191001164125.15398-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 284b94be1925dbe035ce5218d8b5c197321262c7 ]

Commit c48dac137a62 ("block: don't hold q->sysfs_lock in elevator_init_mq")
removes q->sysfs_lock from elevator_init_mq(), but forgot to deal with
lockdep_assert_held() called in blk_mq_sched_free_requests() which is
run in failure path of elevator_init_mq().

blk_mq_sched_free_requests() is called in the following 3 functions:

	elevator_init_mq()
	elevator_exit()
	blk_cleanup_queue()

In blk_cleanup_queue(), blk_mq_sched_free_requests() is followed exactly
by 'mutex_lock(&q->sysfs_lock)'.

So moving the lockdep_assert_held() from blk_mq_sched_free_requests()
into elevator_exit() for fixing the report by syzbot.

Reported-by: syzbot+da3b7677bb913dc1b737@syzkaller.appspotmail.com
Fixed: c48dac137a62 ("block: don't hold q->sysfs_lock in elevator_init_mq")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-sched.c | 2 --
 block/blk.h          | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 2766066a15dbf..3cf555f127006 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -554,8 +554,6 @@ void blk_mq_sched_free_requests(struct request_queue *q)
 	struct blk_mq_hw_ctx *hctx;
 	int i;
 
-	lockdep_assert_held(&q->sysfs_lock);
-
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (hctx->sched_tags)
 			blk_mq_free_rqs(q->tag_set, hctx->sched_tags, i);
diff --git a/block/blk.h b/block/blk.h
index 7814aa207153c..38938125ab729 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -184,6 +184,8 @@ void elv_unregister_queue(struct request_queue *q);
 static inline void elevator_exit(struct request_queue *q,
 		struct elevator_queue *e)
 {
+	lockdep_assert_held(&q->sysfs_lock);
+
 	blk_mq_sched_free_requests(q);
 	__elevator_exit(q, e);
 }
-- 
2.20.1

