Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6C7F17FD81
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgCJN1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:27:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:32880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729087AbgCJMy3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:54:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F2CB20674;
        Tue, 10 Mar 2020 12:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844868;
        bh=Gi8TD+6W9+yKdNB018nsuFUxsWYt6po2L8iD2RX6/rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LD1dFgrq4tVrCUWuO0Bmj6s2rWpbwjhb52uu53i2EFUMC7ZVeF9MzPP8jzxOetE7a
         hlRy3n/nwOcSXL1pYlpq6nDXdtmOQq3W09NG6czgYbUW/jFAWjRZ074NXWFV6jlcgL
         1F+crthHVlwZyQIZdWJWKOji21ej3SIAqjcNzqBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 111/168] dm: fix congested_fn for request-based device
Date:   Tue, 10 Mar 2020 13:39:17 +0100
Message-Id: <20200310123646.632245161@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

commit 974f51e8633f0f3f33e8f86bbb5ae66758aa63c7 upstream.

We neither assign congested_fn for requested-based blk-mq device nor
implement it correctly. So fix both.

Also, remove incorrect comment from dm_init_normal_md_queue and rename
it to dm_init_congested_fn.

Fixes: 4aa9c692e052 ("bdi: separate out congested state into a separate struct")
Cc: stable@vger.kernel.org
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1809,7 +1809,8 @@ static int dm_any_congested(void *conges
 			 * With request-based DM we only need to check the
 			 * top-level queue for congestion.
 			 */
-			r = md->queue->backing_dev_info->wb.state & bdi_bits;
+			struct backing_dev_info *bdi = md->queue->backing_dev_info;
+			r = bdi->wb.congested->state & bdi_bits;
 		} else {
 			map = dm_get_live_table_fast(md);
 			if (map)
@@ -1875,15 +1876,6 @@ static const struct dax_operations dm_da
 
 static void dm_wq_work(struct work_struct *work);
 
-static void dm_init_normal_md_queue(struct mapped_device *md)
-{
-	/*
-	 * Initialize aspects of queue that aren't relevant for blk-mq
-	 */
-	md->queue->backing_dev_info->congested_data = md;
-	md->queue->backing_dev_info->congested_fn = dm_any_congested;
-}
-
 static void cleanup_mapped_device(struct mapped_device *md)
 {
 	if (md->wq)
@@ -2270,6 +2262,12 @@ struct queue_limits *dm_get_queue_limits
 }
 EXPORT_SYMBOL_GPL(dm_get_queue_limits);
 
+static void dm_init_congested_fn(struct mapped_device *md)
+{
+	md->queue->backing_dev_info->congested_data = md;
+	md->queue->backing_dev_info->congested_fn = dm_any_congested;
+}
+
 /*
  * Setup the DM device's queue based on md's type
  */
@@ -2286,11 +2284,12 @@ int dm_setup_md_queue(struct mapped_devi
 			DMERR("Cannot initialize queue for request-based dm-mq mapped device");
 			return r;
 		}
+		dm_init_congested_fn(md);
 		break;
 	case DM_TYPE_BIO_BASED:
 	case DM_TYPE_DAX_BIO_BASED:
 	case DM_TYPE_NVME_BIO_BASED:
-		dm_init_normal_md_queue(md);
+		dm_init_congested_fn(md);
 		break;
 	case DM_TYPE_NONE:
 		WARN_ON_ONCE(true);


