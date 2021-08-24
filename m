Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83553F64C9
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236731AbhHXRHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:07:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239845AbhHXRFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:05:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B883E619E1;
        Tue, 24 Aug 2021 16:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824374;
        bh=kpUObHtSqqqnjxVtandwdODh7v70xoSYVCm4acbUwjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7VoyQPscdGsWfEJNLCrgeCiZ/dYHr7XMenWy85aCiw4uVdjmjZtnHHVZVtVXYVef
         9R4YRrL4CQhhET481pOU82zvT0fxd0qs84QEP4+FRAulsjBKCyYvtYS+K8PUpbMGE3
         LSkvgOzyaPQ8Wu9nnuk2pm0tiX5NqCNDF/4V3FAIf4Qw8ZiqO1uKEaN4cJnpLcVR7g
         8niRL4VAhv6NDgirnDQuWkFOQGIRtjW3D4yrGvYU8CtSPYo2mZ1GFZtd5dgsC0hYGX
         Wh1x81u6x68OvBphUxgeZnnxyT/l5E1IT/Es+ERi9ygfa0Zi3dLPux/KAbOtT3Zt/u
         raqjNtuJ410mA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Bin <yebin10@huawei.com>, Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/98] scsi: scsi_dh_rdac: Avoid crash during rdac_bus_attach()
Date:   Tue, 24 Aug 2021 12:57:54 -0400
Message-Id: <20210824165908.709932-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit bc546c0c9abb3bb2fb46866b3d1e6ade9695a5f6 ]

The following BUG_ON() was observed during RDAC scan:

[595952.944297] kernel BUG at drivers/scsi/device_handler/scsi_dh_rdac.c:427!
[595952.951143] Internal error: Oops - BUG: 0 [#1] SMP
......
[595953.251065] Call trace:
[595953.259054]  check_ownership+0xb0/0x118
[595953.269794]  rdac_bus_attach+0x1f0/0x4b0
[595953.273787]  scsi_dh_handler_attach+0x3c/0xe8
[595953.278211]  scsi_dh_add_device+0xc4/0xe8
[595953.282291]  scsi_sysfs_add_sdev+0x8c/0x2a8
[595953.286544]  scsi_probe_and_add_lun+0x9fc/0xd00
[595953.291142]  __scsi_scan_target+0x598/0x630
[595953.295395]  scsi_scan_target+0x120/0x130
[595953.299481]  fc_user_scan+0x1a0/0x1c0 [scsi_transport_fc]
[595953.304944]  store_scan+0xb0/0x108
[595953.308420]  dev_attr_store+0x44/0x60
[595953.312160]  sysfs_kf_write+0x58/0x80
[595953.315893]  kernfs_fop_write+0xe8/0x1f0
[595953.319888]  __vfs_write+0x60/0x190
[595953.323448]  vfs_write+0xac/0x1c0
[595953.326836]  ksys_write+0x74/0xf0
[595953.330221]  __arm64_sys_write+0x24/0x30

Code is in check_ownership:

	list_for_each_entry_rcu(tmp, &h->ctlr->dh_list, node) {
		/* h->sdev should always be valid */
		BUG_ON(!tmp->sdev);
		tmp->sdev->access_state = access_state;
	}

	rdac_bus_attach
		initialize_controller
			list_add_rcu(&h->node, &h->ctlr->dh_list);
			h->sdev = sdev;

	rdac_bus_detach
		list_del_rcu(&h->node);
		h->sdev = NULL;

Fix the race between rdac_bus_attach() and rdac_bus_detach() where h->sdev
is NULL when processing the RDAC attach.

Link: https://lore.kernel.org/r/20210113063103.2698953-1-yebin10@huawei.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 5efc959493ec..85a71bafaea7 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -453,8 +453,8 @@ static int initialize_controller(struct scsi_device *sdev,
 		if (!h->ctlr)
 			err = SCSI_DH_RES_TEMP_UNAVAIL;
 		else {
-			list_add_rcu(&h->node, &h->ctlr->dh_list);
 			h->sdev = sdev;
+			list_add_rcu(&h->node, &h->ctlr->dh_list);
 		}
 		spin_unlock(&list_lock);
 		err = SCSI_DH_OK;
@@ -778,11 +778,11 @@ static void rdac_bus_detach( struct scsi_device *sdev )
 	spin_lock(&list_lock);
 	if (h->ctlr) {
 		list_del_rcu(&h->node);
-		h->sdev = NULL;
 		kref_put(&h->ctlr->kref, release_controller);
 	}
 	spin_unlock(&list_lock);
 	sdev->handler_data = NULL;
+	synchronize_rcu();
 	kfree(h);
 }
 
-- 
2.30.2

