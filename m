Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4F740E437
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243058AbhIPQ4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:56:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240891AbhIPQwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:52:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7933561A89;
        Thu, 16 Sep 2021 16:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809758;
        bh=smrg7xdiaHk44GbPsjmDFBSTWmaqt+YyDAr2cps7BDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDDqsgydUhJYbnsudoCg8KpnPY5Y/uHO3lE4MV0ccEFW0vtr/KFN0apzhLWx/ZGMG
         hJicabRD2bUwQ7rnAd0h2Zezse51X1oxyZ6GWxtuApy6ejDrbTd6tR1qFijlKznCTL
         EYVA5mJSuJX+uXOIuq91WFSEfNLmIFKoPSLTJ5gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 272/380] nvme-tcp: dont check blk_mq_tag_to_rq when receiving pdu data
Date:   Thu, 16 Sep 2021 18:00:29 +0200
Message-Id: <20210916155813.324701191@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ab1ea5b0888e..da289b8f8a27 100644
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



