Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F44EF4A20
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388999AbfKHLku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:40:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388997AbfKHLks (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05E9421D7B;
        Fri,  8 Nov 2019 11:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213248;
        bh=nbOFxwzTXJEvjhEzo/ISqTtdrt+QvFHEEBN114iqTos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xVgIZPvlbyhPSA418e34SCfDifdTWQy+b8xW7yfZJ2KHtVcsgxeXYN7y8DhwhWFSL
         VLJ+O2BYkPP0B6wOZArOMk/AGyq1jUFw89InTOVr6MoEifxSV3tjSbB0p4yUdhG2J8
         S1jJb04p1N03BR3Q0aULj1weMuKYha9rO8dbE5Jw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, kernel@pengutronix.de,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 115/205] sched/debug: Use symbolic names for task state constants
Date:   Fri,  8 Nov 2019 06:36:22 -0500
Message-Id: <20191108113752.12502-115-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5e1a7578c9edd..9a4bdfadab077 100644
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

