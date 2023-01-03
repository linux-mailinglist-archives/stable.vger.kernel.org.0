Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3200C65BC0D
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbjACISf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237103AbjACISQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:18:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73278E007
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:17:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12673611F4
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D308C433D2;
        Tue,  3 Jan 2023 08:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733865;
        bh=4CWu5UjjA7X3MQwkDqn70NMffUy+PcxF0YnmzN9BDoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eL2mLBmgtas+Jodr8IDiXMGsZw76tCLnF24q1Qv/C0d+NPYiRvMFlvaZjmWlN+4Am
         XXWMl2Sb/TX9Qc2N1bmsNzU5u+PDPlEqHAMFNQ9HwUYzQ5kosjEEL6K/O0Kfjt5MJ9
         FZ7i1rKRKOSMpKDJ7LaaI6QHx92hwcBXhPNuBHao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 61/63] eventpoll: add EPOLL_URING_WAKE poll wakeup flag
Date:   Tue,  3 Jan 2023 09:14:31 +0100
Message-Id: <20230103081312.287304390@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit caf1aeaffc3b09649a56769e559333ae2c4f1802 ]

We can have dependencies between epoll and io_uring. Consider an epoll
context, identified by the epfd file descriptor, and an io_uring file
descriptor identified by iofd. If we add iofd to the epfd context, and
arm a multishot poll request for epfd with iofd, then the multishot
poll request will repeatedly trigger and generate events until terminated
by CQ ring overflow. This isn't a desired behavior.

Add EPOLL_URING so that io_uring can pass it in as part of the poll wakeup
key, and io_uring can check for that to detect a potential recursive
invocation.

Cc: stable@vger.kernel.org # 6.0
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c                 |   18 ++++++++++--------
 include/uapi/linux/eventpoll.h |    6 ++++++
 2 files changed, 16 insertions(+), 8 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -548,7 +548,8 @@ out_unlock:
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
-static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi)
+static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi,
+			     unsigned pollflags)
 {
 	struct eventpoll *ep_src;
 	unsigned long flags;
@@ -579,16 +580,17 @@ static void ep_poll_safewake(struct even
 	}
 	spin_lock_irqsave_nested(&ep->poll_wait.lock, flags, nests);
 	ep->nests = nests + 1;
-	wake_up_locked_poll(&ep->poll_wait, EPOLLIN);
+	wake_up_locked_poll(&ep->poll_wait, EPOLLIN | pollflags);
 	ep->nests = 0;
 	spin_unlock_irqrestore(&ep->poll_wait.lock, flags);
 }
 
 #else
 
-static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi)
+static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi,
+			     unsigned pollflags)
 {
-	wake_up_poll(&ep->poll_wait, EPOLLIN);
+	wake_up_poll(&ep->poll_wait, EPOLLIN | pollflags);
 }
 
 #endif
@@ -815,7 +817,7 @@ static void ep_free(struct eventpoll *ep
 
 	/* We need to release all tasks waiting for these file */
 	if (waitqueue_active(&ep->poll_wait))
-		ep_poll_safewake(ep, NULL);
+		ep_poll_safewake(ep, NULL, 0);
 
 	/*
 	 * We need to lock this because we could be hit by
@@ -1284,7 +1286,7 @@ out_unlock:
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(ep, epi);
+		ep_poll_safewake(ep, epi, pollflags & EPOLL_URING_WAKE);
 
 	if (!(epi->event.events & EPOLLEXCLUSIVE))
 		ewake = 1;
@@ -1589,7 +1591,7 @@ static int ep_insert(struct eventpoll *e
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(ep, NULL);
+		ep_poll_safewake(ep, NULL, 0);
 
 	return 0;
 
@@ -1692,7 +1694,7 @@ static int ep_modify(struct eventpoll *e
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(ep, NULL);
+		ep_poll_safewake(ep, NULL, 0);
 
 	return 0;
 }
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -41,6 +41,12 @@
 #define EPOLLMSG	(__force __poll_t)0x00000400
 #define EPOLLRDHUP	(__force __poll_t)0x00002000
 
+/*
+ * Internal flag - wakeup generated by io_uring, used to detect recursion back
+ * into the io_uring poll handler.
+ */
+#define EPOLL_URING_WAKE	((__force __poll_t)(1U << 27))
+
 /* Set exclusive wakeup mode for the target file descriptor */
 #define EPOLLEXCLUSIVE	((__force __poll_t)(1U << 28))
 


