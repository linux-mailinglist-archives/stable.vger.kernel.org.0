Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC5965BBD3
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbjACIQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237011AbjACIPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:15:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DD3DF47;
        Tue,  3 Jan 2023 00:15:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42024B80E4B;
        Tue,  3 Jan 2023 08:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77973C433D2;
        Tue,  3 Jan 2023 08:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733739;
        bh=Rt+ctlLDG+RcfDhKnOQ3XDWBP/i4HpiT+/Kv3NW5xjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scX5rU+AHzWjE++BCOr7F3nCaUZwsYjg46blicWzZrQp2/qRRmkkdV/CX69kABU97
         7nR9MuP9gIVlpg2jc8UDFZEJRDB2hssWwVMALZpqkgu3RW68D69f/Ok9ICsQxkGPC2
         dnZWpUdxrxUFJI5tP2//53YvCFpZF8dRza3uG5c0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-sh@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 27/63] sh: add support for TIF_NOTIFY_SIGNAL
Date:   Tue,  3 Jan 2023 09:13:57 +0100
Message-Id: <20230103081310.209696584@linuxfoundation.org>
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

[ Upstream commit 6d3a273355e3c8471ddf9e8ce9a7cc4472bf1ccc ]

Wire up TIF_NOTIFY_SIGNAL handling for sh.

Cc: linux-sh@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sh/include/asm/thread_info.h |    4 +++-
 arch/sh/kernel/signal_32.c        |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/sh/include/asm/thread_info.h
+++ b/arch/sh/include/asm/thread_info.h
@@ -105,6 +105,7 @@ extern void init_thread_xstate(void);
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_NOTIFY_SIGNAL	3	/* signal notifications exist */
 #define TIF_SINGLESTEP		4	/* singlestepping active */
 #define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
 #define TIF_SECCOMP		6	/* secure computing */
@@ -116,6 +117,7 @@ extern void init_thread_xstate(void);
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
@@ -132,7 +134,7 @@ extern void init_thread_xstate(void);
 #define _TIF_ALLWORK_MASK	(_TIF_SYSCALL_TRACE | _TIF_SIGPENDING      | \
 				 _TIF_NEED_RESCHED  | _TIF_SYSCALL_AUDIT   | \
 				 _TIF_SINGLESTEP    | _TIF_NOTIFY_RESUME   | \
-				 _TIF_SYSCALL_TRACEPOINT)
+				 _TIF_SYSCALL_TRACEPOINT | _TIF_NOTIFY_SIGNAL)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(_TIF_ALLWORK_MASK & ~(_TIF_SYSCALL_TRACE | \
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -499,7 +499,7 @@ asmlinkage void do_notify_resume(struct
 				 unsigned long thread_info_flags)
 {
 	/* deal with pending signal delivery */
-	if (thread_info_flags & _TIF_SIGPENDING)
+	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		do_signal(regs, save_r0);
 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME)


