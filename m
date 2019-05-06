Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0EF614E59
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfEFOly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728364AbfEFOly (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:41:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CEAC21019;
        Mon,  6 May 2019 14:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153713;
        bh=jxET2lkC8axXa57NGv2c8LLSq54+oEHQi4BAnWts6Mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fuZXM7gLylJZnNholcJIFNCAS70XQnWfe5JCD22Ugy62Ji9v30SctKgRPHef7PlpU
         /qyHoquk2zH4xIdnuVAyeoTiz5x2Nv6LbKutyXadDEfFP/qrl+R7wTLX9d34veNOVH
         pHJStEykRtivmFT9vUa7m912RjLQE3JxK6NAEV8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>,
        syzbot <syzbot+ba2a929dcf8e704c180e@syzkaller.appspotmail.com>
Subject: [PATCH 4.19 69/99] block: pass no-op callback to INIT_WORK().
Date:   Mon,  6 May 2019 16:32:42 +0200
Message-Id: <20190506143100.414365876@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2e3c18d0ada16f145087b2687afcad1748c0827c ]

syzbot is hitting flush_work() warning caused by commit 4d43d395fed12463
("workqueue: Try to catch flush_work() without INIT_WORK().") [1].
Although that commit did not expect INIT_WORK(NULL) case, calling
flush_work() without setting a valid callback should be avoided anyway.
Fix this problem by setting a no-op callback instead of NULL.

[1] https://syzkaller.appspot.com/bug?id=e390366bc48bc82a7c668326e0663be3b91cbd29

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-and-tested-by: syzbot <syzbot+ba2a929dcf8e704c180e@syzkaller.appspotmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[sl: rename blk_timeout_work]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index eb8b52241453..33488b1426b7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -980,6 +980,10 @@ static void blk_rq_timed_out_timer(struct timer_list *t)
 	kblockd_schedule_work(&q->timeout_work);
 }
 
+static void blk_timeout_work_dummy(struct work_struct *work)
+{
+}
+
 /**
  * blk_alloc_queue_node - allocate a request queue
  * @gfp_mask: memory allocation flags
@@ -1034,7 +1038,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id,
 	timer_setup(&q->backing_dev_info->laptop_mode_wb_timer,
 		    laptop_mode_timer_fn, 0);
 	timer_setup(&q->timeout, blk_rq_timed_out_timer, 0);
-	INIT_WORK(&q->timeout_work, NULL);
+	INIT_WORK(&q->timeout_work, blk_timeout_work_dummy);
 	INIT_LIST_HEAD(&q->timeout_list);
 	INIT_LIST_HEAD(&q->icq_list);
 #ifdef CONFIG_BLK_CGROUP
-- 
2.20.1



