Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA013A8580
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbhFOPz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232386AbhFOPx4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:53:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D5956191F;
        Tue, 15 Jun 2021 15:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772243;
        bh=RxjF1xbG9ANpsK/YTtQljWk3fyHQrVucUpRieOFd7Ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CIWMzKbpe84ImZqwk+1h/nhdBSJabyQKMOzWVKS7XIdOwzjjYe2BaxMMwCVqgfWdi
         ENmnOCttkflNCfVOJIfGM73Qamn4jCwpcZXzFOIET1F3x35Y4F0crXzx/tP6EMLQ5H
         lWgUQBLEkoZOYRpsNSL7eSNZswDomH5w+sNXWsntPedjImesaHIVVxuzH8Rt/xN2In
         b1Uz5jOi0Ekzu8WgSaLt8DfD37jpdkyy0IHnXPZKLD/cXU2GGwQTGG633/jfvCPh18
         nMiyRVUzJvUkVp2EU3SjJ6FSgiKZkaJMd1mDrx2HMQOwkNTfu92Bw9HMAMd797u88n
         lYywdHV6ew/Lg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/5] scsi: core: Fix error handling of scsi_host_alloc()
Date:   Tue, 15 Jun 2021 11:50:36 -0400
Message-Id: <20210615155039.63348-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615155039.63348-1-sashal@kernel.org>
References: <20210615155039.63348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 66a834d092930cf41d809c0e989b13cd6f9ca006 ]

After device is initialized via device_initialize(), or its name is set via
dev_set_name(), the device has to be freed via put_device().  Otherwise
device name will be leaked because it is allocated dynamically in
dev_set_name().

Fix the leak by replacing kfree() with put_device(). Since
scsi_host_dev_release() properly handles IDA and kthread removal, remove
special-casing these from the error handling as well.

Link: https://lore.kernel.org/r/20210602133029.2864069-2-ming.lei@redhat.com
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.de>
Tested-by: John Garry <john.garry@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 258a3f9a2519..5722ee66d3aa 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -421,8 +421,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	mutex_init(&shost->scan_mutex);
 
 	index = ida_simple_get(&host_index_ida, 0, 0, GFP_KERNEL);
-	if (index < 0)
-		goto fail_kfree;
+	if (index < 0) {
+		kfree(shost);
+		return NULL;
+	}
 	shost->host_no = index;
 
 	shost->dma_channel = 0xff;
@@ -509,7 +511,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 		shost_printk(KERN_WARNING, shost,
 			"error handler thread failed to spawn, error = %ld\n",
 			PTR_ERR(shost->ehandler));
-		goto fail_index_remove;
+		goto fail;
 	}
 
 	shost->tmf_work_q = alloc_workqueue("scsi_tmf_%d",
@@ -518,17 +520,18 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	if (!shost->tmf_work_q) {
 		shost_printk(KERN_WARNING, shost,
 			     "failed to create tmf workq\n");
-		goto fail_kthread;
+		goto fail;
 	}
 	scsi_proc_hostdir_add(shost->hostt);
 	return shost;
+ fail:
+	/*
+	 * Host state is still SHOST_CREATED and that is enough to release
+	 * ->shost_gendev. scsi_host_dev_release() will free
+	 * dev_name(&shost->shost_dev).
+	 */
+	put_device(&shost->shost_gendev);
 
- fail_kthread:
-	kthread_stop(shost->ehandler);
- fail_index_remove:
-	ida_simple_remove(&host_index_ida, shost->host_no);
- fail_kfree:
-	kfree(shost);
 	return NULL;
 }
 EXPORT_SYMBOL(scsi_host_alloc);
-- 
2.30.2

