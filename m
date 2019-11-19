Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5BE51015D4
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730987AbfKSFrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:47:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730881AbfKSFrm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:47:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 172112071B;
        Tue, 19 Nov 2019 05:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142461;
        bh=paYbxFJhwWi5rUZFJYNrk3e0i0/3tdHI35nXxRrVAuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvvX5xKSKR5Pqi65FcTxa1V3One8IcGsToGo1s7F7MLbb7DvZ0vdGtWqFbALyko95
         L7aDml/Qb10fiZg9CoPULXS/piKknqWU0iJ1JlM0ro/ZGRr+1WdjR2l57uKPWH64vU
         wEes0ENlTNqL5ifI67RK/U9NhbBV9Hh6UTJmlT7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, kernel@pengutronix.de,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 082/239] sched/debug: Use symbolic names for task state constants
Date:   Tue, 19 Nov 2019 06:18:02 +0100
Message-Id: <20191119051315.892771273@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit ff28915fd31ccafc0d38e6f84b66df280ed9e86a ]

include/trace/events/sched.h includes <linux/sched.h> (via
<linux/sched/numa_balancing.h>) and so knows about the TASK_* constants
used to interpret .prev_state. So instead of duplicating the magic
numbers make use of the defined macros to ease understanding the
mapping from state bits to letters which isn't completely intuitive for
an outsider.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel@pengutronix.de
Link: http://lkml.kernel.org/r/20180905093636.24068-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/sched.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 6e692a52936c7..18197e0bb5108 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -169,9 +169,14 @@ TRACE_EVENT(sched_switch,
 
 		(__entry->prev_state & (TASK_REPORT_MAX - 1)) ?
 		  __print_flags(__entry->prev_state & (TASK_REPORT_MAX - 1), "|",
-				{ 0x01, "S" }, { 0x02, "D" }, { 0x04, "T" },
-				{ 0x08, "t" }, { 0x10, "X" }, { 0x20, "Z" },
-				{ 0x40, "P" }, { 0x80, "I" }) :
+				{ TASK_INTERRUPTIBLE, "S" },
+				{ TASK_UNINTERRUPTIBLE, "D" },
+				{ __TASK_STOPPED, "T" },
+				{ __TASK_TRACED, "t" },
+				{ EXIT_DEAD, "X" },
+				{ EXIT_ZOMBIE, "Z" },
+				{ TASK_PARKED, "P" },
+				{ TASK_DEAD, "I" }) :
 		  "R",
 
 		__entry->prev_state & TASK_REPORT_MAX ? "+" : "",
-- 
2.20.1



