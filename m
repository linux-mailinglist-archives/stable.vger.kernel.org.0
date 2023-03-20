Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1003B6C1895
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbjCTPZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbjCTPZb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:25:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E0F367C6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:18:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60EF261575
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70876C433EF;
        Mon, 20 Mar 2023 15:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325520;
        bh=pt+NkFuX8/a4q7hUsBkx1I3oXIoC3ZeJEGymosVjHN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNDJ1G+i/D0P/b3QQnb3DY5QYeivTzQbSl/4BnRfshI+RZIKd29+hdhy2zB9g1bEK
         0GWliGvN3A7VpHlJKZksxYKCZsmQz1HIXSN0LjVEi+v7bttK86ref7+p0lUIbHlWO1
         KKPOvQWeYdLuydWolPsC1QCsrtgRIyxX5phC4ee0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 052/211] block: do not reverse request order when flushing plug list
Date:   Mon, 20 Mar 2023 15:53:07 +0100
Message-Id: <20230320145515.429110598@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 34e0a279a993debaff03158fc2fbf6a00c093643 ]

Commit 26fed4ac4eab ("block: flush plug based on hardware and software
queue order") changed flushing of plug list to submit requests one
device at a time. However while doing that it also started using
list_add_tail() instead of list_add() used previously thus effectively
submitting requests in reverse order. Also when forming a rq_list with
remaining requests (in case two or more devices are used), we
effectively reverse the ordering of the plug list for each device we
process. Submitting requests in reverse order has negative impact on
performance for rotational disks (when BFQ is not in use). We observe
10-25% regression in random 4k write throughput, as well as ~20%
regression in MariaDB OLTP benchmark on rotational storage on btrfs
filesystem.

Fix the problem by preserving ordering of the plug list when inserting
requests into the queuelist as well as by appending to requeue_list
instead of prepending to it.

Fixes: 26fed4ac4eab ("block: flush plug based on hardware and software queue order")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230313093002.11756-1-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c         | 5 +++--
 include/linux/blk-mq.h | 6 ++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b9e3b558367f1..c021fb05161b9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2743,6 +2743,7 @@ static void blk_mq_dispatch_plug_list(struct blk_plug *plug, bool from_sched)
 	struct blk_mq_hw_ctx *this_hctx = NULL;
 	struct blk_mq_ctx *this_ctx = NULL;
 	struct request *requeue_list = NULL;
+	struct request **requeue_lastp = &requeue_list;
 	unsigned int depth = 0;
 	LIST_HEAD(list);
 
@@ -2753,10 +2754,10 @@ static void blk_mq_dispatch_plug_list(struct blk_plug *plug, bool from_sched)
 			this_hctx = rq->mq_hctx;
 			this_ctx = rq->mq_ctx;
 		} else if (this_hctx != rq->mq_hctx || this_ctx != rq->mq_ctx) {
-			rq_list_add(&requeue_list, rq);
+			rq_list_add_tail(&requeue_lastp, rq);
 			continue;
 		}
-		list_add_tail(&rq->queuelist, &list);
+		list_add(&rq->queuelist, &list);
 		depth++;
 	} while (!rq_list_empty(plug->mq_list));
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 779fba613bd09..19ae71f3fb97d 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -228,6 +228,12 @@ static inline unsigned short req_get_ioprio(struct request *req)
 	*(listptr) = rq;				\
 } while (0)
 
+#define rq_list_add_tail(lastpptr, rq)	do {		\
+	(rq)->rq_next = NULL;				\
+	**(lastpptr) = rq;				\
+	*(lastpptr) = &rq->rq_next;			\
+} while (0)
+
 #define rq_list_pop(listptr)				\
 ({							\
 	struct request *__req = NULL;			\
-- 
2.39.2



