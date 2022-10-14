Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5AA5FEF34
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiJNNye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiJNNyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:54:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E151D103D;
        Fri, 14 Oct 2022 06:53:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65EAF61B56;
        Fri, 14 Oct 2022 13:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB47AC433C1;
        Fri, 14 Oct 2022 13:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755585;
        bh=U0lIaU2Bg+EO45Zkz0Q6xlgGl0EgCOwekmuLkCRZk5A=;
        h=From:To:Cc:Subject:Date:From;
        b=Of5JcgeLuETDoSqHAkgNHBV0i2hxxfX4wTBc07DzDK17JL25AZWqNrd0OFuHlH8X4
         XFoQUgMUcvUAccnvE2+FZmF2EIFAb8flfUcRmBF7Ow28zfIKi3LxWLMRLLkFAJWI7i
         z6MQuMbzUlnjVDlIEai2hmj/a9t2xiiNiM7+i+zRGx9CpIStTkl0/1EAF9wEfxouAK
         kNtzdHjGS6qbGxPOAQgF1vfjpsi+fNaGVA2OOKbP1vHSHcr1tFy3KKAtrT9Y2aYg11
         RvxNTEQ7UlEIX1CWOpSGdoBhqozyKDvMvAjH/+x0z0RPl6uS2UpvYrqX60is2I+iBy
         j8WZEhs/OKyEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>, akpm@linux-foundation.org,
        pmladek@suse.com, david@redhat.com, laoar.shao@gmail.com,
        arnd@arndb.de, cai.huoqing@linux.dev
Subject: [PATCH AUTOSEL 5.15 1/8] signal: break out of wait loops on kthread_stop()
Date:   Fri, 14 Oct 2022 09:52:54 -0400
Message-Id: <20221014135302.2109489-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit a7c01fa93aeb03ab76cd3cb2107990dd160498e6 ]

I was recently surprised to learn that msleep_interruptible(),
wait_for_completion_interruptible_timeout(), and related functions
simply hung when I called kthread_stop() on kthreads using them. The
solution to fixing the case with msleep_interruptible() was more simply
to move to schedule_timeout_interruptible(). Why?

The reason is that msleep_interruptible(), and many functions just like
it, has a loop like this:

        while (timeout && !signal_pending(current))
                timeout = schedule_timeout_interruptible(timeout);

The call to kthread_stop() woke up the thread, so schedule_timeout_
interruptible() returned early, but because signal_pending() returned
true, it went back into another timeout, which was never woken up.

This wait loop pattern is common to various pieces of code, and I
suspect that the subtle misuse in a kthread that caused a deadlock in
the code I looked at last week is also found elsewhere.

So this commit causes signal_pending() to return true when
kthread_stop() is called, by setting TIF_NOTIFY_SIGNAL.

The same also probably applies to the similar kthread_park()
functionality, but that can be addressed later, as its semantics are
slightly different.

Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
v1: https://lkml.kernel.org/r/20220627120020.608117-1-Jason@zx2c4.com
v2: https://lkml.kernel.org/r/20220627145716.641185-1-Jason@zx2c4.com
v3: https://lkml.kernel.org/r/20220628161441.892925-1-Jason@zx2c4.com
v4: https://lkml.kernel.org/r/20220711202136.64458-1-Jason@zx2c4.com
v5: https://lkml.kernel.org/r/20220711232123.136330-1-Jason@zx2c4.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kthread.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 5b37a8567168..c8ca1007e2dd 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -644,6 +644,7 @@ int kthread_stop(struct task_struct *k)
 	kthread = to_kthread(k);
 	set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);
 	kthread_unpark(k);
+	set_tsk_thread_flag(k, TIF_NOTIFY_SIGNAL);
 	wake_up_process(k);
 	wait_for_completion(&kthread->exited);
 	ret = k->exit_code;
-- 
2.35.1

