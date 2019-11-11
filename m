Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED1C3F7D51
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbfKKSzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:55:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729895AbfKKSzf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:55:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F37920818;
        Mon, 11 Nov 2019 18:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498533;
        bh=umeMeDhsQodteMFPJzY3tEqJwDH1YTD6mV7K/TP8oB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6AaLQEChpmLF3/Jt+iuwXIvUu1IS3FgsG18vdGGgmu0y1rWE52DDOFO2//Nsas9a
         ZZLa6Ok2933Az/zV3GWJcwNZiRnc0S1dtsWBzBKdxh82p3qWW1pEZHDDNjvBQkIbuQ
         zti4Uz7WdBmrzz8C8M/QE3LDUkwrmBWTOHKU74iQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        linux-drivers-review@eclists.intel.com,
        linux-perf@eclists.intel.com, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 146/193] perf/x86/uncore: Fix event group support
Date:   Mon, 11 Nov 2019 19:28:48 +0100
Message-Id: <20191111181511.923144548@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 75be6f703a141b048590d659a3954c4fedd30bba ]

The events in the same group don't start or stop simultaneously.
Here is the ftrace when enabling event group for uncore_iio_0:

  # perf stat -e "{uncore_iio_0/event=0x1/,uncore_iio_0/event=0xe/}"

            <idle>-0     [000] d.h.  8959.064832: read_msr: a41, value
  b2b0b030		//Read counter reg of IIO unit0 counter0
            <idle>-0     [000] d.h.  8959.064835: write_msr: a48, value
  400001			//Write Ctrl reg of IIO unit0 counter0 to enable
  counter0. <------ Although counter0 is enabled, Unit Ctrl is still
  freezed. Nothing will count. We are still good here.
            <idle>-0     [000] d.h.  8959.064836: read_msr: a40, value
  30100                   //Read Unit Ctrl reg of IIO unit0
            <idle>-0     [000] d.h.  8959.064838: write_msr: a40, value
  30000			//Write Unit Ctrl reg of IIO unit0 to enable all
  counters in the unit by clear Freeze bit  <------Unit0 is un-freezed.
  Counter0 has been enabled. Now it starts counting. But counter1 has not
  been enabled yet. The issue starts here.
            <idle>-0     [000] d.h.  8959.064846: read_msr: a42, value 0
			//Read counter reg of IIO unit0 counter1
            <idle>-0     [000] d.h.  8959.064847: write_msr: a49, value
  40000e			//Write Ctrl reg of IIO unit0 counter1 to enable
  counter1.   <------ Now, counter1 just starts to count. Counter0 has
  been running for a while.

Current code un-freezes the Unit Ctrl right after the first counter is
enabled. The subsequent group events always loses some counter values.

Implement pmu_enable and pmu_disable support for uncore, which can help
to batch hardware accesses.

No one uses uncore_enable_box and uncore_disable_box. Remove them.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-drivers-review@eclists.intel.com
Cc: linux-perf@eclists.intel.com
Fixes: 087bfbb03269 ("perf/x86: Add generic Intel uncore PMU support")
Link: https://lkml.kernel.org/r/1572014593-31591-1-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore.c | 44 +++++++++++++++++++++++++++++-----
 arch/x86/events/intel/uncore.h | 12 ----------
 2 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index 3694a5d0703d9..f7b191d3c9b01 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -502,10 +502,8 @@ void uncore_pmu_event_start(struct perf_event *event, int flags)
 	local64_set(&event->hw.prev_count, uncore_read_counter(box, event));
 	uncore_enable_event(box, event);
 
-	if (box->n_active == 1) {
-		uncore_enable_box(box);
+	if (box->n_active == 1)
 		uncore_pmu_start_hrtimer(box);
-	}
 }
 
 void uncore_pmu_event_stop(struct perf_event *event, int flags)
@@ -529,10 +527,8 @@ void uncore_pmu_event_stop(struct perf_event *event, int flags)
 		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
 		hwc->state |= PERF_HES_STOPPED;
 
-		if (box->n_active == 0) {
-			uncore_disable_box(box);
+		if (box->n_active == 0)
 			uncore_pmu_cancel_hrtimer(box);
-		}
 	}
 
 	if ((flags & PERF_EF_UPDATE) && !(hwc->state & PERF_HES_UPTODATE)) {
@@ -778,6 +774,40 @@ static int uncore_pmu_event_init(struct perf_event *event)
 	return ret;
 }
 
+static void uncore_pmu_enable(struct pmu *pmu)
+{
+	struct intel_uncore_pmu *uncore_pmu;
+	struct intel_uncore_box *box;
+
+	uncore_pmu = container_of(pmu, struct intel_uncore_pmu, pmu);
+	if (!uncore_pmu)
+		return;
+
+	box = uncore_pmu_to_box(uncore_pmu, smp_processor_id());
+	if (!box)
+		return;
+
+	if (uncore_pmu->type->ops->enable_box)
+		uncore_pmu->type->ops->enable_box(box);
+}
+
+static void uncore_pmu_disable(struct pmu *pmu)
+{
+	struct intel_uncore_pmu *uncore_pmu;
+	struct intel_uncore_box *box;
+
+	uncore_pmu = container_of(pmu, struct intel_uncore_pmu, pmu);
+	if (!uncore_pmu)
+		return;
+
+	box = uncore_pmu_to_box(uncore_pmu, smp_processor_id());
+	if (!box)
+		return;
+
+	if (uncore_pmu->type->ops->disable_box)
+		uncore_pmu->type->ops->disable_box(box);
+}
+
 static ssize_t uncore_get_attr_cpumask(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -803,6 +833,8 @@ static int uncore_pmu_register(struct intel_uncore_pmu *pmu)
 		pmu->pmu = (struct pmu) {
 			.attr_groups	= pmu->type->attr_groups,
 			.task_ctx_nr	= perf_invalid_context,
+			.pmu_enable	= uncore_pmu_enable,
+			.pmu_disable	= uncore_pmu_disable,
 			.event_init	= uncore_pmu_event_init,
 			.add		= uncore_pmu_event_add,
 			.del		= uncore_pmu_event_del,
diff --git a/arch/x86/events/intel/uncore.h b/arch/x86/events/intel/uncore.h
index f36f7bebbc1bb..bbfdaa720b456 100644
--- a/arch/x86/events/intel/uncore.h
+++ b/arch/x86/events/intel/uncore.h
@@ -441,18 +441,6 @@ static inline int uncore_freerunning_hw_config(struct intel_uncore_box *box,
 	return -EINVAL;
 }
 
-static inline void uncore_disable_box(struct intel_uncore_box *box)
-{
-	if (box->pmu->type->ops->disable_box)
-		box->pmu->type->ops->disable_box(box);
-}
-
-static inline void uncore_enable_box(struct intel_uncore_box *box)
-{
-	if (box->pmu->type->ops->enable_box)
-		box->pmu->type->ops->enable_box(box);
-}
-
 static inline void uncore_disable_event(struct intel_uncore_box *box,
 				struct perf_event *event)
 {
-- 
2.20.1



