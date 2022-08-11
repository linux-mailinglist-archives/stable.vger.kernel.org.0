Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173AA59089A
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 00:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbiHKWIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 18:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiHKWIU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 18:08:20 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E96A0262
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 15:08:19 -0700 (PDT)
Received: from hednb3.intra.ispras.ru (unknown [109.252.119.247])
        by mail.ispras.ru (Postfix) with ESMTPSA id 37D8440737AA;
        Thu, 11 Aug 2022 22:08:18 +0000 (UTC)
From:   Alexey Khoroshilov <khoroshilov@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        ldv-project@linuxtesting.org
Subject: [PATCH 5.10 1/1] lockdep: Allow tuning tracing capacity constants.
Date:   Fri, 12 Aug 2022 01:08:03 +0300
Message-Id: <1660255683-1889-2-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1660255683-1889-1-git-send-email-khoroshilov@ispras.ru>
References: <1660255683-1889-1-git-send-email-khoroshilov@ispras.ru>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 41fc8a7ca0beca32af0ac6bb0043618dcda967b1 upstream.

Since syzkaller continues various test cases until the kernel crashes,
syzkaller tends to examine more locking dependencies than normal systems.
As a result, syzbot is reporting that the fuzz testing was terminated
due to hitting upper limits lockdep can track [1] [2] [3]. Since analysis
via /proc/lockdep* did not show any obvious culprit [4] [5], we have no
choice but allow tuning tracing capacity constants.

[1] https://syzkaller.appspot.com/bug?id=3d97ba93fb3566000c1c59691ea427370d33ea1b
[2] https://syzkaller.appspot.com/bug?id=381cb436fe60dc03d7fd2a092b46d7f09542a72a
[3] https://syzkaller.appspot.com/bug?id=a588183ac34c1437fc0785e8f220e88282e5a29f
[4] https://lkml.kernel.org/r/4b8f7a57-fa20-47bd-48a0-ae35d860f233@i-love.sakura.ne.jp
[5] https://lkml.kernel.org/r/1c351187-253b-2d49-acaf-4563c63ae7d2@i-love.sakura.ne.jp

References: https://lkml.kernel.org/r/1595640639-9310-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 kernel/locking/lockdep.c           |  2 +-
 kernel/locking/lockdep_internals.h |  8 ++++----
 lib/Kconfig.debug                  | 40 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index b6683ce..c3387cd 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1397,7 +1397,7 @@ static int add_lock_to_list(struct lock_class *this,
 /*
  * For good efficiency of modular, we use power of 2
  */
-#define MAX_CIRCULAR_QUEUE_SIZE		4096UL
+#define MAX_CIRCULAR_QUEUE_SIZE		(1UL << CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS)
 #define CQ_MASK				(MAX_CIRCULAR_QUEUE_SIZE-1)
 
 /*
diff --git a/kernel/locking/lockdep_internals.h b/kernel/locking/lockdep_internals.h
index a19b016..bbe9000 100644
--- a/kernel/locking/lockdep_internals.h
+++ b/kernel/locking/lockdep_internals.h
@@ -99,16 +99,16 @@ static const unsigned long LOCKF_USED_IN_IRQ_READ =
 #define MAX_STACK_TRACE_ENTRIES	262144UL
 #define STACK_TRACE_HASH_SIZE	8192
 #else
-#define MAX_LOCKDEP_ENTRIES	32768UL
+#define MAX_LOCKDEP_ENTRIES	(1UL << CONFIG_LOCKDEP_BITS)
 
-#define MAX_LOCKDEP_CHAINS_BITS	16
+#define MAX_LOCKDEP_CHAINS_BITS	CONFIG_LOCKDEP_CHAINS_BITS
 
 /*
  * Stack-trace: tightly packed array of stack backtrace
  * addresses. Protected by the hash_lock.
  */
-#define MAX_STACK_TRACE_ENTRIES	524288UL
-#define STACK_TRACE_HASH_SIZE	16384
+#define MAX_STACK_TRACE_ENTRIES	(1UL << CONFIG_LOCKDEP_STACK_TRACE_BITS)
+#define STACK_TRACE_HASH_SIZE	(1 << CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS)
 #endif
 
 /*
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3656fa8..ce796ca 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1307,6 +1307,46 @@ config LOCKDEP
 config LOCKDEP_SMALL
 	bool
 
+config LOCKDEP_BITS
+	int "Bitsize for MAX_LOCKDEP_ENTRIES"
+	depends on LOCKDEP && !LOCKDEP_SMALL
+	range 10 30
+	default 15
+	help
+	  Try increasing this value if you hit "BUG: MAX_LOCKDEP_ENTRIES too low!" message.
+
+config LOCKDEP_CHAINS_BITS
+	int "Bitsize for MAX_LOCKDEP_CHAINS"
+	depends on LOCKDEP && !LOCKDEP_SMALL
+	range 10 30
+	default 16
+	help
+	  Try increasing this value if you hit "BUG: MAX_LOCKDEP_CHAINS too low!" message.
+
+config LOCKDEP_STACK_TRACE_BITS
+	int "Bitsize for MAX_STACK_TRACE_ENTRIES"
+	depends on LOCKDEP && !LOCKDEP_SMALL
+	range 10 30
+	default 19
+	help
+	  Try increasing this value if you hit "BUG: MAX_STACK_TRACE_ENTRIES too low!" message.
+
+config LOCKDEP_STACK_TRACE_HASH_BITS
+	int "Bitsize for STACK_TRACE_HASH_SIZE"
+	depends on LOCKDEP && !LOCKDEP_SMALL
+	range 10 30
+	default 14
+	help
+	  Try increasing this value if you need large MAX_STACK_TRACE_ENTRIES.
+
+config LOCKDEP_CIRCULAR_QUEUE_BITS
+	int "Bitsize for elements in circular_queue struct"
+	depends on LOCKDEP
+	range 10 30
+	default 12
+	help
+	  Try increasing this value if you hit "lockdep bfs error:-1" warning due to __cq_enqueue() failure.
+
 config DEBUG_LOCKDEP
 	bool "Lock dependency engine debugging"
 	depends on DEBUG_KERNEL && LOCKDEP
-- 
2.7.4

