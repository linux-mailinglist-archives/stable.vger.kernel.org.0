Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C03BAADC
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437781AbfIVTbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391571AbfIVSso (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:48:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 899FA21A4C;
        Sun, 22 Sep 2019 18:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178124;
        bh=qzhzxhxwZtPw9WUK7gM1IqcV5+m1vRHorMTFT6SbNOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGIMy4vp4WpJAB9MEtErxkZ3Ahs+R1ynH+rG9KI3sfI80fHNJBKAQZVWs0SpY1JeN
         YVCe+UBvEXOFtDJrTwjEObMcyMXEWy1TQicdAhAdxbXnomVou3GTsX/ynC4JhAaxX4
         LzVUxpnpD9Zo/cw9Hbvx0+STwSnImo3ulYmwUhfk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jackie Liu <liuyun01@kylinos.cn>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 178/203] io_uring: fix wrong sequence setting logic
Date:   Sun, 22 Sep 2019 14:43:24 -0400
Message-Id: <20190922184350.30563-178-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

[ Upstream commit 8776f3fa15a5cd213c4dfab7ddaf557983374ea6 ]

Sqo_thread will get sqring in batches, which will cause
ctx->cached_sq_head to be added in batches. if one of these
sqes is set with the DRAIN flag, then he will never get a
chance to process, and finally sqo_thread will not exit.

Fixes: de0617e4671 ("io_uring: add support for marking commands as draining")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cfb48bd088e12..06d048341fa41 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -288,6 +288,7 @@ struct io_ring_ctx {
 struct sqe_submit {
 	const struct io_uring_sqe	*sqe;
 	unsigned short			index;
+	u32				sequence;
 	bool				has_user;
 	bool				needs_lock;
 	bool				needs_fixed_file;
@@ -2040,7 +2041,7 @@ static int io_req_set_file(struct io_ring_ctx *ctx, const struct sqe_submit *s,
 
 	if (flags & IOSQE_IO_DRAIN) {
 		req->flags |= REQ_F_IO_DRAIN;
-		req->sequence = ctx->cached_sq_head - 1;
+		req->sequence = s->sequence;
 	}
 
 	if (!io_op_needs_file(s->sqe))
@@ -2247,6 +2248,7 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct sqe_submit *s)
 	if (head < ctx->sq_entries) {
 		s->index = head;
 		s->sqe = &ctx->sq_sqes[head];
+		s->sequence = ctx->cached_sq_head;
 		ctx->cached_sq_head++;
 		return true;
 	}
-- 
2.20.1

