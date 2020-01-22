Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9514B145574
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbgAVNWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:22:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730468AbgAVNWN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:22:13 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CC20205F4;
        Wed, 22 Jan 2020 13:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699332;
        bh=7BagCFkr7Ej8uB6WoRDmtl/Nn2vddSkOeXvraWty/M4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyh73MDpmwXOcaf3EKrLBQO68fBBGYXY2sAWwanEmpnkGGxK83g2NFwlirMjnNnFQ
         tepMCbs0E3pficQj3d4PQYuF9ii2XQenZlsewhrD8SH4mlZjkl6jkJYFdKFoXPDcuR
         4hAg4ipJ2SH3musOMsQCdwdYh7Mz7wV7bOLEFDts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.4 076/222] locking/lockdep: Fix buffer overrun problem in stack_trace[]
Date:   Wed, 22 Jan 2020 10:27:42 +0100
Message-Id: <20200122092839.158437396@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit d91f3057263ceb691ef527e71b41a56b17f6c869 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/locking/lockdep.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -482,7 +482,7 @@ static struct lock_trace *save_trace(voi
 	struct lock_trace *trace, *t2;
 	struct hlist_head *hash_head;
 	u32 hash;
-	unsigned int max_entries;
+	int max_entries;
 
 	BUILD_BUG_ON_NOT_POWER_OF_2(STACK_TRACE_HASH_SIZE);
 	BUILD_BUG_ON(LOCK_TRACE_SIZE_IN_LONGS >= MAX_STACK_TRACE_ENTRIES);
@@ -490,10 +490,8 @@ static struct lock_trace *save_trace(voi
 	trace = (struct lock_trace *)(stack_trace + nr_stack_trace_entries);
 	max_entries = MAX_STACK_TRACE_ENTRIES - nr_stack_trace_entries -
 		LOCK_TRACE_SIZE_IN_LONGS;
-	trace->nr_entries = stack_trace_save(trace->entries, max_entries, 3);
 
-	if (nr_stack_trace_entries >= MAX_STACK_TRACE_ENTRIES -
-	    LOCK_TRACE_SIZE_IN_LONGS - 1) {
+	if (max_entries <= 0) {
 		if (!debug_locks_off_graph_unlock())
 			return NULL;
 
@@ -502,6 +500,7 @@ static struct lock_trace *save_trace(voi
 
 		return NULL;
 	}
+	trace->nr_entries = stack_trace_save(trace->entries, max_entries, 3);
 
 	hash = jhash(trace->entries, trace->nr_entries *
 		     sizeof(trace->entries[0]), 0);


