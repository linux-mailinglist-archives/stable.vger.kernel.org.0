Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C659C65BBFC
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbjACIR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237080AbjACIRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:17:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32FFE028
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:17:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32D36611F0
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C8AC433F0;
        Tue,  3 Jan 2023 08:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733827;
        bh=b0Kucyb2ql/kHHPCrUlcNegZWffcedsOdFEfMLeOiIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VccoWS+BTcLsTqySX3pfhkAz+FF9e6hX2unsglrEXPVZLzWfBn0P8yyQTpErQSUTy
         K/7dIJTnTdsNjS/YfMRRjILhMtemYlpwsPj1IaZowOvh8pv4ou+MByt5t975mW0Lar
         ezYdt00MwgpUjW3HyBOFymWSC2kfvWmPpeRyKqb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 38/63] nds32: add support for TIF_NOTIFY_SIGNAL
Date:   Tue,  3 Jan 2023 09:14:08 +0100
Message-Id: <20230103081310.864434606@linuxfoundation.org>
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

[ Upstream commit b13e8bf615fe26fb6a6dfe1b5a1c65e1624dfee2 ]

Wire up TIF_NOTIFY_SIGNAL handling for nds32.

Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nds32/include/asm/thread_info.h |    2 ++
 arch/nds32/kernel/ex-exit.S          |    2 +-
 arch/nds32/kernel/signal.c           |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/nds32/include/asm/thread_info.h
+++ b/arch/nds32/include/asm/thread_info.h
@@ -48,6 +48,7 @@ struct thread_info {
 #define TIF_NEED_RESCHED	2
 #define TIF_SINGLESTEP		3
 #define TIF_NOTIFY_RESUME	4	/* callback before returning to user */
+#define TIF_NOTIFY_SIGNAL	5	/* signal notifications exist */
 #define TIF_SYSCALL_TRACE	8
 #define TIF_POLLING_NRFLAG	17
 #define TIF_MEMDIE		18
@@ -57,6 +58,7 @@ struct thread_info {
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
--- a/arch/nds32/kernel/ex-exit.S
+++ b/arch/nds32/kernel/ex-exit.S
@@ -120,7 +120,7 @@ work_pending:
 	andi	$p1, $r1, #_TIF_NEED_RESCHED
 	bnez	$p1, work_resched
 
-	andi	$p1, $r1, #_TIF_SIGPENDING|#_TIF_NOTIFY_RESUME
+	andi	$p1, $r1, #_TIF_SIGPENDING|#_TIF_NOTIFY_RESUME|#_TIF_NOTIFY_SIGNAL
 	beqz	$p1, no_work_pending
 
 	move	$r0, $sp			! 'regs'
--- a/arch/nds32/kernel/signal.c
+++ b/arch/nds32/kernel/signal.c
@@ -376,7 +376,7 @@ static void do_signal(struct pt_regs *re
 asmlinkage void
 do_notify_resume(struct pt_regs *regs, unsigned int thread_flags)
 {
-	if (thread_flags & _TIF_SIGPENDING)
+	if (thread_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		do_signal(regs);
 
 	if (thread_flags & _TIF_NOTIFY_RESUME)


