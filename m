Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119D045136C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348242AbhKOTvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:51:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343514AbhKOTVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90917635A5;
        Mon, 15 Nov 2021 18:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001683;
        bh=lcCV30G/mq28L/PPnQv/jfYx7hQjjpWu5db7/gr5x6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=myc9IGA66lUOcYql0aCdMXax3HY22xm2kxjd/lgzm9PUONCammRMvxOS93Ca7xrbY
         Z/ZfnsmBimJKYkghSL0KRvvhL9peaOODed29//KBgjSg4FWW1JiZWPeK8nQWikMhWI
         60rx20Ey5ONOuDX9uXylcwZ5P1N1lceuH6SsD0Cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 281/917] nvme: drop scan_lock and always kick requeue list when removing namespaces
Date:   Mon, 15 Nov 2021 17:56:16 +0100
Message-Id: <20211115165438.300583057@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 2b81a5f015199f3d585ce710190a9e87714d3c1e ]

When reading the partition table on initial scan hits an I/O error the
I/O will hang with the scan_mutex held:

[<0>] do_read_cache_page+0x49b/0x790
[<0>] read_part_sector+0x39/0xe0
[<0>] read_lba+0xf9/0x1d0
[<0>] efi_partition+0xf1/0x7f0
[<0>] bdev_disk_changed+0x1ee/0x550
[<0>] blkdev_get_whole+0x81/0x90
[<0>] blkdev_get_by_dev+0x128/0x2e0
[<0>] device_add_disk+0x377/0x3c0
[<0>] nvme_mpath_set_live+0x130/0x1b0 [nvme_core]
[<0>] nvme_mpath_add_disk+0x150/0x160 [nvme_core]
[<0>] nvme_alloc_ns+0x417/0x950 [nvme_core]
[<0>] nvme_validate_or_alloc_ns+0xe9/0x1e0 [nvme_core]
[<0>] nvme_scan_work+0x168/0x310 [nvme_core]
[<0>] process_one_work+0x231/0x420

and trying to delete the controller will deadlock as it tries to grab
the scan mutex:

[<0>] nvme_mpath_clear_ctrl_paths+0x25/0x80 [nvme_core]
[<0>] nvme_remove_namespaces+0x31/0xf0 [nvme_core]
[<0>] nvme_do_delete_ctrl+0x4b/0x80 [nvme_core]

As we're now properly ordering the namespace list there is no need to
hold the scan_mutex in nvme_mpath_clear_ctrl_paths() anymore.
And we always need to kick the requeue list as the path will be marked
as unusable and I/O will be requeued _without_ a current path.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index fba06618c6c23..2f76969408b27 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -138,13 +138,12 @@ void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
 {
 	struct nvme_ns *ns;
 
-	mutex_lock(&ctrl->scan_lock);
 	down_read(&ctrl->namespaces_rwsem);
-	list_for_each_entry(ns, &ctrl->namespaces, list)
-		if (nvme_mpath_clear_current_path(ns))
-			kblockd_schedule_work(&ns->head->requeue_work);
+	list_for_each_entry(ns, &ctrl->namespaces, list) {
+		nvme_mpath_clear_current_path(ns);
+		kblockd_schedule_work(&ns->head->requeue_work);
+	}
 	up_read(&ctrl->namespaces_rwsem);
-	mutex_unlock(&ctrl->scan_lock);
 }
 
 void nvme_mpath_revalidate_paths(struct nvme_ns *ns)
-- 
2.33.0



