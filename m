Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633402B6246
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731693AbgKQN1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:27:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731692AbgKQN1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:27:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E37F2168B;
        Tue, 17 Nov 2020 13:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619631;
        bh=kV+qDBtDnP2542WwcfD5iDSQX3OY2/PuyoOpF9RD6+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppH3/ZOLVfA85OcecF3AU06b/w3whx9nGwas06Vn83GAHs7Tju9ppADN5Ce4JW0cN
         vbcCPYblK+TiB0+GJyFgYdul5wHAu60ntiVBpFVl1m/DKymTMoVYUC8Qu+fK4U1jQT
         EERp/MKKIvhFIIzWhoZXIr47XWiTk/sN0isOadIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/151] nvme-tcp: avoid repeated request completion
Date:   Tue, 17 Nov 2020 14:05:03 +0100
Message-Id: <20201117122124.970481821@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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
index 76440f26c1453..a31c6e1f6063a 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2071,7 +2071,7 @@ static void nvme_tcp_complete_timed_out(struct request *rq)
 	struct nvme_ctrl *ctrl = &req->queue->ctrl->ctrl;
 
 	nvme_tcp_stop_queue(ctrl, nvme_tcp_queue_id(req->queue));
-	if (!blk_mq_request_completed(rq)) {
+	if (blk_mq_request_started(rq) && !blk_mq_request_completed(rq)) {
 		nvme_req(rq)->status = NVME_SC_HOST_ABORTED_CMD;
 		blk_mq_complete_request(rq);
 	}
-- 
2.27.0



