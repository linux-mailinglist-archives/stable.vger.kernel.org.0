Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5333065BC06
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237162AbjACIS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237069AbjACISI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:18:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DC4DFC4
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:17:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49751611F8
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47168C433EF;
        Tue,  3 Jan 2023 08:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733856;
        bh=AW3Xg04G+JFLKZ8SCgA/2SIqNKtWhO3hFUmd9846Hlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZXOffm0Nad7DQb7t6c8Adx7+0ypDyOoqJfZ3QH2dzxdqBgoSereJm5cy6brqfNSp
         g7D4THljTX1E2z/lWhCqCuWqxhQ7SXwb2W8oKlzMxnziyuO0iftYqJ91ctQdWc+XnA
         b8v9eTTvqJQ45EOYbbrA79IWW8RIN6XIJcYEDaYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 45/63] kernel: remove checking for TIF_NOTIFY_SIGNAL
Date:   Tue,  3 Jan 2023 09:14:15 +0100
Message-Id: <20230103081311.295770562@linuxfoundation.org>
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

[ Upstream commit e296dc4996b8094ccde45d19090d804c4103513e ]

It's available everywhere now, no need to check or add dummy defines.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/entry-common.h |    4 ----
 include/linux/sched/signal.h |    2 --
 include/linux/tracehook.h    |    4 ----
 kernel/signal.c              |    2 --
 4 files changed, 12 deletions(-)

--- a/include/linux/entry-common.h
+++ b/include/linux/entry-common.h
@@ -37,10 +37,6 @@
 # define _TIF_UPROBE			(0)
 #endif
 
-#ifndef _TIF_NOTIFY_SIGNAL
-# define _TIF_NOTIFY_SIGNAL		(0)
-#endif
-
 /*
  * TIF flags handled in syscall_enter_from_user_mode()
  */
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -361,7 +361,6 @@ static inline int task_sigpending(struct
 
 static inline int signal_pending(struct task_struct *p)
 {
-#if defined(TIF_NOTIFY_SIGNAL)
 	/*
 	 * TIF_NOTIFY_SIGNAL isn't really a signal, but it requires the same
 	 * behavior in terms of ensuring that we break out of wait loops
@@ -369,7 +368,6 @@ static inline int signal_pending(struct
 	 */
 	if (unlikely(test_tsk_thread_flag(p, TIF_NOTIFY_SIGNAL)))
 		return 1;
-#endif
 	return task_sigpending(p);
 }
 
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -205,12 +205,10 @@ static inline void tracehook_notify_resu
  */
 static inline void tracehook_notify_signal(void)
 {
-#if defined(TIF_NOTIFY_SIGNAL)
 	clear_thread_flag(TIF_NOTIFY_SIGNAL);
 	smp_mb__after_atomic();
 	if (current->task_works)
 		task_work_run();
-#endif
 }
 
 /*
@@ -218,11 +216,9 @@ static inline void tracehook_notify_sign
  */
 static inline void set_notify_signal(struct task_struct *task)
 {
-#if defined(TIF_NOTIFY_SIGNAL)
 	if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL) &&
 	    !wake_up_state(task, TASK_INTERRUPTIBLE))
 		kick_process(task);
-#endif
 }
 
 #endif	/* <linux/tracehook.h> */
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2525,14 +2525,12 @@ bool get_signal(struct ksignal *ksig)
 	 * that the arch handlers don't all have to do it. If we get here
 	 * without TIF_SIGPENDING, just exit after running signal work.
 	 */
-#ifdef TIF_NOTIFY_SIGNAL
 	if (!IS_ENABLED(CONFIG_GENERIC_ENTRY)) {
 		if (test_thread_flag(TIF_NOTIFY_SIGNAL))
 			tracehook_notify_signal();
 		if (!task_sigpending(current))
 			return false;
 	}
-#endif
 
 	if (unlikely(uprobe_deny_signal()))
 		return false;


