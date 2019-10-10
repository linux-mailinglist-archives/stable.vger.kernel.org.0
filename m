Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F323BD2459
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387586AbfJJIoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388850AbfJJIoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:44:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99D652054F;
        Thu, 10 Oct 2019 08:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697040;
        bh=V9YzdNPN6AFK80kaYRmWSmcCKiuPRnSwCqA6BHrZ6nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfV2exs3INcu4pdHODkny7QrsDySE56JCoYbb1biriT7UJlfiR/4MhRjQ+n7mAZKt
         6Q+Qach8OCisW7jxsKAK4AolNvYOLcvJurG8t54bHTpEVbWdTs8q6Q31D3dboF4NaO
         aXdI+WtIRD1D7W3ArIm18v4TGbITsVVVxnNDBx5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+da3b7677bb913dc1b737@syzkaller.appspotmail.com,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 128/148] blk-mq: move lockdep_assert_held() into elevator_exit
Date:   Thu, 10 Oct 2019 10:36:29 +0200
Message-Id: <20191010083620.131266351@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d5edfd73d45ea..0685c45e3d96e 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -201,6 +201,8 @@ void elv_unregister_queue(struct request_queue *q);
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



