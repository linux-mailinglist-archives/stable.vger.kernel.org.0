Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08D62A55C6
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387802AbgKCVFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:05:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:43798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732586AbgKCVFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:05:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA816205ED;
        Tue,  3 Nov 2020 21:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437519;
        bh=YYkLz3QUm+o8MytFs130s7j/6j4iqNUfVefHb36a7ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcj9yFbSETZlILwVfbNBFdN4Dj2sUIgUq/wKKRsj5YJXXu3Itopu9ib14ScSyidht
         jq1cLGSmjS7wH4xza/mcyJKzPtlr+JPOoRH7qy2j6Bd/eJXc4zXQfgUIu8p/zKudUU
         F2jDBc4Z4R63Y1tNuHgklh1rwQ0cP3zBCs/oZhps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Leng <lengchao@huawei.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/191] nvme-rdma: fix crash when connect rejected
Date:   Tue,  3 Nov 2020 21:36:43 +0100
Message-Id: <20201103203243.872525339@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 077c678166651..134e14e778f8e 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1640,7 +1640,6 @@ static int nvme_rdma_cm_handler(struct rdma_cm_id *cm_id,
 		complete(&queue->cm_done);
 		return 0;
 	case RDMA_CM_EVENT_REJECTED:
-		nvme_rdma_destroy_queue_ib(queue);
 		cm_error = nvme_rdma_conn_rejected(queue, ev);
 		break;
 	case RDMA_CM_EVENT_ROUTE_ERROR:
-- 
2.27.0



