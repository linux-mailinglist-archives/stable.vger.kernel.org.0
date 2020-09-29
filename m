Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D02D27CAAA
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732504AbgI2MUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729861AbgI2Lff (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2263223D5A;
        Tue, 29 Sep 2020 11:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379016;
        bh=5tWw8+7X8x+c5St1Qd4NjQqQ8m53+X3V+BbR4dkABlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S1U6dz6b6Bgy1Ye8LvsV38FX+HzyW0OVQFTnnZFLTB7X40fQTRTkwAEKTJIFjhiBk
         G8p/Yt2n7SoU8nIycecHboOLuRepDpXhGa4ErvERj5poIHpfCuA18RrnMVIAV0d3UJ
         dR3rGSgf3Nbp/11V8NByYdkQIXjj7zD1iJcQcmB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Iliopoulos <ailiop@suse.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 205/245] nvme: explicitly update mpath disk capacity on revalidation
Date:   Tue, 29 Sep 2020 13:00:56 +0200
Message-Id: <20200929105956.949535586@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



