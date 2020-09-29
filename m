Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19ED027C5A6
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgI2Lh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730091AbgI2Lh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6591E23F27;
        Tue, 29 Sep 2020 11:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379187;
        bh=Z7volDgXc2TCyPukQKLaVFuHy6dtRxpOhS0ltgZslLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKUKx7x9LVlrhhXVdj0kia77kPy3RRj1Y35ZjodBJwWfcoLYB1jgd4ck/UaXQ4E3f
         PABR8K1AxmfiEftqb3PzLEWme2lxI1QjXC3aU/DEQRrNDmeodUAOcUR57trklOpDSV
         wVxEdeLbknUoMHRG7BqI2KAkOQOSfqNWylIT45KY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/388] dm table: do not allow request-based DM to stack on partitions
Date:   Tue, 29 Sep 2020 12:55:55 +0200
Message-Id: <20200929110011.655247388@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index edc3660759131..13ad791126618 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -922,21 +922,15 @@ bool dm_table_supports_dax(struct dm_table *t,
 
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
@@ -945,7 +939,6 @@ static int dm_table_determine_type(struct dm_table *t)
 {
 	unsigned i;
 	unsigned bio_based = 0, request_based = 0, hybrid = 0;
-	struct verify_rq_based_data v = {.sq_count = 0, .mq_count = 0};
 	struct dm_target *tgt;
 	struct list_head *devices = dm_table_get_devices(t);
 	enum dm_queue_mode live_md_type = dm_get_md_type(t->md);
@@ -1049,14 +1042,10 @@ verify_rq_based:
 
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



