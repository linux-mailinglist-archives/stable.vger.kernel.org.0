Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F9365B105
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbjABL3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236117AbjABL3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:29:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4756591
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:28:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB33F60F37
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A57C433D2;
        Mon,  2 Jan 2023 11:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658930;
        bh=HeJkn1jLxWY+w8gyUnKdkWnaovpbLoor7n8BwgMK9Rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYl/NGWEx/MR+/FAzFWZ+llvY7mmWe9XZwApj57pyVlim9pt2qTrbiHO39i0vWtek
         qCIekkZKGtWnsWAwhhb6wnvesBM14rj1snyv3dDi318WtdFK8yt5+ExkCCkLk8k8L3
         v05G79zk8wWMwUsLt+eZrOomfPnBk2rHWZFpuIuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 53/74] eventpoll: add EPOLL_URING_WAKE poll wakeup flag
Date:   Mon,  2 Jan 2023 12:22:26 +0100
Message-Id: <20230102110554.366305960@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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

commit caf1aeaffc3b09649a56769e559333ae2c4f1802 upstream.

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
 fs/eventpoll.c                 | 18 ++++++++++--------
 include/uapi/linux/eventpoll.h |  6 ++++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 52954d4637b5..64659b110973 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -491,7 +491,8 @@ static inline void ep_set_busy_poll_napi_id(struct epitem *epi)
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
-static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi)
+static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi,
+			     unsigned pollflags)
 {
 	struct eventpoll *ep_src;
 	unsigned long flags;
@@ -522,16 +523,17 @@ static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi)
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
@@ -742,7 +744,7 @@ static void ep_free(struct eventpoll *ep)
 
 	/* We need to release all tasks waiting for these file */
 	if (waitqueue_active(&ep->poll_wait))
-		ep_poll_safewake(ep, NULL);
+		ep_poll_safewake(ep, NULL, 0);
 
 	/*
 	 * We need to lock this because we could be hit by
@@ -1208,7 +1210,7 @@ out_unlock:
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(ep, epi);
+		ep_poll_safewake(ep, epi, pollflags & EPOLL_URING_WAKE);
 
 	if (!(epi->event.events & EPOLLEXCLUSIVE))
 		ewake = 1;
@@ -1553,7 +1555,7 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(ep, NULL);
+		ep_poll_safewake(ep, NULL, 0);
 
 	return 0;
 }
@@ -1629,7 +1631,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
 
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



