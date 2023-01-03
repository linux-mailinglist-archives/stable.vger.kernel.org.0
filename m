Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8959F65BBE6
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbjACIQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237061AbjACIQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:16:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AABDF6E;
        Tue,  3 Jan 2023 00:16:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55866B80E46;
        Tue,  3 Jan 2023 08:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE09DC433EF;
        Tue,  3 Jan 2023 08:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733791;
        bh=LMollx75INxlsOc4OTrM24TyDpkA3hw5kYHp28nCAsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFr1bMX5LNT5kMw5nBD7CP7aipg3AkHRh+9WTP65KmAoE7dSfnogM0M2Hvx8AMRtn
         vZG+5GgjoDSAZGNEA/cdYuh2kdcFrlrxfXqpZV3rOAPPMdhgbPKi5RheD67Z1iZf51
         UmRF7/VE3haFmFRAlGM11bVNu3p7A9KERtAPj8+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-ia64@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 37/63] ia64: add support for TIF_NOTIFY_SIGNAL
Date:   Tue,  3 Jan 2023 09:14:07 +0100
Message-Id: <20230103081310.802833748@linuxfoundation.org>
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

[ Upstream commit b269c229b0e89aedb7943c06673b56b6052cf5e5 ]

Wire up TIF_NOTIFY_SIGNAL handling for ia64.

Cc: linux-ia64@vger.kernel.org
[axboe: added fixes from Mike Rapoport <rppt@kernel.org>]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/include/asm/thread_info.h |    4 +++-
 arch/ia64/kernel/process.c          |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/ia64/include/asm/thread_info.h
+++ b/arch/ia64/include/asm/thread_info.h
@@ -103,6 +103,7 @@ struct thread_info {
 #define TIF_SYSCALL_TRACE	2	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	3	/* syscall auditing active */
 #define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
+#define TIF_NOTIFY_SIGNAL	5	/* signal notification exist */
 #define TIF_NOTIFY_RESUME	6	/* resumption notification requested */
 #define TIF_MEMDIE		17	/* is terminating due to OOM killer */
 #define TIF_MCA_INIT		18	/* this task is processing MCA or INIT */
@@ -115,6 +116,7 @@ struct thread_info {
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_SYSCALL_TRACEAUDIT	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_MCA_INIT		(1 << TIF_MCA_INIT)
@@ -124,7 +126,7 @@ struct thread_info {
 
 /* "work to do on user-return" bits */
 #define TIF_ALLWORK_MASK	(_TIF_SIGPENDING|_TIF_NOTIFY_RESUME|_TIF_SYSCALL_AUDIT|\
-				 _TIF_NEED_RESCHED|_TIF_SYSCALL_TRACE)
+				 _TIF_NEED_RESCHED|_TIF_SYSCALL_TRACE|_TIF_NOTIFY_SIGNAL)
 /* like TIF_ALLWORK_BITS but sans TIF_SYSCALL_TRACE or TIF_SYSCALL_AUDIT */
 #define TIF_WORK_MASK		(TIF_ALLWORK_MASK&~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT))
 
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -171,7 +171,8 @@ do_notify_resume_user(sigset_t *unused,
 	}
 
 	/* deal with pending signal delivery */
-	if (test_thread_flag(TIF_SIGPENDING)) {
+	if (test_thread_flag(TIF_SIGPENDING) ||
+	    test_thread_flag(TIF_NOTIFY_SIGNAL)) {
 		local_irq_enable();	/* force interrupt enable */
 		ia64_do_signal(scr, in_syscall);
 	}


