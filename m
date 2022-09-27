Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31355ED0E8
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 01:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbiI0XRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 19:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiI0XRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 19:17:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28533112FC2;
        Tue, 27 Sep 2022 16:17:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CAFB61C33;
        Tue, 27 Sep 2022 23:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7438C43470;
        Tue, 27 Sep 2022 23:17:13 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1odJqK-00HDeI-1x;
        Tue, 27 Sep 2022 19:18:24 -0400
Message-ID: <20220927231824.209460321@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 27 Sep 2022 19:15:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 2/5] ring-buffer: Check pending waiters when doing wake ups as well
References: <20220927231523.298295015@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The wake up waiters only checks the "wakeup_full" variable and not the
"full_waiters_pending". The full_waiters_pending is set when a waiter is
added to the wait queue. The wakeup_full is only set when an event is
triggered, and it clears the full_waiters_pending to avoid multiple calls
to irq_work_queue().

The irq_work callback really needs to check both wakeup_full as well as
full_waiters_pending such that this code can be used to wake up waiters
when a file is closed that represents the ring buffer and the waiters need
to be woken up.

Cc: stable@vger.kernel.org
Fixes: 15693458c4bc0 ("tracing/ring-buffer: Move poll wake ups into ring buffer code")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 02db92c9eb1b..5a7d818ca3ea 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -917,8 +917,9 @@ static void rb_wake_up_waiters(struct irq_work *work)
 	struct rb_irq_work *rbwork = container_of(work, struct rb_irq_work, work);
 
 	wake_up_all(&rbwork->waiters);
-	if (rbwork->wakeup_full) {
+	if (rbwork->full_waiters_pending || rbwork->wakeup_full) {
 		rbwork->wakeup_full = false;
+		rbwork->full_waiters_pending = false;
 		wake_up_all(&rbwork->full_waiters);
 	}
 }
-- 
2.35.1
