Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC060401450
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241045AbhIFBcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351395AbhIFBa0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:30:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40043611EF;
        Mon,  6 Sep 2021 01:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891419;
        bh=iO7NCkoA0Z8ZCilKJsMYkUfxXp2UzeeJ05EuQUhobl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXyhFKsNx9AJeP5TNt1xObJEM3gWtFm/jejaJ/xKM7X23T/dTzM5AdEP9SbmfvOhf
         WZqOOWvgL1q6n4D8IwBXltvFI1JbLgbVEhJoSJ6WfHv3p6CiutHt+QjyUYdTzj8eA8
         3Ted2u9G2kdZyAQ8w06ZCmN68ah+dGBfA0ru30pnRINLG9HjeufnIN3b/IAE/w/nB3
         ViNV63XWj4IJSc0Q1IynhsR1M81E2gsaLzWYs7nt17HmdQW+8ww/JGR8UZmTB5wgyB
         UKb6YZYgrtTRwroTBS5ah+t+OTQLy8ea15A0co9I3FxS2K4h9N/xymkonCAoWsjDnk
         CN+TKcKUz1vXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ruozhu Li <liruozhu@huawei.com>, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 13/23] nvme-rdma: don't update queue count when failing to set io queues
Date:   Sun,  5 Sep 2021 21:23:12 -0400
Message-Id: <20210906012322.930668-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012322.930668-1-sashal@kernel.org>
References: <20210906012322.930668-1-sashal@kernel.org>
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
index 8798274dc3ba..ffd6a7204509 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -643,13 +643,13 @@ static int nvme_rdma_alloc_io_queues(struct nvme_rdma_ctrl *ctrl)
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

