Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777BA401405
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240735AbhIFBcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241258AbhIFB2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:28:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53EF461107;
        Mon,  6 Sep 2021 01:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891385;
        bh=gFpyd9f1axHKpXgw46ZEkMf+JSr+smxLSKk0Bfgu7CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TH0oZ8kq3hA46dPby4y27L5IteqhYkjinfWWSa/aA6c0YEJzc2pxmpey9NsDfeYMV
         7gKJWsIwo+5j15nu9BTpfkC0ye1BosMLz7SUC0SDbdEA7N7EeSm4q5L8ghD3OvsZkc
         qpHmf0p/gbVF3FRxakhBP8rqp4/q5tV9geceD5KJrCQPRRUQBCUB5wxN8KhC4/cL5V
         9VkaY2Mx/uhcnkrBEOiCzzEI0ny6IJdrEajyDSVVwp4h/cczXcEw+s82kNFy1HFxHd
         8aoPqRUNloJKpUOoeeiMjRqvvcGceKudhiRnA4biLvhiKaIPl2snpjJJMMTKPanzFi
         6XzTHaHrjMfmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ruozhu Li <liruozhu@huawei.com>, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 17/30] nvme-rdma: don't update queue count when failing to set io queues
Date:   Sun,  5 Sep 2021 21:22:30 -0400
Message-Id: <20210906012244.930338-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012244.930338-1-sashal@kernel.org>
References: <20210906012244.930338-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ruozhu Li <liruozhu@huawei.com>

[ Upstream commit 85032874f80ba17bf187de1d14d9603bf3f582b8 ]

We update ctrl->queue_count and schedule another reconnect when io queue
count is zero.But we will never try to create any io queue in next reco-
nnection, because ctrl->queue_count already set to zero.We will end up
having an admin-only session in Live state, which is exactly what we try
to avoid in the original patch.
Update ctrl->queue_count after queue_count zero checking to fix it.

Signed-off-by: Ruozhu Li <liruozhu@huawei.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index b8c0f75bfb7b..dcc3d2393605 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -665,13 +665,13 @@ static int nvme_rdma_alloc_io_queues(struct nvme_rdma_ctrl *ctrl)
 	if (ret)
 		return ret;
 
-	ctrl->ctrl.queue_count = nr_io_queues + 1;
-	if (ctrl->ctrl.queue_count < 2) {
+	if (nr_io_queues == 0) {
 		dev_err(ctrl->ctrl.device,
 			"unable to set any I/O queues\n");
 		return -ENOMEM;
 	}
 
+	ctrl->ctrl.queue_count = nr_io_queues + 1;
 	dev_info(ctrl->ctrl.device,
 		"creating %d I/O queues.\n", nr_io_queues);
 
-- 
2.30.2

