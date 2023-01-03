Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF48F65BBE1
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbjACIQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237044AbjACIQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:16:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BF1D73
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:16:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1486611F3
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6158C433D2;
        Tue,  3 Jan 2023 08:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733779;
        bh=rGnLQW0KYhZj3CJ2qeg+Xt8P52Lv49N2I110CqaeL/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBo3cqOiSlT0Lj7kw9I6tg22qUwyHcIkv6xq1rjZraCF5foQrWi718o7vdh7DGvIe
         l200srQ1qYrZ6YrocS9uPb0O1umEK/JbrjhJNZbATC2w3mlN0UkhSLwjEhScbalRr+
         +vBuqHynDKliyv5W8eRIKzJMpG/5brHyRSO5ivw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 19/63] arm64: add support for TIF_NOTIFY_SIGNAL
Date:   Tue,  3 Jan 2023 09:13:49 +0100
Message-Id: <20230103081309.719639438@linuxfoundation.org>
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

[ Upstream commit 192caabd4dd92c98d23ed4334d7596af05af2fb4 ]

Wire up TIF_NOTIFY_SIGNAL handling for arm64.

Cc: linux-arm-kernel@lists.infradead.org
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/thread_info.h |    5 ++++-
 arch/arm64/kernel/signal.c           |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -68,6 +68,7 @@ void arch_release_task_struct(struct tas
 #define TIF_UPROBE		4	/* uprobe breakpoint or singlestep */
 #define TIF_FSCHECK		5	/* Check FS is USER_DS on return */
 #define TIF_MTE_ASYNC_FAULT	6	/* MTE Asynchronous Tag Check Fault */
+#define TIF_NOTIFY_SIGNAL	7	/* signal notifications exist */
 #define TIF_SYSCALL_TRACE	8	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	9	/* syscall auditing */
 #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
@@ -98,10 +99,12 @@ void arch_release_task_struct(struct tas
 #define _TIF_32BIT		(1 << TIF_32BIT)
 #define _TIF_SVE		(1 << TIF_SVE)
 #define _TIF_MTE_ASYNC_FAULT	(1 << TIF_MTE_ASYNC_FAULT)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
 				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE | \
-				 _TIF_UPROBE | _TIF_FSCHECK | _TIF_MTE_ASYNC_FAULT)
+				 _TIF_UPROBE | _TIF_FSCHECK | _TIF_MTE_ASYNC_FAULT | \
+				 _TIF_NOTIFY_SIGNAL)
 
 #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
 				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -938,7 +938,7 @@ asmlinkage void do_notify_resume(struct
 					       (void __user *)NULL, current);
 			}
 
-			if (thread_flags & _TIF_SIGPENDING)
+			if (thread_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 				do_signal(regs);
 
 			if (thread_flags & _TIF_NOTIFY_RESUME) {


