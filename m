Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE91232E23A
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 07:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhCEGa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 01:30:57 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:59099 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229690AbhCEGa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 01:30:56 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UQWlIbk_1614925853;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQWlIbk_1614925853)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Mar 2021 14:30:54 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, jefflexu@linux.alibaba.com,
        snitzer@redhat.com
Subject: [PATCH 4.4.y 2/2] dm table: fix no_sg_merge iterate_devices based device capability checks
Date:   Fri,  5 Mar 2021 14:30:51 +0800
Message-Id: <20210305063051.51030-3-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210305063051.51030-1-jefflexu@linux.alibaba.com>
References: <161460624611368@kroah.com>
 <20210305063051.51030-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Similar to commit a4c8dd9c2d09 ("dm table: fix iterate_devices based
device capability checks"), fix NO_SG_MERGE capability check and invert
logic of the corresponding iterate_devices_callout_fn so that all
devices' NO_SG_MERGE capabilities are properly checked.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Fixes: 200612ec33e5 ("dm table: propagate QUEUE_FLAG_NO_SG_MERGE")
---
 drivers/md/dm-table.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 6580de65b81d..7ee520d4d216 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1436,12 +1436,12 @@ static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
 	return q && !blk_queue_add_random(q);
 }
 
-static int queue_supports_sg_merge(struct dm_target *ti, struct dm_dev *dev,
-				   sector_t start, sector_t len, void *data)
+static int queue_no_sg_merge(struct dm_target *ti, struct dm_dev *dev,
+			     sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 
-	return q && !test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags);
+	return q && test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags);
 }
 
 static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
@@ -1542,10 +1542,10 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (!dm_table_supports_write_same(t))
 		q->limits.max_write_same_sectors = 0;
 
-	if (dm_table_all_devices_attribute(t, queue_supports_sg_merge))
-		queue_flag_clear_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
-	else
+	if (dm_table_any_dev_attr(t, queue_no_sg_merge))
 		queue_flag_set_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
+	else
+		queue_flag_clear_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
 
 	dm_table_verify_integrity(t);
 
-- 
2.27.0

