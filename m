Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DD1348F76
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhCYL1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231180AbhCYL0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:26:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03FA561A42;
        Thu, 25 Mar 2021 11:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671589;
        bh=tYK6JorG/GMDG3hQ4G3ziCubcVXm1h0jIMS4881mn7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahxms33htF84KZBxEBkn+CqjW5UarQ057R75c4Knag631/C8lEfbbvweQRBVjl2Vc
         erlpudkrc/O1PVhnz86RQRI48+coUhgYdhjrD69bH/4esVwFJ/VYBFEKV29/Z7OGf5
         lguWOaEpprvkOGWR8TWmBQ7BBAJwnYr6emeCRHI6gR23xME2uhKDeAXSMkMrQRN0NG
         FT4T7R1XxSis1BnwcvyC6CA0gA1OgVm5BBFiUcbAowJfncB0ZajCtI7rsljhPnOjKC
         qsTEgsu2N9edLpwRWwqdXnziq80GOmkRBUB+Xo4MpaYvDnJjCe9XbyCOvtR2bce+1b
         Be295IXxTPt0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 23/39] io_uring: fix ->flags races by linked timeouts
Date:   Thu, 25 Mar 2021 07:25:42 -0400
Message-Id: <20210325112558.1927423-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112558.1927423-1-sashal@kernel.org>
References: <20210325112558.1927423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 691c99869143..8f57fd328df6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6231,7 +6231,6 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	if (prev) {
-		req_set_fail_links(prev);
 		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
 		io_put_req(prev);
 	} else {
-- 
2.30.1

