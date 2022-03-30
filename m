Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8504EC2C3
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344344AbiC3MBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344482AbiC3L4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:56:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9D02D1CB;
        Wed, 30 Mar 2022 04:53:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DC5061701;
        Wed, 30 Mar 2022 11:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABB8C36AE5;
        Wed, 30 Mar 2022 11:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641236;
        bh=DkGHMydh/VtOG4fKv7CV+oXv46cGRizuSw/e+gZC7hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6o8ARWJhk2MJPIUWXFL1SYLTH13jnk6z6tMg3ocOPJUzYC3eGcvJ1l7lhwDlfZr2
         kq/5bHDmN3KI9Nt2gXKL5fbJ883RL7f9+MNjcjmrqGezEZdCG/vbLbG5Wb7iswISsD
         YLs3ZycmZLcYpWLprTLV1s/xZFe3DsSHQEZyYRXzU6QmTLy6cIPFGJRLf5t4tAuK61
         pr0XEgDLbpEXFYtE/9gPVjdhDO9kAJ0avcKvxdTwYdQL4ixLfJPACOpTUEtqlmHw5Z
         xJv9LoSf3F/7XSOb25A71Orertd1EtTpBpyN9Gqcv/dS9ysRTqqtnaWRieUyIjRhfl
         BE+WZyV/5Pj5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Ogness <john.ogness@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Petr Mladek <pmladek@suse.com>,
        Sasha Levin <sashal@kernel.org>, senozhatsky@chromium.org,
        gregkh@linuxfoundation.org, linux@roeck-us.net,
        stephen.s.brennan@oracle.com
Subject: [PATCH AUTOSEL 4.14 12/20] printk: use atomic updates for klogd work
Date:   Wed, 30 Mar 2022 07:53:28 -0400
Message-Id: <20220330115336.1672930-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115336.1672930-1-sashal@kernel.org>
References: <20220330115336.1672930-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 2ba3673d70178bf07fb75ff25c54bc478add4021 ]

The per-cpu @printk_pending variable can be updated from
sleepable contexts, such as:

  get_random_bytes()
    warn_unseeded_randomness()
      printk_deferred()
        defer_console_output()

and can be updated from interrupt contexts, such as:

  handle_irq_event_percpu()
    __irq_wake_thread()
      wake_up_process()
        try_to_wake_up()
          select_task_rq()
            select_fallback_rq()
              printk_deferred()
                defer_console_output()

and can be updated from NMI contexts, such as:

  vprintk()
    if (in_nmi()) defer_console_output()

Therefore the atomic variant of the updating functions must be used.

Replace __this_cpu_xchg() with this_cpu_xchg().
Replace __this_cpu_or() with this_cpu_or().

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/87iltld4ue.fsf@jogness.linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 1d7325f09004..8ec99b643a5a 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2874,7 +2874,7 @@ static DEFINE_PER_CPU(int, printk_pending);
 
 static void wake_up_klogd_work_func(struct irq_work *irq_work)
 {
-	int pending = __this_cpu_xchg(printk_pending, 0);
+	int pending = this_cpu_xchg(printk_pending, 0);
 
 	if (pending & PRINTK_PENDING_OUTPUT) {
 		/* If trylock fails, someone else is doing the printing */
@@ -2904,7 +2904,7 @@ void wake_up_klogd(void)
 void defer_console_output(void)
 {
 	preempt_disable();
-	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
+	this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
 	irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
 	preempt_enable();
 }
-- 
2.34.1

