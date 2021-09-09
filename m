Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDCBD4057C2
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353471AbhIINmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351449AbhIIMrk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:47:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C4DB60555;
        Thu,  9 Sep 2021 11:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188594;
        bh=ya837GmVjltzofHK0e4DImDd6KZP8/OzW8tMJEzZJ3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4RFH9rGiFP9omwyzDi/XV4qeJahUx32NQH9tdoSDOKK2PBfaE/VuwBNDwfyE5S42
         GL7i6ZDcrK3GKa3B+w6pBg8HeNL1qmUNpGpeFjmitk55ANtVVq5b4uVi8lm3HNQt36
         F77eVoobq5rcNc5tNDAoqyXPdZEgtTMiyQjGuLq5cFignQP3T1UUdVpDHzu+6yxXl5
         vlShKO3kOuD6Umj55jMm06VUzHvZ7K53Y5gxUbJSlY3iqAyt36Yr9ckSeFrGsprdqP
         Al5vDNPP4hcXCtGasVeAsSu0y+NO8h5BpSyqELIbzJd8vjLb9vvn8eBDUCQ/2LDOsl
         d/o1pCpTYQ3Cw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 068/109] nvme-tcp: don't check blk_mq_tag_to_rq when receiving pdu data
Date:   Thu,  9 Sep 2021 07:54:25 -0400
Message-Id: <20210909115507.147917-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 3b01a9d0caa8276d9ce314e09610f7fb70f49a00 ]

We already validate it when receiving the c2hdata pdu header
and this is not changing so this is a redundant check.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 718152adc625..1458b18cbf24 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -642,17 +642,9 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 			      unsigned int *offset, size_t *len)
 {
 	struct nvme_tcp_data_pdu *pdu = (void *)queue->pdu;
-	struct nvme_tcp_request *req;
-	struct request *rq;
-
-	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
-	if (!rq) {
-		dev_err(queue->ctrl->ctrl.device,
-			"queue %d tag %#x not found\n",
-			nvme_tcp_queue_id(queue), pdu->command_id);
-		return -ENOENT;
-	}
-	req = blk_mq_rq_to_pdu(rq);
+	struct request *rq =
+		blk_mq_tag_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
 	while (true) {
 		int recv_len, ret;
-- 
2.30.2

