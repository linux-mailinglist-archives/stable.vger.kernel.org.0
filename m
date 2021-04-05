Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9428E353F7E
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239243AbhDEJMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239161AbhDEJMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:12:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C84661398;
        Mon,  5 Apr 2021 09:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613937;
        bh=1LGFYN4CYv4Ej0ILyBEqVgC+nXewIRtPJtIZGbid2jA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxRZcNbhgPGilQvPxjxNFBPNI7Yb6U6RnZxTiwvfUol2E+8fJdZfYj2Jy8PgcL8Wk
         XFNRVn6yrN7Rps2B5VKQqcv/nlObxkcdLIznHeRfXJKyrDYY+5etsTn2E48G8/ooCu
         emB0IJmg/XrrcO6Yq/fnzypx7mMQT48R/91QXVxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 022/152] io_uring: fix ->flags races by linked timeouts
Date:   Mon,  5 Apr 2021 10:52:51 +0200
Message-Id: <20210405085034.966628404@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit efe814a471e0e58f28f1efaf430c8784a4f36626 ]

It's racy to modify req->flags from a not owning context, e.g. linked
timeout calling req_set_fail_links() for the master request might race
with that request setting/clearing flags while being executed
concurrently. Just remove req_set_fail_links(prev) from
io_link_timeout_fn(), io_async_find_and_cancel() and functions down the
line take care of setting the fail bit.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5c4378694d54..381f82ebd282 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6496,7 +6496,6 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	if (prev) {
-		req_set_fail_links(prev);
 		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
 		io_put_req_deferred(prev, 1);
 	} else {
-- 
2.30.1



