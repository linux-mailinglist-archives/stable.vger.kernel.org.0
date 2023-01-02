Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3989165B07E
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbjABLX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbjABLXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:23:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AFF5F61
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:23:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 149C260E76
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE42C433D2;
        Mon,  2 Jan 2023 11:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658627;
        bh=bx1CHs0HiGSPbYFh3kGTr1T49A9//Zdu1SW+nGxb6Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sf9j7c5i/A9dvLe6j1WjTSzgdDAVkv8wpuQr7cNHp/APUpr23WYXfNCLpU340YFiY
         nXOfQM/ROzMKYvp621ipbakMCI+/e8mX0iRp/reZbe/tQhBNxJk/hyBwaSm6vrWtfF
         kzhUMc2XOBcLpWliFlJPsBP+X0p1oaHgoAlUsrFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 02/71] eventfd: provide a eventfd_signal_mask() helper
Date:   Mon,  2 Jan 2023 12:21:27 +0100
Message-Id: <20230102110551.616071258@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
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

[ Upstream commit 03e02acda8e267a8183e1e0ed289ff1ef9cd7ed8 ]

This is identical to eventfd_signal(), but it allows the caller to pass
in a mask to be used for the poll wakeup key. The use case is avoiding
repeated multishot triggers if we have a dependency between eventfd and
io_uring.

If we setup an eventfd context and register that as the io_uring eventfd,
and at the same time queue a multishot poll request for the eventfd
context, then any CQE posted will repeatedly trigger the multishot request
until it terminates when the CQ ring overflows.

In preparation for io_uring detecting this circular dependency, add the
mentioned helper so that io_uring can pass in EPOLL_URING as part of the
poll wakeup key.

Cc: stable@vger.kernel.org # 6.0
[axboe: fold in !CONFIG_EVENTFD fix from Zhang Qilong]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 4464853277d0 ("io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and wakeups")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventfd.c            | 37 +++++++++++++++++++++----------------
 include/linux/eventfd.h |  7 +++++++
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index c0ffee99ad23..249ca6c0b784 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -43,21 +43,7 @@ struct eventfd_ctx {
 	int id;
 };
 
-/**
- * eventfd_signal - Adds @n to the eventfd counter.
- * @ctx: [in] Pointer to the eventfd context.
- * @n: [in] Value of the counter to be added to the eventfd internal counter.
- *          The value cannot be negative.
- *
- * This function is supposed to be called by the kernel in paths that do not
- * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
- * value, and we signal this as overflow condition by returning a EPOLLERR
- * to poll(2).
- *
- * Returns the amount by which the counter was incremented.  This will be less
- * than @n if the counter has overflowed.
- */
-__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
+__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, unsigned mask)
 {
 	unsigned long flags;
 
@@ -78,12 +64,31 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 		n = ULLONG_MAX - ctx->count;
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
-		wake_up_locked_poll(&ctx->wqh, EPOLLIN);
+		wake_up_locked_poll(&ctx->wqh, EPOLLIN | mask);
 	current->in_eventfd = 0;
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return n;
 }
+
+/**
+ * eventfd_signal - Adds @n to the eventfd counter.
+ * @ctx: [in] Pointer to the eventfd context.
+ * @n: [in] Value of the counter to be added to the eventfd internal counter.
+ *          The value cannot be negative.
+ *
+ * This function is supposed to be called by the kernel in paths that do not
+ * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
+ * value, and we signal this as overflow condition by returning a EPOLLERR
+ * to poll(2).
+ *
+ * Returns the amount by which the counter was incremented.  This will be less
+ * than @n if the counter has overflowed.
+ */
+__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
+{
+	return eventfd_signal_mask(ctx, n, 0);
+}
 EXPORT_SYMBOL_GPL(eventfd_signal);
 
 static void eventfd_free_ctx(struct eventfd_ctx *ctx)
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 3cd202d3eefb..36a486505b08 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -40,6 +40,7 @@ struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
 __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n);
+__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, unsigned mask);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_entry_t *wait,
 				  __u64 *cnt);
 void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt);
@@ -66,6 +67,12 @@ static inline int eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 	return -ENOSYS;
 }
 
+static inline int eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n,
+				      unsigned mask)
+{
+	return -ENOSYS;
+}
+
 static inline void eventfd_ctx_put(struct eventfd_ctx *ctx)
 {
 
-- 
2.35.1



