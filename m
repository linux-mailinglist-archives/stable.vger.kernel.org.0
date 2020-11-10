Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11B92ACD66
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733276AbgKJEB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 23:01:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733105AbgKJDzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:55:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 682F121D7F;
        Tue, 10 Nov 2020 03:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980520;
        bh=kV+qDBtDnP2542WwcfD5iDSQX3OY2/PuyoOpF9RD6+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZwEdVPsM972AxwGUv4F9+uMOE45A2Ja9m0TmycpX+68M7qqT27PUvA/AeU8a9/Ap
         R/jtij0snercNoaUBKt0NuTYhmhm95vrzFnD2SFwmpJ55X736bugte8wrSj4UtQuZ2
         XaabyI7gGehGuy+8FishFVeenjTIay30+RwDzjCI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Chao Leng <lengchao@huawei.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 28/42] nvme-tcp: avoid repeated request completion
Date:   Mon,  9 Nov 2020 22:54:26 -0500
Message-Id: <20201110035440.424258-28-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035440.424258-1-sashal@kernel.org>
References: <20201110035440.424258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

