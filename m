Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D6D1AED95
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 15:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgDRNws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 09:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbgDRNsg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 09:48:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9232422202;
        Sat, 18 Apr 2020 13:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587217716;
        bh=emCtJ33z/m5pfLdFAGdxdHQ4439wBNBlCSZF5CWCU9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qm41ULvokLlKS1OQ+dND0L+w+oL4Tta1sixjMVwuCppI4tpsG3Yzh1HLqiSimpwkv
         DYN4GzNI9qNDwYxYzM0/qiu/NGPpAb/D3hd54CDTejp+Bc0Twq6ZOUvOdqNTUAvAGi
         iBD0RND7aksie2rzww1mto8fLY/FwVkZZvmRRQj8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Tony Asleson <tasleson@redhat.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 17/73] nvme-tcp: fix possible crash in write_zeroes processing
Date:   Sat, 18 Apr 2020 09:47:19 -0400
Message-Id: <20200418134815.6519-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418134815.6519-1-sashal@kernel.org>
References: <20200418134815.6519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 25e5cb780e62bde432b401f312bb847edc78b432 ]

We cannot look at blk_rq_payload_bytes without first checking
that the request has a mappable physical segments first (e.g.
blk_rq_nr_phys_segments(rq) != 0) and only then to take the
request payload bytes. This caused us to send a wrong sgl to
the target or even dereference a non-existing buffer in case
we actually got to the data send sequence (if it was in-capsule).

Reported-by: Tony Asleson <tasleson@redhat.com>
Suggested-by: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 49d4373b84eb3..00e6aa59954d4 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -164,16 +164,14 @@ static inline bool nvme_tcp_async_req(struct nvme_tcp_request *req)
 static inline bool nvme_tcp_has_inline_data(struct nvme_tcp_request *req)
 {
 	struct request *rq;
-	unsigned int bytes;
 
 	if (unlikely(nvme_tcp_async_req(req)))
 		return false; /* async events don't have a request */
 
 	rq = blk_mq_rq_from_pdu(req);
-	bytes = blk_rq_payload_bytes(rq);
 
-	return rq_data_dir(rq) == WRITE && bytes &&
-		bytes <= nvme_tcp_inline_data_size(req->queue);
+	return rq_data_dir(rq) == WRITE && req->data_len &&
+		req->data_len <= nvme_tcp_inline_data_size(req->queue);
 }
 
 static inline struct page *nvme_tcp_req_cur_page(struct nvme_tcp_request *req)
@@ -2090,7 +2088,9 @@ static blk_status_t nvme_tcp_map_data(struct nvme_tcp_queue *queue,
 
 	c->common.flags |= NVME_CMD_SGL_METABUF;
 
-	if (rq_data_dir(rq) == WRITE && req->data_len &&
+	if (!blk_rq_nr_phys_segments(rq))
+		nvme_tcp_set_sg_null(c);
+	else if (rq_data_dir(rq) == WRITE &&
 	    req->data_len <= nvme_tcp_inline_data_size(queue))
 		nvme_tcp_set_sg_inline(queue, c, req->data_len);
 	else
@@ -2117,7 +2117,8 @@ static blk_status_t nvme_tcp_setup_cmd_pdu(struct nvme_ns *ns,
 	req->data_sent = 0;
 	req->pdu_len = 0;
 	req->pdu_sent = 0;
-	req->data_len = blk_rq_payload_bytes(rq);
+	req->data_len = blk_rq_nr_phys_segments(rq) ?
+				blk_rq_payload_bytes(rq) : 0;
 	req->curr_bio = rq->bio;
 
 	if (rq_data_dir(rq) == WRITE &&
-- 
2.20.1

