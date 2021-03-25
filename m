Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5719348F1A
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhCYL0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhCYLZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9888461A2E;
        Thu, 25 Mar 2021 11:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671531;
        bh=urEUOJ+unEA+MVgJJVh5ooOq9+AZZXQWO6jPTuA1vu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhAhan0SV8OmuKRnFH7TNyTQwqElytor7Lgb5x6LNdy1Qj6WlpWfqe6anYuhAtitv
         VE8cTHPeem1TrspgDr3WWOB3jLkRgj4R14rX3clTCRy1mjp1t21ebjTU7b+Stt0GLD
         8vzmufBm0meC4dD/lgVSIJ64iC5cCYmEgjQN6q+KEKyVIdXiLIQb/y8vC/VUiSLayZ
         tiLCOKex1xxGP4mF1fufLVMZ986mnbRS8ZJ26oUQ+YJQTYM5XMVOxs4uiEM5xGYbUu
         wEbc5h+Kb1crFfwu4HvopqhVslWOy8u7hb+E1+lfEsZ/eBG84+kM8j+NJNhgUYlGo3
         hYqug3SQ/KIpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 24/44] io_uring: fix ->flags races by linked timeouts
Date:   Thu, 25 Mar 2021 07:24:39 -0400
Message-Id: <20210325112459.1926846-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
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
index 262fd4cfd3ad..b82fe753a6d0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6493,7 +6493,6 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	if (prev) {
-		req_set_fail_links(prev);
 		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
 		io_put_req_deferred(prev, 1);
 	} else {
-- 
2.30.1

