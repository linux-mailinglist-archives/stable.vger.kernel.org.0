Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6D844189B
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhKAJth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232346AbhKAJoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:44:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B2D361407;
        Mon,  1 Nov 2021 09:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758986;
        bh=Z/cUCPXMS5z1azsoc/8KO/HVpK3NL+kZ3c427D6Fh2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2du3pCrtVIJTsqV4O5OMP8E3w0eAncjqZnELrzi43Dfgj651GmOypWY8feqcxOqb
         aXrrcqXl97CrW31Qn+hHGPC2UnlgfH3TTLNNnojkXHWXohMa53xyHi6f617/TlpIQY
         hg11ZbVMnKy4R5P0xx32Vv/RmoUiiS6uO7ryW720=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.14 065/125] nvmet-tcp: fix data digest pointer calculation
Date:   Mon,  1 Nov 2021 10:17:18 +0100
Message-Id: <20211101082545.463654423@linuxfoundation.org>
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
@@ -702,7 +702,7 @@ static int nvmet_try_send_ddgst(struct n
 	struct nvmet_tcp_queue *queue = cmd->queue;
 	struct msghdr msg = { .msg_flags = MSG_DONTWAIT };
 	struct kvec iov = {
-		.iov_base = &cmd->exp_ddgst + cmd->offset,
+		.iov_base = (u8 *)&cmd->exp_ddgst + cmd->offset,
 		.iov_len = NVME_TCP_DIGEST_LENGTH - cmd->offset
 	};
 	int ret;


