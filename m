Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AD2318E69
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhBKP0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:26:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230418AbhBKPWh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:22:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E74E64F32;
        Thu, 11 Feb 2021 15:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613056028;
        bh=/nF6qPipkgNN+AGt8o6n3NFN/weCxFIubucELHp2D2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fsYiuLuNcYkl289j+cDte0rnXPiqpYjWyQffiQH46wIQjPeHa479gA74qKWz9pBRS
         zAm1CxKQzDbAOWVxjJFw2+b4JqQ88QDMa97mLTAz5aOsTP45EimiYN11aKRVdxRnhp
         1mK6aLnwUEcK4CMVLKSS70m6A9rCYM2bcvDXR8pY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 4.19 21/24] blk-mq: dont hold q->sysfs_lock in blk_mq_map_swqueue
Date:   Thu, 11 Feb 2021 16:02:55 +0100
Message-Id: <20210211150148.681811267@linuxfoundation.org>
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

commit c6ba933358f0d7a6a042b894dba20cc70396a6d3 upstream.

blk_mq_map_swqueue() is called from blk_mq_init_allocated_queue()
and blk_mq_update_nr_hw_queues(). For the former caller, the kobject
isn't exposed to userspace yet. For the latter caller, hctx sysfs entries
and debugfs are un-registered before updating nr_hw_queues.

On the other hand, commit 2f8f1336a48b ("blk-mq: always free hctx after
request queue is freed") moves freeing hctx into queue's release
handler, so there won't be race with queue release path too.

So don't hold q->sysfs_lock in blk_mq_map_swqueue().

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2324,11 +2324,6 @@ static void blk_mq_map_swqueue(struct re
 	struct blk_mq_ctx *ctx;
 	struct blk_mq_tag_set *set = q->tag_set;
 
-	/*
-	 * Avoid others reading imcomplete hctx->cpumask through sysfs
-	 */
-	mutex_lock(&q->sysfs_lock);
-
 	queue_for_each_hw_ctx(q, hctx, i) {
 		cpumask_clear(hctx->cpumask);
 		hctx->nr_ctx = 0;
@@ -2362,8 +2357,6 @@ static void blk_mq_map_swqueue(struct re
 		hctx->ctxs[hctx->nr_ctx++] = ctx;
 	}
 
-	mutex_unlock(&q->sysfs_lock);
-
 	queue_for_each_hw_ctx(q, hctx, i) {
 		/*
 		 * If no software queues are mapped to this hardware queue,


