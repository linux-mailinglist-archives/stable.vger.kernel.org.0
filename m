Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DD42B6320
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732371AbgKQNfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:35:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732433AbgKQNfK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:35:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D09002465E;
        Tue, 17 Nov 2020 13:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620110;
        bh=s8zYsADDEm3HMFvjpIL9cWv+bO0V/ydArzW6IdD9Q90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q6H+Xje7IFxPtDVzTBkCGYB6IDuQ35wdtF7K+HEsW4mYHWXBc2zO8LblNUkFCFyJ4
         RhAZRyTn0IreNroiE2ewavXa8+bOgGqrRVieOFd8lPm0WtCh6261FOpqMdVyIqiReb
         BhH1SJ7Md6P1dEyttyJgigvQO2ZvA7ab53+xhiQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 110/255] nvme-rdma: avoid repeated request completion
Date:   Tue, 17 Nov 2020 14:04:10 +0100
Message-Id: <20201117122144.308871571@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit fdf58e02adecbef4c7cbb2073d8ea225e6fd5f26 ]

The request may be executed asynchronously, and rq->state may be
changed to IDLE. To avoid repeated request completion, only
MQ_RQ_COMPLETE of rq->state is checked in nvme_rdma_complete_timed_out.
It is not safe, so need adding check IDLE for rq->state.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Chao Leng <lengchao@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 73961cc1e9799..f91c20e3daf7b 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1974,7 +1974,7 @@ static void nvme_rdma_complete_timed_out(struct request *rq)
 	struct nvme_rdma_queue *queue = req->queue;
 
 	nvme_rdma_stop_queue(queue);
-	if (!blk_mq_request_completed(rq)) {
+	if (blk_mq_request_started(rq) && !blk_mq_request_completed(rq)) {
 		nvme_req(rq)->status = NVME_SC_HOST_ABORTED_CMD;
 		blk_mq_complete_request(rq);
 	}
-- 
2.27.0



