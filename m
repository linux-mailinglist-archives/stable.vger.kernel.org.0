Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1CB65BBC8
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbjACIPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236990AbjACIPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:15:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86C8DF47;
        Tue,  3 Jan 2023 00:15:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88BB7611F0;
        Tue,  3 Jan 2023 08:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5A7C433EF;
        Tue,  3 Jan 2023 08:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733733;
        bh=a/FcX1DrHi4fYlfYvL75m1mDjOg30lklyzaTQTcHWe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bruXIDIVE0Xl/omtX1abJolrerYTaRsMyjB/TvXqH4sy/Cn3OY57+dB2a/ZSmue5H
         y53DJXLtHL4842sVmBEHyYKjx/7MRHiYdTn46MhMhK62KWu/+Zb294t6ogQdMxvuJk
         np+Ozfd5di8OvtkXNnSzE+bHlrBYCd5Eq/yKRwGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 25/63] s390: add support for TIF_NOTIFY_SIGNAL
Date:   Tue,  3 Jan 2023 09:13:55 +0100
Message-Id: <20230103081310.082733700@linuxfoundation.org>
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

[ Upstream commit 75309018a24ddfb930c51bad8f4070b9bc2c923b ]

Wire up TIF_NOTIFY_SIGNAL handling for s390.

Cc: linux-s390@vger.kernel.org
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/thread_info.h |    2 ++
 arch/s390/kernel/entry.S            |   11 ++++++-----
 arch/s390/kernel/signal.c           |    2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -65,6 +65,7 @@ void arch_setup_new_exec(void);
 #define TIF_GUARDED_STORAGE	4	/* load guarded storage control block */
 #define TIF_PATCH_PENDING	5	/* pending live patching update */
 #define TIF_PGSTE		6	/* New mm's will use 4K page tables */
+#define TIF_NOTIFY_SIGNAL	7	/* signal notifications exist */
 #define TIF_ISOLATE_BP		8	/* Run process with isolated BP */
 #define TIF_ISOLATE_BP_GUEST	9	/* Run KVM guests with isolated BP */
 
@@ -82,6 +83,7 @@ void arch_setup_new_exec(void);
 #define TIF_SYSCALL_TRACEPOINT	27	/* syscall tracepoint instrumentation */
 
 #define _TIF_NOTIFY_RESUME	BIT(TIF_NOTIFY_RESUME)
+#define _TIF_NOTIFY_SIGNAL	BIT(TIF_NOTIFY_SIGNAL)
 #define _TIF_SIGPENDING		BIT(TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	BIT(TIF_NEED_RESCHED)
 #define _TIF_UPROBE		BIT(TIF_UPROBE)
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -52,7 +52,8 @@ STACK_SIZE  = 1 << STACK_SHIFT
 STACK_INIT = STACK_SIZE - STACK_FRAME_OVERHEAD - __PT_SIZE
 
 _TIF_WORK	= (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_NEED_RESCHED | \
-		   _TIF_UPROBE | _TIF_GUARDED_STORAGE | _TIF_PATCH_PENDING)
+		   _TIF_UPROBE | _TIF_GUARDED_STORAGE | _TIF_PATCH_PENDING | \
+		   _TIF_NOTIFY_SIGNAL)
 _TIF_TRACE	= (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SECCOMP | \
 		   _TIF_SYSCALL_TRACEPOINT)
 _CIF_WORK	= (_CIF_ASCE_PRIMARY | _CIF_ASCE_SECONDARY | _CIF_FPU)
@@ -481,8 +482,8 @@ ENTRY(system_call)
 #endif
 	TSTMSK	__PT_FLAGS(%r11),_PIF_SYSCALL_RESTART
 	jo	.Lsysc_syscall_restart
-	TSTMSK	__TI_flags(%r12),_TIF_SIGPENDING
-	jo	.Lsysc_sigpending
+	TSTMSK	__TI_flags(%r12),(_TIF_SIGPENDING|_TIF_NOTIFY_SIGNAL)
+	jnz	.Lsysc_sigpending
 	TSTMSK	__TI_flags(%r12),_TIF_NOTIFY_RESUME
 	jo	.Lsysc_notify_resume
 	TSTMSK	__LC_CPU_FLAGS,(_CIF_ASCE_PRIMARY|_CIF_ASCE_SECONDARY)
@@ -863,8 +864,8 @@ ENTRY(io_int_handler)
 	TSTMSK	__TI_flags(%r12),_TIF_PATCH_PENDING
 	jo	.Lio_patch_pending
 #endif
-	TSTMSK	__TI_flags(%r12),_TIF_SIGPENDING
-	jo	.Lio_sigpending
+	TSTMSK	__TI_flags(%r12),(_TIF_SIGPENDING|_TIF_NOTIFY_SIGNAL)
+	jnz	.Lio_sigpending
 	TSTMSK	__TI_flags(%r12),_TIF_NOTIFY_RESUME
 	jo	.Lio_notify_resume
 	TSTMSK	__TI_flags(%r12),_TIF_GUARDED_STORAGE
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -472,7 +472,7 @@ void do_signal(struct pt_regs *regs)
 	current->thread.system_call =
 		test_pt_regs_flag(regs, PIF_SYSCALL) ? regs->int_code : 0;
 
-	if (get_signal(&ksig)) {
+	if (test_thread_flag(TIF_SIGPENDING) && get_signal(&ksig)) {
 		/* Whee!  Actually deliver the signal.  */
 		if (current->thread.system_call) {
 			regs->int_code = current->thread.system_call;


