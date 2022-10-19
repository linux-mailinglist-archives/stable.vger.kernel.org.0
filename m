Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079236044EF
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbiJSMTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbiJSMSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:18:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1289136403;
        Wed, 19 Oct 2022 04:54:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00F99B822BB;
        Wed, 19 Oct 2022 09:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F77C433D6;
        Wed, 19 Oct 2022 09:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170148;
        bh=6A4G5ttVug3XAxhzsOqGeSmvV1mp2WWrcAMaD8Bz/k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abVJlzuzJx3hexX5PeEqOSdur8KO1npIUlD2kkvBdT4nNB2RMvXxK3n5sM1EU9tzV
         3aXQEuVsHqI+QNyRgk7xhsmgzSf8FpTT70JI5R8Qwpz30JCwJGrUkljC4RiRkIVnIO
         RnP9OG1SsVGQbhS8T92ldDxxIHdJ1VgCtcWH+kNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Yudaken <dylany@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 545/862] eventfd: guard wake_up in eventfd fs calls as well
Date:   Wed, 19 Oct 2022 10:30:32 +0200
Message-Id: <20221019083314.035666345@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dylan Yudaken <dylany@fb.com>

[ Upstream commit 9f0deaa12d832f488500a5afe9b912e9b3cfc432 ]

Guard wakeups that the user can trigger, and that may end up triggering a
call back into eventfd_signal. This is in addition to the current approach
that only guards in eventfd_signal.

Rename in_eventfd_signal -> in_eventfd at the same time to reflect this.

Without this there would be a deadlock in the following code using libaio:

int main()
{
	struct io_context *ctx = NULL;
	struct iocb iocb;
	struct iocb *iocbs[] = { &iocb };
	int evfd;
        uint64_t val = 1;

	evfd = eventfd(0, EFD_CLOEXEC);
	assert(!io_setup(2, &ctx));
	io_prep_poll(&iocb, evfd, POLLIN);
	io_set_eventfd(&iocb, evfd);
	assert(1 == io_submit(ctx, 1, iocbs));
        write(evfd, &val, 8);
}

Signed-off-by: Dylan Yudaken <dylany@fb.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/r/20220816135959.1490641-1-dylany@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventfd.c            |   10 +++++++---
 include/linux/eventfd.h |    2 +-
 include/linux/sched.h   |    2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -69,17 +69,17 @@ __u64 eventfd_signal(struct eventfd_ctx
 	 * it returns false, the eventfd_signal() call should be deferred to a
 	 * safe context.
 	 */
-	if (WARN_ON_ONCE(current->in_eventfd_signal))
+	if (WARN_ON_ONCE(current->in_eventfd))
 		return 0;
 
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
-	current->in_eventfd_signal = 1;
+	current->in_eventfd = 1;
 	if (ULLONG_MAX - ctx->count < n)
 		n = ULLONG_MAX - ctx->count;
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
 		wake_up_locked_poll(&ctx->wqh, EPOLLIN);
-	current->in_eventfd_signal = 0;
+	current->in_eventfd = 0;
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return n;
@@ -253,8 +253,10 @@ static ssize_t eventfd_read(struct kiocb
 		__set_current_state(TASK_RUNNING);
 	}
 	eventfd_ctx_do_read(ctx, &ucnt);
+	current->in_eventfd = 1;
 	if (waitqueue_active(&ctx->wqh))
 		wake_up_locked_poll(&ctx->wqh, EPOLLOUT);
+	current->in_eventfd = 0;
 	spin_unlock_irq(&ctx->wqh.lock);
 	if (unlikely(copy_to_iter(&ucnt, sizeof(ucnt), to) != sizeof(ucnt)))
 		return -EFAULT;
@@ -301,8 +303,10 @@ static ssize_t eventfd_write(struct file
 	}
 	if (likely(res > 0)) {
 		ctx->count += ucnt;
+		current->in_eventfd = 1;
 		if (waitqueue_active(&ctx->wqh))
 			wake_up_locked_poll(&ctx->wqh, EPOLLIN);
+		current->in_eventfd = 0;
 	}
 	spin_unlock_irq(&ctx->wqh.lock);
 
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -46,7 +46,7 @@ void eventfd_ctx_do_read(struct eventfd_
 
 static inline bool eventfd_signal_allowed(void)
 {
-	return !current->in_eventfd_signal;
+	return !current->in_eventfd;
 }
 
 #else /* CONFIG_EVENTFD */
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -936,7 +936,7 @@ struct task_struct {
 #endif
 #ifdef CONFIG_EVENTFD
 	/* Recursion prevention for eventfd_signal() */
-	unsigned			in_eventfd_signal:1;
+	unsigned			in_eventfd:1;
 #endif
 #ifdef CONFIG_IOMMU_SVA
 	unsigned			pasid_activated:1;


