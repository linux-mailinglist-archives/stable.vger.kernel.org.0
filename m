Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE5C01486D1
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390993AbgAXOSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:18:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403748AbgAXOSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:18:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4463024658;
        Fri, 24 Jan 2020 14:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875521;
        bh=7EUQP8HwpY6+rfh1K7GoRHWZxuvTbWqNTYnVX5w5dhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zH8BGA2B/SwBZ7+0cLBHuEKKl9oV9/gtsW6S2EQnvMxphVlCFXo5x9G2cjK9NmfBX
         R80zfca+H4jn7utjvgPgwNZg1j5qm5jhARIXpOy2JwzC78HL7Z4ExW/H0XLg/wU+Md
         XwW1EIIIyB883MKBpdVv6rpcKl4ma2wzgwvBIfrk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 020/107] locking/lockdep: Fix buffer overrun problem in stack_trace[]
Date:   Fri, 24 Jan 2020 09:16:50 -0500
Message-Id: <20200124141817.28793-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit d91f3057263ceb691ef527e71b41a56b17f6c869 ]

If the lockdep code is really running out of the stack_trace entries,
it is likely that buffer overrun can happen and the data immediately
after stack_trace[] will be corrupted.

If there is less than LOCK_TRACE_SIZE_IN_LONGS entries left before
the call to save_trace(), the max_entries computation will leave it
with a very large positive number because of its unsigned nature. The
subsequent call to stack_trace_save() will then corrupt the data after
stack_trace[]. Fix that by changing max_entries to a signed integer
and check for negative value before calling stack_trace_save().

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 12593b7467f9 ("locking/lockdep: Reduce space occupied by stack traces")
Link: https://lkml.kernel.org/r/20191220135128.14876-1-longman@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 233459c03b5ae..35d3b6925b1ee 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -482,7 +482,7 @@ static struct lock_trace *save_trace(void)
 	struct lock_trace *trace, *t2;
 	struct hlist_head *hash_head;
 	u32 hash;
-	unsigned int max_entries;
+	int max_entries;
 
 	BUILD_BUG_ON_NOT_POWER_OF_2(STACK_TRACE_HASH_SIZE);
 	BUILD_BUG_ON(LOCK_TRACE_SIZE_IN_LONGS >= MAX_STACK_TRACE_ENTRIES);
@@ -490,10 +490,8 @@ static struct lock_trace *save_trace(void)
 	trace = (struct lock_trace *)(stack_trace + nr_stack_trace_entries);
 	max_entries = MAX_STACK_TRACE_ENTRIES - nr_stack_trace_entries -
 		LOCK_TRACE_SIZE_IN_LONGS;
-	trace->nr_entries = stack_trace_save(trace->entries, max_entries, 3);
 
-	if (nr_stack_trace_entries >= MAX_STACK_TRACE_ENTRIES -
-	    LOCK_TRACE_SIZE_IN_LONGS - 1) {
+	if (max_entries <= 0) {
 		if (!debug_locks_off_graph_unlock())
 			return NULL;
 
@@ -502,6 +500,7 @@ static struct lock_trace *save_trace(void)
 
 		return NULL;
 	}
+	trace->nr_entries = stack_trace_save(trace->entries, max_entries, 3);
 
 	hash = jhash(trace->entries, trace->nr_entries *
 		     sizeof(trace->entries[0]), 0);
-- 
2.20.1

