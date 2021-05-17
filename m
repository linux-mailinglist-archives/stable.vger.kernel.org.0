Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6161F3831D5
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240661AbhEQOlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240868AbhEQOjU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:39:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D67C061937;
        Mon, 17 May 2021 14:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261102;
        bh=PlpePXivunUZg8exTB6V4+pEmH7TIZv8X5nGFEjG21k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QyTbcF+c4KJYDLNe/ibHVysBAiSuAvCVAyxSS2xufU3epH8xjstxTpm5sElK8F5lc
         AfMdJZh60EjCx3npIWX80LA51aY7nWQicFdr+2v1ZhOF8Pid39RkNMYxXigsgUMjXd
         IhYIV6UIU6RRB4XiGpHQXzdONvlzBJ7EnIijWeio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yanhui Ma <yama@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        kashyap.desai@broadcom.com, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 306/363] blk-mq: plug request for shared sbitmap
Date:   Mon, 17 May 2021 16:02:52 +0200
Message-Id: <20210517140312.937872656@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 03f26d8f11403295de445b6e4e0e57ac57755791 ]

In case of shared sbitmap, request won't be held in plug list any more
sine commit 32bc15afed04 ("blk-mq: Facilitate a shared sbitmap per
tagset"), this way makes request merge from flush plug list & batching
submission not possible, so cause performance regression.

Yanhui reports performance regression when running sequential IO
test(libaio, 16 jobs, 8 depth for each job) in VM, and the VM disk
is emulated with image stored on xfs/megaraid_sas.

Fix the issue by recovering original behavior to allow to hold request
in plug list.

Cc: Yanhui Ma <yama@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: kashyap.desai@broadcom.com
Fixes: 32bc15afed04 ("blk-mq: Facilitate a shared sbitmap per tagset")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20210514022052.1047665-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d4d7c1caa439..c0b740be62ad 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2216,8 +2216,9 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio)
 		/* Bypass scheduler for flush requests */
 		blk_insert_flush(rq);
 		blk_mq_run_hw_queue(data.hctx, true);
-	} else if (plug && (q->nr_hw_queues == 1 || q->mq_ops->commit_rqs ||
-				!blk_queue_nonrot(q))) {
+	} else if (plug && (q->nr_hw_queues == 1 ||
+		   blk_mq_is_sbitmap_shared(rq->mq_hctx->flags) ||
+		   q->mq_ops->commit_rqs || !blk_queue_nonrot(q))) {
 		/*
 		 * Use plugging if we have a ->commit_rqs() hook as well, as
 		 * we know the driver uses bd->last in a smart fashion.
-- 
2.30.2



