Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210F8341C82
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhCSMVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:21:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230461AbhCSMUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:20:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 414DD64F65;
        Fri, 19 Mar 2021 12:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156453;
        bh=e7ZskurLN2Zjvhw3VZ8qsP3ILAnSTgu0xQhLUQkjq04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzLIE8FQsr8zZ3Vqy/TpCVlHF04qd5osXp5zIPiYz3Y0Q+t5Kt8+BbjJhQniitw7p
         Z3Ud0AsY9LfuSEx/KSBSoFkpYDLyTHfFcEXvBwp0E0fp37zwl9LaXUkRufEjxDaGMU
         ASLwU/XZShd7XwINCYU7xVB2DfhCQ1xc2H2b8Ls8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 07/31] io_uring: refactor scheduling in io_cqring_wait
Date:   Fri, 19 Mar 2021 13:19:01 +0100
Message-Id: <20210319121747.445396723@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit c1d5a224683b333ddbe278e455d639ccd4f5ca2b ]

schedule_timeout() with timeout=MAX_SCHEDULE_TIMEOUT is guaranteed to
work just as schedule(), so instead of hand-coding it based on arguments
always use the timeout version and simplify code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 68508f010b90..3e610ac062a3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7226,9 +7226,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		.to_wait	= min_events,
 	};
 	struct io_rings *rings = ctx->rings;
-	struct timespec64 ts;
-	signed long timeout = 0;
-	int ret = 0;
+	signed long timeout = MAX_SCHEDULE_TIMEOUT;
+	int ret;
 
 	do {
 		io_cqring_overflow_flush(ctx, false, NULL, NULL);
@@ -7252,6 +7251,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	}
 
 	if (uts) {
+		struct timespec64 ts;
+
 		if (get_timespec64(&ts, uts))
 			return -EFAULT;
 		timeout = timespec64_to_jiffies(&ts);
@@ -7277,14 +7278,10 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			finish_wait(&ctx->wait, &iowq.wq);
 			continue;
 		}
-		if (uts) {
-			timeout = schedule_timeout(timeout);
-			if (timeout == 0) {
-				ret = -ETIME;
-				break;
-			}
-		} else {
-			schedule();
+		timeout = schedule_timeout(timeout);
+		if (timeout == 0) {
+			ret = -ETIME;
+			break;
 		}
 	} while (1);
 	finish_wait(&ctx->wait, &iowq.wq);
-- 
2.30.1



