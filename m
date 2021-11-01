Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EC14417D1
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbhKAJkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233740AbhKAJh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:37:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0541E6135F;
        Mon,  1 Nov 2021 09:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758821;
        bh=73kbLrNQx+k4FLJe261GHYcAhY78v1LnKm7hh+TgTs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ageqs7yCKGtmVPIPIjQV0zTqUumley+RYY6jQ3tW5aLdshzyMec4LVXb72nT7cWAP
         Qy8GMmfxuTKEqKm0v0Ia7ljE9C7+TZSWxN1IWJ5sSQEgwnQIGXzrDXxd9z2JIKeyRR
         dwfV+bpWAfHdBAM3sl5P7QoWqFLF2WYgWy2Lsc3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 41/77] nvmet-tcp: fix data digest pointer calculation
Date:   Mon,  1 Nov 2021 10:17:29 +0100
Message-Id: <20211101082520.522300494@linuxfoundation.org>
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

commit e790de54e94a7a15fb725b34724d41d41cbaa60c upstream.

exp_ddgst is of type __le32, &cmd->exp_ddgst + cmd->offset increases
&cmd->exp_ddgst by 4 * cmd->offset, fix this by type casting
&cmd->exp_ddgst to u8 *.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Signed-off-by: Varun Prakash <varun@chelsio.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -690,7 +690,7 @@ static int nvmet_try_send_ddgst(struct n
 	struct nvmet_tcp_queue *queue = cmd->queue;
 	struct msghdr msg = { .msg_flags = MSG_DONTWAIT };
 	struct kvec iov = {
-		.iov_base = &cmd->exp_ddgst + cmd->offset,
+		.iov_base = (u8 *)&cmd->exp_ddgst + cmd->offset,
 		.iov_len = NVME_TCP_DIGEST_LENGTH - cmd->offset
 	};
 	int ret;


