Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C97129BC32
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761420AbgJ0PnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:43:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800896AbgJ0PhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:37:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84C162225E;
        Tue, 27 Oct 2020 15:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813023;
        bh=DiH1HAZwXO36LxTGNXeKKd80sgNs5R3T2ja/pUZlFLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMNMzWTMO4lf1fyhta1XO2MF5Pf6WgIc3BFXEhxbRcRL+Y+MuXb4Aw/4/2XOYYNDO
         usQeTkJgf8i8Y20XvguD60AVpvaclgnaar/yZv4SXbYRBN2nFJhNtQthytGXw7qLAz
         ViN8IDed9wyaJ1Nrx6VGiFPrzv/zyS3qXn2Jilwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 381/757] dm: fix request-based DM to not bounce through indirect dm_submit_bio
Date:   Tue, 27 Oct 2020 14:50:31 +0100
Message-Id: <20201027135508.425400738@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

[ Upstream commit 681cc5e8667e8579a2da8fa4090c48a2d73fc3bb ]

It is unnecessary to force request-based DM to call into bio-based
dm_submit_bio (via indirect disk->fops->submit_bio) only to have it then
call blk_mq_submit_bio().

Fix this by establishing a request-based DM block_device_operations
(dm_rq_blk_dops, which doesn't have .submit_bio) and update
dm_setup_md_queue() to set md->disk->fops to it for
DM_TYPE_REQUEST_BASED.

Remove DM_TYPE_REQUEST_BASED conditional in dm_submit_bio and unexport
blk_mq_submit_bio.

Fixes: c62b37d96b6eb ("block: move ->make_request_fn to struct block_device_operations")
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c  |  1 -
 drivers/md/dm.c | 25 ++++++++++++-------------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index cdced4aca2e81..c27a61029cdd0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2264,7 +2264,6 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio)
 	blk_queue_exit(q);
 	return BLK_QC_T_NONE;
 }
-EXPORT_SYMBOL_GPL(blk_mq_submit_bio); /* only for request based dm */
 
 void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 		     unsigned int hctx_idx)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b060a28ff1c6d..9b005e144014f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1762,18 +1762,6 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
 	int srcu_idx;
 	struct dm_table *map;
 
-	if (dm_get_md_type(md) == DM_TYPE_REQUEST_BASED) {
-		/*
-		 * We are called with a live reference on q_usage_counter, but
-		 * that one will be released as soon as we return.  Grab an
-		 * extra one as blk_mq_submit_bio expects to be able to consume
-		 * a reference (which lives until the request is freed in case a
-		 * request is allocated).
-		 */
-		percpu_ref_get(&bio->bi_disk->queue->q_usage_counter);
-		return blk_mq_submit_bio(bio);
-	}
-
 	map = dm_get_live_table(md, &srcu_idx);
 
 	/* if we're suspended, we have to queue this io for later */
@@ -1843,6 +1831,7 @@ static int next_free_minor(int *minor)
 }
 
 static const struct block_device_operations dm_blk_dops;
+static const struct block_device_operations dm_rq_blk_dops;
 static const struct dax_operations dm_dax_ops;
 
 static void dm_wq_work(struct work_struct *work);
@@ -2242,9 +2231,10 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 
 	switch (type) {
 	case DM_TYPE_REQUEST_BASED:
+		md->disk->fops = &dm_rq_blk_dops;
 		r = dm_mq_init_request_queue(md, t);
 		if (r) {
-			DMERR("Cannot initialize queue for request-based dm-mq mapped device");
+			DMERR("Cannot initialize queue for request-based dm mapped device");
 			return r;
 		}
 		break;
@@ -3227,6 +3217,15 @@ static const struct block_device_operations dm_blk_dops = {
 	.owner = THIS_MODULE
 };
 
+static const struct block_device_operations dm_rq_blk_dops = {
+	.open = dm_blk_open,
+	.release = dm_blk_close,
+	.ioctl = dm_blk_ioctl,
+	.getgeo = dm_blk_getgeo,
+	.pr_ops = &dm_pr_ops,
+	.owner = THIS_MODULE
+};
+
 static const struct dax_operations dm_dax_ops = {
 	.direct_access = dm_dax_direct_access,
 	.dax_supported = dm_dax_supported,
-- 
2.25.1



