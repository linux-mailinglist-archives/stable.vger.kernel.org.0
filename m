Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899A1226752
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387682AbgGTQKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733042AbgGTQKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:10:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 664082064B;
        Mon, 20 Jul 2020 16:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261433;
        bh=7l2mC/8Pcjw0+InFX8xGT4xB/xpRCBCKKjD43qqVbpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jX+7wSUZPPL+LgIRfeJEm+wezrQJAcb3qhnX724/6r5ENrXj/iZw/2Pr4IAq4lX1T
         S+Ps5+HZmj+LpSG4cOzlGCwi/iepVUIIuIsszI8xOPa9jelV0AcVcmVJfGEyYjJwYB
         sObCMPXMI/ctCOOuHN8fwYh/n7RqlBY5XPh0nNKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Iliopoulos <ailiop@suse.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 115/244] nvme: explicitly update mpath disk capacity on revalidation
Date:   Mon, 20 Jul 2020 17:36:26 +0200
Message-Id: <20200720152831.314311521@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Iliopoulos <ailiop@suse.com>

[ Upstream commit 05b29021fba5e725dd385151ef00b6340229b500 ]

Commit 3b4b19721ec652 ("nvme: fix possible deadlock when I/O is
blocked") reverted multipath head disk revalidation due to deadlocks
caused by holding the bd_mutex during revalidate.

Updating the multipath disk blockdev size is still required though for
userspace to be able to observe any resizing while the device is
mounted. Directly update the bdev inode size to avoid unnecessarily
holding the bdev->bd_mutex.

Fixes: 3b4b19721ec652 ("nvme: fix possible deadlock when I/O is
blocked")

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c |  1 +
 drivers/nvme/host/nvme.h | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 71d63ed62071e..137d7bcc13585 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1916,6 +1916,7 @@ static void __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 	if (ns->head->disk) {
 		nvme_update_disk_info(ns->head->disk, ns, id);
 		blk_queue_stack_limits(ns->head->disk->queue, ns->queue);
+		nvme_mpath_update_disk_size(ns->head->disk);
 	}
 #endif
 }
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 719342600be62..46f965f8c9bcd 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -583,6 +583,16 @@ static inline void nvme_trace_bio_complete(struct request *req,
 					 req->bio, status);
 }
 
+static inline void nvme_mpath_update_disk_size(struct gendisk *disk)
+{
+	struct block_device *bdev = bdget_disk(disk, 0);
+
+	if (bdev) {
+		bd_set_size(bdev, get_capacity(disk) << SECTOR_SHIFT);
+		bdput(bdev);
+	}
+}
+
 extern struct device_attribute dev_attr_ana_grpid;
 extern struct device_attribute dev_attr_ana_state;
 extern struct device_attribute subsys_attr_iopolicy;
@@ -658,6 +668,9 @@ static inline void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys)
 static inline void nvme_mpath_start_freeze(struct nvme_subsystem *subsys)
 {
 }
+static inline void nvme_mpath_update_disk_size(struct gendisk *disk)
+{
+}
 #endif /* CONFIG_NVME_MULTIPATH */
 
 #ifdef CONFIG_NVM
-- 
2.25.1



