Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8C1A236D
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbfH2SPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:15:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729392AbfH2SPk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:15:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DE8623426;
        Thu, 29 Aug 2019 18:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102539;
        bh=loIvfXxJrf4NnIrQL+3Q5C5MQVuqdI6QAgWsWx7KpkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWqzyOoPT4goMXfx+Kt39TfL85PyvRwTuzy895mBm1fCv+ASCfadrEh1WTU6eSi6c
         dvjolowhRkaqITsxHIfHDpMCEkZaN8vOfveHLGzfEiH4Dbcr7jGithnIjib8fDm/X4
         wEdoO0C8fDQ0o2bdhPu6GFhyAnSoy+tATPnisUVw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 74/76] io_uring: add need_resched() check in inner poll loop
Date:   Thu, 29 Aug 2019 14:13:09 -0400
Message-Id: <20190829181311.7562-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 08f5439f1df25a6cf6cf4c72cf6c13025599ce67 ]

The outer poll loop checks for whether we need to reschedule, and
returns to userspace if we do. However, it's possible to get stuck
in the inner loop as well, if the CPU we are running on needs to
reschedule to finish the IO work.

Add the need_resched() check in the inner loop as well. This fixes
a potential hang if the kernel is configured with
CONFIG_PREEMPT_VOLUNTARY=y.

Reported-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Tested-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 83e3cede11220..03cd8f5bba850 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -716,7 +716,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 static int io_iopoll_getevents(struct io_ring_ctx *ctx, unsigned int *nr_events,
 				long min)
 {
-	while (!list_empty(&ctx->poll_list)) {
+	while (!list_empty(&ctx->poll_list) && !need_resched()) {
 		int ret;
 
 		ret = io_do_iopoll(ctx, nr_events, min);
@@ -743,6 +743,12 @@ static void io_iopoll_reap_events(struct io_ring_ctx *ctx)
 		unsigned int nr_events = 0;
 
 		io_iopoll_getevents(ctx, &nr_events, 1);
+
+		/*
+		 * Ensure we allow local-to-the-cpu processing to take place,
+		 * in this case we need to ensure that we reap all events.
+		 */
+		cond_resched();
 	}
 	mutex_unlock(&ctx->uring_lock);
 }
-- 
2.20.1

