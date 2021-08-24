Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300053F6576
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239677AbhHXRNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:13:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240301AbhHXRLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:11:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D6C161A6C;
        Tue, 24 Aug 2021 17:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824445;
        bh=ccZ06tpZkMf3ZaosIbzOufFlKZXwfcpWHxfEn/T88rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkcNCfMFBroTYIRyhjH16o3dKu9Ku9f92OtauUzyyz5D66mo3+VRvgS7YbRkJAgHz
         xbv2n0XnDMTD4Ac70cNJT/1NVbEGBZrd4aGjtypFo4bJHrLE6z6U19mnK7mBC7BlG0
         3l9Tq0YVsI2J6salJvk60jkSm4QUbZG2OiyFD/oj1diOwTI3sBGBsXywWfYQ0FMOpa
         YoFVI/BMIhslWvJ8DZ4E0ml05egtJ+8wT9HZSgL/H9QtWgBiLEPbystmY/NwPaAfmJ
         FSdY7kff/IajDsBAwZN1H/d77+/MLZl37gp3wtjzjW6kVbBH0PmTJIH/pmKmLjEW4K
         18YFmp7xj7Szw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 97/98] io_uring: only assign io_uring_enter() SQPOLL error in actual error case
Date:   Tue, 24 Aug 2021 12:59:07 -0400
Message-Id: <20210824165908.709932-98-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ upstream commit 21f965221e7c42609521342403e8fb91b8b3e76e ]

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
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 762eae2440b5..108b0ed31c11 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9078,9 +9078,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		io_cqring_overflow_flush(ctx, false, NULL, NULL);
 
-		ret = -EOWNERDEAD;
-		if (unlikely(ctx->sqo_dead))
+		if (unlikely(ctx->sqo_dead)) {
+			ret = -EOWNERDEAD;
 			goto out;
+		}
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT) {
-- 
2.30.2

