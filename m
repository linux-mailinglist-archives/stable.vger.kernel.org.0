Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF5B5FEEF7
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJNNvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJNNvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:51:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DCA1C20AF;
        Fri, 14 Oct 2022 06:51:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DDA5B82215;
        Fri, 14 Oct 2022 13:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DACAC433D6;
        Fri, 14 Oct 2022 13:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755502;
        bh=pVtcIk5f4lbGwH3S1i66yRlLGQYZVbWBPr4Q53IDJRc=;
        h=From:To:Cc:Subject:Date:From;
        b=k1UaFJwUDKRjRPp6Des2cI9nwrBsA8JwK/iJcbe2jox/qVVAjEfnZnSN1pqXzer7p
         HXkwoyc6rq2eDOIh+hQ76WE7LRypv33lh5nsSTYkTKrir8m4G/1uTZyqE84u+X5/jn
         BU2AaU+CCYxkGLUyJdtb4PPmMGCqWDAwuGc+xirWBpyAevglZJAzLcXYFKDKQJSaNW
         WckoeMhbiELZeZrVDw9eshkQt6XlYchr1pXRAh7jCXuynDNq8iPBxd5jlhQKQDqQc/
         ToQEtklA8RHODKqGpcp3UcHW/5rbUZY9Pm61jUbYHOULk4X2UR/RbQlRyqXEe6+yZ3
         YxoLV7DJg+oYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>, akpm@linux-foundation.org,
        pmladek@suse.com, axboe@kernel.dk, juri.lelli@redhat.com,
        laoar.shao@gmail.com, arnd@arndb.de
Subject: [PATCH AUTOSEL 6.0 01/11] signal: break out of wait loops on kthread_stop()
Date:   Fri, 14 Oct 2022 09:51:27 -0400
Message-Id: <20221014135139.2109024-1-sashal@kernel.org>
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
index 3c677918d8f2..7243a010f433 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -704,6 +704,7 @@ int kthread_stop(struct task_struct *k)
 	kthread = to_kthread(k);
 	set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);
 	kthread_unpark(k);
+	set_tsk_thread_flag(k, TIF_NOTIFY_SIGNAL);
 	wake_up_process(k);
 	wait_for_completion(&kthread->exited);
 	ret = kthread->result;
-- 
2.35.1

