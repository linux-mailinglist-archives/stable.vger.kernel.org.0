Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0666CC50E
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjC1PMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjC1PMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:12:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACE1F74B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:11:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06C1DB81D98
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46889C433EF;
        Tue, 28 Mar 2023 15:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016191;
        bh=w3eECJi3wwE/hikXO0UAr4lhKLbAC01FyqAMomvHfyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpDb0Sf1WGhd5psKyodV0vPnSozzshNcnbZS5Gktp8qLKExqU6vHSrKA215qeH62P
         S3qHNcYsVz2v2tszgePUvGXZvV6Y6MsmoiqzWsYUgX5sXA411KbKzYAagbvD7i3DCh
         hndVHwpy6we8xfV0xvHc0NLuPbZypLeB/5128xSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/146] thread_info: Add helpers to snapshot thread flags
Date:   Tue, 28 Mar 2023 16:42:37 +0200
Message-Id: <20230328142605.552678094@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 7ad639840acf2800b5f387c495795f995a67a329 ]

In <linux/thread_info.h> there are helpers to manipulate individual thread
flags, but where code wants to check several flags at once, it must open
code reading current_thread_info()->flags and operating on a snapshot.

As some flags can be set remotely it's necessary to use READ_ONCE() to get
a consistent snapshot even when IRQs are disabled, but some code forgets to
do this. Generally this is unlike to cause a problem in practice, but it is
somewhat unsound, and KCSAN will legitimately warn that there is a data
race.

To make it easier to do the right thing, and to highlight that concurrent
modification is possible, add new helpers to snapshot the flags, which
should be used in preference to plain reads. Subsequent patches will move
existing code to use the new helpers.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Marco Elver <elver@google.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20211129130653.2037928-2-mark.rutland@arm.com
Stable-dep-of: b41651405481 ("entry/rcu: Check TIF_RESCHED _after_ delayed RCU wake-up")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/thread_info.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 0999f6317978f..9a073535c0bdd 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -118,6 +118,15 @@ static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
 	return test_bit(flag, (unsigned long *)&ti->flags);
 }
 
+/*
+ * This may be used in noinstr code, and needs to be __always_inline to prevent
+ * inadvertent instrumentation.
+ */
+static __always_inline unsigned long read_ti_thread_flags(struct thread_info *ti)
+{
+	return READ_ONCE(ti->flags);
+}
+
 #define set_thread_flag(flag) \
 	set_ti_thread_flag(current_thread_info(), flag)
 #define clear_thread_flag(flag) \
@@ -130,6 +139,11 @@ static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
 	test_and_clear_ti_thread_flag(current_thread_info(), flag)
 #define test_thread_flag(flag) \
 	test_ti_thread_flag(current_thread_info(), flag)
+#define read_thread_flags() \
+	read_ti_thread_flags(current_thread_info())
+
+#define read_task_thread_flags(t) \
+	read_ti_thread_flags(task_thread_info(t))
 
 #ifdef CONFIG_GENERIC_ENTRY
 #define set_syscall_work(fl) \
-- 
2.39.2



