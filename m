Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9119A3A8599
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbhFOP4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:56:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232910AbhFOPyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:54:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B37161926;
        Tue, 15 Jun 2021 15:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772251;
        bh=rVFHbefc3vZW5UlaK94h8CYFEByVPep2nAzuVRLgaaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IofL9jSklp53wYb1dZJgaNSfXG94xHai/EdPKYJIFShd+Jys9m9yzvz0TOtsjqLJp
         USO60p5kWtOMYvBg7xZkAronTsQBfzFuXy/yJJe/XpMlAt9ilqMLhfjR47llexr4aC
         P2XdyYoPe2OCzr/LK2Yaa3FyftKQmORJeaKVyIyimmswrinlO2ytjzAoTVEFsEukhe
         23BvQV8XVwHgarNR5/CwwDAaOfjLJnKIqgfi4yl0yuphV6BYjmL2vXyfIPtvADIurK
         nuTQ0UtJpqmLl/hCpOVfisxgQDOyVYOUOZwVaaLr52pWUJVwbjCkGaF8R6st9OGUJU
         vIVchqxQXSmag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 2/3] scsi: core: Put .shost_dev in failure path if host state changes to RUNNING
Date:   Tue, 15 Jun 2021 11:50:46 -0400
Message-Id: <20210615155048.63448-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615155048.63448-1-sashal@kernel.org>
References: <20210615155048.63448-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 11714026c02d613c30a149c3f4c4a15047744529 ]

scsi_host_dev_release() only frees dev_name when host state is
SHOST_CREATED. After host state has changed to SHOST_RUNNING,
scsi_host_dev_release() no longer cleans up.

Fix this by doing a put_device(&shost->shost_dev) in the failure path when
host state is SHOST_RUNNING. Move get_device(&shost->shost_gendev) before
device_add(&shost->shost_dev) so that scsi_host_cls_release() can do a put
on this reference.

Link: https://lore.kernel.org/r/20210602133029.2864069-4-ming.lei@redhat.com
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Reported-by: John Garry <john.garry@huawei.com>
Tested-by: John Garry <john.garry@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 82ac1cd818ac..8a00d404f306 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -259,12 +259,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 
 	device_enable_async_suspend(&shost->shost_dev);
 
+	get_device(&shost->shost_gendev);
 	error = device_add(&shost->shost_dev);
 	if (error)
 		goto out_del_gendev;
 
-	get_device(&shost->shost_gendev);
-
 	if (shost->transportt->host_size) {
 		shost->shost_data = kzalloc(shost->transportt->host_size,
 					 GFP_KERNEL);
@@ -300,6 +299,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
  out_del_dev:
 	device_del(&shost->shost_dev);
  out_del_gendev:
+	/*
+	 * Host state is SHOST_RUNNING so we have to explicitly release
+	 * ->shost_dev.
+	 */
+	put_device(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
  out_destroy_freelist:
 	scsi_destroy_command_freelist(shost);
-- 
2.30.2

