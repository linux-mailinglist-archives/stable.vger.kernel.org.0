Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E8A2EFD0C
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 03:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbhAICHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 21:07:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbhAICHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 21:07:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A50BA23AAC;
        Sat,  9 Jan 2021 02:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610157957;
        bh=Fzo/QSm35F0Z7LELOpY7VgizteZ3qNLeNfRMdCSQd0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KnLp8klBGeRrcBUdXeUNkxoySoLM9jFuUgz4No1rubfYcuQE+O6x7CTwUKL5IddD0
         CCS5ncNzXNfERbKR9ClrKbfWIP3wx5G/vTaNQTNt2lugxkHBZrFIhea3doEvOA3WVH
         HsR5920fqt6Ks+RAGRXJ4A67/mh3fiQfjgIxC+H2v6JWVpVp605nUt+YrmBOUnzC4F
         6/G0N64MKOa4yLHnsjGiMmr18faEjsr4kz4Yp/lU4l0pa4datekO+z6I8pHaiBhuFF
         vY95wYvTlmU0bPlMXoiyKWm0naa61Q63MIZBSH+fhkCLV00l6rThL4yjJyZ91WDEOm
         QXUkO6LzHlJWg==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [RFC PATCH 7/8] entry: Report local wake up on resched blind zone while resuming to user
Date:   Sat,  9 Jan 2021 03:05:35 +0100
Message-Id: <20210109020536.127953-8-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109020536.127953-1-frederic@kernel.org>
References: <20210109020536.127953-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The last rescheduling opportunity while resuming to user is in
exit_to_user_mode_loop(). This means that any wake up performed on
the local runqueue after this point is going to have its rescheduling
silently ignored.

Perform sanity checks to report these situations.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar<mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/entry/common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index 8f3292b5f9b7..1dfb97762336 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -5,6 +5,7 @@
 #include <linux/highmem.h>
 #include <linux/livepatch.h>
 #include <linux/audit.h>
+#include <linux/sched.h>
 
 #include "common.h"
 
@@ -23,6 +24,8 @@ static __always_inline void __enter_from_user_mode(struct pt_regs *regs)
 	instrumentation_begin();
 	trace_hardirqs_off_finish();
 	instrumentation_end();
+
+	sched_resched_local_allow();
 }
 
 void noinstr enter_from_user_mode(struct pt_regs *regs)
@@ -206,6 +209,7 @@ static void exit_to_user_mode_prepare(struct pt_regs *regs)
 	if (unlikely(ti_work & EXIT_TO_USER_MODE_WORK))
 		ti_work = exit_to_user_mode_loop(regs, ti_work);
 
+	sched_resched_local_forbid();
 	arch_exit_to_user_mode_prepare(regs, ti_work);
 
 	/* Ensure that the address limit is intact and no locks are held */
-- 
2.25.1

