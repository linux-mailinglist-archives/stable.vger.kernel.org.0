Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022A396152
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbfHTNqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729838AbfHTNmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:42:16 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 851F622DD3;
        Tue, 20 Aug 2019 13:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308536;
        bh=nYizPpnTiY7xVQPeBOPeOVVEBMRRYIfGNXJevNUNqpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4wCG0nA+LLNTh/EOOPdRTuCi0vkUPdh78UZ8N77GOrzdadpdagk4hmCw0MNnUU1m
         e/69DJ02nftffpJuEyaQPt9Rug+R/wGfm88oOkHBDrsogCpdOwYH1bDetz/0D/+RjQ
         2ruCK/tPNW4CvS7yikBZS7Poc8S5d8e8U0yhoI4M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Iliopoulos <ailiopoulos@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 02/27] nvme-multipath: revalidate nvme_ns_head gendisk in nvme_validate_ns
Date:   Tue, 20 Aug 2019 09:41:48 -0400
Message-Id: <20190820134213.11279-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134213.11279-1-sashal@kernel.org>
References: <20190820134213.11279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Iliopoulos <ailiopoulos@suse.com>

[ Upstream commit fab7772bfbcfe8fb8e3e352a6a8fcaf044cded17 ]

When CONFIG_NVME_MULTIPATH is set, only the hidden gendisk associated
with the per-controller ns is run through revalidate_disk when a
rescan is triggered, while the visible blockdev never gets its size
(bdev->bd_inode->i_size) updated to reflect any capacity changes that
may have occurred.

This prevents online resizing of nvme block devices and in extension of
any filesystems atop that will are unable to expand while mounted, as
userspace relies on the blockdev size for obtaining the disk capacity
(via BLKGETSIZE/64 ioctls).

Fix this by explicitly revalidating the actual namespace gendisk in
addition to the per-controller gendisk, when multipath is enabled.

Signed-off-by: Anthony Iliopoulos <ailiopoulos@suse.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e26d1191c5ad6..d838a300ae770 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1557,6 +1557,7 @@ static void __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 	if (ns->head->disk) {
 		nvme_update_disk_info(ns->head->disk, ns, id);
 		blk_queue_stack_limits(ns->head->disk->queue, ns->queue);
+		revalidate_disk(ns->head->disk);
 	}
 #endif
 }
-- 
2.20.1

