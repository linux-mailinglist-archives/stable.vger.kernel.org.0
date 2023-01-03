Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8325C65BBF8
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbjACIR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237119AbjACIRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:17:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79208CE5
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:17:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9F4A611FD
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09002C433F0;
        Tue,  3 Jan 2023 08:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733830;
        bh=lUbYilCbJypDEukFEE64+pgiT8jz6xb0PEwjX9BHEl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fU9Qh9Sxhql5xhP/pBlL3ln2XcSbsHjG5lK+xFttyWoCF2xx0dDOzx1S19I72ZmcY
         qVDjHvCbOBOvpjs/Y8mOJMulmgoA7M+Gu1ayYKynCC0wTxPOk2polmsFvFysLGqkwh
         53EUSASdpnetrDqIipnkizvJeeYPPtErmAAqgpXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 56/63] signal: kill JOBCTL_TASK_WORK
Date:   Tue,  3 Jan 2023 09:14:26 +0100
Message-Id: <20230103081311.971784785@linuxfoundation.org>
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

[ Upstream commit 98b89b649fce39dacb9dc036d6d0fdb8caff73f7 ]

It's no longer used, get rid of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched/jobctl.h |    4 +---
 kernel/signal.c              |   20 --------------------
 2 files changed, 1 insertion(+), 23 deletions(-)

--- a/include/linux/sched/jobctl.h
+++ b/include/linux/sched/jobctl.h
@@ -19,7 +19,6 @@ struct task_struct;
 #define JOBCTL_TRAPPING_BIT	21	/* switching to TRACED */
 #define JOBCTL_LISTENING_BIT	22	/* ptracer is listening for events */
 #define JOBCTL_TRAP_FREEZE_BIT	23	/* trap for cgroup freezer */
-#define JOBCTL_TASK_WORK_BIT	24	/* set by TWA_SIGNAL */
 
 #define JOBCTL_STOP_DEQUEUED	(1UL << JOBCTL_STOP_DEQUEUED_BIT)
 #define JOBCTL_STOP_PENDING	(1UL << JOBCTL_STOP_PENDING_BIT)
@@ -29,10 +28,9 @@ struct task_struct;
 #define JOBCTL_TRAPPING		(1UL << JOBCTL_TRAPPING_BIT)
 #define JOBCTL_LISTENING	(1UL << JOBCTL_LISTENING_BIT)
 #define JOBCTL_TRAP_FREEZE	(1UL << JOBCTL_TRAP_FREEZE_BIT)
-#define JOBCTL_TASK_WORK	(1UL << JOBCTL_TASK_WORK_BIT)
 
 #define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY)
-#define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK | JOBCTL_TASK_WORK)
+#define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
 
 extern bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask);
 extern void task_clear_jobctl_trapping(struct task_struct *task);
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2544,26 +2544,6 @@ bool get_signal(struct ksignal *ksig)
 
 relock:
 	spin_lock_irq(&sighand->siglock);
-	/*
-	 * Make sure we can safely read ->jobctl() in task_work add. As Oleg
-	 * states:
-	 *
-	 * It pairs with mb (implied by cmpxchg) before READ_ONCE. So we
-	 * roughly have
-	 *
-	 *	task_work_add:				get_signal:
-	 *	STORE(task->task_works, new_work);	STORE(task->jobctl);
-	 *	mb();					mb();
-	 *	LOAD(task->jobctl);			LOAD(task->task_works);
-	 *
-	 * and we can rely on STORE-MB-LOAD [ in task_work_add].
-	 */
-	smp_store_mb(current->jobctl, current->jobctl & ~JOBCTL_TASK_WORK);
-	if (unlikely(current->task_works)) {
-		spin_unlock_irq(&sighand->siglock);
-		task_work_run();
-		goto relock;
-	}
 
 	/*
 	 * Every stopped thread goes here after wakeup. Check to see if


