Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804D4541C13
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382854AbiFGV4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382141AbiFGVtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:49:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2405118FF11;
        Tue,  7 Jun 2022 12:08:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B06461768;
        Tue,  7 Jun 2022 19:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DC7C385A5;
        Tue,  7 Jun 2022 19:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628913;
        bh=1xphEaU64A+Q8NDY8DCsk7LVDIw4vXTtIDDTXjOER0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPsHLHzHS/FeLP6xIzS39z0qqe/vnJfgREmPexgRTUOw8pjdoGX5GT+LqW+xAFZ5e
         /Rjtu81428sVvoH0fTbzP5i1Esro63exTEi8tLxzI8eBLNxUd+VGze++Y20i10zcBg
         Qsmljk7MN03rUtCsGTwf/hMu0U2iyt4kHxRT9iBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Yudaken <dylany@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 461/879] io_uring: only wake when the correct events are set
Date:   Tue,  7 Jun 2022 18:59:39 +0200
Message-Id: <20220607165016.254910676@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dylan Yudaken <dylany@fb.com>

[ Upstream commit 1b1d7b4bf1d9948c8dba5ee550459ce7c65ac019 ]

The check for waking up a request compares the poll_t bits, however this
will always contain some common flags so this always wakes up.

For files with single wait queues such as sockets this can cause the
request to be sent to the async worker unnecesarily. Further if it is
non-blocking will complete the request with EAGAIN which is not desired.

Here exclude these common events, making sure to not exclude POLLERR which
might be important.

Fixes: d7718a9d25a6 ("io_uring: use poll driven retry for files that support it")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
Link: https://lore.kernel.org/r/20220512091834.728610-3-dylany@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7272e410d24a..9e247335e70d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5981,6 +5981,7 @@ static void io_poll_cancel_req(struct io_kiocb *req)
 
 #define wqe_to_req(wait)	((void *)((unsigned long) (wait)->private & ~1))
 #define wqe_is_double(wait)	((unsigned long) (wait)->private & 1)
+#define IO_ASYNC_POLL_COMMON	(EPOLLONESHOT | POLLPRI)
 
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			void *key)
@@ -6015,7 +6016,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	}
 
 	/* for instances that support it check for an event match first */
-	if (mask && !(mask & poll->events))
+	if (mask && !(mask & (poll->events & ~IO_ASYNC_POLL_COMMON)))
 		return 0;
 
 	if (io_poll_get_ownership(req)) {
@@ -6171,7 +6172,7 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
-	__poll_t mask = EPOLLONESHOT | POLLERR | POLLPRI;
+	__poll_t mask = IO_ASYNC_POLL_COMMON | POLLERR;
 	int ret;
 
 	if (!def->pollin && !def->pollout)
-- 
2.35.1



