Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37C965BC08
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbjACISd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237044AbjACISL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:18:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC4BE0AD
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:17:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 188AF611F9
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C40BC433D2;
        Tue,  3 Jan 2023 08:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733859;
        bh=ohY9Vjf6EMTTLGLcgy72VHnIJwgMLFGzZFK1OmGw0vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gy4Qnz/zaQKIyT7g/VUZ3v/Z7bh3VKV4/NcsQRtO9TVxeN2RytdhgoZUUYpEMl5dM
         o7EOVU+JOtsDajemAMO+xNLhnQ7WxEdIln0PLs5p80KHpUJSoNjSCcldDYYadI6cgG
         3HtgRA8JqaXmw59M03QzcuUPSQJ9+P2IgRFuh+ZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, uclinux-h8-devel@lists.sourceforge.jp,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 36/63] h8300: add support for TIF_NOTIFY_SIGNAL
Date:   Tue,  3 Jan 2023 09:14:06 +0100
Message-Id: <20230103081310.743092944@linuxfoundation.org>
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

[ Upstream commit 2f9799ad0111ee742ccc02dd2ea2c87646746fc1 ]

Wire up TIF_NOTIFY_SIGNAL handling for h8300.

Cc: uclinux-h8-devel@lists.sourceforge.jp
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/h8300/include/asm/thread_info.h |    4 +++-
 arch/h8300/kernel/signal.c           |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/h8300/include/asm/thread_info.h
+++ b/arch/h8300/include/asm/thread_info.h
@@ -73,6 +73,7 @@ static inline struct thread_info *curren
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SYSCALL_TRACEPOINT	8	/* for ftrace syscall instrumentation */
 #define TIF_POLLING_NRFLAG	9	/* true if poll_idle() is polling TIF_NEED_RESCHED */
+#define TIF_NOTIFY_SIGNAL	10	/* signal notifications exist */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
@@ -83,6 +84,7 @@ static inline struct thread_info *curren
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 
 /* work to do in syscall trace */
 #define _TIF_WORK_SYSCALL_MASK	(_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP | \
@@ -92,7 +94,7 @@ static inline struct thread_info *curren
 #define _TIF_ALLWORK_MASK	(_TIF_SYSCALL_TRACE | _TIF_SIGPENDING      | \
 				 _TIF_NEED_RESCHED  | _TIF_SYSCALL_AUDIT   | \
 				 _TIF_SINGLESTEP    | _TIF_NOTIFY_RESUME   | \
-				 _TIF_SYSCALL_TRACEPOINT)
+				 _TIF_SYSCALL_TRACEPOINT | _TIF_NOTIFY_SIGNAL)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(_TIF_ALLWORK_MASK & ~(_TIF_SYSCALL_TRACE | \
--- a/arch/h8300/kernel/signal.c
+++ b/arch/h8300/kernel/signal.c
@@ -279,7 +279,7 @@ static void do_signal(struct pt_regs *re
 
 asmlinkage void do_notify_resume(struct pt_regs *regs, u32 thread_info_flags)
 {
-	if (thread_info_flags & _TIF_SIGPENDING)
+	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		do_signal(regs);
 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME)


