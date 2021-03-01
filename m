Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B36328A36
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbhCASN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:13:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239293AbhCASIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:08:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 105A065103;
        Mon,  1 Mar 2021 17:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618891;
        bh=RQY+9gZbr/bRsI/eznwtH0hBGu31BLnYjYT3lhylAJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TtRO3zo6SeMyugaKxtOw5DMEdXtOapHFGYpxau/paBSnmQ6UR/aXAQrrk1Paz2PyJ
         EhNkctq3ZhBlK4O3q9CSYWaNk/Ey9VJtks3kHNn4qA3JippBpMzmOZlHEDt7K25nPI
         a/N28P3X47LEiCJfL6t70NX5J/lUmx6otdRH+KTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 255/663] smp: Process pending softirqs in flush_smp_call_function_from_idle()
Date:   Mon,  1 Mar 2021 17:08:23 +0100
Message-Id: <20210301161154.447737241@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 66040b2d5d41f85cb1a752a75260595344c5ec3b ]

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
Link: https://lkml.kernel.org/r/20210123201027.3262800-2-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/smp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/smp.c b/kernel/smp.c
index 4d17501433be7..25240fb2df949 100644
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



