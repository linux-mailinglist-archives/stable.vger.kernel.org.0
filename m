Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE95232E293
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 07:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbhCEGzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 01:55:33 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:55565 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229457AbhCEGzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 01:55:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UQWlMF8_1614927329;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQWlMF8_1614927329)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Mar 2021 14:55:30 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, jefflexu@linux.alibaba.com,
        snitzer@redhat.com
Subject: [PATCH 4.19.y 3/5] dm table: fix partial completion iterate_devices based device capability checks
Date:   Fri,  5 Mar 2021 14:55:24 +0800
Message-Id: <20210305065526.72663-4-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210305065526.72663-1-jefflexu@linux.alibaba.com>
References: <1614606251118245@kroah.com>
 <20210305065526.72663-1-jefflexu@linux.alibaba.com>
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
index 5a94e6dc0b70..1f745d371957 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1772,18 +1772,18 @@ static int queue_no_sg_merge(struct dm_target *ti, struct dm_dev *dev,
 	return q && test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags);
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

