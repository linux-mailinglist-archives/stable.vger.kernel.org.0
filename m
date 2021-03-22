Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A681344236
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhCVMjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231286AbhCVMiJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:38:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68E1B61994;
        Mon, 22 Mar 2021 12:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416639;
        bh=1/IVbCB4L41rAqqxmzsDd9nryLAFzd61mULM2vAsHGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hyG9Df7WZ6rJhrec6ekkqAM1b8QALXokZwgDZkcYcu1T4WwmLKwB2o01LrFk0t6T9
         9TiiZzm34VLX9X3uVGyLhEDhynSKiWQZigiAyf+4hQbCRoHtajxuBTI0STfTCK543i
         dPic/R46D/NMBUD/fq6MhAaAn4DQ/tdLhsCwlLuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Leng <lengchao@huawei.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/157] nvme-rdma: fix possible hang when failing to set io queues
Date:   Mon, 22 Mar 2021 13:26:59 +0100
Message-Id: <20210322121935.730037892@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
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
index 195703013272..8b326508a480 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -736,8 +736,11 @@ static int nvme_rdma_alloc_io_queues(struct nvme_rdma_ctrl *ctrl)
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



