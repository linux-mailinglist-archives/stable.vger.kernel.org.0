Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A70115C6B2
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgBMQC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:02:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728671AbgBMPYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:22 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10CD2246B5;
        Thu, 13 Feb 2020 15:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607462;
        bh=zH3x33qs0K8qoJGQE4wg2/9JdytOeTto6gC4iSRmVAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swBs68gz8UKr1tdHjkkzi+0QF9E1B+mkK428nusH2u9wa+dOIkD7P3s/JmJiTUjK4
         rxWofOyI+zQZ2HW3DvpcZdlRMziX8TW8kOPSBtTHOd4Z4UfWNb1BvYFQR/bSas5uyp
         OPjbRbijoEcGTrC+Eyt5ieTzKrDj1X3r76PsbhCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Bader <stefan.bader@canonical.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.9 112/116] dm: fix potential for q->make_request_fn NULL pointer
Date:   Thu, 13 Feb 2020 07:20:56 -0800
Message-Id: <20200213151925.429688133@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit 47ace7e012b9f7ad71d43ac9063d335ea3d6820b upstream.

Move blk_queue_make_request() to dm.c:alloc_dev() so that
q->make_request_fn is never NULL during the lifetime of a DM device
(even one that is created without a DM table).

Otherwise generic_make_request() will crash simply by doing:
  dmsetup create -n test
  mount /dev/dm-N /mnt

While at it, move ->congested_data initialization out of
dm.c:alloc_dev() and into the bio-based specific init method.

Reported-by: Stefan Bader <stefan.bader@canonical.com>
BugLink: https://bugs.launchpad.net/bugs/1860231
Fixes: ff36ab34583a ("dm: remove request-based logic from make_request_fn wrapper")
Depends-on: c12c9a3c3860c ("dm: various cleanups to md->queue initialization code")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[smb: adjusted for context and dm_init_md_queue() exitsting in older
      kernels, and congested_data embedded in backing_dev_info]
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1457,7 +1457,6 @@ void dm_init_md_queue(struct mapped_devi
 	 * - must do so here (in alloc_dev callchain) before queue is used
 	 */
 	md->queue->queuedata = md;
-	md->queue->backing_dev_info.congested_data = md;
 }
 
 void dm_init_normal_md_queue(struct mapped_device *md)
@@ -1468,6 +1467,7 @@ void dm_init_normal_md_queue(struct mapp
 	/*
 	 * Initialize aspects of queue that aren't relevant for blk-mq
 	 */
+	md->queue->backing_dev_info.congested_data = md;
 	md->queue->backing_dev_info.congested_fn = dm_any_congested;
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
 }
@@ -1555,6 +1555,12 @@ static struct mapped_device *alloc_dev(i
 		goto bad;
 
 	dm_init_md_queue(md);
+	/*
+	 * default to bio-based required ->make_request_fn until DM
+	 * table is loaded and md->type established. If request-based
+	 * table is loaded: blk-mq will override accordingly.
+	 */
+	blk_queue_make_request(md->queue, dm_make_request);
 
 	md->disk = alloc_disk_node(1, numa_node_id);
 	if (!md->disk)
@@ -1853,7 +1859,6 @@ int dm_setup_md_queue(struct mapped_devi
 	case DM_TYPE_BIO_BASED:
 	case DM_TYPE_DAX_BIO_BASED:
 		dm_init_normal_md_queue(md);
-		blk_queue_make_request(md->queue, dm_make_request);
 		/*
 		 * DM handles splitting bios as needed.  Free the bio_split bioset
 		 * since it won't be used (saves 1 process per bio-based DM device).


