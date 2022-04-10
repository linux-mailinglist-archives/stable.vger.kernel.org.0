Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793C04FAD48
	for <lists+stable@lfdr.de>; Sun, 10 Apr 2022 12:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbiDJKfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Apr 2022 06:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbiDJKfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Apr 2022 06:35:14 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D53673C6;
        Sun, 10 Apr 2022 03:33:04 -0700 (PDT)
Date:   Sun, 10 Apr 2022 10:33:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649586782;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=60Lfwzh0nAtHFcSVWbVw2y7ROX/9cN8agVJL8qXTZ+w=;
        b=olLE6vPdCbJgJNxvvqrlDTs5gvaXAKVmPamzDz7CAZBmaUknR6tPcw3FhJL5WoLeI6Pcmz
        BqrrtwUofoHrWAwTQ1qqfgWPkREaP4s9cHW0mxkGBzIt9l9KStjn1zSBLJqZMqAhj7QmJZ
        2NgPNnQo2Jmdf/ia2+9IjsUKhZsy4DZekdGL6BD21fNfEtic7df8j3+ycizGbK6N0/TaN5
        oJdYWFfnwPrQEvrjdCIQgrXCEw9kgAu6J8UqS4cG+M/48FAHeP/vmIqByD7xNfASCIFxYf
        j2veZrATjFhvUB9SRGY4uiyfikLcU1Qe1Z6RushYiOx01d9NuA2BQ5eckyCCoA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649586782;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=60Lfwzh0nAtHFcSVWbVw2y7ROX/9cN8agVJL8qXTZ+w=;
        b=0uRNVo9rYMkOmWY+Lo77BEMlbSc7IOTVMp3rUEtGXaKKGuCUiMY1UgCbGDQwh3WomDytT4
        THIQg7RtOv4z02AA==
From:   "tip-bot2 for Paul Gortmaker" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] tick/nohz: Use WARN_ON_ONCE() to prevent console
 saturation
Cc:     Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211206145950.10927-3-paul.gortmaker@windriver.com>
References: <20211206145950.10927-3-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Message-ID: <164958678121.4207.8216849655499016396.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     40e97e42961f8c6cc7bd5fe67cc18417e02d78f1
Gitweb:        https://git.kernel.org/tip/40e97e42961f8c6cc7bd5fe67cc18417e02d78f1
Author:        Paul Gortmaker <paul.gortmaker@windriver.com>
AuthorDate:    Mon, 06 Dec 2021 09:59:50 -05:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Sun, 10 Apr 2022 12:23:34 +02:00

tick/nohz: Use WARN_ON_ONCE() to prevent console saturation

While running some testing on code that happened to allow the variable
tick_nohz_full_running to get set but with no "possible" NOHZ cores to
back up that setting, this warning triggered:

        if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
                WARN_ON(tick_nohz_full_running);

The console was overwhemled with an endless stream of one WARN per tick
per core and there was no way to even see what was going on w/o using a
serial console to capture it and then trace it back to this.

Change it to WARN_ON_ONCE().

Fixes: 08ae95f4fd3b ("nohz_full: Allow the boot CPU to be nohz_full")
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211206145950.10927-3-paul.gortmaker@windriver.com

---
 kernel/time/tick-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 2d76c91..3506f6e 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -188,7 +188,7 @@ static void tick_sched_do_timer(struct tick_sched *ts, ktime_t now)
 	 */
 	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE)) {
 #ifdef CONFIG_NO_HZ_FULL
-		WARN_ON(tick_nohz_full_running);
+		WARN_ON_ONCE(tick_nohz_full_running);
 #endif
 		tick_do_timer_cpu = cpu;
 	}
