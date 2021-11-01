Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6494416E2
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhKAJa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233141AbhKAJ23 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:28:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F01D061212;
        Mon,  1 Nov 2021 09:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758590;
        bh=oFxIsY/aJ8ewwV+5Xa6c1c8AIfynrV3qjjxQLnLi5DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5JpTrZjRoBnQws1lo01MExccNS6ewQgLZisagWumse9awfdPQj1QJT84xVDD3Oh7
         hV1pgmOZb8dsqm8ur9ZqalFYvwcQZ4Z5av/WPrfFhQ5NteQYeq6TZdrN8Jo0bc56ry
         L0M6MEUR2Pumm7uklmWmrwP1F/t+4BMuuh707kUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.4 27/51] nvme-tcp: fix data digest pointer calculation
Date:   Mon,  1 Nov 2021 10:17:31 +0100
Message-Id: <20211101082506.727106380@linuxfoundation.org>
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
@@ -962,7 +962,7 @@ static int nvme_tcp_try_send_ddgst(struc
 	int ret;
 	struct msghdr msg = { .msg_flags = MSG_DONTWAIT | MSG_EOR };
 	struct kvec iov = {
-		.iov_base = &req->ddgst + req->offset,
+		.iov_base = (u8 *)&req->ddgst + req->offset,
 		.iov_len = NVME_TCP_DIGEST_LENGTH - req->offset
 	};
 


