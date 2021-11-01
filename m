Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611C84418BC
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbhKAJu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:50:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234738AbhKAJss (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:48:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C37E611CC;
        Mon,  1 Nov 2021 09:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759087;
        bh=oP70mvvBFpm42lYoA/4Wu789MTu/AJSU+1ote24pc8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qoN7BupUPKKbqvobFGbVjVDjVVXwdF66sfYTemxzy5H1h8yM9wiLpbXfk71zUsgQU
         bZKqXpHPfQPhpcQWrWGAppFh1tAM9WOBYKvz89wiJHLXVOfk4to3BNfVy6DjLOiLzm
         apuAMYhT0VbY19jz0myInfLSm1VNi1Bps+80/Sdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.14 067/125] nvme-tcp: fix possible req->offset corruption
Date:   Mon,  1 Nov 2021 10:17:20 +0100
Message-Id: <20211101082545.833634434@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>

commit ce7723e9cdae4eb3030da082876580f4b2dc0861 upstream.

With commit db5ad6b7f8cd ("nvme-tcp: try to send request in queue_rq
context") r2t and response PDU can get processed while send function
is executing.

Current data digest send code uses req->offset after kernel_sendmsg(),
this creates a race condition where req->offset gets reset before it
is used in send function.

This can happen in two cases -
1. Target sends r2t PDU which resets req->offset.
2. Target send response PDU which completes the req and then req is
   used for a new command, nvme_tcp_setup_cmd_pdu() resets req->offset.

Fix this by storing req->offset in a local variable and using
this local variable after kernel_sendmsg().

Fixes: db5ad6b7f8cd ("nvme-tcp: try to send request in queue_rq context")
Signed-off-by: Varun Prakash <varun@chelsio.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1037,6 +1037,7 @@ static int nvme_tcp_try_send_data_pdu(st
 static int nvme_tcp_try_send_ddgst(struct nvme_tcp_request *req)
 {
 	struct nvme_tcp_queue *queue = req->queue;
+	size_t offset = req->offset;
 	int ret;
 	struct msghdr msg = { .msg_flags = MSG_DONTWAIT };
 	struct kvec iov = {
@@ -1053,7 +1054,7 @@ static int nvme_tcp_try_send_ddgst(struc
 	if (unlikely(ret <= 0))
 		return ret;
 
-	if (req->offset + ret == NVME_TCP_DIGEST_LENGTH) {
+	if (offset + ret == NVME_TCP_DIGEST_LENGTH) {
 		nvme_tcp_done_send_req(queue);
 		return 1;
 	}


