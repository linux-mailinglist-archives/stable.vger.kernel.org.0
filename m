Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360FF2171A7
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgGGPXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728879AbgGGPXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:23:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40ABD2065D;
        Tue,  7 Jul 2020 15:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135416;
        bh=icEx2rs1FcIm/j9Jcdb7xo63CLckXhpCa6bWSvF59U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+ow4+93qKnwU3rnNF+5EUk2SseCgzyPLxZyM2gUmbMMmCdoV9K+VUcudtnGmBJdx
         b44LkiX+FoIq3a16d38tZRI8ieWPRyj4n3y2lkaYwt1oza1zImzVbBm+DtzhBc2SBt
         QYgZ9upexy9kafqtJa9i+6nakJvO8ziJ/cYeJtcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 033/112] io_uring: fix io_sq_thread no schedule when busy
Date:   Tue,  7 Jul 2020 17:16:38 +0200
Message-Id: <20200707145802.563255670@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

[ Upstream commit b772f07add1c0b22e02c0f1e96f647560679d3a9 ]

When the user consumes and generates sqe at a fast rate,
io_sqring_entries can always get sqe, and ret will not be equal to -EBUSY,
so that io_sq_thread will never call cond_resched or schedule, and then
we will get the following system error prompt:

rcu: INFO: rcu_sched self-detected stall on CPU
or
watchdog: BUG: soft lockup-CPU#23 stuck for 112s! [io_uring-sq:1863]

This patch checks whether need to call cond_resched() by checking
the need_resched() function every cycle.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bb74e45941af2..63a456921903e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6084,7 +6084,7 @@ static int io_sq_thread(void *data)
 		 * If submit got -EBUSY, flag us as needing the application
 		 * to enter the kernel to reap and flush events.
 		 */
-		if (!to_submit || ret == -EBUSY) {
+		if (!to_submit || ret == -EBUSY || need_resched()) {
 			/*
 			 * Drop cur_mm before scheduling, we can't hold it for
 			 * long periods (or over schedule()). Do this before
@@ -6100,7 +6100,7 @@ static int io_sq_thread(void *data)
 			 * more IO, we should wait for the application to
 			 * reap events and wake us up.
 			 */
-			if (!list_empty(&ctx->poll_list) ||
+			if (!list_empty(&ctx->poll_list) || need_resched() ||
 			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
 			    !percpu_ref_is_dying(&ctx->refs))) {
 				if (current->task_works)
-- 
2.25.1



