Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE71B331D68
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 04:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbhCIDVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 22:21:04 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:25222 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229573AbhCIDUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 22:20:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UR.n2Sq_1615260026;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UR.n2Sq_1615260026)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 09 Mar 2021 11:20:26 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, jefflexu@linux.alibaba.com
Subject: [PATCH v2 4.9 2/2] dm table: fix DAX iterate_devices based device capability checks
Date:   Tue,  9 Mar 2021 11:20:23 +0800
Message-Id: <20210309032023.98465-3-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210309032023.98465-1-jefflexu@linux.alibaba.com>
References: <20210309032023.98465-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 5b0fab508992c2e120971da658ce80027acbc405 upstream.

Fix dm_table_supports_dax() and invert logic of both
iterate_devices_callout_fn so that all devices' DAX capabilities are
properly checked.

Fixes: 545ed20e6df6 ("dm: add infrastructure for DAX support")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[jeffle: no dax write cache, no dax synchronous]
---
 drivers/md/dm-table.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 1728e3638136..4fc68c00c231 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -848,12 +848,12 @@ void dm_table_set_type(struct dm_table *t, unsigned type)
 }
 EXPORT_SYMBOL_GPL(dm_table_set_type);
 
-static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
-			       sector_t start, sector_t len, void *data)
+static int device_not_dax_capable(struct dm_target *ti, struct dm_dev *dev,
+				  sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 
-	return q && blk_queue_dax(q);
+	return q && !blk_queue_dax(q);
 }
 
 static bool dm_table_supports_dax(struct dm_table *t)
@@ -869,7 +869,7 @@ static bool dm_table_supports_dax(struct dm_table *t)
 			return false;
 
 		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, device_supports_dax, NULL))
+		    ti->type->iterate_devices(ti, device_not_dax_capable, NULL))
 			return false;
 	}
 
-- 
2.27.0

