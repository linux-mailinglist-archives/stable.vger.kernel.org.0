Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9A6111FA6
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbfLCWlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:41:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:56532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728599AbfLCWlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:41:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C9D6206EC;
        Tue,  3 Dec 2019 22:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412911;
        bh=tl2BlP5KFSF/9iTakiKZ+ZmyzdBRYiZqwHFpFIWRalw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O620BjaDHARqiviCQ7IwgtE9cRzrCtlY+SRj+MYWx4oAgr9HO0uEajIDFUG/6IVe7
         cGc1lFkCYSNcTXXieguXxsnVRefzSLB8w8z/zAxPOD5EGOYboZ2cWI9NdxohaKqZmK
         yy2GEXygcJ/2A3Vn6mO0/F6jW6yTn/BjDY0inbLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Anton Eidelman <anton@lightbitslabs.com>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 064/135] nvme-multipath: fix crash in nvme_mpath_clear_ctrl_paths
Date:   Tue,  3 Dec 2019 23:35:04 +0100
Message-Id: <20191203213024.261860605@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Eidelman <anton@lightbitslabs.com>

[ Upstream commit 763303a83a095a88c3a8a0d1abf97165db2e8bf5 ]

nvme_mpath_clear_ctrl_paths() iterates through
the ctrl->namespaces list while holding ctrl->scan_lock.
This does not seem to be the correct way of protecting
from concurrent list modification.

Specifically, nvme_scan_work() sorts ctrl->namespaces
AFTER unlocking scan_lock.

This may result in the following (rare) crash in ctrl disconnect
during scan_work:

    BUG: kernel NULL pointer dereference, address: 0000000000000050
    Oops: 0000 [#1] SMP PTI
    CPU: 0 PID: 3995 Comm: nvme 5.3.5-050305-generic
    RIP: 0010:nvme_mpath_clear_current_path+0xe/0x90 [nvme_core]
    ...
    Call Trace:
     nvme_mpath_clear_ctrl_paths+0x3c/0x70 [nvme_core]
     nvme_remove_namespaces+0x35/0xe0 [nvme_core]
     nvme_do_delete_ctrl+0x47/0x90 [nvme_core]
     nvme_sysfs_delete+0x49/0x60 [nvme_core]
     dev_attr_store+0x17/0x30
     sysfs_kf_write+0x3e/0x50
     kernfs_fop_write+0x11e/0x1a0
     __vfs_write+0x1b/0x40
     vfs_write+0xb9/0x1a0
     ksys_write+0x67/0xe0
     __x64_sys_write+0x1a/0x20
     do_syscall_64+0x5a/0x130
     entry_SYSCALL_64_after_hwframe+0x44/0xa9
    RIP: 0033:0x7f8d02bfb154

Fix:
After taking scan_lock in nvme_mpath_clear_ctrl_paths()
down_read(&ctrl->namespaces_rwsem) as well to make list traversal safe.
This will not cause deadlocks because taking scan_lock never happens
while holding the namespaces_rwsem.
Moreover, scan work downs namespaces_rwsem in the same order.

Alternative: sort ctrl->namespaces in nvme_scan_work()
while still holding the scan_lock.
This would leave nvme_mpath_clear_ctrl_paths() without correct protection
against ctrl->namespaces modification by anyone other than scan_work.

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anton Eidelman <anton@lightbitslabs.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index d320684d25b20..a5c809c85f6d2 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -158,9 +158,11 @@ void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
 	struct nvme_ns *ns;
 
 	mutex_lock(&ctrl->scan_lock);
+	down_read(&ctrl->namespaces_rwsem);
 	list_for_each_entry(ns, &ctrl->namespaces, list)
 		if (nvme_mpath_clear_current_path(ns))
 			kblockd_schedule_work(&ns->head->requeue_work);
+	up_read(&ctrl->namespaces_rwsem);
 	mutex_unlock(&ctrl->scan_lock);
 }
 
-- 
2.20.1



