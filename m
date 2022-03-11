Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F0B4D6341
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 15:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiCKORe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 09:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbiCKORc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 09:17:32 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73191C74F4
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 06:16:28 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id 15-20020a17090a098f00b001bef0376d5cso8242162pjo.5
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 06:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=+oS2bWla/ptzYMItLrPppbVG1Ger1LonrKp81nNPpN8=;
        b=5RRuC0dsR9/7aLhr7L+J6N6hO8XWwPsJHj5rCr1/GGxIjcSSE2DUfR1Y9ozjGdesl8
         UChZejTmUFtbMWjJtIz7+5vjXoEwqzHzMg2Rpq7Qpa3J2yfh8f7KOgngAnhPyQ+sCqCk
         5bX2rz74PUwYLjODGouyyBIui3sDAWOeL49uyiKgMo/U7K3kir/FsBzHmufgoU0DCoeh
         V9uRX94y68u4ZJj997PNaMkFpz6xe0hA4g15RV9tBEpsxkgYCl1HGbJtDEJPLkpYfW6w
         SPzzVk9Mb47dDzqkqeUryCFi60J92UIjokTiJIZtq/mhB8pcxdKsCQ40mhkfM3Mw6mhM
         DJ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=+oS2bWla/ptzYMItLrPppbVG1Ger1LonrKp81nNPpN8=;
        b=2+PkQwgAKpyWGlmT1VTxStmXKwc438GJAOzb7kH1y+/YV+hQhwpr0sB302mUXp4czS
         sp9M4g3/HuwZRxx/ulVQmL0tCMaa9l4+Y5OQVSPH4bsKZrPOhxn6uSZGqf2pbtix3Ayx
         6T00obSwtmZ/4RDxqEpOYmXlttaBsTm7LrsHMrFl84oyalN/5/BLsGat82i4kV2+8HNh
         4x6kKJL0piWiiUIuO0Jw/NqOmXotmnvOWGhIlYSACPBkma+taQb6j0NiXEIzg3A70tg0
         FOfQ/D+I/ggrDX7AG049Juux9BVXzB94aZnq2I12s3+X5l8T6iFQxSwJrUXggSWa20sU
         V8dQ==
X-Gm-Message-State: AOAM530STXSmG2K6vvs7T3qrQdJH4TsI3caz3dr5n70fuJglVurZZzVs
        5nPe4TzrPbytIrkACNNIcon1hw==
X-Google-Smtp-Source: ABdhPJxST1H0NP+HIpvAJmYeC2IMaUeaSnT2v6L5kGxoYjfzXqF8HxjJg0i6gjh5N74d3gsuxn21yA==
X-Received: by 2002:a17:902:b210:b0:14f:d0ff:46bb with SMTP id t16-20020a170902b21000b0014fd0ff46bbmr10514714plr.47.1647008188259;
        Fri, 11 Mar 2022 06:16:28 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ip13-20020a17090b314d00b001bfaa1f060bsm10445598pjb.5.2022.03.11.06.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 06:16:27 -0800 (PST)
Message-ID: <84310ba2-a413-22f4-1349-59a09f4851a1@kernel.dk>
Date:   Fri, 11 Mar 2022 07:16:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Song Liu <song@kernel.org>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, stable@vger.kernel.org,
        Larkin Lowrey <llowrey@nuclearwinter.com>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
References: <20220309064209.4169303-1-song@kernel.org>
 <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
 <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk>
 <CAPhsuW7zdYZqxaJ7SOWdnVOx-cASSoXS4OwtWVbms_jOHNh=Kw@mail.gmail.com>
 <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk>
In-Reply-To: <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/22 5:07 PM, Jens Axboe wrote:
> In any case, just doing larger reads would likely help quite a bit, but
> would still be nice to get to the bottom of why we're not seeing the
> level of merging we expect.

Song, can you try this one? It'll do the dispatch in a somewhat saner
fashion, bundling identical queues. And we'll keep iterating the plug
list for a merge if we have multiple disks, until we've seen a queue
match and checked.


diff --git a/block/blk-merge.c b/block/blk-merge.c
index 0e871d4e7cb8..68b623d00db5 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -1073,12 +1073,20 @@ bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
 	if (!plug || rq_list_empty(plug->mq_list))
 		return false;
 
-	/* check the previously added entry for a quick merge attempt */
-	rq = rq_list_peek(&plug->mq_list);
-	if (rq->q == q) {
-		if (blk_attempt_bio_merge(q, rq, bio, nr_segs, false) ==
-				BIO_MERGE_OK)
-			return true;
+	rq_list_for_each(&plug->mq_list, rq) {
+		if (rq->q == q) {
+			if (blk_attempt_bio_merge(q, rq, bio, nr_segs, false) ==
+			    BIO_MERGE_OK)
+				return true;
+			break;
+		}
+
+		/*
+		 * Only keep iterating plug list for merges if we have multiple
+		 * queues
+		 */
+		if (!plug->multiple_queues)
+			break;
 	}
 	return false;
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index bb263abbb40f..9c784262fd6b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2576,13 +2576,36 @@ static void __blk_mq_flush_plug_list(struct request_queue *q,
 	q->mq_ops->queue_rqs(&plug->mq_list);
 }
 
+static void blk_mq_dispatch_plug_list(struct blk_plug *plug, bool from_sched)
+{
+	struct blk_mq_hw_ctx *this_hctx = NULL;
+	struct blk_mq_ctx *this_ctx = NULL;
+	struct request *requeue_list = NULL;
+	unsigned int depth = 0;
+	LIST_HEAD(list);
+
+	do {
+		struct request *rq = rq_list_pop(&plug->mq_list);
+
+		if (!this_hctx) {
+			this_hctx = rq->mq_hctx;
+			this_ctx = rq->mq_ctx;
+		} else if (this_hctx != rq->mq_hctx || this_ctx != rq->mq_ctx) {
+			rq_list_add(&requeue_list, rq);
+			continue;
+		}
+		list_add_tail(&rq->queuelist, &list);
+		depth++;
+	} while (!rq_list_empty(plug->mq_list));
+
+	plug->mq_list = requeue_list;
+	trace_block_unplug(this_hctx->queue, depth, !from_sched);
+	blk_mq_sched_insert_requests(this_hctx, this_ctx, &list, from_sched);
+}
+
 void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 {
-	struct blk_mq_hw_ctx *this_hctx;
-	struct blk_mq_ctx *this_ctx;
 	struct request *rq;
-	unsigned int depth;
-	LIST_HEAD(list);
 
 	if (rq_list_empty(plug->mq_list))
 		return;
@@ -2618,35 +2641,9 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 			return;
 	}
 
-	this_hctx = NULL;
-	this_ctx = NULL;
-	depth = 0;
 	do {
-		rq = rq_list_pop(&plug->mq_list);
-
-		if (!this_hctx) {
-			this_hctx = rq->mq_hctx;
-			this_ctx = rq->mq_ctx;
-		} else if (this_hctx != rq->mq_hctx || this_ctx != rq->mq_ctx) {
-			trace_block_unplug(this_hctx->queue, depth,
-						!from_schedule);
-			blk_mq_sched_insert_requests(this_hctx, this_ctx,
-						&list, from_schedule);
-			depth = 0;
-			this_hctx = rq->mq_hctx;
-			this_ctx = rq->mq_ctx;
-
-		}
-
-		list_add(&rq->queuelist, &list);
-		depth++;
+		blk_mq_dispatch_plug_list(plug, from_schedule);
 	} while (!rq_list_empty(plug->mq_list));
-
-	if (!list_empty(&list)) {
-		trace_block_unplug(this_hctx->queue, depth, !from_schedule);
-		blk_mq_sched_insert_requests(this_hctx, this_ctx, &list,
-						from_schedule);
-	}
 }
 
 void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,

-- 
Jens Axboe

