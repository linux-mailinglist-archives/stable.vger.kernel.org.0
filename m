Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3FA24107C
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgHJTaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728922AbgHJTKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:10:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7FDC22B47;
        Mon, 10 Aug 2020 19:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086622;
        bh=B7pz3A/RGxlVPXqUbuyVNgpNuReQn/DdqP+RwKMq5vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PiYnedJVx/Eu7fcr+nuZ2pfgM5io3xIT0SkSFNRgMhAWpxSEnzYxUd0rjYm6/jfvC
         t1yNtc7m09ScS6ev2bS7Z00uxoeX76b0Z3KzLCbBMHaoQrVJk7X0kbFw+E5hBiGJMD
         iTTLytYWZFngBvmpfGkCBDXd2wL6mppJwJWqzFPE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 61/64] io_uring: fix racy overflow count reporting
Date:   Mon, 10 Aug 2020 15:08:56 -0400
Message-Id: <20200810190859.3793319-61-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810190859.3793319-1-sashal@kernel.org>
References: <20200810190859.3793319-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit b2bd1cf99f3e7c8fbf12ea07af2c6998e1209e25 ]

All ->cq_overflow modifications should be under completion_lock,
otherwise it can report a wrong number to the userspace. Fix it in
io_uring_cancel_files().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index acd98df1f7d44..73f5e0a9bf2bd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7529,10 +7529,9 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				clear_bit(0, &ctx->cq_check_overflow);
 				ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
 			}
-			spin_unlock_irq(&ctx->completion_lock);
-
 			WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
+			spin_unlock_irq(&ctx->completion_lock);
 
 			/*
 			 * Put inflight ref and overflow ref. If that's
-- 
2.25.1

