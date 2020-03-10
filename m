Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC6817F9ED
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbgCJNBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729942AbgCJNBO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:01:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CADE2467D;
        Tue, 10 Mar 2020 13:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845273;
        bh=TgijbQx+j8pF/MwcM2OHeiCApkANqraS0PDS4F8Ts9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDki9ND7dXtOm30Lvozyc047LzdDAHIXDctTkLoTJbjy1yks6UPtded3fLPEOEnoV
         Yi/xHcTD0yech74t/dz9xp2s8zfyWkWOsthoOHh/ecfa8sObatxYwYqNniNtNak18n
         TiV622CaefpRVWFWG2nbGneIhlKkz7lsCkQSOOEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.5 125/189] dm: fix congested_fn for request-based device
Date:   Tue, 10 Mar 2020 13:39:22 +0100
Message-Id: <20200310123652.402156432@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
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
@@ -1788,7 +1788,8 @@ static int dm_any_congested(void *conges
 			 * With request-based DM we only need to check the
 			 * top-level queue for congestion.
 			 */
-			r = md->queue->backing_dev_info->wb.state & bdi_bits;
+			struct backing_dev_info *bdi = md->queue->backing_dev_info;
+			r = bdi->wb.congested->state & bdi_bits;
 		} else {
 			map = dm_get_live_table_fast(md);
 			if (map)
@@ -1854,15 +1855,6 @@ static const struct dax_operations dm_da
 
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
@@ -2249,6 +2241,12 @@ struct queue_limits *dm_get_queue_limits
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
@@ -2265,11 +2263,12 @@ int dm_setup_md_queue(struct mapped_devi
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


