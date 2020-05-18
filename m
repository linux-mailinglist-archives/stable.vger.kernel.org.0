Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B6C1D8098
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgERRko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729134AbgERRkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:40:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 797E720835;
        Mon, 18 May 2020 17:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823642;
        bh=k+sP1Ye2sq++ijswRFnpLTlJM38933ANkE+pDkrZzCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2XvQncyKPmMhME1yW8nUws4HXCN0oGnQKCsk7cdxcjYE/SQ5Tgt3xT4WayYxBbYVf
         HDOW39Gg0b5/NZWtl6omKJJ46h+EoN3vDZW9/M1qXF1IaOCNKZAe5V3QYfsfRW0ncx
         tBeMnrNOpVn1oC9jm6phr7zREY3or2GIHjPRr+oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianchao Wang <jianchao.w.wang@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 65/86] blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter
Date:   Mon, 18 May 2020 19:36:36 +0200
Message-Id: <20200518173503.473464673@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianchao Wang <jianchao.w.wang@oracle.com>

commit f5bbbbe4d63577026f908a809f22f5fd5a90ea1f upstream.

For blk-mq, part_in_flight/rw will invoke blk_mq_in_flight/rw to
account the inflight requests. It will access the queue_hw_ctx and
nr_hw_queues w/o any protection. When updating nr_hw_queues and
blk_mq_in_flight/rw occur concurrently, panic comes up.

Before update nr_hw_queues, the q will be frozen. So we could use
q_usage_counter to avoid the race. percpu_ref_is_zero is used here
so that we will not miss any in-flight request. The access to
nr_hw_queues and queue_hw_ctx in blk_mq_queue_tag_busy_iter are
under rcu critical section, __blk_mq_update_nr_hw_queues could use
synchronize_rcu to ensure the zeroed q_usage_counter to be globally
visible.

--------------
NOTE: Back-ported to 4.4.y.

The upstream commit was intended to prevent concurrent manipulation of
nr_hw_queues and iteration over queues. The former doesn't happen in
this in 4.4.7 (as __blk_mq_update_nr_hw_queues doesn't exist). The
extra locking is also buggy in this commit but fixed in a follow-up.

It may protect against other concurrent accesses such as queue removal
by synchronising RCU locking around q_usage_counter.
--------------

Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq-tag.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -481,6 +481,14 @@ void blk_mq_queue_tag_busy_iter(struct r
 	struct blk_mq_hw_ctx *hctx;
 	int i;
 
+	/*
+	 * Avoid potential races with things like queue removal.
+	 */
+	rcu_read_lock();
+	if (percpu_ref_is_zero(&q->q_usage_counter)) {
+		rcu_read_unlock();
+		return;
+	}
 
 	queue_for_each_hw_ctx(q, hctx, i) {
 		struct blk_mq_tags *tags = hctx->tags;
@@ -497,7 +505,7 @@ void blk_mq_queue_tag_busy_iter(struct r
 		bt_for_each(hctx, &tags->bitmap_tags, tags->nr_reserved_tags, fn, priv,
 		      false);
 	}
-
+	rcu_read_unlock();
 }
 
 static unsigned int bt_unused_tags(struct blk_mq_bitmap_tags *bt)


