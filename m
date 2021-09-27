Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B101E419C52
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbhI0R1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236643AbhI0RZc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:25:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E19CA6137C;
        Mon, 27 Sep 2021 17:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762960;
        bh=uewsuqHOAzhF6e7hHwqFiIl5eV4KRYXoxhTq1vu+WxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qGFjfNV084CB3TYSztc6lYEzBMyg7LWkDvNqf9HFtL4yTqbO23peRKJlDx3xODDKJ
         icb5PKI6V19axU7YcoSgAy7eVpslOSO/+Qch6Ghgnz9CV5kTA3ywYmsLIahMdA405O
         ZFkB++FAHr1Zjkh+YOsmCY5xLmR+bq6M+SA9wyIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 115/162] io_uring: dont punt files update to io-wq unconditionally
Date:   Mon, 27 Sep 2021 19:02:41 +0200
Message-Id: <20210927170237.424782292@linuxfoundation.org>
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

[ Upstream commit cdb31c29d397a8076d81fd1458d091c647ef94ba ]

There's no reason to punt it unconditionally, we just need to ensure that
the submit lock grabbing is conditional.

Fixes: 05f3fb3c5397 ("io_uring: avoid ring quiesce for fixed file set unregister and update")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 187eb1907bde..699a08d724c2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5919,19 +5919,16 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_uring_rsrc_update2 up;
 	int ret;
 
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-
 	up.offset = req->rsrc_update.offset;
 	up.data = req->rsrc_update.arg;
 	up.nr = 0;
 	up.tags = 0;
 	up.resv = 0;
 
-	mutex_lock(&ctx->uring_lock);
+	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
 	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
 					&up, req->rsrc_update.nr_args);
-	mutex_unlock(&ctx->uring_lock);
+	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
 
 	if (ret < 0)
 		req_set_fail(req);
-- 
2.33.0



