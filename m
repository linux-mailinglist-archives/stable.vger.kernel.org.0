Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A95B3F6441
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbhHXRCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235118AbhHXRAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:00:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C65B2615A6;
        Tue, 24 Aug 2021 16:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824269;
        bh=sUdnMZ87hKclP//RayoM2+eP99F1/e2lqLdI5PC3wR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gIlH+bismzI678X+yURlmz3DBh9OPaJQwL8/sk/fe3rBYcky0viFI9meYXrqcW+Pa
         WfE5tvdG6WuQbkOw1QVWrpqfHXtHPsHIreTqoU7Mqj4sisbJSrr87vUozK4WYidwc4
         hTPhSo9ZpmtOuw2GzXBRaGA1Evvymr9txM65xUhUfxSpfrCrlGHDq6FRTTdtwj/s+p
         FN2sTth6s/lHTRR8+D4oVOioPMj6cXcd5OVENnRRobsMBL26lXOQ3WZcoRXctWXPkT
         KZlhhxglkyygtURhYSut7TtT3ho5KFDjgq0KXE0aRcAeel0JNNI0zNczbCWqOPXLhm
         he7o8HFUOXJ8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 103/127] io_uring: only assign io_uring_enter() SQPOLL error in actual error case
Date:   Tue, 24 Aug 2021 12:55:43 -0400
Message-Id: <20210824165607.709387-104-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 21f965221e7c42609521342403e8fb91b8b3e76e ]

If an SQPOLL based ring is newly created and an application issues an
io_uring_enter(2) system call on it, then we can return a spurious
-EOWNERDEAD error. This happens because there's nothing to submit, and
if the caller doesn't specify any other action, the initial error
assignment of -EOWNERDEAD never gets overwritten. This causes us to
return it directly, even if it isn't valid.

Move the error assignment into the actual failure case instead.

Cc: stable@vger.kernel.org
Fixes: d9d05217cb69 ("io_uring: stop SQPOLL submit on creator's death")
Reported-by: Sherlock Holo sherlockya@gmail.com
Link: https://github.com/axboe/liburing/issues/413
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 00746109e0c8..221b80ae831f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9362,9 +9362,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		io_cqring_overflow_flush(ctx, false);
 
-		ret = -EOWNERDEAD;
-		if (unlikely(ctx->sq_data->thread == NULL))
+		if (unlikely(ctx->sq_data->thread == NULL)) {
+			ret = -EOWNERDEAD;
 			goto out;
+		}
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT) {
-- 
2.30.2

