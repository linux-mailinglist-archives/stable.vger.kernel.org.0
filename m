Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21E064D243
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 23:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiLNWUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 17:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiLNWUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 17:20:20 -0500
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B6841992;
        Wed, 14 Dec 2022 14:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1671056416;
        bh=oNv/gSWyb/MpDqS0P30UCCNCdFs5k2+DfmT7cH4zL1E=;
        h=From:To:Cc:Subject:Date:From;
        b=J4HP1YEUylZ4Twplg0KjRig3OwM1h23nU7ydzPq6I19c5zCoqj5qxM1lAxVBInCfI
         +VbRgaAsrgGuI93EKdy1e2+TbH0WG+I87Bn96TZTp37hQtZLRd7l9vmFpAFyWrRFxR
         0VWs3su9aZgQ7d/eMKIP79Fntx6kEj701HyzDPUBHgwTs1HfuuvXTGhKnweSKYYXXs
         V3w1nnOXumE2IhNRivgDzIWZsXmNZ2ef96WLQ/W6+WINMuwgG6phWxU2jt9lQUksJk
         Pi4HpOe31zh2G0SuuvYcNQaUrel3MusCxAO/1pgPduejbbE53a9JX9KYY2pUX23TOO
         BxOJw7c388LMQ==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4NXVDJ3VCjzbgh;
        Wed, 14 Dec 2022 17:20:16 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andre Almeida <andrealmeid@collabora.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>, stable@vger.kernel.org
Subject: [RFC PATCH] futex: Fix futex_waitv() hrtimer debug object leak on kcalloc error
Date:   Wed, 14 Dec 2022 17:20:08 -0500
Message-Id: <20221214222008.200393-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In a scenario where kcalloc() fails to allocate memory, the futex_waitv
system call immediately returns -ENOMEM without invoking
destroy_hrtimer_on_stack(). When CONFIG_DEBUG_OBJECTS_TIMERS=y, this
results in leaking a timer debug object.

Fixes: bf69bad38cf6 ("futex: Implement sys_futex_waitv()")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andre Almeida <andrealmeid@collabora.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: stable@vger.kernel.org # v5.16+
---
 kernel/futex/syscalls.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 086a22d1adb7..a8074079b09e 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -286,19 +286,22 @@ SYSCALL_DEFINE5(futex_waitv, struct futex_waitv __user *, waiters,
 	}
 
 	futexv = kcalloc(nr_futexes, sizeof(*futexv), GFP_KERNEL);
-	if (!futexv)
-		return -ENOMEM;
+	if (!futexv) {
+		ret = -ENOMEM;
+		goto destroy_timer;
+	}
 
 	ret = futex_parse_waitv(futexv, waiters, nr_futexes);
 	if (!ret)
 		ret = futex_wait_multiple(futexv, nr_futexes, timeout ? &to : NULL);
 
+	kfree(futexv);
+
+destroy_timer:
 	if (timeout) {
 		hrtimer_cancel(&to.timer);
 		destroy_hrtimer_on_stack(&to.timer);
 	}
-
-	kfree(futexv);
 	return ret;
 }
 
-- 
2.25.1

