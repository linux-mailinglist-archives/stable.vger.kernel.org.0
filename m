Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B06A1E2A65
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389536AbgEZSzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389529AbgEZSzb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:55:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C04432084C;
        Tue, 26 May 2020 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519330;
        bh=3pSeskTFjO+0bbdeOLUtWgslWTMrbRVNNNRWN0jVovo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwSM5xgpTUImhI4viHXgNCFGTSCyRiRyt4bhB/lwx2XFM6nm+lDVPjHCVTCGxFP8U
         Dlkz9KGryf8lumpl8KMTz9xyUSbn3YO9o8sMXpdDTCjp9L4HbSO2DE/jjtR4OQxJul
         3r6eqPWe4Be9xKcI4aohSk5IeaVF7DnGfvgAHq5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lauro Ramos Venancio <lvenanci@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Rik van Riel <riel@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, lwang@redhat.com,
        Ingo Molnar <mingo@kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 26/65] sched/fair, cpumask: Export for_each_cpu_wrap()
Date:   Tue, 26 May 2020 20:52:45 +0200
Message-Id: <20200526183915.976645661@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit c743f0a5c50f2fcbc628526279cfa24f3dabe182 ]

More users for for_each_cpu_wrap() have appeared. Promote the construct
to generic cpumask interface.

The implementation is slightly modified to reduce arguments.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Lauro Ramos Venancio <lvenanci@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: lwang@redhat.com
Link: http://lkml.kernel.org/r/20170414122005.o35me2h5nowqkxbv@hirez.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[dj: include only what's added to the cpumask interface, 4.4 doesn't
     have them in the scheduler]
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cpumask.h | 17 +++++++++++++++++
 lib/cpumask.c           | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index bb3a4bb35183..1322883e7b46 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -232,6 +232,23 @@ unsigned int cpumask_local_spread(unsigned int i, int node);
 		(cpu) = cpumask_next_zero((cpu), (mask)),	\
 		(cpu) < nr_cpu_ids;)
 
+extern int cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool wrap);
+
+/**
+ * for_each_cpu_wrap - iterate over every cpu in a mask, starting at a specified location
+ * @cpu: the (optionally unsigned) integer iterator
+ * @mask: the cpumask poiter
+ * @start: the start location
+ *
+ * The implementation does not assume any bit in @mask is set (including @start).
+ *
+ * After the loop, cpu is >= nr_cpu_ids.
+ */
+#define for_each_cpu_wrap(cpu, mask, start)					\
+	for ((cpu) = cpumask_next_wrap((start)-1, (mask), (start), false);	\
+	     (cpu) < nr_cpumask_bits;						\
+	     (cpu) = cpumask_next_wrap((cpu), (mask), (start), true))
+
 /**
  * for_each_cpu_and - iterate over every cpu in both masks
  * @cpu: the (optionally unsigned) integer iterator
diff --git a/lib/cpumask.c b/lib/cpumask.c
index 5a70f6196f57..24f06e7abf92 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -42,6 +42,38 @@ int cpumask_any_but(const struct cpumask *mask, unsigned int cpu)
 	return i;
 }
 
+/**
+ * cpumask_next_wrap - helper to implement for_each_cpu_wrap
+ * @n: the cpu prior to the place to search
+ * @mask: the cpumask pointer
+ * @start: the start point of the iteration
+ * @wrap: assume @n crossing @start terminates the iteration
+ *
+ * Returns >= nr_cpu_ids on completion
+ *
+ * Note: the @wrap argument is required for the start condition when
+ * we cannot assume @start is set in @mask.
+ */
+int cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool wrap)
+{
+	int next;
+
+again:
+	next = cpumask_next(n, mask);
+
+	if (wrap && n < start && next >= start) {
+		return nr_cpumask_bits;
+
+	} else if (next >= nr_cpumask_bits) {
+		wrap = true;
+		n = -1;
+		goto again;
+	}
+
+	return next;
+}
+EXPORT_SYMBOL(cpumask_next_wrap);
+
 /* These are not inline because of header tangles. */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 /**
-- 
2.25.1



