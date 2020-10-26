Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6F2298A86
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 11:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770074AbgJZKkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 06:40:24 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39044 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1770067AbgJZKkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 06:40:22 -0400
Date:   Mon, 26 Oct 2020 10:40:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603708820;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=08EbtSloDeX9auUDy0ygY+Usk0vTSJgHxNB0kRIuqHI=;
        b=U1HiCRqw0eqEO3woi64N3L2U6jUWXJQFAi9SmZpUo0YOUadobX7QsZUclfv1c/2oRD5g/5
        THn36L/GIjtq/b3aM0Uc6M9qy42uUGNmRnHYIqVeVz88cDc7VYqxdXvy2mNNRTXj+NqEtv
        XNYs7ahHPZP6TVA8mqoWaXxd+fkNDEi+kaDESnTC+bx0s6QAgHpELUfz1aqERTc0HTVwXb
        oBrahh9+zWD1s7lfYA3gnssErMhOwK1BlDJmAzJFbjxiUUuPG120t8F1LByq0U5jx1Ezbq
        iENWoXIiojOrFJhya7tPFOeDodtJM4oFMj7q/XAmHPePYwLZC5KGFcEIwAfwKg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603708820;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=08EbtSloDeX9auUDy0ygY+Usk0vTSJgHxNB0kRIuqHI=;
        b=waGHkoGOIjcIPakATwVuZOFfPWUh4d3Iaqtao7Y/7E9rWuI/bnPlrO8f0B7KkUxdVWuRZn
        sBXccEynEQzFH7BQ==
From:   "tip-bot2 for Quanyang Wang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] time/sched_clock: Mark
 sched_clock_read_begin/retry() as notrace
Cc:     Quanyang Wang <quanyang.wang@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200929082027.16787-1-quanyang.wang@windriver.com>
References: <20200929082027.16787-1-quanyang.wang@windriver.com>
MIME-Version: 1.0
Message-ID: <160370881926.397.16021594131838342411.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     4cd2bb12981165f865d2b8ed92b446b52310ef74
Gitweb:        https://git.kernel.org/tip/4cd2bb12981165f865d2b8ed92b446b52310ef74
Author:        Quanyang Wang <quanyang.wang@windriver.com>
AuthorDate:    Tue, 29 Sep 2020 16:20:27 +08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 26 Oct 2020 11:34:31 +01:00

time/sched_clock: Mark sched_clock_read_begin/retry() as notrace

Since sched_clock_read_begin() and sched_clock_read_retry() are called
by notrace function sched_clock(), they shouldn't be traceable either,
or else ftrace_graph_caller will run into a dead loop on the path
as below (arm for instance):

  ftrace_graph_caller()
    prepare_ftrace_return()
      function_graph_enter()
        ftrace_push_return_trace()
          trace_clock_local()
            sched_clock()
              sched_clock_read_begin/retry()

Fixes: 1b86abc1c645 ("sched_clock: Expose struct clock_read_data")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200929082027.16787-1-quanyang.wang@windriver.com
---
 kernel/time/sched_clock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 0642013..b1b9b12 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -68,13 +68,13 @@ static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
 	return (cyc * mult) >> shift;
 }
 
-struct clock_read_data *sched_clock_read_begin(unsigned int *seq)
+notrace struct clock_read_data *sched_clock_read_begin(unsigned int *seq)
 {
 	*seq = raw_read_seqcount_latch(&cd.seq);
 	return cd.read_data + (*seq & 1);
 }
 
-int sched_clock_read_retry(unsigned int seq)
+notrace int sched_clock_read_retry(unsigned int seq)
 {
 	return read_seqcount_latch_retry(&cd.seq, seq);
 }
