Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E9343FF0
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390806AbfFMQBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731421AbfFMIsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:48:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E027206BA;
        Thu, 13 Jun 2019 08:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415700;
        bh=E5UbYvVCXRmNxOfHlKZINw1XeuPFmN2QSPmi70zTzmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=toP3uT9MGiNwnGprHTwFBW5ZS0HC9svQG7e3TfAAHH4D8nhnGvSHIxWmoGuKk0rZd
         WVsWJnEUuIGtTlZll3LhX0TGy4Ie3BzfQEh4I4t0z7MQ+LrsqlwUsQ6Eol/NZVtYvh
         DlkuTY15mb+CdsBDkjS+hdJNp4rQvIPKjUBZGGBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongli Zhang <dongli.zhang@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Subject: [PATCH 5.1 070/155] blk-mq: move cancel of requeue_work into blk_mq_release
Date:   Thu, 13 Jun 2019 10:33:02 +0200
Message-Id: <20190613075656.897201625@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fbc2a15e3433058582e5635aabe48a3011a644a8 ]

With holding queue's kobject refcount, it is safe for driver
to schedule requeue. However, blk_mq_kick_requeue_list() may
be called after blk_sync_queue() is done because of concurrent
requeue activities, then requeue work may not be completed when
freeing queue, and kernel oops is triggered.

So moving the cancel of requeue_work into blk_mq_release() for
avoiding race between requeue and freeing queue.

Cc: Dongli Zhang <dongli.zhang@oracle.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: linux-scsi@vger.kernel.org,
Cc: Martin K . Petersen <martin.petersen@oracle.com>,
Cc: Christoph Hellwig <hch@lst.de>,
Cc: James E . J . Bottomley <jejb@linux.vnet.ibm.com>,
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 1 -
 block/blk-mq.c   | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b375cfea024c..2dd94b3e9ece 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -237,7 +237,6 @@ void blk_sync_queue(struct request_queue *q)
 		struct blk_mq_hw_ctx *hctx;
 		int i;
 
-		cancel_delayed_work_sync(&q->requeue_work);
 		queue_for_each_hw_ctx(q, hctx, i)
 			cancel_delayed_work_sync(&hctx->run_work);
 	}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8a41cc5974fe..11efca3534ad 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2666,6 +2666,8 @@ void blk_mq_release(struct request_queue *q)
 	struct blk_mq_hw_ctx *hctx;
 	unsigned int i;
 
+	cancel_delayed_work_sync(&q->requeue_work);
+
 	/* hctx kobj stays in hctx */
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (!hctx)
-- 
2.20.1



