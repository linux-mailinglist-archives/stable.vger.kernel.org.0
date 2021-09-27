Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB95E419C4D
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236462AbhI0R1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:27:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237171AbhI0RZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:25:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FBA6613D0;
        Mon, 27 Sep 2021 17:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762957;
        bh=fcZUzwczjOEb9zt0FSjMbUg0DNYaPwq9AHHaVxyGV8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UO31P3kCXNQ14TPHZ+nwuKHIM7YooqkDbk4RIcLmSWPJ79gspu/AAE44LrUaDPY5Y
         2/vtfPbFRkfy8SBJ0Zi1sOZ7W8l5iRTquFaCYW6vUZK+lOixdHAMVkmEUCkz22JApt
         ksifswSFEVxXp8Y5p8tFv8xKCNg0K20WXIU26KKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 114/162] io_uring: put provided buffer meta data under memcg accounting
Date:   Mon, 27 Sep 2021 19:02:40 +0200
Message-Id: <20210927170237.393889051@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 9990da93d2bf9892c2c14c958bef050d4e461a1a ]

For each provided buffer, we allocate a struct io_buffer to hold the
data associated with it. As a large number of buffers can be provided,
account that data with memcg.

Fixes: ddf0322db79c ("io_uring: add IORING_OP_PROVIDE_BUFFERS")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 739e58ccc982..187eb1907bde 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4043,7 +4043,7 @@ static int io_add_buffers(struct io_provide_buf *pbuf, struct io_buffer **head)
 	int i, bid = pbuf->bid;
 
 	for (i = 0; i < pbuf->nbufs; i++) {
-		buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+		buf = kmalloc(sizeof(*buf), GFP_KERNEL_ACCOUNT);
 		if (!buf)
 			break;
 
-- 
2.33.0



