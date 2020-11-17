Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301252B6453
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733096AbgKQNp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:45:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732488AbgKQNil (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E9E52465E;
        Tue, 17 Nov 2020 13:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620318;
        bh=mMVwK18t0G0zhE+tOLd8BKUQPmXLFpyIrRhS2BoLkgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/qk5gw+prt/mxy+eA9IfopvzelG3h8ZiUtkgj7ljEQPpTJ4yZKAda98MX5r66V3D
         fhbe3ppHr3ZIxHwqFUQl54Ym41LPRhawfDa4YNf6HZ8nPXb5BKH56uxe6gGuswPpnS
         7/Ez4iA2nOzXF7J308TCfu3l4qzLq+/5d9Y1OpiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 178/255] nvme: freeze the queue over ->lba_shift updates
Date:   Tue, 17 Nov 2020 14:05:18 +0100
Message-Id: <20201117122147.591803039@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f9d5f4579feafa721dba2f350fc064a1852c6f8c ]

Ensure that there can't be any I/O in flight went we change the disk
geometry in nvme_update_ns_info, most notable the LBA size by lifting
the queue free from nvme_update_disk_info into the caller

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index be0cec51f5e6d..b130696b00592 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2001,7 +2001,7 @@ static void nvme_update_disk_info(struct gendisk *disk,
 		/* unsupported block size, set capacity to 0 later */
 		bs = (1 << 9);
 	}
-	blk_mq_freeze_queue(disk->queue);
+
 	blk_integrity_unregister(disk);
 
 	atomic_bs = phys_bs = bs;
@@ -2066,8 +2066,6 @@ static void nvme_update_disk_info(struct gendisk *disk,
 		set_disk_ro(disk, true);
 	else
 		set_disk_ro(disk, false);
-
-	blk_mq_unfreeze_queue(disk->queue);
 }
 
 static inline bool nvme_first_scan(struct gendisk *disk)
@@ -2114,6 +2112,7 @@ static int __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 	struct nvme_ctrl *ctrl = ns->ctrl;
 	int ret;
 
+	blk_mq_freeze_queue(ns->disk->queue);
 	/*
 	 * If identify namespace failed, use default 512 byte block size so
 	 * block layer can use before failing read/write for 0 capacity.
@@ -2131,29 +2130,38 @@ static int __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 			dev_warn(ctrl->device,
 				"failed to add zoned namespace:%u ret:%d\n",
 				ns->head->ns_id, ret);
-			return ret;
+			goto out_unfreeze;
 		}
 		break;
 	default:
 		dev_warn(ctrl->device, "unknown csi:%u ns:%u\n",
 			ns->head->ids.csi, ns->head->ns_id);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_unfreeze;
 	}
 
 	ret = nvme_configure_metadata(ns, id);
 	if (ret)
-		return ret;
+		goto out_unfreeze;
 	nvme_set_chunk_sectors(ns, id);
 	nvme_update_disk_info(disk, ns, id);
+	blk_mq_unfreeze_queue(ns->disk->queue);
+
 #ifdef CONFIG_NVME_MULTIPATH
 	if (ns->head->disk) {
+		blk_mq_freeze_queue(ns->head->disk->queue);
 		nvme_update_disk_info(ns->head->disk, ns, id);
 		blk_stack_limits(&ns->head->disk->queue->limits,
 				 &ns->queue->limits, 0);
 		nvme_mpath_update_disk_size(ns->head->disk);
+		blk_mq_unfreeze_queue(ns->head->disk->queue);
 	}
 #endif
 	return 0;
+
+out_unfreeze:
+	blk_mq_unfreeze_queue(ns->disk->queue);
+	return ret;
 }
 
 static int _nvme_revalidate_disk(struct gendisk *disk)
-- 
2.27.0



