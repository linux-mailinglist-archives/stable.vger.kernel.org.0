Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13F065BBD5
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbjACIQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237003AbjACIPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:15:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE8FDF4C;
        Tue,  3 Jan 2023 00:15:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D0DFB80E56;
        Tue,  3 Jan 2023 08:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F8EC433EF;
        Tue,  3 Jan 2023 08:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733745;
        bh=lyrliJQSOV8XQYB1qNXDyEHxJsVSxRLvYk3RuJLbrD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ng97aOtKiUkp+RSlJI3nLUXV0oNpReLhK2E+atWIdsyVnSIMHhJc22iZ5/5FFsyGM
         /nAxbJJ90WOA+ccvGr5sWVCbg2irM/dPCC+f18RClwCKkz94MEF1y6JJuin9efxqN5
         fNQNiXG1WuGg9Q6US224P7L2E1YKWQtOGnwY7dJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-csky@vger.kernel.org,
        Guo Ren <guoren@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 29/63] csky: add support for TIF_NOTIFY_SIGNAL
Date:   Tue,  3 Jan 2023 09:13:59 +0100
Message-Id: <20230103081310.330470070@linuxfoundation.org>
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

[ Upstream commit f3924d763c8af4c5d441b666c01f4de03ac9449e ]

Wire up TIF_NOTIFY_SIGNAL handling for csky.

Cc: linux-csky@vger.kernel.org
Acked-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/csky/include/asm/thread_info.h |    5 ++++-
 arch/csky/kernel/signal.c           |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/csky/include/asm/thread_info.h
+++ b/arch/csky/include/asm/thread_info.h
@@ -64,6 +64,7 @@ static inline struct thread_info *curren
 #define TIF_SYSCALL_TRACE	4	/* syscall trace active */
 #define TIF_SYSCALL_TRACEPOINT	5       /* syscall tracepoint instrumentation */
 #define TIF_SYSCALL_AUDIT	6	/* syscall auditing */
+#define TIF_NOTIFY_SIGNAL	7	/* signal notifications exist */
 #define TIF_POLLING_NRFLAG	16	/* poll_idle() is TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18      /* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	20	/* restore signal mask in do_signal() */
@@ -75,6 +76,7 @@ static inline struct thread_info *curren
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
@@ -82,7 +84,8 @@ static inline struct thread_info *curren
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
-				 _TIF_NOTIFY_RESUME | _TIF_UPROBE)
+				 _TIF_NOTIFY_RESUME | _TIF_UPROBE | \
+				 _TIF_NOTIFY_SIGNAL)
 
 #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
 				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP)
--- a/arch/csky/kernel/signal.c
+++ b/arch/csky/kernel/signal.c
@@ -261,7 +261,7 @@ asmlinkage void do_notify_resume(struct
 		uprobe_notify_resume(regs);
 
 	/* Handle pending signal delivery */
-	if (thread_info_flags & _TIF_SIGPENDING)
+	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		do_signal(regs);
 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {


