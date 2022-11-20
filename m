Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5D7631584
	for <lists+stable@lfdr.de>; Sun, 20 Nov 2022 18:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiKTR2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Nov 2022 12:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiKTR2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Nov 2022 12:28:14 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0318B50
        for <stable@vger.kernel.org>; Sun, 20 Nov 2022 09:28:13 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id 71-20020a17090a09cd00b00218adeb3549so893226pjo.1
        for <stable@vger.kernel.org>; Sun, 20 Nov 2022 09:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=76MVOt/up7BUknWuGmpl00ZmM3I7BwtXZcmniA9qmuo=;
        b=cAcq15oFVNssiAaA1+sTqwpgHDh1e15jWmeDPDy66NuGC25jNsln9F+0KT/gT8gBuU
         5wE12fGK1ljHRM4UykWbPJQt0AgnRTp5cveXEZz6yNqqD3G63ciwNMc+vsBvzFmza12O
         VBOZq5POobHQs/aBFdP2XaP6Qp8veK0GMjYrAkKbu5yXtM1diyHq9iKmc9cEn9568KX7
         HvWBGh1KR9BQ5Rf2TQLxBZMOj1bUsuOHXsAcQPkTZQh24L3A0Hi1omghwJkNmxX0kAOq
         Xil6NcaJht/RmwvUEPcOeRLe2nV9S83hYKI2zw9KCwmU1L27IN7psoln3sP8cmZDt0Sg
         /dLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=76MVOt/up7BUknWuGmpl00ZmM3I7BwtXZcmniA9qmuo=;
        b=0qvELuZVPzaTJ4rljQr09ai4ylHhgdkeWhNxX8kqL81OA1jdKWqN9iWHsAPGOCydg/
         I8NIzMWCWIZ9aoQirvfslAUbheCE0DvdIhsADMoacBV0bL3hpgdNwIp9WnNzTxLGnK5d
         rPLZPaxtuj/LMe5BHS+cS4EwyUUBQhqs4aMRf8sfHzJravZ2g3MG8UEe2GtnnCAls30F
         UAja2HTuzEVDrAgoNQMZBfqnG9JXYe7sBtmjJ1unEd3GRN9v9cmrWoHEC3SrO2mYk7Qz
         +aHmk5xK6WWJD63YzpvBon2pLcJyr92+P8JBBAEX5+yQKckHtkof6vjf8B+WbwHI0sHr
         XAeA==
X-Gm-Message-State: ANoB5pnQn96eIUR8Eocpn0cdBdzNtrb73sQD050mdPN3s1KwOUIkQaaK
        YRtMVIzvqpGAKSo2byKJmOxAVQ==
X-Google-Smtp-Source: AA0mqf5Ob53srCCwHBdEZtPbGznP6xqpEBrkCTE62mgckR3fwPb9gp+xuIjYU6tp4RK9OpW76n3LyQ==
X-Received: by 2002:a17:902:d88c:b0:186:a7f1:8d2b with SMTP id b12-20020a170902d88c00b00186a7f18d2bmr8029594plz.137.1668965293255;
        Sun, 20 Nov 2022 09:28:13 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d12-20020a170903230c00b0017e9b820a1asm7876953plh.100.2022.11.20.09.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 09:28:12 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 3/4] io_uring: pass in EPOLL_URING as part of eventfd signaling and wakeups
Date:   Sun, 20 Nov 2022 10:28:06 -0700
Message-Id: <20221120172807.358868-4-axboe@kernel.dk>
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

Pass in EPOLL_URING when signaling eventfd or doing poll related wakups,
so that we can check for a circular event dependency between eventfd
and epoll. If this flag is set when our wakeup handlers are called, then
we know we have a dependency that needs to terminate multishot requests.

eventfd and epoll are the only such possible dependencies.

Cc: stable@vger.kernel.org # 6.0
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c |  4 ++--
 io_uring/io_uring.h | 15 +++++++++++----
 io_uring/poll.c     |  8 ++++++++
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8840cf3e20f2..53d0043b77a5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -495,7 +495,7 @@ static void io_eventfd_ops(struct rcu_head *rcu)
 	int ops = atomic_xchg(&ev_fd->ops, 0);
 
 	if (ops & BIT(IO_EVENTFD_OP_SIGNAL_BIT))
-		eventfd_signal(ev_fd->cq_ev_fd, 1);
+		eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING);
 
 	/* IO_EVENTFD_OP_FREE_BIT may not be set here depending on callback
 	 * ordering in a race but if references are 0 we know we have to free
@@ -531,7 +531,7 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
 		goto out;
 
 	if (likely(eventfd_signal_allowed())) {
-		eventfd_signal(ev_fd->cq_ev_fd, 1);
+		eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING);
 	} else {
 		atomic_inc(&ev_fd->refs);
 		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops))
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index cef5ff924e63..f6cf74cd692b 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -4,6 +4,7 @@
 #include <linux/errno.h>
 #include <linux/lockdep.h>
 #include <linux/io_uring_types.h>
+#include <uapi/linux/eventpoll.h>
 #include "io-wq.h"
 #include "slist.h"
 #include "filetable.h"
@@ -207,12 +208,18 @@ static inline void io_commit_cqring(struct io_ring_ctx *ctx)
 static inline void __io_cqring_wake(struct io_ring_ctx *ctx)
 {
 	/*
-	 * wake_up_all() may seem excessive, but io_wake_function() and
-	 * io_should_wake() handle the termination of the loop and only
-	 * wake as many waiters as we need to.
+	 * Trigger waitqueue handler on all waiters on our waitqueue. This
+	 * won't necessarily wake up all the tasks, io_should_wake() will make
+	 * that decision.
+	 *
+	 * Pass in EPOLLIN|EPOLL_URING as the poll wakeup key. The latter set
+	 * in the mask so that if we recurse back into our own poll waitqueue
+	 * handlers, we know we have a dependency between eventfd or epoll and
+	 * should terminate multishot poll at that point.
 	 */
 	if (waitqueue_active(&ctx->cq_wait))
-		wake_up_all(&ctx->cq_wait);
+		__wake_up(&ctx->cq_wait, TASK_NORMAL, 0,
+				poll_to_key(EPOLL_URING | EPOLLIN));
 }
 
 static inline void io_cqring_wake(struct io_ring_ctx *ctx)
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 055632e9092a..b5d9426c60f6 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -394,6 +394,14 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 		return 0;
 
 	if (io_poll_get_ownership(req)) {
+		/*
+		 * If we trigger a multishot poll off our own wakeup path,
+		 * disable multishot as there is a circular dependency between
+		 * CQ posting and triggering the event.
+		 */
+		if (mask & EPOLL_URING)
+			poll->events |= EPOLLONESHOT;
+
 		/* optional, saves extra locking for removal in tw handler */
 		if (mask && poll->events & EPOLLONESHOT) {
 			list_del_init(&poll->wait.entry);
-- 
2.35.1

