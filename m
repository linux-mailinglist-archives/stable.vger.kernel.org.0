Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FDF419C4A
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbhI0R1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237660AbhI0RZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:25:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BF166138B;
        Mon, 27 Sep 2021 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762955;
        bh=ndZ3P0EuF5SeTY+eoTaPRChv3ubGhicc3zYUPt3zmek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T41S+NqD+V0BESerCKJsXN7jBycLbgVrUmzOu43A9K7VdyffxzrhGAWfoUO+ck8CW
         Dje1D3ygfo0XjOB1Mw8+lHjbRgJ89CnBXeyK6VrH01H5Icss9/TdpfsAGF8pjmJmXD
         mKW7ElI4bifzG5CFt6XjfLrRJl3qcXRl1pAlnjuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 113/162] io_uring: fix missing set of EPOLLONESHOT for CQ ring overflow
Date:   Mon, 27 Sep 2021 19:02:39 +0200
Message-Id: <20210927170237.362444454@linuxfoundation.org>
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

From: Hao Xu <haoxu@linux.alibaba.com>

[ Upstream commit a62682f92eedb41c1cd8290fa875a4b85624fb9a ]

We should set EPOLLONESHOT if cqring_fill_event() returns false since
io_poll_add() decides to put req or not by it.

Fixes: 5082620fb2ca ("io_uring: terminate multishot poll for CQ ring overflow")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
Link: https://lore.kernel.org/r/20210922101238.7177-3-haoxu@linux.alibaba.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 27a1c813f1e1..739e58ccc982 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4968,8 +4968,10 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	}
 	if (req->poll.events & EPOLLONESHOT)
 		flags = 0;
-	if (!io_cqring_fill_event(ctx, req->user_data, error, flags))
+	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
+		req->poll.events |= EPOLLONESHOT;
 		flags = 0;
+	}
 	if (flags & IORING_CQE_F_MORE)
 		ctx->cq_extra++;
 
-- 
2.33.0



