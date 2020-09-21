Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EEC272832
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgIUOla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:41:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728031AbgIUOlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:41:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 330872371F;
        Mon, 21 Sep 2020 14:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699282;
        bh=DOwg7wsIbWSWtlF7OlVEGYVmShh1txnXKYdPZzbhWCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQ4ZdzVIyjBub1jjO3iclAoEV4v/o5hK5k9m6nVCBbp1P7JtRLaqah+jqrCLvFBLq
         U8zT40Dd1SBQ3XIj8dWRzEiQpa7D8SIm4Jp7EIY8YeDh61tqKVzJDMVVFPTxE9av03
         FXaVjQYbzuFqcKnXrPqX3TN6MPwRs2ofhKeydmJE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 6/9] lockdep: fix order in trace_hardirqs_off_caller()
Date:   Mon, 21 Sep 2020 10:41:11 -0400
Message-Id: <20200921144114.2135773-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144114.2135773-1-sashal@kernel.org>
References: <20200921144114.2135773-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 73ac74c7d489756d2313219a108809921dbfaea1 ]

Switch order so that locking state is consistent even
if the IRQ tracer calls into lockdep again.

Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_preemptirq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_preemptirq.c b/kernel/trace/trace_preemptirq.c
index 71f553cceb3c1..0e373cb0106bb 100644
--- a/kernel/trace/trace_preemptirq.c
+++ b/kernel/trace/trace_preemptirq.c
@@ -59,14 +59,14 @@ EXPORT_SYMBOL(trace_hardirqs_on_caller);
 
 __visible void trace_hardirqs_off_caller(unsigned long caller_addr)
 {
+	lockdep_hardirqs_off(CALLER_ADDR0);
+
 	if (!this_cpu_read(tracing_irq_cpu)) {
 		this_cpu_write(tracing_irq_cpu, 1);
 		tracer_hardirqs_off(CALLER_ADDR0, caller_addr);
 		if (!in_nmi())
 			trace_irq_disable_rcuidle(CALLER_ADDR0, caller_addr);
 	}
-
-	lockdep_hardirqs_off(CALLER_ADDR0);
 }
 EXPORT_SYMBOL(trace_hardirqs_off_caller);
 #endif /* CONFIG_TRACE_IRQFLAGS */
-- 
2.25.1

