Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0ACF44187F
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhKAJtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232929AbhKAJo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:44:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8E876121E;
        Mon,  1 Nov 2021 09:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758989;
        bh=mihaGiEok+Hj226MMQ1qfWL5u3i23tWW2o5SAc+iwIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUwy2Ws7yjewCs6+bQH1aRlddEyXRShX0A93XG99/zE8/qlizLamt6IcIiVmA6O2m
         x7kuZsH2vMvvkvheDiLXu5Rfx6gJ6MhQW8rnENqy+4t3m4OMtFiB8q8b3zEaiSRYfQ
         mnVDBvfGz9gdBunCm2JZ4ITadvn8kihaqZSAphkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.14 066/125] nvme-tcp: fix data digest pointer calculation
Date:   Mon,  1 Nov 2021 10:17:19 +0100
Message-Id: <20211101082545.650531163@linuxfoundation.org>
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

commit d89b9f3bbb58e9e378881209756b0723694f22ff upstream.

ddgst is of type __le32, &req->ddgst + req->offset
increases &req->ddgst by 4 * req->offset, fix this by
type casting &req->ddgst to u8 *.

Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Signed-off-by: Varun Prakash <varun@chelsio.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1040,7 +1040,7 @@ static int nvme_tcp_try_send_ddgst(struc
 	int ret;
 	struct msghdr msg = { .msg_flags = MSG_DONTWAIT };
 	struct kvec iov = {
-		.iov_base = &req->ddgst + req->offset,
+		.iov_base = (u8 *)&req->ddgst + req->offset,
 		.iov_len = NVME_TCP_DIGEST_LENGTH - req->offset
 	};
 


