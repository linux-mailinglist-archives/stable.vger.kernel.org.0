Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B56419CDD
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236323AbhI0RdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:33:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237943AbhI0Raz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:30:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CBA76113D;
        Mon, 27 Sep 2021 17:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763387;
        bh=FyIoA/F2sgzljwJzCSywgfeR1zCGkXO2Y7KRzjjcGko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRxEHycxt+KiBoUxBeDfhdayiaPXHol1BYx9+OGQhxKRBhRtliDy2zyfyj63KjTpH
         Vx5IgBSa0wIdtyTy06Hq6JfIqwlrg52fklw/gSRdGRQXDeqjwD12B6xW3I2sPF8xsa
         c2/E+BsswQJmbzlSEEcNvpTkwqG+gJcikNkkcA9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Nowak, Lukasz" <Lukasz.Nowak@Dell.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 098/162] nvme-tcp: fix incorrect h2cdata pdu offset accounting
Date:   Mon, 27 Sep 2021 19:02:24 +0200
Message-Id: <20210927170236.838116698@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
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
index 19a711395cdc..fd28a23d45ed 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -614,7 +614,7 @@ static int nvme_tcp_setup_h2c_data_pdu(struct nvme_tcp_request *req,
 		cpu_to_le32(data->hdr.hlen + hdgst + req->pdu_len + ddgst);
 	data->ttag = pdu->ttag;
 	data->command_id = nvme_cid(rq);
-	data->data_offset = cpu_to_le32(req->data_sent);
+	data->data_offset = pdu->r2t_offset;
 	data->data_length = cpu_to_le32(req->pdu_len);
 	return 0;
 }
@@ -940,7 +940,15 @@ static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
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
@@ -952,7 +960,6 @@ static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
 			}
 			return 1;
 		}
-		nvme_tcp_advance_req(req, ret);
 	}
 	return -EAGAIN;
 }
-- 
2.33.0



