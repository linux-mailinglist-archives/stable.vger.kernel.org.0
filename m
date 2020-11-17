Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250B02B6323
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732446AbgKQNfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:35:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732439AbgKQNfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:35:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8B002078E;
        Tue, 17 Nov 2020 13:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620113;
        bh=Zkure4hyDU7vk0/XAXYQaRhl+s3T3kxNQ6o1n5JAdHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x6NYqaqW9g8oP06RdqLZFrTtQBVB2iGUaXkyLuxiE5Ggn/JIlTIvARohWmudI7ktD
         mBg3rbTHuqH9eJGKB5qBB5RXNoeTJwYwayNqlEXYwW+vP//o5eQw3KskNtu3GedMSf
         kE34xU/H1j5Zo72pcVTYkQTzFD46SqfDJ07LdTy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 111/255] nvme-tcp: avoid repeated request completion
Date:   Tue, 17 Nov 2020 14:04:11 +0100
Message-Id: <20201117122144.357668381@linuxfoundation.org>
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

[ Upstream commit 0a8a2c85b83589a5c10bc5564b796836bf4b4984 ]

The request may be executed asynchronously, and rq->state may be
changed to IDLE. To avoid repeated request completion, only
MQ_RQ_COMPLETE of rq->state is checked in nvme_tcp_complete_timed_out.
It is not safe, so need adding check IDLE for rq->state.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Chao Leng <lengchao@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 19f86ea547bbc..c0c33320fe659 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2168,7 +2168,7 @@ static void nvme_tcp_complete_timed_out(struct request *rq)
 	struct nvme_ctrl *ctrl = &req->queue->ctrl->ctrl;
 
 	nvme_tcp_stop_queue(ctrl, nvme_tcp_queue_id(req->queue));
-	if (!blk_mq_request_completed(rq)) {
+	if (blk_mq_request_started(rq) && !blk_mq_request_completed(rq)) {
 		nvme_req(rq)->status = NVME_SC_HOST_ABORTED_CMD;
 		blk_mq_complete_request(rq);
 	}
-- 
2.27.0



