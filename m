Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F9A57C6B9
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 10:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbiGUIpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 04:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbiGUIo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 04:44:59 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADD97FE65;
        Thu, 21 Jul 2022 01:44:53 -0700 (PDT)
Date:   Thu, 21 Jul 2022 08:44:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1658393092;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Tqoe9ErZGuiOGQOEuxZHvru68/1En7mH71iUA7ma28=;
        b=QRt18Ufw/Qttk5f8bvFnRsELPpe3479JGU1AYFbDVFvjE8PFLgWq319lw4BX+3RToAo7sn
        n+iV5pcBIUWuEHVF+rLz6iF/d8Ao7Mt4lfuGFQ2woh8n6dMBIqi4oUuLx/0a6pP/g91aBP
        VlO6eoIOp/jqTXOHPdvitca3oOg5l4tSCE25Y27/F7hhdfzZsi4eAvqEuR6tqm2TccYAe7
        PBKnoauWRX1i1f4QfwWjOA9V2b16i4cKseRGeeRZ44HrDgZVlrw00LR5cdQctJo5WZ9V6W
        2+8YRWj3x/H1dAmj+J5wW+opB1Mf5F6eFYPjrygxIC1nRSDTkxXWmkdyMAbzGg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1658393092;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Tqoe9ErZGuiOGQOEuxZHvru68/1En7mH71iUA7ma28=;
        b=xUMbUfaY4vlLgOxG08vILuuaE9BM8TRoCgsqiFMloRWVAX/JbulvcL9/WcGninuVydI/Cb
        ptGavNu6G5wRr3AQ==
From:   "tip-bot2 for Juri Lelli" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/urgent] sched/deadline: Fix BUG_ON condition for deboosted tasks
Cc:     Juri Lelli <juri.lelli@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220714151908.533052-1-juri.lelli@redhat.com>
References: <20220714151908.533052-1-juri.lelli@redhat.com>
MIME-Version: 1.0
Message-ID: <165839309101.15455.13532699965942868865.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/urgent branch of tip:

Commit-ID:     ddfc710395cccc61247348df9eb18ea50321cbed
Gitweb:        https://git.kernel.org/tip/ddfc710395cccc61247348df9eb18ea50321cbed
Author:        Juri Lelli <juri.lelli@redhat.com>
AuthorDate:    Thu, 14 Jul 2022 17:19:08 +02:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Thu, 21 Jul 2022 10:35:28 +02:00

sched/deadline: Fix BUG_ON condition for deboosted tasks

Tasks the are being deboosted from SCHED_DEADLINE might enter
enqueue_task_dl() one last time and hit an erroneous BUG_ON condition:
since they are not boosted anymore, the if (is_dl_boosted()) branch is
not taken, but the else if (!dl_prio) is and inside this one we
BUG_ON(!is_dl_boosted), which is of course false (BUG_ON triggered)
otherwise we had entered the if branch above. Long story short, the
current condition doesn't make sense and always leads to triggering of a
BUG.

Fix this by only checking enqueue flags, properly: ENQUEUE_REPLENISH has
to be present, but additional flags are not a problem.

Fixes: 64be6f1f5f71 ("sched/deadline: Don't replenish from a !SCHED_DEADLINE entity")
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20220714151908.533052-1-juri.lelli@redhat.com
---
 kernel/sched/deadline.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b515296..7bf5612 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1701,7 +1701,10 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 		 * the throttle.
 		 */
 		p->dl.dl_throttled = 0;
-		BUG_ON(!is_dl_boosted(&p->dl) || flags != ENQUEUE_REPLENISH);
+		if (!(flags & ENQUEUE_REPLENISH))
+			printk_deferred_once("sched: DL de-boosted task PID %d: REPLENISH flag missing\n",
+					     task_pid_nr(p));
+
 		return;
 	}
 
