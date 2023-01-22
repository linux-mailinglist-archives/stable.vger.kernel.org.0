Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F8B676EF7
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbjAVPQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbjAVPQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:16:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FF622038
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:16:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3AD660C48
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DDBC433EF;
        Sun, 22 Jan 2023 15:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400577;
        bh=AeCHHQjwEnJ406A9haBiXqp0zCwTpMkEvbCGhoH5fu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3kan2a1OqwfQ/r23R2ZKVJsZhn7VsDb+aefhBXydWH7lGJci4F5bRxJks7wK+8O8
         cP7J9qitWclGkp0PlAPp2b9X7qKE+5GdSFQhe8+PuL3gig2mjKT+SCsru47x1cgeR3
         FV1dL+UHcdgHZtD0mBqnQLHMW4zMnFkrEMyWqp9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/117] eventpoll: add EPOLL_URING_WAKE poll wakeup flag
Date:   Sun, 22 Jan 2023 16:03:38 +0100
Message-Id: <20230122150233.875098720@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c                 | 18 ++++++++++--------
 include/uapi/linux/eventpoll.h |  6 ++++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index cf326c53db0f..1ec197825544 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -484,7 +484,8 @@ static inline void ep_set_busy_poll_napi_id(struct epitem *epi)
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
-static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi)
+static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi,
+			     unsigned pollflags)
 {
 	struct eventpoll *ep_src;
 	unsigned long flags;
@@ -515,16 +516,17 @@ static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi)
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
@@ -735,7 +737,7 @@ static void ep_free(struct eventpoll *ep)
 
 	/* We need to release all tasks waiting for these file */
 	if (waitqueue_active(&ep->poll_wait))
-		ep_poll_safewake(ep, NULL);
+		ep_poll_safewake(ep, NULL, 0);
 
 	/*
 	 * We need to lock this because we could be hit by
@@ -1201,7 +1203,7 @@ static int ep_poll_callback(wait_queue_entry_t *wait, unsigned mode, int sync, v
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(ep, epi);
+		ep_poll_safewake(ep, epi, pollflags & EPOLL_URING_WAKE);
 
 	if (!(epi->event.events & EPOLLEXCLUSIVE))
 		ewake = 1;
@@ -1546,7 +1548,7 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(ep, NULL);
+		ep_poll_safewake(ep, NULL, 0);
 
 	return 0;
 }
@@ -1622,7 +1624,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(ep, NULL);
+		ep_poll_safewake(ep, NULL, 0);
 
 	return 0;
 }
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index 8a3432d0f0dc..e687658843b1 100644
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
 
-- 
2.39.0



