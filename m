Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF9626EFB1
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgIRCM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728762AbgIRCM0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:12:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E4AA208DB;
        Fri, 18 Sep 2020 02:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395137;
        bh=5tWw8+7X8x+c5St1Qd4NjQqQ8m53+X3V+BbR4dkABlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WufvMU3Qf8D+vjKo5URZrzwgxX2ehGgEjfjRvKFW+jxJqDJOw+VwJCAtG+kywj/pz
         S94GbSkZ5lmANmCrBTCuj76S7ilCIQruaF11EYZbx+vho17Bdo9AelxiRXvf5EMFVH
         iUjS60EslnVnXqaGJhTBvpKU7GzrJJTkGd/ZFrAU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Iliopoulos <ailiop@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 206/206] nvme: explicitly update mpath disk capacity on revalidation
Date:   Thu, 17 Sep 2020 22:08:02 -0400
Message-Id: <20200918020802.2065198-206-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
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
index 84fcfcdb8ba5f..33dad9774da01 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1599,6 +1599,7 @@ static void __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 	if (ns->head->disk) {
 		nvme_update_disk_info(ns->head->disk, ns, id);
 		blk_queue_stack_limits(ns->head->disk->queue, ns->queue);
+		nvme_mpath_update_disk_size(ns->head->disk);
 	}
 #endif
 }
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index a70b997060e68..9c2e7a151e400 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -504,6 +504,16 @@ static inline void nvme_mpath_check_last_path(struct nvme_ns *ns)
 		kblockd_schedule_work(&head->requeue_work);
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
 
@@ -570,6 +580,9 @@ static inline void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys)
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

