Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 826E413807A
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730890AbgAKKaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:30:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728889AbgAKKaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:30:17 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D07C20842;
        Sat, 11 Jan 2020 10:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738616;
        bh=CFNwPztFO66+fNuWLj9lWoBwPVGYz0e6dx8S1QsPuDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2M1+ahFH/E2kDgquRRQbPCano75oRV9GIfN4/lg+2a78C71CnSVdMDVPoEvbt+4lE
         9FTcNp5tSwDCgqw2oxX2BVHy7MlBW62jlHW4523txiPYhbwzXtS+JD7/TIPeThqbI9
         bnkqKBmbLGNtatM48DnYibu4gcjJpu9HNG3f2/QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 108/165] io_uring: dont wait when under-submitting
Date:   Sat, 11 Jan 2020 10:50:27 +0100
Message-Id: <20200111094931.130840868@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 7c504e65206a4379ff38fe41d21b32b6c2c3e53e ]

There is no reliable way to submit and wait in a single syscall, as
io_submit_sqes() may under-consume sqes (in case of an early error).
Then it will wait for not-yet-submitted requests, deadlocking the user
in most cases.

Don't wait/poll if can't submit all sqes

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a60c6315a348..709671faaed6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3721,6 +3721,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		mutex_lock(&ctx->uring_lock);
 		submitted = io_ring_submit(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
+
+		if (submitted != to_submit)
+			goto out;
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
 		unsigned nr_events = 0;
@@ -3734,6 +3737,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		}
 	}
 
+out:
 	percpu_ref_put(&ctx->refs);
 out_fput:
 	fdput(f);
-- 
2.20.1



