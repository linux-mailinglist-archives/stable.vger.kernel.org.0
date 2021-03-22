Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFAB344355
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhCVMti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232766AbhCVMsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:48:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF0AE619CC;
        Mon, 22 Mar 2021 12:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417047;
        bh=vRM6U3XQPzYZ/vO6pDovKg8Objfa3kJjfPwjSM7U9HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1UrPmDOB0BgMfNtP5IVk0pHVNijwe+Dla0bdfznBq9SR/CunpqcEA4sUWWu/DL0R
         2PRbrzivJuyIOJGXEUWg7tMn2ewWuzWIted1yBiBea+Rn7R+kOGKMO4AGeJAY7FUP/
         JW+S9m4y48Xg3uGWF6oYtc/pUm23gcSdnhDSfA8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Leng <lengchao@huawei.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/60] nvme-rdma: fix possible hang when failing to set io queues
Date:   Mon, 22 Mar 2021 13:28:21 +0100
Message-Id: <20210322121923.477871583@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit c4c6df5fc84659690d4391d1fba155cd94185295 ]

We only setup io queues for nvme controllers, and it makes absolutely no
sense to allow a controller (re)connect without any I/O queues.  If we
happen to fail setting the queue count for any reason, we should not allow
this to be a successful reconnect as I/O has no chance in going through.
Instead just fail and schedule another reconnect.

Reported-by: Chao Leng <lengchao@huawei.com>
Fixes: 711023071960 ("nvme-rdma: add a NVMe over Fabrics RDMA host driver")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chao Leng <lengchao@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index da6030010432..b8c0f75bfb7b 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -666,8 +666,11 @@ static int nvme_rdma_alloc_io_queues(struct nvme_rdma_ctrl *ctrl)
 		return ret;
 
 	ctrl->ctrl.queue_count = nr_io_queues + 1;
-	if (ctrl->ctrl.queue_count < 2)
-		return 0;
+	if (ctrl->ctrl.queue_count < 2) {
+		dev_err(ctrl->ctrl.device,
+			"unable to set any I/O queues\n");
+		return -ENOMEM;
+	}
 
 	dev_info(ctrl->ctrl.device,
 		"creating %d I/O queues.\n", nr_io_queues);
-- 
2.30.1



