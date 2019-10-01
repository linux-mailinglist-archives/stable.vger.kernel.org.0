Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A10C3D7E
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 19:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbfJAQkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:40:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbfJAQku (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:40:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D293621A4C;
        Tue,  1 Oct 2019 16:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948049;
        bh=9ja428gZ4RmI6EOL72mQVEMXFQ6pN4UX4cmhs7izldg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WhrQhPlxyp6wbGCCnrQTe4AjV9mbdbt8QMh5Nf80R+sn36jhdXOjVC4lwb6SRHmHw
         nuf1CV78yNkdNQdhKkyOSgRsTyq2eDVnLSzxYGvl1J9JIdelTK/NHOIwev8I/j3xdU
         6/fruZ6jcseZMmExmgXvLmfk+Vbff/wOV3VHYpWw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        syzbot+da3b7677bb913dc1b737@syzkaller.appspotmail.com,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 54/71] blk-mq: move lockdep_assert_held() into elevator_exit
Date:   Tue,  1 Oct 2019 12:39:04 -0400
Message-Id: <20191001163922.14735-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
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
index c9d183d6c4999..ca22afd47b3dc 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -555,8 +555,6 @@ void blk_mq_sched_free_requests(struct request_queue *q)
 	struct blk_mq_hw_ctx *hctx;
 	int i;
 
-	lockdep_assert_held(&q->sysfs_lock);
-
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (hctx->sched_tags)
 			blk_mq_free_rqs(q->tag_set, hctx->sched_tags, i);
diff --git a/block/blk.h b/block/blk.h
index de6b2e146d6eb..3ce8b73bb2264 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -194,6 +194,8 @@ void elv_unregister_queue(struct request_queue *q);
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

