Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91B13A8490
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhFOPvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231270AbhFOPvC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6044261606;
        Tue, 15 Jun 2021 15:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772136;
        bh=CWn57cX62MYv93TJVhCWkAurqo1QfU4eJSOhxDYLLPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xbng6RH1DB+WFty9ijv4JRUKmI0U6j1icrX9o4i1sEHWBEE6ffvg4Z9OR5kZ3kmuF
         NKfZt1AFPQ/Q//k/cjmwWO2KUHTGESVkQu8uQAfrwD75JwiuhWplvHQ3l/9Z1v/CS4
         UIVfQnddVvqft8eB8aXE+iQdM6Ed4sxB1Gauti+Nvcpk/iOKSMqHXyg8wJxuWgFTVm
         wkajILByYZyKPLLqljQoh+NORfJHyeqEqto1vZ5jzQ8oU2uMOnAKsU47VC6mEL0TYR
         nCExsLkx0dOd1k3meYkdmoyNKyOT9NRRPdKjhjfVOTuddOKfSORoeDYK/78avAHQqf
         pHjGgtE7kFScA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 25/33] scsi: core: Fix failure handling of scsi_add_host_with_dma()
Date:   Tue, 15 Jun 2021 11:48:16 -0400
Message-Id: <20210615154824.62044-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154824.62044-1-sashal@kernel.org>
References: <20210615154824.62044-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 3719f4ff047e20062b8314c23ec3cab84d74c908 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index d835a7b23614..48ec9c35daa4 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -278,23 +278,22 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 
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
@@ -304,7 +303,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	pm_runtime_disable(&shost->shost_gendev);
 	pm_runtime_set_suspended(&shost->shost_gendev);
 	pm_runtime_put_noidle(&shost->shost_gendev);
-	scsi_mq_destroy_tags(shost);
  fail:
 	return error;
 }
-- 
2.30.2

