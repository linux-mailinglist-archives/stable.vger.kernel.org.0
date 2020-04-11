Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE0C91A51CD
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbgDKMNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:13:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727608AbgDKMNH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:13:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BACAC215A4;
        Sat, 11 Apr 2020 12:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607187;
        bh=Pa5+l78f/hLPIgJYaiYO+xjtCaCaOUnntR7EXklcnmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ue/xMp0VupTqokbSEO4fth65CC8/QOpDytnPLv1u8i+Mfv13xDFbf38AKtax6dsNi
         qySAIEALpLYOdBwpLJ7ZETPvyOfgjf27Bb60K5gkmnjiMF+5PLNdX7sFm9yS7vhEO1
         iKLfi0jTdQxEZNEO0N8X/uwaBL82DsbP4iJRLPz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianchao Wang <jianchao.w.wang@oracle.com>,
        Keith Busch <keith.busch@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.14 10/38] blk-mq: Allow blocking queue tag iter callbacks
Date:   Sat, 11 Apr 2020 14:08:54 +0200
Message-Id: <20200411115439.016686728@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115437.795556138@linuxfoundation.org>
References: <20200411115437.795556138@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <keith.busch@intel.com>

commit 530ca2c9bd6949c72c9b5cfc330cb3dbccaa3f5b upstream.

A recent commit runs tag iterator callbacks under the rcu read lock,
but existing callbacks do not satisfy the non-blocking requirement.
The commit intended to prevent an iterator from accessing a queue that's
being modified. This patch fixes the original issue by taking a queue
reference instead of reading it, which allows callbacks to make blocking
calls.

Fixes: f5bbbbe4d6357 ("blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter")
Acked-by: Jianchao Wang <jianchao.w.wang@oracle.com>
Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-mq-tag.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -336,16 +336,11 @@ void blk_mq_queue_tag_busy_iter(struct r
 
 	/*
 	 * __blk_mq_update_nr_hw_queues will update the nr_hw_queues and
-	 * queue_hw_ctx after freeze the queue. So we could use q_usage_counter
-	 * to avoid race with it. __blk_mq_update_nr_hw_queues will users
-	 * synchronize_rcu to ensure all of the users go out of the critical
-	 * section below and see zeroed q_usage_counter.
+	 * queue_hw_ctx after freeze the queue, so we use q_usage_counter
+	 * to avoid race with it.
 	 */
-	rcu_read_lock();
-	if (percpu_ref_is_zero(&q->q_usage_counter)) {
-		rcu_read_unlock();
+	if (!percpu_ref_tryget(&q->q_usage_counter))
 		return;
-	}
 
 	queue_for_each_hw_ctx(q, hctx, i) {
 		struct blk_mq_tags *tags = hctx->tags;
@@ -361,7 +356,7 @@ void blk_mq_queue_tag_busy_iter(struct r
 			bt_for_each(hctx, &tags->breserved_tags, fn, priv, true);
 		bt_for_each(hctx, &tags->bitmap_tags, fn, priv, false);
 	}
-	rcu_read_unlock();
+	blk_queue_exit(q);
 }
 
 static int bt_alloc(struct sbitmap_queue *bt, unsigned int depth,


