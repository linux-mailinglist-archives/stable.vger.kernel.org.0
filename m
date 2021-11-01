Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1438F44178D
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbhKAJhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:37:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232958AbhKAJfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:35:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B93E161165;
        Mon,  1 Nov 2021 09:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758749;
        bh=oP70mvvBFpm42lYoA/4Wu789MTu/AJSU+1ote24pc8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Tp55feM08uiZBjyuwyasQuaYAXw3eyhScY87Jm4+8v+tcfwghpvD6cX+tzP6B7b7
         qbBiLFGzxPgK25mP53XHDRr4maDj9PnrmNJ7tsrKha//By9toYo95En9uwY3ukoIiS
         D5pQWfzkPAWE8Ud1RNMtekQhqddsWr+GplVuPfcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 43/77] nvme-tcp: fix possible req->offset corruption
Date:   Mon,  1 Nov 2021 10:17:31 +0100
Message-Id: <20211101082520.940326703@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
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


