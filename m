Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746AD328A7E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239629AbhCASSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:18:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239337AbhCASLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:11:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D9F064F0C;
        Mon,  1 Mar 2021 17:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620919;
        bh=T3mWAzRnWiyZJijb0klKFp2aI48V0LfXLgCxCOcBctc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bnk3DvzADqzmSaq419W1FUHhOU+RoHMv4mAuUTMb1vHhZRlffpChC/CqPJ1KRXI62
         BhW+eTgGWVib4fL5ZhsVcGBDprreljeA7k+ykimxSxpEuhvWMYKfC43VpWmfd1enQf
         wUgb8EFATKc7LQ7ZQTR/xeINwIG+f1AcT9YElL28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 300/775] smp: Process pending softirqs in flush_smp_call_function_from_idle()
Date:   Mon,  1 Mar 2021 17:07:48 +0100
Message-Id: <20210301161216.452455647@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit f9d34595ae4feed38856b88769e2ba5af22d2548 ]

send_call_function_single_ipi() may wake an idle CPU without sending an
IPI. The woken up CPU will process the SMP-functions in
flush_smp_call_function_from_idle(). Any raised softirq from within the
SMP-function call will not be processed.
Should the CPU have no tasks assigned, then it will go back to idle with
pending softirqs and the NOHZ will rightfully complain.

Process pending softirqs on return from flush_smp_call_function_queue().

Fixes: b2a02fc43a1f4 ("smp: Optimize send_call_function_single_ipi()")
Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/20210123201027.3262800-2-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/smp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/smp.c b/kernel/smp.c
index 1b6070bf97bb0..aeb0adfa06063 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -14,6 +14,7 @@
 #include <linux/export.h>
 #include <linux/percpu.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
@@ -449,6 +450,9 @@ void flush_smp_call_function_from_idle(void)
 
 	local_irq_save(flags);
 	flush_smp_call_function_queue(true);
+	if (local_softirq_pending())
+		do_softirq();
+
 	local_irq_restore(flags);
 }
 
-- 
2.27.0



