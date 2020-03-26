Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62548194D07
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgCZX22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:28:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727950AbgCZXYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:24:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0F1520848;
        Thu, 26 Mar 2020 23:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265074;
        bh=OtlQIGTdzG3Q8cgGhGQT9pGdOUBBXdJWpQ6hGKqJ2Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0W+Dtcyvw/c1TKzkkrByQcQZhEXM2kBuzjxiNoYQfL2a8LIwrcNRKnwRC/xbZJYCO
         VkMrLq3jhHKjf2JUN1vemHtqlq3IFcBNbZjenpMZ/WmUyF3U0GSg694S1XGAcMy8pr
         VUtoxpRUySc4pBxJRaMDYclR9fWRIx8B+HwVBnPU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prabhath Sajeepa <psajeepa@purestorage.com>,
        Roland Dreier <roland@purestorage.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 02/19] nvme-rdma: Avoid double freeing of async event data
Date:   Thu, 26 Mar 2020 19:24:14 -0400
Message-Id: <20200326232431.7816-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232431.7816-1-sashal@kernel.org>
References: <20200326232431.7816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prabhath Sajeepa <psajeepa@purestorage.com>

[ Upstream commit 9134ae2a2546cb96abddcd4469a79c77ee3a4480 ]

The timeout of identify cmd, which is invoked as part of admin queue
creation, can result in freeing of async event data both in
nvme_rdma_timeout handler and error handling path of
nvme_rdma_configure_admin queue thus causing NULL pointer reference.
Call Trace:
 ? nvme_rdma_setup_ctrl+0x223/0x800 [nvme_rdma]
 nvme_rdma_create_ctrl+0x2ba/0x3f7 [nvme_rdma]
 nvmf_dev_write+0xa54/0xcc6 [nvme_fabrics]
 __vfs_write+0x1b/0x40
 vfs_write+0xb2/0x1b0
 ksys_write+0x61/0xd0
 __x64_sys_write+0x1a/0x20
 do_syscall_64+0x60/0x1e0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reviewed-by: Roland Dreier <roland@purestorage.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Prabhath Sajeepa <psajeepa@purestorage.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 4ff51da3b13fa..73e8475ddc8ab 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -850,9 +850,11 @@ static int nvme_rdma_configure_admin_queue(struct nvme_rdma_ctrl *ctrl,
 	if (new)
 		blk_mq_free_tag_set(ctrl->ctrl.admin_tagset);
 out_free_async_qe:
-	nvme_rdma_free_qe(ctrl->device->dev, &ctrl->async_event_sqe,
-		sizeof(struct nvme_command), DMA_TO_DEVICE);
-	ctrl->async_event_sqe.data = NULL;
+	if (ctrl->async_event_sqe.data) {
+		nvme_rdma_free_qe(ctrl->device->dev, &ctrl->async_event_sqe,
+			sizeof(struct nvme_command), DMA_TO_DEVICE);
+		ctrl->async_event_sqe.data = NULL;
+	}
 out_free_queue:
 	nvme_rdma_free_queue(&ctrl->queues[0]);
 	return error;
-- 
2.20.1

