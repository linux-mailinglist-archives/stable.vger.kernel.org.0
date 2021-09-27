Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6831419CD9
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238085AbhI0Rch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236198AbhI0Raf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:30:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8C7960F4A;
        Mon, 27 Sep 2021 17:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763385;
        bh=AAzw6SDUvq6M1tCKBlxfuU4NYcgoAyNvVxKy0fNnRaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjIT8Jw4r+mLB9p9ZjwQnH2skqSHZN6PnZc7LVlwk9y9qJkfUIXILM3NvNcXyVy2I
         bl1pYegj0ewAngOH9bz4Whei10yNtz9EmZhnQbzvfAxnOmIQ4tCFNRhSAt45L7fyl+
         Bg4y6Kjpy7HZuCH4G++3Kc8b72OwYxaTMoSNAgDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Nowak, Lukasz" <Lukasz.Nowak@Dell.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/103] nvme-tcp: fix incorrect h2cdata pdu offset accounting
Date:   Mon, 27 Sep 2021 19:02:31 +0200
Message-Id: <20210927170227.806699954@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit e371af033c560b9dd1e861f8f0b503142bf0a06c ]

When the controller sends us multiple r2t PDUs in a single
request we need to account for it correctly as our send/recv
context run concurrently (i.e. we get a new r2t with r2t_offset
before we updated our iterator and req->data_sent marker). This
can cause wrong offsets to be sent to the controller.

To fix that, we will first know that this may happen only in
the send sequence of the last page, hence we will take
the r2t_offset to the h2c PDU data_offset, and in
nvme_tcp_try_send_data loop, we make sure to increment
the request markers also when we completed a PDU but
we are expecting more r2t PDUs as we still did not send
the entire data of the request.

Fixes: 825619b09ad3 ("nvme-tcp: fix possible use-after-completion")
Reported-by: Nowak, Lukasz <Lukasz.Nowak@Dell.com>
Tested-by: Nowak, Lukasz <Lukasz.Nowak@Dell.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index a6b3b0762763..05ad6bee085c 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -611,7 +611,7 @@ static int nvme_tcp_setup_h2c_data_pdu(struct nvme_tcp_request *req,
 		cpu_to_le32(data->hdr.hlen + hdgst + req->pdu_len + ddgst);
 	data->ttag = pdu->ttag;
 	data->command_id = nvme_cid(rq);
-	data->data_offset = cpu_to_le32(req->data_sent);
+	data->data_offset = pdu->r2t_offset;
 	data->data_length = cpu_to_le32(req->pdu_len);
 	return 0;
 }
@@ -937,7 +937,15 @@ static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
 			nvme_tcp_ddgst_update(queue->snd_hash, page,
 					offset, ret);
 
-		/* fully successful last write*/
+		/*
+		 * update the request iterator except for the last payload send
+		 * in the request where we don't want to modify it as we may
+		 * compete with the RX path completing the request.
+		 */
+		if (req->data_sent + ret < req->data_len)
+			nvme_tcp_advance_req(req, ret);
+
+		/* fully successful last send in current PDU */
 		if (last && ret == len) {
 			if (queue->data_digest) {
 				nvme_tcp_ddgst_final(queue->snd_hash,
@@ -949,7 +957,6 @@ static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
 			}
 			return 1;
 		}
-		nvme_tcp_advance_req(req, ret);
 	}
 	return -EAGAIN;
 }
-- 
2.33.0



