Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E04BCA6CB
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405173AbfJCQr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405164AbfJCQr0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:47:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6066420865;
        Thu,  3 Oct 2019 16:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121245;
        bh=qzhzxhxwZtPw9WUK7gM1IqcV5+m1vRHorMTFT6SbNOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IohfoyjEKZy/Sc97zUKiV0G1pBB9l8M58MAvTgy9fBcN3Y+u3nfR7fWWpZSYB7Tjf
         3H8NMiyU3MpvcmPI8EbKH2h5sjc2J4CmuPnGsIVkjtW2l8OhfMsXZWnOFADWEUWvAS
         IOyuv5Cgi1ltDLAcL+pCpKuMvVHZryyE8S9l3Ha0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jackie Liu <liuyun01@kylinos.cn>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 208/344] io_uring: fix wrong sequence setting logic
Date:   Thu,  3 Oct 2019 17:52:53 +0200
Message-Id: <20191003154600.783669292@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



