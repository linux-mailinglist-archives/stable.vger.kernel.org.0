Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B714269B6
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242750AbhJHLkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243266AbhJHLjH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:39:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F5FA61555;
        Fri,  8 Oct 2021 11:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692801;
        bh=QiUPzBAK7jBE8jLKyJk8nUc0GTtaiCmv0Beg7KyTHoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UocTBchsqe3k00PqVHHG8XHFM/vUr8odCZYtCfUcYpAzySCwu/ITBMDrC2pPqFA1d
         25lzcj/ZitN911en/dUzwFWiGCDtqsHmJSydIvZ7rgKoLQ4r0+Lrnaa/fMNhnUjb+f
         UTzaEEKO+isacFbzj1EAWN9SmCYxlv24U1bX8M6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        tj@kernel.org, Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 37/48] block: dont call rq_qos_ops->done_bio if the bio isnt tracked
Date:   Fri,  8 Oct 2021 13:28:13 +0200
Message-Id: <20211008112721.273391677@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit a647a524a46736786c95cdb553a070322ca096e3 ]

rq_qos framework is only applied on request based driver, so:

1) rq_qos_done_bio() needn't to be called for bio based driver

2) rq_qos_done_bio() needn't to be called for bio which isn't tracked,
such as bios ended from error handling code.

Especially in bio_endio():

1) request queue is referred via bio->bi_bdev->bd_disk->queue, which
may be gone since request queue refcount may not be held in above two
cases

2) q->rq_qos may be freed in blk_cleanup_queue() when calling into
__rq_qos_done_bio()

Fix the potential kernel panic by not calling rq_qos_ops->done_bio if
the bio isn't tracked. This way is safe because both ioc_rqos_done_bio()
and blkcg_iolatency_done_bio() are nop if the bio isn't tracked.

Reported-by: Yu Kuai <yukuai3@huawei.com>
Cc: tj@kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20210924110704.1541818-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index d95e3456ba0c..52548c487883 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1396,7 +1396,7 @@ again:
 	if (!bio_integrity_endio(bio))
 		return;
 
-	if (bio->bi_bdev)
+	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACKED))
 		rq_qos_done_bio(bio->bi_bdev->bd_disk->queue, bio);
 
 	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACE_COMPLETION)) {
-- 
2.33.0



