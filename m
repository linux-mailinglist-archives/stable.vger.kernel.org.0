Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB5F462296
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 21:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbhK2U5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 15:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbhK2Uzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 15:55:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71977C12A774;
        Mon, 29 Nov 2021 10:26:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38A11B815B1;
        Mon, 29 Nov 2021 18:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CEBC53FD3;
        Mon, 29 Nov 2021 18:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210371;
        bh=iNe/giluwUDGUxHNgE1QvHW7bmW+GC/cyRil6ps0aWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WovyrC8UTBPV+gsn3ClbUqoPZikMr96pbQq7BYg6h9bhDtiAq/6fpllfoLZWYoHDz
         3y4e/5CA4yy0/hXZOuE8lCu8rNHdTZVpGVLctxLjB3kx1z2wt5LjDChVA9gTOikR+j
         IsQWhHMutnU5MV2Q65Dk7fkes6DwkH3n0zUv4Mf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 64/92] nvmet-tcp: fix incomplete data digest send
Date:   Mon, 29 Nov 2021 19:18:33 +0100
Message-Id: <20211129181709.548772666@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
index fac1985870765..4341c72446628 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -631,10 +631,11 @@ static int nvmet_try_send_r2t(struct nvmet_tcp_cmd *cmd, bool last_in_batch)
 static int nvmet_try_send_ddgst(struct nvmet_tcp_cmd *cmd)
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
 
@@ -643,6 +644,10 @@ static int nvmet_try_send_ddgst(struct nvmet_tcp_cmd *cmd)
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



