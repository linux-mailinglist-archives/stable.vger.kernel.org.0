Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFEF419B18
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236659AbhI0RPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:15:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236956AbhI0RN0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:13:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19C9A61350;
        Mon, 27 Sep 2021 17:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762561;
        bh=5PpxMosUvbaHxWTsZ4bA+bjUF2Cj80aRhhZh5tYbYn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6+wRRsApZkqpPa6CTH6pRShzd7jai8+bk8LHMjV76cONoHYvUzIVYljyGFNYrOsv
         ImH9Y2utXrvqqhhqKiMmjcYfjrZCkFjfkIB8NJe8g80cH8AGA0c3TnLCoArWxwSr1A
         EsxfwTmx3A/8/MB9v/oQ4KiRnGkr4ZPz/NbBBJqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/103] io_uring: put provided buffer meta data under memcg accounting
Date:   Mon, 27 Sep 2021 19:02:43 +0200
Message-Id: <20210927170228.223387332@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
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
index a8d07273ddc0..26753d0cb431 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4041,7 +4041,7 @@ static int io_add_buffers(struct io_provide_buf *pbuf, struct io_buffer **head)
 	int i, bid = pbuf->bid;
 
 	for (i = 0; i < pbuf->nbufs; i++) {
-		buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+		buf = kmalloc(sizeof(*buf), GFP_KERNEL_ACCOUNT);
 		if (!buf)
 			break;
 
-- 
2.33.0



