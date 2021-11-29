Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EECD461E7F
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379694AbhK2Sgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:36:39 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:52408 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379610AbhK2Sei (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:34:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 89A19CE13D4;
        Mon, 29 Nov 2021 18:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F1DC53FAD;
        Mon, 29 Nov 2021 18:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210677;
        bh=aXMJ5QelXegTrmDY3GpaJAfea2NXqK4Y5vbfGRWknJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3PFb6RSCqKi75no5xrbFKj+zNJNqbdKaL+GebUB+5sk1Y3JCFYxJpKv7MG7E9yQE
         pvfaQO1s9gG/E7gFv5dhXJeLqy+DSizkOWuYCTWo0TNCy1pOfoLsFXjzlQxj/zt4Zg
         lQFR3jho9RojBWEW9jOyytcrrzGGODzDjoPVrny8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/121] nvmet-tcp: fix incomplete data digest send
Date:   Mon, 29 Nov 2021 19:18:30 +0100
Message-Id: <20211129181714.323782176@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>

[ Upstream commit 102110efdff6beedece6ab9b51664c32ac01e2db ]

Current nvmet_try_send_ddgst() code does not check whether
all data digest bytes are transmitted, fix this by returning
-EAGAIN if all data digest bytes are not transmitted.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Signed-off-by: Varun Prakash <varun@chelsio.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 1251fd6e92780..96b67a70cbbbd 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -688,10 +688,11 @@ static int nvmet_try_send_r2t(struct nvmet_tcp_cmd *cmd, bool last_in_batch)
 static int nvmet_try_send_ddgst(struct nvmet_tcp_cmd *cmd, bool last_in_batch)
 {
 	struct nvmet_tcp_queue *queue = cmd->queue;
+	int left = NVME_TCP_DIGEST_LENGTH - cmd->offset;
 	struct msghdr msg = { .msg_flags = MSG_DONTWAIT };
 	struct kvec iov = {
 		.iov_base = (u8 *)&cmd->exp_ddgst + cmd->offset,
-		.iov_len = NVME_TCP_DIGEST_LENGTH - cmd->offset
+		.iov_len = left
 	};
 	int ret;
 
@@ -705,6 +706,10 @@ static int nvmet_try_send_ddgst(struct nvmet_tcp_cmd *cmd, bool last_in_batch)
 		return ret;
 
 	cmd->offset += ret;
+	left -= ret;
+
+	if (left)
+		return -EAGAIN;
 
 	if (queue->nvme_sq.sqhd_disabled) {
 		cmd->queue->snd_cmd = NULL;
-- 
2.33.0



