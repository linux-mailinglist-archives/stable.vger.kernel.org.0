Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF39E0409
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 14:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbfJVMlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 08:41:20 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40923 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731405AbfJVMlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Oct 2019 08:41:20 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iMtTC-0006aF-Pt; Tue, 22 Oct 2019 14:41:02 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 53A7F1C0090;
        Tue, 22 Oct 2019 14:41:02 +0200 (CEST)
Date:   Tue, 22 Oct 2019 12:41:01 -0000
From:   "tip-bot2 for Alexander Shishkin" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/aux: Fix AUX output stopping
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20191022073940.61814-1-alexander.shishkin@linux.intel.com>
References: <20191022073940.61814-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Message-ID: <157174806200.29376.5249502095555132828.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     f3a519e4add93b7b31a6616f0b09635ff2e6a159
Gitweb:        https://git.kernel.org/tip/f3a519e4add93b7b31a6616f0b09635ff2e6a159
Author:        Alexander Shishkin <alexander.shishkin@linux.intel.com>
AuthorDate:    Tue, 22 Oct 2019 10:39:40 +03:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Tue, 22 Oct 2019 14:39:37 +02:00

perf/aux: Fix AUX output stopping

Commit:

  8a58ddae2379 ("perf/core: Fix exclusive events' grouping")

allows CAP_EXCLUSIVE events to be grouped with other events. Since all
of those also happen to be AUX events (which is not the case the other
way around, because arch/s390), this changes the rules for stopping the
output: the AUX event may not be on its PMU's context any more, if it's
grouped with a HW event, in which case it will be on that HW event's
context instead. If that's the case, munmap() of the AUX buffer can't
find and stop the AUX event, potentially leaving the last reference with
the atomic context, which will then end up freeing the AUX buffer. This
will then trip warnings:

Fix this by using the context's PMU context when looking for events
to stop, instead of the event's PMU context.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20191022073940.61814-1-alexander.shishkin@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f5d7950..bb3748d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6949,7 +6949,7 @@ static void __perf_event_output_stop(struct perf_event *event, void *data)
 static int __perf_pmu_output_stop(void *info)
 {
 	struct perf_event *event = info;
-	struct pmu *pmu = event->pmu;
+	struct pmu *pmu = event->ctx->pmu;
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 	struct remote_output ro = {
 		.rb	= event->rb,
