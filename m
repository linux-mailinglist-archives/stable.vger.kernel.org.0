Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73744051DF
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244974AbhIIMjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353783AbhIIMe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:34:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52D1561B65;
        Thu,  9 Sep 2021 11:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188423;
        bh=9ypwcsjxCdo3RdnCl7/tSh1D+ZCeOPIxePDgPuKdxRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r8+cQCF6PbHZyEeBiw69nGmDjOP/NSw+z6FAYwVjX66CdmEqbygMbnmeKjcsujezL
         IwLAZB3wgVVSXguG4MV31w3qExuAB/5WcLAyIQhbPDzqhbhUP61NBJh5//vDPkHdsk
         Zih68iRFT4zknw9BtHOD1oNSIM5eJPQ9dB0QFDm0wzkYedQAZMCvOilo8EEPADXiah
         qAJRKIz3sk8AQnJVU/kZSJnTekxgIX06y0MiS/G8HDfqr1E45Jb8fYUEqSBMEwfRR+
         5C3nVRqiB+3Cklidyk3Su7iJV8PsE1TWerAVy6kYRVYq+L5Mao//OB8P/sAtVpe9nv
         4KouXlNx8gHVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 112/176] nvme-tcp: don't check blk_mq_tag_to_rq when receiving pdu data
Date:   Thu,  9 Sep 2021 07:50:14 -0400
Message-Id: <20210909115118.146181-112-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index 82b2611d39a2..ab03da094db7 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -699,17 +699,9 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
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

