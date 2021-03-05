Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D44B32E2A1
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 07:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbhCEG52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 01:57:28 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:33247 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229517AbhCEG51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 01:57:27 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UQVykpi_1614927445;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQVykpi_1614927445)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Mar 2021 14:57:25 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, jefflexu@linux.alibaba.com,
        snitzer@redhat.com
Subject: [PATCH 5.4.y 2/4] dm table: fix partial completion iterate_devices based device capability checks
Date:   Fri,  5 Mar 2021 14:57:20 +0800
Message-Id: <20210305065722.73504-3-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210305065722.73504-1-jefflexu@linux.alibaba.com>
References: <161460625264244@kroah.com>
 <20210305065722.73504-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Similar to commit a4c8dd9c2d09 ("dm table: fix iterate_devices based
device capability checks"), fix partial completion capability check and
invert logic of the corresponding iterate_devices_callout_fn so that all
devices' partial completion capabilities are properly checked.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Fixes: 22c11858e800 ("dm: introduce DM_TYPE_NVME_BIO_BASED")
---
 drivers/md/dm-table.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index bf704d238662..c470e174e686 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1748,18 +1748,18 @@ static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
 	return q && !blk_queue_add_random(q);
 }
 
-static int device_no_partial_completion(struct dm_target *ti, struct dm_dev *dev,
+static int device_is_partial_completion(struct dm_target *ti, struct dm_dev *dev,
 					sector_t start, sector_t len, void *data)
 {
 	char b[BDEVNAME_SIZE];
 
 	/* For now, NVMe devices are the only devices of this class */
-	return (strncmp(bdevname(dev->bdev, b), "nvme", 4) == 0);
+	return (strncmp(bdevname(dev->bdev, b), "nvme", 4) != 0);
 }
 
 static bool dm_table_does_not_support_partial_completion(struct dm_table *t)
 {
-	return dm_table_all_devices_attribute(t, device_no_partial_completion);
+	return !dm_table_any_dev_attr(t, device_is_partial_completion);
 }
 
 static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
-- 
2.27.0

