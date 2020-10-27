Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D992299E9A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411586AbgJ0AKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411582AbgJ0AKm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:10:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEE6C216FD;
        Tue, 27 Oct 2020 00:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757441;
        bh=i7JPtbEiXAS705p4PMda+eMSdKJ4qDNXLXWfIebaYWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2wjJWXAFTcoSEiYgnF4rjBFJqN3uB79+/6bdHQ+eBpxTaU6Svuhg3XBhpNikL8ETr
         4vXvyj4KMFXu8Z9nhyVGKPeItiLPt3TUhHC+xyGfmz5tG1pjJDAas++PzMDI9/JXG3
         E5fYOWHwSRE2nmJ+4cOq58tb4nVaFVIEccDujPCg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Leng <lengchao@huawei.com>, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 46/46] nvme-rdma: fix crash when connect rejected
Date:   Mon, 26 Oct 2020 20:09:45 -0400
Message-Id: <20201027000946.1026923-46-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000946.1026923-1-sashal@kernel.org>
References: <20201027000946.1026923-1-sashal@kernel.org>
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
index c91bfd839cabe..564e457f1345e 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1545,7 +1545,6 @@ static int nvme_rdma_cm_handler(struct rdma_cm_id *cm_id,
 		complete(&queue->cm_done);
 		return 0;
 	case RDMA_CM_EVENT_REJECTED:
-		nvme_rdma_destroy_queue_ib(queue);
 		cm_error = nvme_rdma_conn_rejected(queue, ev);
 		break;
 	case RDMA_CM_EVENT_ROUTE_ERROR:
-- 
2.25.1

