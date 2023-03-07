Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25E06AEC2C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjCGRxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbjCGRwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:52:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81D0A5926
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:47:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C029B819BB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0AAC433EF;
        Tue,  7 Mar 2023 17:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211219;
        bh=xxpeEWbtzCaCcrNYi5Os0wf7DXMlueFz6qbsMy0zr+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xp2MAy9z9AoAQio0wc925mzwGLluGr1S5vffk4W3rnzVpRxZSvKX6zBFddgewSILO
         47JE1TTi2JGA9uFnDRSXjHOEhMWN5To3La0pQMAPY1zxow47ZMRc9pwUmypkf5XHM9
         NJIHXLKwzAsYvrgtSpqEfngXVizr28QVbp/En7lI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 0761/1001] io_uring/poll: allow some retries for poll triggering spuriously
Date:   Tue,  7 Mar 2023 17:58:53 +0100
Message-Id: <20230307170054.782172167@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit c16bda37594f83147b167d381d54c010024efecf upstream.

If we get woken spuriously when polling and fail the operation with
-EAGAIN again, then we generally only allow polling again if data
had been transferred at some point. This is indicated with
REQ_F_PARTIAL_IO. However, if the spurious poll triggers when the socket
was originally empty, then we haven't transferred data yet and we will
fail the poll re-arm. This either punts the socket to io-wq if it's
blocking, or it fails the request with -EAGAIN if not. Neither condition
is desirable, as the former will slow things down, while the latter
will make the application confused.

We want to ensure that a repeated poll trigger doesn't lead to infinite
work making no progress, that's what the REQ_F_PARTIAL_IO check was
for. But it doesn't protect against a loop post the first receive, and
it's unnecessarily strict if we started out with an empty socket.

Add a somewhat random retry count, just to put an upper limit on the
potential number of retries that will be done. This should be high enough
that we won't really hit it in practice, unless something needs to be
aborted anyway.

Cc: stable@vger.kernel.org # v5.10+
Link: https://github.com/axboe/liburing/issues/364
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |   14 ++++++++++++--
 io_uring/poll.h |    1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -650,6 +650,14 @@ static void io_async_queue_proc(struct f
 	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
 }
 
+/*
+ * We can't reliably detect loops in repeated poll triggers and issue
+ * subsequently failing. But rather than fail these immediately, allow a
+ * certain amount of retries before we give up. Given that this condition
+ * should _rarely_ trigger even once, we should be fine with a larger value.
+ */
+#define APOLL_MAX_RETRY		128
+
 static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 					     unsigned issue_flags)
 {
@@ -665,14 +673,18 @@ static struct async_poll *io_req_alloc_a
 		if (entry == NULL)
 			goto alloc_apoll;
 		apoll = container_of(entry, struct async_poll, cache);
+		apoll->poll.retries = APOLL_MAX_RETRY;
 	} else {
 alloc_apoll:
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 		if (unlikely(!apoll))
 			return NULL;
+		apoll->poll.retries = APOLL_MAX_RETRY;
 	}
 	apoll->double_poll = NULL;
 	req->apoll = apoll;
+	if (unlikely(!--apoll->poll.retries))
+		return NULL;
 	return apoll;
 }
 
@@ -694,8 +706,6 @@ int io_arm_poll_handler(struct io_kiocb
 		return IO_APOLL_ABORTED;
 	if (!file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
-	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
-		return IO_APOLL_ABORTED;
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
 		mask |= EPOLLONESHOT;
 
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -12,6 +12,7 @@ struct io_poll {
 	struct file			*file;
 	struct wait_queue_head		*head;
 	__poll_t			events;
+	int				retries;
 	struct wait_queue_entry		wait;
 };
 


