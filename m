Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505E840130D
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239795AbhIFBXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:23:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239447AbhIFBWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:22:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C54661101;
        Mon,  6 Sep 2021 01:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891279;
        bh=ZkBB5WuHosXe/9jqN8ntx8HZyJ4sv1now/CKp4qhYGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmqBOsGlOIQbAYN4PQTQcNqe8G1XOak59m0j6UjylLN/hNTG5Q8qFzTzBjJYPtOhr
         BFdQVDEUrwK1fWKNZVDkgofo+MENkY8nxwagfg3xTpQB/WXP5SkEVgs8fOGirN7xQc
         wSlQ6AOn1VDFbKAuLScAGbqTWgMhBBJEmw+tvzYO5zS/1fSmdf11uYeHIGerQBEnfg
         l4QpaFjJ1hNtgiJHoSO4WxG/HeDCFQEUXRlDkOW8n47wrjAPOuYLn5OKsRDlkudl1L
         w2R0OhvV+ErlHmnmpWbV3lyIZWwqXvkiLwppmTHaUUFLWANz+Tbbc0XgMgj/uTMt7/
         ZUkVFO8XczZTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ruozhu Li <liruozhu@huawei.com>, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 21/46] nvme-rdma: don't update queue count when failing to set io queues
Date:   Sun,  5 Sep 2021 21:20:26 -0400
Message-Id: <20210906012052.929174-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012052.929174-1-sashal@kernel.org>
References: <20210906012052.929174-1-sashal@kernel.org>
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
index 4697a94c0945..f80682f7df54 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -736,13 +736,13 @@ static int nvme_rdma_alloc_io_queues(struct nvme_rdma_ctrl *ctrl)
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

