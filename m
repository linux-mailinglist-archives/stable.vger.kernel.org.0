Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34A5318E50
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhBKPYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:24:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230337AbhBKPUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:20:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1A6D64F2D;
        Thu, 11 Feb 2021 15:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613056023;
        bh=C0DPekt7cQ22yF5PHlX2iRYj1NNUEKIwedTttxOIvXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1sVoj93yPS0XtUl4IcQUaX11ss4FBIM4wB6rmcPO39jmZ6RZJu1wKvh8C7DtBWr0
         7cufx56k4EfPkfns+X7q/NQG5U90yE2puCEjEiNNXZt1+JVK6U/+gcAKjQUUmlbwsw
         KOhpCnfxjVarI1dL9wAIFxNr2UuvcXRiyTjmFQOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 4.19 20/24] block: dont hold q->sysfs_lock in elevator_init_mq
Date:   Thu, 11 Feb 2021 16:02:54 +0100
Message-Id: <20210211150148.637345944@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150147.743660073@linuxfoundation.org>
References: <20210211150147.743660073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit c48dac137a62a5d6fa1ef3fa445cbd9c43655a76 upstream.

The original comment says:

	q->sysfs_lock must be held to provide mutual exclusion between
	elevator_switch() and here.

Which is simply wrong. elevator_init_mq() is only called from
blk_mq_init_allocated_queue, which is always called before the request
queue is registered via blk_register_queue(), for dm-rq or normal rq
based driver. However, queue's kobject is only exposed and added to sysfs
in blk_register_queue(). So there isn't such race between elevator_switch()
and elevator_init_mq().

So avoid to hold q->sysfs_lock in elevator_init_mq().

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/elevator.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/block/elevator.c
+++ b/block/elevator.c
@@ -980,23 +980,19 @@ int elevator_init_mq(struct request_queu
 	if (q->nr_hw_queues != 1)
 		return 0;
 
-	/*
-	 * q->sysfs_lock must be held to provide mutual exclusion between
-	 * elevator_switch() and here.
-	 */
-	mutex_lock(&q->sysfs_lock);
+	WARN_ON_ONCE(test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags));
+
 	if (unlikely(q->elevator))
-		goto out_unlock;
+		goto out;
 
 	e = elevator_get(q, "mq-deadline", false);
 	if (!e)
-		goto out_unlock;
+		goto out;
 
 	err = blk_mq_init_sched(q, e);
 	if (err)
 		elevator_put(e);
-out_unlock:
-	mutex_unlock(&q->sysfs_lock);
+out:
 	return err;
 }
 


