Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D84315BC02
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 10:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbgBMJtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 04:49:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39312 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbgBMJtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 04:49:31 -0500
Received: from 1.general.smb.uk.vpn ([10.172.193.28] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <stefan.bader@canonical.com>)
        id 1j2B7h-00050s-Et; Thu, 13 Feb 2020 09:49:29 +0000
From:   Stefan Bader <stefan.bader@canonical.com>
To:     stable@vger.kernel.org, snitzer@redhat.com
Subject: [PATCH 4.14.y] dm: fix potential for q->make_request_fn NULL pointer
Date:   Thu, 13 Feb 2020 10:49:26 +0100
Message-Id: <20200213094928.30487-2-stefan.bader@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200213094928.30487-1-stefan.bader@canonical.com>
References: <20200213094928.30487-1-stefan.bader@canonical.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

[ Upstream commit 47ace7e012b9f7ad71d43ac9063d335ea3d6820b ]
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
      kernels]
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/md/dm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a56008b2e7c2..02ba6849f89d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1647,7 +1647,6 @@ void dm_init_md_queue(struct mapped_device *md)
 	 * - must do so here (in alloc_dev callchain) before queue is used
 	 */
 	md->queue->queuedata = md;
-	md->queue->backing_dev_info->congested_data = md;
 }
 
 void dm_init_normal_md_queue(struct mapped_device *md)
@@ -1658,6 +1657,7 @@ void dm_init_normal_md_queue(struct mapped_device *md)
 	/*
 	 * Initialize aspects of queue that aren't relevant for blk-mq
 	 */
+	md->queue->backing_dev_info->congested_data = md;
 	md->queue->backing_dev_info->congested_fn = dm_any_congested;
 }
 
@@ -1750,6 +1750,12 @@ static struct mapped_device *alloc_dev(int minor)
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
@@ -2055,7 +2061,6 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 	case DM_TYPE_BIO_BASED:
 	case DM_TYPE_DAX_BIO_BASED:
 		dm_init_normal_md_queue(md);
-		blk_queue_make_request(md->queue, dm_make_request);
 		/*
 		 * DM handles splitting bios as needed.  Free the bio_split bioset
 		 * since it won't be used (saves 1 process per bio-based DM device).
-- 
2.17.1

