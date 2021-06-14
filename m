Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5463A6096
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhFNKfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232889AbhFNKeZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:34:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18D31613DE;
        Mon, 14 Jun 2021 10:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666723;
        bh=xibRKAsrqoqo4jpJALC329ZDUqJa3sA51jXzSLjKD3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vjh2Qq6aqYeHXcYWTYKYRPG+rYgk7WYzeuxBQT19Hho4kM1rIqWEIVrZXdFoxzuGt
         m0TQd2w7Bt9TJu77r9I99+10+UzHgHChT20USpHcegtNWkmstacFOENsm4oo4em/sR
         lTK73Bk0nlmFhPYWbRGYgKtn6UZtFBt1SPeafKW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.9 39/42] scsi: core: Fix error handling of scsi_host_alloc()
Date:   Mon, 14 Jun 2021 12:27:30 +0200
Message-Id: <20210614102643.956167995@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102642.700712386@linuxfoundation.org>
References: <20210614102642.700712386@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 66a834d092930cf41d809c0e989b13cd6f9ca006 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/hosts.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -421,8 +421,10 @@ struct Scsi_Host *scsi_host_alloc(struct
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
@@ -509,7 +511,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 		shost_printk(KERN_WARNING, shost,
 			"error handler thread failed to spawn, error = %ld\n",
 			PTR_ERR(shost->ehandler));
-		goto fail_index_remove;
+		goto fail;
 	}
 
 	shost->tmf_work_q = alloc_workqueue("scsi_tmf_%d",
@@ -518,17 +520,18 @@ struct Scsi_Host *scsi_host_alloc(struct
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


