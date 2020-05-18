Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FC51D8095
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbgERRkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729112AbgERRki (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:40:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C38F207C4;
        Mon, 18 May 2020 17:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823638;
        bh=k7emKby5tOFFms/cf5P7x4wI0xM6kC32fF4oJWJ9pdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j5gKq3L7+SWPFDZ1Dgw6syU1+NzF6trDErlk1wcStYOfjg3FyZsNOjbN2uVzL1orc
         CpWeuoWq8jf3ZB3HxAwUTe9PNp3CJQM9v0LKgkLGMyAHPR/Zl3L3kiLSUDbzmP8OAv
         z+zUAd/4A1MyPzcr1lMTgEsxx3kucVtLA1KRNQxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 63/86] block: defer timeouts to a workqueue
Date:   Mon, 18 May 2020 19:36:34 +0200
Message-Id: <20200518173503.131794977@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 287922eb0b186e2a5bf54fdd04b734c25c90035c upstream.

Timer context is not very useful for drivers to perform any meaningful abort
action from.  So instead of calling the driver from this useless context
defer it to a workqueue as soon as possible.

Note that while a delayed_work item would seem the right thing here I didn't
dare to use it due to the magic in blk_add_timer that pokes deep into timer
internals.  But maybe this encourages Tejun to add a sensible API for that to
the workqueue API and we'll all be fine in the end :)

Contains a major update from Keith Bush:

"This patch removes synchronizing the timeout work so that the timer can
 start a freeze on its own queue. The timer enters the queue, so timer
 context can only start a freeze, but not wait for frozen."

-------------
NOTE: Back-ported to 4.4.y.

The only parts of the upstream commit that have been kept are various
locking changes, none of which were mentioned in the original commit
message which therefore describes this change not at all.

Timeout callbacks continue to be run via a timer. Both blk_mq_rq_timer
and blk_rq_timed_out_timer will return without without doing any work
if they cannot acquire the queue (without waiting).
-------------

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c      |    4 ++++
 block/blk-timeout.c |    3 +++
 2 files changed, 7 insertions(+)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -628,6 +628,9 @@ static void blk_mq_rq_timer(unsigned lon
 	};
 	int i;
 
+	if (blk_queue_enter(q, GFP_NOWAIT))
+		return;
+
 	blk_mq_queue_tag_busy_iter(q, blk_mq_check_expired, &data);
 
 	if (data.next_set) {
@@ -642,6 +645,7 @@ static void blk_mq_rq_timer(unsigned lon
 				blk_mq_tag_idle(hctx);
 		}
 	}
+	blk_queue_exit(q);
 }
 
 /*
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -134,6 +134,8 @@ void blk_rq_timed_out_timer(unsigned lon
 	struct request *rq, *tmp;
 	int next_set = 0;
 
+	if (blk_queue_enter(q, GFP_NOWAIT))
+		return;
 	spin_lock_irqsave(q->queue_lock, flags);
 
 	list_for_each_entry_safe(rq, tmp, &q->timeout_list, timeout_list)
@@ -143,6 +145,7 @@ void blk_rq_timed_out_timer(unsigned lon
 		mod_timer(&q->timeout, round_jiffies_up(next));
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
+	blk_queue_exit(q);
 }
 
 /**


