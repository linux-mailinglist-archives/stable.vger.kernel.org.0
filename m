Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD24299C7D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 00:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410510AbgJZX7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436633AbgJZX4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:56:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE21120770;
        Mon, 26 Oct 2020 23:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756613;
        bh=cCVgGMe5hoIQ+QFz+qgGojy6g3g+wPwt63Y5/vZUW0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LNZ57PDg6tQ8tF+AM7jHI41/PE8CfMhXrflkKYIrdMkTA4H6I6KZ/Q4xvAnjqwH1X
         dK6wX6pbK7Kdl0Rm1/XOowwiYj8vkeXwSBWOGZVGdwYtnDWTISD19d6RyAb9PFh6e9
         hUfp5yWmDdXACr0aVLg0A/ocdJOLrM7aIVaBn8Q8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Leng <lengchao@huawei.com>, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 80/80] nvme-rdma: fix crash when connect rejected
Date:   Mon, 26 Oct 2020 19:55:16 -0400
Message-Id: <20201026235516.1025100-80-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235516.1025100-1-sashal@kernel.org>
References: <20201026235516.1025100-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Leng <lengchao@huawei.com>

[ Upstream commit 43efdb8e870ee0f58633fd579aa5b5185bf5d39e ]

A crash can happened when a connect is rejected.   The host establishes
the connection after received ConnectReply, and then continues to send
the fabrics Connect command.  If the controller does not receive the
ReadyToUse capsule, host may receive a ConnectReject reply.

Call nvme_rdma_destroy_queue_ib after the host received the
RDMA_CM_EVENT_REJECTED event.  Then when the fabrics Connect command
times out, nvme_rdma_timeout calls nvme_rdma_complete_rq to fail the
request.  A crash happenes due to use after free in
nvme_rdma_complete_rq.

nvme_rdma_destroy_queue_ib is redundant when handling the
RDMA_CM_EVENT_REJECTED event as nvme_rdma_destroy_queue_ib is already
called in connection failure handler.

Signed-off-by: Chao Leng <lengchao@huawei.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index abe4fe496d05c..a41ee9feab8e7 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1679,7 +1679,6 @@ static int nvme_rdma_cm_handler(struct rdma_cm_id *cm_id,
 		complete(&queue->cm_done);
 		return 0;
 	case RDMA_CM_EVENT_REJECTED:
-		nvme_rdma_destroy_queue_ib(queue);
 		cm_error = nvme_rdma_conn_rejected(queue, ev);
 		break;
 	case RDMA_CM_EVENT_ROUTE_ERROR:
-- 
2.25.1

