Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EB9441749
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbhKAJfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:35:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232591AbhKAJcN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:32:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDC7C610CA;
        Mon,  1 Nov 2021 09:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758665;
        bh=dsaKun6tFX0na/bmmAKdGf5z0k6FM6O1hCw9ug0G3B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4QlxQrv7TXQfbwXkpGufkfzDXbSmeRY92gttip2liyPOqSPYaYfEgYt92i+STMgp
         c4CgLEUp9jBsVl07VmubZMntJDzxU7By36p/AGcWTbANwDlGA3cgtH58b/YCjDusBq
         c+Y1O47JWqN0z1v/2zrWg2K09JdNi9szrqsD938I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.4 26/51] nvmet-tcp: fix data digest pointer calculation
Date:   Mon,  1 Nov 2021 10:17:30 +0100
Message-Id: <20211101082506.533867159@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
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
@@ -633,7 +633,7 @@ static int nvmet_try_send_ddgst(struct n
 	struct nvmet_tcp_queue *queue = cmd->queue;
 	struct msghdr msg = { .msg_flags = MSG_DONTWAIT };
 	struct kvec iov = {
-		.iov_base = &cmd->exp_ddgst + cmd->offset,
+		.iov_base = (u8 *)&cmd->exp_ddgst + cmd->offset,
 		.iov_len = NVME_TCP_DIGEST_LENGTH - cmd->offset
 	};
 	int ret;


