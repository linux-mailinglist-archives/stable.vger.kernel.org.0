Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4BC406BD4
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhIJMex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:34:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234089AbhIJMeQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1217B611CC;
        Fri, 10 Sep 2021 12:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277185;
        bh=vDMNfXKcEpvZWh9QXgp98GoQ3gV53ERvyl94vM74WCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8vfWDOmZtPMTu8Af2Xvyia1gcbJtC68sGlqLAm+tNmbblQSgLOZ+gTEIx3GZrusn
         08Bq0vuryWTqpvnB0LiECzzZpUNV+DTHrQsiuvi18Wyj4/G0ZBJ5wtmfU6QnqgUGJT
         jsEeL8yVr7vPL5f1dOMS9WId0woNvTJQRIe1zZeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Blank-Burian, Markus, Dr." <blankburian@uni-muenster.de>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Yi Zhang <yi.zhang@redhat.com>
Subject: [PATCH 5.10 11/26] blk-mq: fix kernel panic during iterating over flush request
Date:   Fri, 10 Sep 2021 14:30:15 +0200
Message-Id: <20210910122916.618186764@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.253646001@linuxfoundation.org>
References: <20210910122916.253646001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit c2da19ed50554ce52ecbad3655c98371fe58599f upstream.

For fixing use-after-free during iterating over requests, we grabbed
request's refcount before calling ->fn in commit 2e315dc07df0 ("blk-mq:
grab rq->refcount before calling ->fn in blk_mq_tagset_busy_iter").
Turns out this way may cause kernel panic when iterating over one flush
request:

1) old flush request's tag is just released, and this tag is reused by
one new request, but ->rqs[] isn't updated yet

2) the flush request can be re-used for submitting one new flush command,
so blk_rq_init() is called at the same time

3) meantime blk_mq_queue_tag_busy_iter() is called, and old flush request
is retrieved from ->rqs[tag]; when blk_mq_put_rq_ref() is called,
flush_rq->end_io may not be updated yet, so NULL pointer dereference
is triggered in blk_mq_put_rq_ref().

Fix the issue by calling refcount_set(&flush_rq->ref, 1) after
flush_rq->end_io is set. So far the only other caller of blk_rq_init() is
scsi_ioctl_reset() in which the request doesn't enter block IO stack and
the request reference count isn't used, so the change is safe.

Fixes: 2e315dc07df0 ("blk-mq: grab rq->refcount before calling ->fn in blk_mq_tagset_busy_iter")
Reported-by: "Blank-Burian, Markus, Dr." <blankburian@uni-muenster.de>
Tested-by: "Blank-Burian, Markus, Dr." <blankburian@uni-muenster.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.garry@huawei.com>
Link: https://lore.kernel.org/r/20210811142624.618598-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c  |    1 -
 block/blk-flush.c |    8 ++++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -121,7 +121,6 @@ void blk_rq_init(struct request_queue *q
 	rq->internal_tag = BLK_MQ_NO_TAG;
 	rq->start_time_ns = ktime_get_ns();
 	rq->part = NULL;
-	refcount_set(&rq->ref, 1);
 	blk_crypto_rq_set_defaults(rq);
 }
 EXPORT_SYMBOL(blk_rq_init);
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -330,6 +330,14 @@ static void blk_kick_flush(struct reques
 	flush_rq->rq_flags |= RQF_FLUSH_SEQ;
 	flush_rq->rq_disk = first_rq->rq_disk;
 	flush_rq->end_io = flush_end_io;
+	/*
+	 * Order WRITE ->end_io and WRITE rq->ref, and its pair is the one
+	 * implied in refcount_inc_not_zero() called from
+	 * blk_mq_find_and_get_req(), which orders WRITE/READ flush_rq->ref
+	 * and READ flush_rq->end_io
+	 */
+	smp_wmb();
+	refcount_set(&flush_rq->ref, 1);
 
 	blk_flush_queue_rq(flush_rq, false);
 }


