Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65837E68BF
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbfJ0Vbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730783AbfJ0VQS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:16:18 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 317DD205C9;
        Sun, 27 Oct 2019 21:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210977;
        bh=kBixZciC+SwAD5N9IqEnDJit+WNCuEd8YTzQB0ENBSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2U7BFUZvPIVuLbuNx+N10fAKiXfT+savOGig0L88K8ulM5zIc+ct0r0JV8e2/gHla
         ymgDq3gSS3Uhl3tPvNu6YPG7+2HxOijVDbmimRgbSuozPHq2/ClnloNxetgMR694/Z
         KV/V8MOx1n2PEfE96DIKfrAx5s5q5uAO3abK1M4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.19 76/93] perf/aux: Fix AUX output stopping
Date:   Sun, 27 Oct 2019 22:01:28 +0100
Message-Id: <20191027203311.208096055@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit f3a519e4add93b7b31a6616f0b09635ff2e6a159 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6813,7 +6813,7 @@ static void __perf_event_output_stop(str
 static int __perf_pmu_output_stop(void *info)
 {
 	struct perf_event *event = info;
-	struct pmu *pmu = event->pmu;
+	struct pmu *pmu = event->ctx->pmu;
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 	struct remote_output ro = {
 		.rb	= event->rb,


