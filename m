Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106E3404C0F
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238762AbhIILz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242995AbhIILxD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:53:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E496361362;
        Thu,  9 Sep 2021 11:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187871;
        bh=6oZCUpyxr2EJT7JalbSNKJm7FX02wo6SvZ2McfbqLOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YX6SpFo425SHwRrvqTZLrGSgY+Fl80Oa4MHkxKSbzK8T7j+2a4W4pM1xaNGozamLc
         dGkNy5KX6Dg7PRab+B/ALgGBj4a2kIbDicPW9//LD2MTipE6j4OhElkj3ENCuMtV2q
         KStzxjUJqi4927wklMsVLTsRCvsHEqmxtZ4JI3P/GYhFxbCO0gCGFZm7VDionLik/8
         BnQg3UyMIAPkJ3f0YUExb+BTsn/FBUe02GZem/0ZCIIGYJrXsVM/hfSAA2pENyKcyW
         QPSSZRRW9Qhc37oJHnZtJcJBRpUYATlWz/3Gv9fX7u4yOe7RaszckHDe8NxJVsxpG/
         4RRYnyPvDMKSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 157/252] nvme-tcp: don't check blk_mq_tag_to_rq when receiving pdu data
Date:   Thu,  9 Sep 2021 07:39:31 -0400
Message-Id: <20210909114106.141462-157-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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
index 8cb15ee5b249..d649b446da66 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -702,17 +702,9 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
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

