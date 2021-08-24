Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7633F5605
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 04:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbhHXC6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 22:58:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233847AbhHXC6c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 22:58:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ECFC611C8;
        Tue, 24 Aug 2021 02:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629773869;
        bh=flhHQzXKNCiSDM4aaiL1rBvLmbZ8bDMjLpAFb71Pq5Q=;
        h=From:To:Cc:Subject:Date:From;
        b=U1nsy1+1DOwF493ss7rkoyXFnYewtCO3rZAg9u/qXYE6zTS5p2pZ+XAy19wwITMWJ
         rTvonLS1OkofFNzS3iOlt/qLp5VNm7r2NBYAeagp4MA9DpEXjfvHzcWUBUmx0zP7l9
         eyD3ptco19TlQSbT+5HJ7Y/1nreVXYNN+2+SfHLS6y5qXOWTvuLZWUF3Puy6SRxirC
         uV1EnTVz6JdIF+rs4kHv2wiQ9/YjQbWGhzXMq42CrbiV5TqM14AjasWJ9fw8cvS0+p
         IzjvSMhy9cLwtjLHtEv9z7mAZNB5eNzyPGmDX1oDnpkxZzYcXYABiGN1M6b4J9IowP
         4iDyBCJ8tAptQ==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: FAILED: Patch "io_uring: only assign io_uring_enter() SQPOLL error in actual error case" failed to apply to 5.10-stable tree
Date:   Mon, 23 Aug 2021 22:57:47 -0400
Message-Id: <20210824025748.658175-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 21f965221e7c42609521342403e8fb91b8b3e76e Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sat, 14 Aug 2021 09:04:40 -0600
Subject: [PATCH] io_uring: only assign io_uring_enter() SQPOLL error in actual
 error case

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
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 04c6d059ea94..6a092a534d2b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9370,9 +9370,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
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




