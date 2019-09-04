Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58CA0A9063
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388631AbfIDSJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389928AbfIDSJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:09:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67F28208E4;
        Wed,  4 Sep 2019 18:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620560;
        bh=F5X2Tw6fGwcM5GWIJCsXtZMbUmjKCSlTq9VUSvzj8tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjpm6zjXQQA2hQKmhzUTllGFwsv9foCXcu85ncN4gvHUqmQrlnmxWrvUpG9IwkWXB
         gugKblYx3TflzgiAdk4EKjET6taerZika1994oF+Pi5oIMWV+QEFBIZ8sRRZ3UfeW6
         tVcinv15iMoB7aIQkqSkbszJECFBAHJd/r7JNCk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Iliopoulos <ailiopoulos@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 002/143] nvme-multipath: revalidate nvme_ns_head gendisk in nvme_validate_ns
Date:   Wed,  4 Sep 2019 19:52:25 +0200
Message-Id: <20190904175314.293360423@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 5deb4deb38209..ab1a2b1ec3637 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1668,6 +1668,7 @@ static void __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 	if (ns->head->disk) {
 		nvme_update_disk_info(ns->head->disk, ns, id);
 		blk_queue_stack_limits(ns->head->disk->queue, ns->queue);
+		revalidate_disk(ns->head->disk);
 	}
 #endif
 }
-- 
2.20.1



