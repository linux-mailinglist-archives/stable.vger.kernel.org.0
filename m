Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE49263157E
	for <lists+stable@lfdr.de>; Sun, 20 Nov 2022 18:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiKTR2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Nov 2022 12:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiKTR2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Nov 2022 12:28:13 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BC9275
        for <stable@vger.kernel.org>; Sun, 20 Nov 2022 09:28:12 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so8904020pjb.0
        for <stable@vger.kernel.org>; Sun, 20 Nov 2022 09:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XsuU+H3M3u2D+FIXWZSZgr+vWK9V5oMVu5fEmmlGnTM=;
        b=BOM0BtImH2FIi/g7YbbYOzI/qZgRZKJMBZo3NRfjjYs1WLlD2gXdxSXQyuA7AzGVUa
         YGwmEkoKWRT31nH0qOglZP2f4wUJNWzx1uI8uLw5DkJS5G6c6jSf0aQLS7ekPhaIborG
         r0eB2oEnU7uekWdsI4C25/GOp3Op3L4ZLrrOeC75CTwWm0ld+vxnDx1ctNRRv1hnfpnR
         qt2MKeF28AvjD9egvIcUJV3+51jPebWha9J3QWBPwQiG7MQkq/nhoeKBNu3Z9M7SkI5G
         wjtD5NFJnHFNchJ3FSeJhaMmptXBgdf42nqOgC1JQOE67dm8lL3plCYB2vUCR00+9SmI
         cc9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XsuU+H3M3u2D+FIXWZSZgr+vWK9V5oMVu5fEmmlGnTM=;
        b=PptkXKMKeuAqp1kpSUvFvtQPfGimen2AFlZLVcBW3KX6Q6VOjY6FP4hpsUIFLq6V+9
         /NjiaNkpcMcZyXgfF6jfCRYIAW89/ATP8X76DnapGq+Xu0dIhq0Bxr3dMsLtzB4KY9GA
         TWkquJx2eMqotauU4J/qSYskLtxtFUw1sb7BcVXL3oTSJK5keeXhNx59Z67tSy14PM+N
         KIP+2+ZR5diLRxGcEuifw0MOZQz16CljQXNvrWvwGVQFxczCZvQZF5iVJXeSu3OW2j5c
         S/Q71tn+I6hmIGyJ9LBSE2MYYfiSvRnzebKyCp+241Dd/aBnRWK/IpKcN7WcDV7maZwh
         AIaw==
X-Gm-Message-State: ANoB5pm/oHG0hN3G7NLnAFN8+2M7RGsULQPxLWVCLi0d8RkZmGxsphrD
        IcWShi7hua/NlXG2711M5P0HZ3CQLPTk8A==
X-Google-Smtp-Source: AA0mqf7GR3SUKhpj8VHRQuUOsPQxLSFGTv+QnscjV3POlq9BN0LCOK9w20UVmOQeceVM85gW0YQUgA==
X-Received: by 2002:a17:902:9004:b0:17c:9a37:72fb with SMTP id a4-20020a170902900400b0017c9a3772fbmr8115908plp.82.1668965291402;
        Sun, 20 Nov 2022 09:28:11 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d12-20020a170903230c00b0017e9b820a1asm7876953plh.100.2022.11.20.09.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 09:28:10 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 1/4] eventpoll: add EPOLL_URING wakeup flag
Date:   Sun, 20 Nov 2022 10:28:04 -0700
Message-Id: <20221120172807.358868-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221120172807.358868-1-axboe@kernel.dk>
References: <20221120172807.358868-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/eventpoll.c                 | 18 ++++++++++--------
 include/uapi/linux/eventpoll.h |  6 ++++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 52954d4637b5..e864256001e8 100644
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
@@ -1208,7 +1210,7 @@ static int ep_poll_callback(wait_queue_entry_t *wait, unsigned mode, int sync, v
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(ep, epi);
+		ep_poll_safewake(ep, epi, pollflags & EPOLL_URING);
 
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
index 8a3432d0f0dc..532cc7fa75c0 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -41,6 +41,12 @@
 #define EPOLLMSG	(__force __poll_t)0x00000400
 #define EPOLLRDHUP	(__force __poll_t)0x00002000
 
+/*
+ * Internal flag - wakeup generated by io_uring, used to detect recursion back
+ * into the io_uring poll handler.
+ */
+#define EPOLL_URING	((__force __poll_t)(1U << 27))
+
 /* Set exclusive wakeup mode for the target file descriptor */
 #define EPOLLEXCLUSIVE	((__force __poll_t)(1U << 28))
 
-- 
2.35.1

