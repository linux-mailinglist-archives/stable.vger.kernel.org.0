Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D522B3F674C
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239591AbhHXRch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241380AbhHXRak (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:30:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FB9F61B53;
        Tue, 24 Aug 2021 17:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824740;
        bh=w8pDDPMYhfsLQpZ0e2KQHcd7hv5UFcdnIsVsd4pCtW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=km2OXMY/Pq49/5wCfAgOVzvoyJS4ngKflxTlVCpN5M1CJUxJ6qwa4l6mER855C4+A
         vI5ZEguEDH5XOZ44xRkd4f2+Cu0P54BHPiyBxHqc4dChcJvqCeatMCMIYTKdRO2Vp8
         +vHBWGhkAS8FNue+zWyb586Ft9ZgM+zqfrRHRHtBMCw/njYGgjb+WpYEYm5JhY9sxe
         3NTbDM47IY1hbdboYao6iKGTG3RXXf+bn+/hWUYTFwYRRjPsG1I63c8Igz/Xy6muTH
         WLykcrzK2hoq6vFEPveaH5h2nrS7/WAz9TXnwAiF6rEzHhdx40Z/KZ1LyLx7uY0DNj
         eoXb0Fod4h3og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Bin <yebin10@huawei.com>, Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 43/64] scsi: scsi_dh_rdac: Avoid crash during rdac_bus_attach()
Date:   Tue, 24 Aug 2021 13:04:36 -0400
Message-Id: <20210824170457.710623-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
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
index b92e06f75756..897449deab62 100644
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
@@ -779,11 +779,11 @@ static void rdac_bus_detach( struct scsi_device *sdev )
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

