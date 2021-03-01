Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEB0328FAC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbhCATyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:54:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242314AbhCATo3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAE4764F44;
        Mon,  1 Mar 2021 17:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618848;
        bh=dndZKJjYtARRKhaUfQar40ecfJDvNDi1MP0H8Ml87K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0n0JkgfNWTz45e0NpueMpUmgEBIwAXM8iVDcrye2g7+pd3VuGnRpqeNuJjjTDmvaP
         2LIGA4IRZD9HtEj2KnY4XnVsKjcxsuS0Gfvpo9v/m7r1x6X6+Gy3OpZ6SfG0mTkGc7
         vjqZSHgpc2sy9K5XJPiC1i/h77avrXqhGIjPIMrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Narayan Ayalasomayajula <Narayan.Ayalasomayajula@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 240/663] nvmet-tcp: fix receive data digest calculation for multiple h2cdata PDUs
Date:   Mon,  1 Mar 2021 17:08:08 +0100
Message-Id: <20210301161153.694443923@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit fda871c0ba5d2eed2cd1c881573168129da70058 ]

When a host sends multiple h2cdata PDUs for a single command, we
should verify the data digest calculation per PDU and not
per command.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Reported-by: Narayan Ayalasomayajula <Narayan.Ayalasomayajula@wdc.com>
Tested-by: Narayan Ayalasomayajula <Narayan.Ayalasomayajula@wdc.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index aacf06f0b4312..577ce7d403ae9 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -379,7 +379,7 @@ err:
 	return NVME_SC_INTERNAL;
 }
 
-static void nvmet_tcp_ddgst(struct ahash_request *hash,
+static void nvmet_tcp_send_ddgst(struct ahash_request *hash,
 		struct nvmet_tcp_cmd *cmd)
 {
 	ahash_request_set_crypt(hash, cmd->req.sg,
@@ -387,6 +387,23 @@ static void nvmet_tcp_ddgst(struct ahash_request *hash,
 	crypto_ahash_digest(hash);
 }
 
+static void nvmet_tcp_recv_ddgst(struct ahash_request *hash,
+		struct nvmet_tcp_cmd *cmd)
+{
+	struct scatterlist sg;
+	struct kvec *iov;
+	int i;
+
+	crypto_ahash_init(hash);
+	for (i = 0, iov = cmd->iov; i < cmd->nr_mapped; i++, iov++) {
+		sg_init_one(&sg, iov->iov_base, iov->iov_len);
+		ahash_request_set_crypt(hash, &sg, NULL, iov->iov_len);
+		crypto_ahash_update(hash);
+	}
+	ahash_request_set_crypt(hash, NULL, (void *)&cmd->exp_ddgst, 0);
+	crypto_ahash_final(hash);
+}
+
 static void nvmet_setup_c2h_data_pdu(struct nvmet_tcp_cmd *cmd)
 {
 	struct nvme_tcp_data_pdu *pdu = cmd->data_pdu;
@@ -411,7 +428,7 @@ static void nvmet_setup_c2h_data_pdu(struct nvmet_tcp_cmd *cmd)
 
 	if (queue->data_digest) {
 		pdu->hdr.flags |= NVME_TCP_F_DDGST;
-		nvmet_tcp_ddgst(queue->snd_hash, cmd);
+		nvmet_tcp_send_ddgst(queue->snd_hash, cmd);
 	}
 
 	if (cmd->queue->hdr_digest) {
@@ -1060,7 +1077,7 @@ static void nvmet_tcp_prep_recv_ddgst(struct nvmet_tcp_cmd *cmd)
 {
 	struct nvmet_tcp_queue *queue = cmd->queue;
 
-	nvmet_tcp_ddgst(queue->rcv_hash, cmd);
+	nvmet_tcp_recv_ddgst(queue->rcv_hash, cmd);
 	queue->offset = 0;
 	queue->left = NVME_TCP_DIGEST_LENGTH;
 	queue->rcv_state = NVMET_TCP_RECV_DDGST;
@@ -1081,14 +1098,14 @@ static int nvmet_tcp_try_recv_data(struct nvmet_tcp_queue *queue)
 		cmd->rbytes_done += ret;
 	}
 
+	if (queue->data_digest) {
+		nvmet_tcp_prep_recv_ddgst(cmd);
+		return 0;
+	}
 	nvmet_tcp_unmap_pdu_iovec(cmd);
 
 	if (!(cmd->flags & NVMET_TCP_F_INIT_FAILED) &&
 	    cmd->rbytes_done == cmd->req.transfer_len) {
-		if (queue->data_digest) {
-			nvmet_tcp_prep_recv_ddgst(cmd);
-			return 0;
-		}
 		cmd->req.execute(&cmd->req);
 	}
 
-- 
2.27.0



