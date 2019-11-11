Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20CFEF7B98
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbfKKShs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:37:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728895AbfKKShp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:37:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF8F921655;
        Mon, 11 Nov 2019 18:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497464;
        bh=5GN9Z8z2i4CPM2GG6ItL3lR2p202qoU9ErlKq3e+xgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CK+q8LAbJsB009bgt+P6d8dWYUGJrNX1j4OqlWtOpCIJ1e+GXZ1RGz7zsrHcPy0ai
         ++me3RWpASW3WqR7jy8XSYmrjJZSKjSbuuAQ3279TAaUcCCCwiYmMXqaJPmmE/VR5r
         1bj3ddVseF2nK9GUeH0gbzjOz76n4PhjyfPADKxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ben Segall <bsegall@google.com>,
        Dave Chiluk <chiluk+linux@indeed.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, pauld@redhat.com,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.14 063/105] sched/fair: Fix -Wunused-but-set-variable warnings
Date:   Mon, 11 Nov 2019 19:28:33 +0100
Message-Id: <20191111181445.120295345@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

commit 763a9ec06c409dcde2a761aac4bb83ff3938e0b3 upstream.

Commit:

   de53fd7aedb1 ("sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices")

introduced a few compilation warnings:

  kernel/sched/fair.c: In function '__refill_cfs_bandwidth_runtime':
  kernel/sched/fair.c:4365:6: warning: variable 'now' set but not used [-Wunused-but-set-variable]
  kernel/sched/fair.c: In function 'start_cfs_bandwidth':
  kernel/sched/fair.c:4992:6: warning: variable 'overrun' set but not used [-Wunused-but-set-variable]

Also, __refill_cfs_bandwidth_runtime() does no longer update the
expiration time, so fix the comments accordingly.

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ben Segall <bsegall@google.com>
Reviewed-by: Dave Chiluk <chiluk+linux@indeed.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: pauld@redhat.com
Fixes: de53fd7aedb1 ("sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices")
Link: https://lkml.kernel.org/r/1566326455-8038-1-git-send-email-cai@lca.pw
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4091,21 +4091,16 @@ static inline u64 sched_cfs_bandwidth_sl
 }
 
 /*
- * Replenish runtime according to assigned quota and update expiration time.
- * We use sched_clock_cpu directly instead of rq->clock to avoid adding
- * additional synchronization around rq->lock.
+ * Replenish runtime according to assigned quota. We use sched_clock_cpu
+ * directly instead of rq->clock to avoid adding additional synchronization
+ * around rq->lock.
  *
  * requires cfs_b->lock
  */
 void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 {
-	u64 now;
-
-	if (cfs_b->quota == RUNTIME_INF)
-		return;
-
-	now = sched_clock_cpu(smp_processor_id());
-	cfs_b->runtime = cfs_b->quota;
+	if (cfs_b->quota != RUNTIME_INF)
+		cfs_b->runtime = cfs_b->quota;
 }
 
 static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)


