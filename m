Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23D758DE3F
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245547AbiHISMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345870AbiHISLx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:11:53 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B302F2B240;
        Tue,  9 Aug 2022 11:05:02 -0700 (PDT)
Date:   Tue, 09 Aug 2022 18:04:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660068296;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=81ZQ63nPkM9CSzyuw77Sv89rOSrkq0ThYb9yTC3BSxk=;
        b=sl2Dy1lZ+sp1HDr/0dReFXU4Ikjyy14z1/zzA0dApXqcGukpDSfqb9mj0H92n06lEtweqD
        L3YCRvzsuzmnjhLvZkt3yj2z7CjEokPUIXauxiHX73hgCqr1OEGWGjFLuJaTxTLgsNx42L
        d8Hu5nQqOspJkrB/h4/Eq39n4pJ1OoOTKF68DCma+Na27BEC92NRPLNy+hxy/a3WiGDlJA
        qALi/fNu6cMAfEmm4kezFhKl+iYbBDasLLsiX1o2sTx0fzs4HHA07UBIv/6JLX+hAPyePw
        ChKOIAhDjOB3SnDuFkTLm1NAyk/xXa51I0njT14SirNQOd2GtHH8tSZY+yM3hg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660068296;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=81ZQ63nPkM9CSzyuw77Sv89rOSrkq0ThYb9yTC3BSxk=;
        b=7zFNvZUqBuNY0Wd9G7A/zMP82l1aW5Z9XuEmDwRqSCFB6LzsZZilAm6d3Xy7xucVlktIAu
        DFmLTmg2xvFIylCg==
From:   "tip-bot2 for Thadeu Lima de Souza Cascardo" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] posix-cpu-timers: Cleanup CPU timers before
 freeing them during exec
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220809170751.164716-1-cascardo@canonical.com>
References: <20220809170751.164716-1-cascardo@canonical.com>
MIME-Version: 1.0
Message-ID: <166006829371.15455.12477315109108649290.tip-bot2@tip-bot2>
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

Commit-ID:     e362359ace6f87c201531872486ff295df306d13
Gitweb:        https://git.kernel.org/tip/e362359ace6f87c201531872486ff295df306d13
Author:        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
AuthorDate:    Tue, 09 Aug 2022 14:07:51 -03:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 09 Aug 2022 20:02:13 +02:00

posix-cpu-timers: Cleanup CPU timers before freeing them during exec

Commit 55e8c8eb2c7b ("posix-cpu-timers: Store a reference to a pid not a
task") started looking up tasks by PID when deleting a CPU timer.

When a non-leader thread calls execve, it will switch PIDs with the leader
process. Then, as it calls exit_itimers, posix_cpu_timer_del cannot find
the task because the timer still points out to the old PID.

That means that armed timers won't be disarmed, that is, they won't be
removed from the timerqueue_list. exit_itimers will still release their
memory, and when that list is later processed, it leads to a
use-after-free.

Clean up the timers from the de-threaded task before freeing them. This
prevents a reported use-after-free.

Fixes: 55e8c8eb2c7b ("posix-cpu-timers: Store a reference to a pid not a task")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220809170751.164716-1-cascardo@canonical.com

---
 fs/exec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index 5fd7391..f793221 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1304,6 +1304,9 @@ int begin_new_exec(struct linux_binprm * bprm)
 	bprm->mm = NULL;
 
 #ifdef CONFIG_POSIX_TIMERS
+	spin_lock_irq(&me->sighand->siglock);
+	posix_cpu_timers_exit(me);
+	spin_unlock_irq(&me->sighand->siglock);
 	exit_itimers(me);
 	flush_itimer_signals();
 #endif
