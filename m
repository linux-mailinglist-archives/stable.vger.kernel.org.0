Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC20065BBEA
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbjACIQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236923AbjACIQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:16:06 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52847C14;
        Tue,  3 Jan 2023 00:16:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BF43BCE0FEA;
        Tue,  3 Jan 2023 08:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF11C433F0;
        Tue,  3 Jan 2023 08:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733762;
        bh=2oxq34liO1ryKmPeUcmFtTAz13Uo4QTI6qbeiEhScWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bu2sp7nR0HMSpxJTs7OP92PT1HE7SrJLH5opNp2tn39CcaEvyRQAIQpusMrAtfg82
         hjuwUi4HrMHfMF2IJnVZaVxkuoYW1JhJuX3s9T8UkiPCDAJsGuLDfaYcF/aE4I6nVa
         0CcM8GVydnEk0e4k8fnlSLoY1j1R8qyJG5AYw+cU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-alpha@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 34/63] alpha: add support for TIF_NOTIFY_SIGNAL
Date:   Tue,  3 Jan 2023 09:14:04 +0100
Message-Id: <20230103081310.623361636@linuxfoundation.org>
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

[ Upstream commit 5a9a8897c253a075805401d38d987ec1ac1824b6 ]

Wire up TIF_NOTIFY_SIGNAL handling for alpha.

Cc: linux-alpha@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/include/asm/thread_info.h |    2 ++
 arch/alpha/kernel/entry.S            |    2 +-
 arch/alpha/kernel/signal.c           |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -62,6 +62,7 @@ register struct thread_info *__current_t
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_SYSCALL_AUDIT	4	/* syscall audit active */
+#define TIF_NOTIFY_SIGNAL	5	/* signal notifications exist */
 #define TIF_DIE_IF_KERNEL	9	/* dik recursion lock */
 #define TIF_MEMDIE		13	/* is terminating due to OOM killer */
 #define TIF_POLLING_NRFLAG	14	/* idle is polling for TIF_NEED_RESCHED */
@@ -71,6 +72,7 @@ register struct thread_info *__current_t
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
+#define _TIF_NOTIFY_SIGNAL	(1<<TIF_NOTIFY_SIGNAL)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 
 /* Work to do on interrupt/exception return.  */
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -544,7 +544,7 @@ $ret_success:
 	.align	4
 	.type	work_pending, @function
 work_pending:
-	and	$17, _TIF_NOTIFY_RESUME | _TIF_SIGPENDING, $2
+	and	$17, _TIF_NOTIFY_RESUME | _TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL, $2
 	bne	$2, $work_notifysig
 
 $work_resched:
--- a/arch/alpha/kernel/signal.c
+++ b/arch/alpha/kernel/signal.c
@@ -527,7 +527,7 @@ do_work_pending(struct pt_regs *regs, un
 			schedule();
 		} else {
 			local_irq_enable();
-			if (thread_flags & _TIF_SIGPENDING) {
+			if (thread_flags & (_TIF_SIGPENDING|_TIF_NOTIFY_SIGNAL)) {
 				do_signal(regs, r0, r19);
 				r0 = 0;
 			} else {


