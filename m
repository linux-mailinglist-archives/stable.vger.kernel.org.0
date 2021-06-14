Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3A93A6346
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbhFNLLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234768AbhFNLJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:09:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30D3A6144C;
        Mon, 14 Jun 2021 10:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667584;
        bh=RH4EQxQ2TUvsfwUy4R7MqfP+T8OMT4TnkQWLRuy/yaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWzXFwFyjtKj8PObD/uxi5ttCEMSs1QvYxs2tmb/LIvlplbeBO3zc0HG6CVp+uou3
         p0iNyMXoUJzegvw2bSNzcrHzc0OG1m1VrqlJO0QeQ8y4KzDVlQNLhvgFeIV0J87epo
         1FhVdHSRm8NnGUgkRhOdwG/Q7FEQEKzs4+lbqSKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 128/131] scsi: core: Fix failure handling of scsi_add_host_with_dma()
Date:   Mon, 14 Jun 2021 12:28:09 +0200
Message-Id: <20210614102657.362543492@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 3719f4ff047e20062b8314c23ec3cab84d74c908 upstream.

When scsi_add_host_with_dma() returns failure, the caller will call
scsi_host_put(shost) to release everything allocated for this host
instance. Consequently we can't also free allocated stuff in
scsi_add_host_with_dma(), otherwise we will end up with a double free.

Strictly speaking, host resource allocations should have been done in
scsi_host_alloc(). However, the allocations may need information which is
not yet provided by the driver when that function is called. So leave the
allocations where they are but rely on host device's release handler to
free resources.

Link: https://lore.kernel.org/r/20210602133029.2864069-3-ming.lei@redhat.com
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
 drivers/scsi/hosts.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -278,23 +278,22 @@ int scsi_add_host_with_dma(struct Scsi_H
 
 		if (!shost->work_q) {
 			error = -EINVAL;
-			goto out_free_shost_data;
+			goto out_del_dev;
 		}
 	}
 
 	error = scsi_sysfs_add_host(shost);
 	if (error)
-		goto out_destroy_host;
+		goto out_del_dev;
 
 	scsi_proc_host_add(shost);
 	scsi_autopm_put_host(shost);
 	return error;
 
- out_destroy_host:
-	if (shost->work_q)
-		destroy_workqueue(shost->work_q);
- out_free_shost_data:
-	kfree(shost->shost_data);
+	/*
+	 * Any host allocation in this function will be freed in
+	 * scsi_host_dev_release().
+	 */
  out_del_dev:
 	device_del(&shost->shost_dev);
  out_del_gendev:
@@ -304,7 +303,6 @@ int scsi_add_host_with_dma(struct Scsi_H
 	pm_runtime_disable(&shost->shost_gendev);
 	pm_runtime_set_suspended(&shost->shost_gendev);
 	pm_runtime_put_noidle(&shost->shost_gendev);
-	scsi_mq_destroy_tags(shost);
  fail:
 	return error;
 }


