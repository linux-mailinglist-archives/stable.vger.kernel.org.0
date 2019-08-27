Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B79B59E0E3
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733079AbfH0IGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:06:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733073AbfH0IGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:06:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98DF3206BA;
        Tue, 27 Aug 2019 08:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893209;
        bh=HvmvIsrVqVKebI1YvpNqor93rKIy6ruroAlxsG4/1Y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O232IVRtGoQasLYdPfFYM1cC4yBtRI2h/obn8lrRonRaKiN2sobjapyt59hTxTiPa
         CMC+n9vnLPfP6kqO1cBgQnLc7QfBKTy2pUva1eCrg4h7HLuTpSlrM1evkuWhQchD2J
         VhKrp70uNpHxF8OhRL0SmZoddRhQoXEuLEr4Kmi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 159/162] io_uring: add need_resched() check in inner poll loop
Date:   Tue, 27 Aug 2019 09:51:27 +0200
Message-Id: <20190827072744.365607802@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



