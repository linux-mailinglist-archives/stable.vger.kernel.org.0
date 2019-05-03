Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5039B130D9
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 17:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfECPEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 11:04:38 -0400
Received: from smtp03.citrix.com ([162.221.156.55]:19873 "EHLO
        SMTP03.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbfECPEi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 11:04:38 -0400
X-IronPort-AV: E=Sophos;i="5.60,426,1549929600"; 
   d="scan'208";a="85072069"
From:   Roger Pau Monne <roger.pau@citrix.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Roger Pau Monne <roger.pau@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, <xen-devel@lists.xenproject.org>,
        <linux-block@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH] xen-blkfront: switch kcalloc to kvcalloc for large array allocation
Date:   Fri, 3 May 2019 17:04:01 +0200
Message-ID: <20190503150401.15904-1-roger.pau@citrix.com>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There's no reason to request physically contiguous memory for those
allocations.

Reported-by: Ian Jackson <ian.jackson@citrix.com>
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
---
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: xen-devel@lists.xenproject.org
Cc: linux-block@vger.kernel.org
Cc: stable@vger.kernel.org
---
 drivers/block/xen-blkfront.c | 38 ++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index d43a5677ccbc..a74d03913822 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1310,11 +1310,11 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
 		}
 
 free_shadow:
-		kfree(rinfo->shadow[i].grants_used);
+		kvfree(rinfo->shadow[i].grants_used);
 		rinfo->shadow[i].grants_used = NULL;
-		kfree(rinfo->shadow[i].indirect_grants);
+		kvfree(rinfo->shadow[i].indirect_grants);
 		rinfo->shadow[i].indirect_grants = NULL;
-		kfree(rinfo->shadow[i].sg);
+		kvfree(rinfo->shadow[i].sg);
 		rinfo->shadow[i].sg = NULL;
 	}
 
@@ -1353,7 +1353,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 	for (i = 0; i < info->nr_rings; i++)
 		blkif_free_ring(&info->rinfo[i]);
 
-	kfree(info->rinfo);
+	kvfree(info->rinfo);
 	info->rinfo = NULL;
 	info->nr_rings = 0;
 }
@@ -1914,9 +1914,9 @@ static int negotiate_mq(struct blkfront_info *info)
 	if (!info->nr_rings)
 		info->nr_rings = 1;
 
-	info->rinfo = kcalloc(info->nr_rings,
-			      sizeof(struct blkfront_ring_info),
-			      GFP_KERNEL);
+	info->rinfo = kvcalloc(info->nr_rings,
+			       sizeof(struct blkfront_ring_info),
+			       GFP_KERNEL);
 	if (!info->rinfo) {
 		xenbus_dev_fatal(info->xbdev, -ENOMEM, "allocating ring_info structure");
 		info->nr_rings = 0;
@@ -2232,17 +2232,17 @@ static int blkfront_setup_indirect(struct blkfront_ring_info *rinfo)
 
 	for (i = 0; i < BLK_RING_SIZE(info); i++) {
 		rinfo->shadow[i].grants_used =
-			kcalloc(grants,
-				sizeof(rinfo->shadow[i].grants_used[0]),
-				GFP_NOIO);
-		rinfo->shadow[i].sg = kcalloc(psegs,
-					      sizeof(rinfo->shadow[i].sg[0]),
-					      GFP_NOIO);
+			kvcalloc(grants,
+				 sizeof(rinfo->shadow[i].grants_used[0]),
+				 GFP_NOIO);
+		rinfo->shadow[i].sg = kvcalloc(psegs,
+					       sizeof(rinfo->shadow[i].sg[0]),
+					       GFP_NOIO);
 		if (info->max_indirect_segments)
 			rinfo->shadow[i].indirect_grants =
-				kcalloc(INDIRECT_GREFS(grants),
-					sizeof(rinfo->shadow[i].indirect_grants[0]),
-					GFP_NOIO);
+				kvcalloc(INDIRECT_GREFS(grants),
+					 sizeof(rinfo->shadow[i].indirect_grants[0]),
+					 GFP_NOIO);
 		if ((rinfo->shadow[i].grants_used == NULL) ||
 			(rinfo->shadow[i].sg == NULL) ||
 		     (info->max_indirect_segments &&
@@ -2256,11 +2256,11 @@ static int blkfront_setup_indirect(struct blkfront_ring_info *rinfo)
 
 out_of_memory:
 	for (i = 0; i < BLK_RING_SIZE(info); i++) {
-		kfree(rinfo->shadow[i].grants_used);
+		kvfree(rinfo->shadow[i].grants_used);
 		rinfo->shadow[i].grants_used = NULL;
-		kfree(rinfo->shadow[i].sg);
+		kvfree(rinfo->shadow[i].sg);
 		rinfo->shadow[i].sg = NULL;
-		kfree(rinfo->shadow[i].indirect_grants);
+		kvfree(rinfo->shadow[i].indirect_grants);
 		rinfo->shadow[i].indirect_grants = NULL;
 	}
 	if (!list_empty(&rinfo->indirect_pages)) {
-- 
2.17.2 (Apple Git-113)

