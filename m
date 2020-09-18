Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9C526F465
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbgIRDOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:14:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgIRCBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A390B2311C;
        Fri, 18 Sep 2020 02:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394502;
        bh=GCpIlk45KEdWE+TgcSSh2KmZtDCtTFvs1FUmXMqcwe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfiUt2BGvX2cJC1I9GjTCELDbpdMkv2RQVsjkCwQGHkNI56eHhP5nsqpNO8mCHCRj
         erHZ5Gn4PNdkQl+fU0NVXDxAzLgN3WMc3tW9um8N7J163uJbp6x1z/F5utJ2oRjISI
         Ue3kpCZb1IbpTrXO05nbViiFFrVLLeJ4v9NtKbck=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@redhat.com>, Sasha Levin <sashal@kernel.org>,
        dm-devel@redhat.com, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 026/330] dm table: do not allow request-based DM to stack on partitions
Date:   Thu, 17 Sep 2020 21:56:06 -0400
Message-Id: <20200918020110.2063155-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

[ Upstream commit 6ba01df72b4b63a26b4977790f58d8f775d2992c ]

Partitioned request-based devices cannot be used as underlying devices
for request-based DM because no partition offsets are added to each
incoming request.  As such, until now, stacking on partitioned devices
would _always_ result in data corruption (e.g. wiping the partition
table, writing to other partitions, etc).  Fix this by disallowing
request-based stacking on partitions.

While at it, since all .request_fn support has been removed from block
core, remove legacy dm-table code that differentiated between blk-mq and
.request_fn request-based.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 52e049554f5cd..2ae0c19137667 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -918,21 +918,15 @@ bool dm_table_supports_dax(struct dm_table *t,
 
 static bool dm_table_does_not_support_partial_completion(struct dm_table *t);
 
-struct verify_rq_based_data {
-	unsigned sq_count;
-	unsigned mq_count;
-};
-
-static int device_is_rq_based(struct dm_target *ti, struct dm_dev *dev,
-			      sector_t start, sector_t len, void *data)
+static int device_is_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
+				  sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q = bdev_get_queue(dev->bdev);
-	struct verify_rq_based_data *v = data;
+	struct block_device *bdev = dev->bdev;
+	struct request_queue *q = bdev_get_queue(bdev);
 
-	if (queue_is_mq(q))
-		v->mq_count++;
-	else
-		v->sq_count++;
+	/* request-based cannot stack on partitions! */
+	if (bdev != bdev->bd_contains)
+		return false;
 
 	return queue_is_mq(q);
 }
@@ -941,7 +935,6 @@ static int dm_table_determine_type(struct dm_table *t)
 {
 	unsigned i;
 	unsigned bio_based = 0, request_based = 0, hybrid = 0;
-	struct verify_rq_based_data v = {.sq_count = 0, .mq_count = 0};
 	struct dm_target *tgt;
 	struct list_head *devices = dm_table_get_devices(t);
 	enum dm_queue_mode live_md_type = dm_get_md_type(t->md);
@@ -1045,14 +1038,10 @@ verify_rq_based:
 
 	/* Non-request-stackable devices can't be used for request-based dm */
 	if (!tgt->type->iterate_devices ||
-	    !tgt->type->iterate_devices(tgt, device_is_rq_based, &v)) {
+	    !tgt->type->iterate_devices(tgt, device_is_rq_stackable, NULL)) {
 		DMERR("table load rejected: including non-request-stackable devices");
 		return -EINVAL;
 	}
-	if (v.sq_count > 0) {
-		DMERR("table load rejected: not all devices are blk-mq request-stackable");
-		return -EINVAL;
-	}
 
 	return 0;
 }
-- 
2.25.1

