Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE789679EA
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 13:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfGMLNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 07:13:20 -0400
Received: from terminus.zytor.com ([198.137.202.136]:49683 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbfGMLNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 07:13:20 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x6DBD2J23842082
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 13 Jul 2019 04:13:03 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x6DBD2J23842082
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019061801; t=1563016383;
        bh=4NiuF9ef3LEZajpUQw81R/JZpb3yA4FfFwW+QZfNl2A=;
        h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
        b=Qz8tOZBpf0VGt3yqtIeMmlcliCUmSQTq+x6lw2B1IpeBEFmpoqndmj/QvB/IAhpa+
         G8Q1QLv0Z6e1NCT6v8S5wM6JDdys/6o7P7oD+/eD+mRg9qDVY4kkAnsTezMrzmd9bv
         ystjBT3aiE8Qev3wDPea+sS9sDCTJqvoql3wQiC9hR5YK0k146Sd8U61ejvKAonhlT
         rAsHZXW/fOIhJkifdzXMyKBIfFKjRwTy0ssn9F1Hyi1+QWh/D3zuY4u1H2uX2ys+FT
         UuTK9lQ30bFLuW1kSrBI33tqjAYzeBR1L8UR78LyLAc+2MuGzpP2jVhtyH/Aj9anyB
         KxialLPmzPFkg==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x6DBD2Tk3842076;
        Sat, 13 Jul 2019 04:13:02 -0700
Date:   Sat, 13 Jul 2019 04:13:02 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for Kan Liang <tipbot@zytor.com>
Message-ID: <tip-e4557c1a46b0d32746bd309e1941914b5a6912b4@git.kernel.org>
Cc:     linux-kernel@vger.kernel.org, eranian@google.com,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, jolsa@kernel.org, vincent.weaver@maine.edu,
        jolsa@redhat.com, mingo@kernel.org,
        alexander.shishkin@linux.intel.com, ammy.yi@intel.com,
        acme@redhat.com, kan.liang@linux.intel.com, stable@vger.kernel.org,
        hpa@zytor.com
Reply-To: torvalds@linux-foundation.org, eranian@google.com,
          linux-kernel@vger.kernel.org, peterz@infradead.org,
          tglx@linutronix.de, jolsa@kernel.org, vincent.weaver@maine.edu,
          alexander.shishkin@linux.intel.com, jolsa@redhat.com,
          mingo@kernel.org, ammy.yi@intel.com, kan.liang@linux.intel.com,
          acme@redhat.com, stable@vger.kernel.org, hpa@zytor.com
In-Reply-To: <20190625142135.22112-1-kan.liang@linux.intel.com>
References: <20190625142135.22112-1-kan.liang@linux.intel.com>
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel: Fix spurious NMI on fixed counter
Git-Commit-ID: e4557c1a46b0d32746bd309e1941914b5a6912b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DATE_IN_FUTURE_06_12,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
        DKIM_VALID_EF autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit-ID:  e4557c1a46b0d32746bd309e1941914b5a6912b4
Gitweb:     https://git.kernel.org/tip/e4557c1a46b0d32746bd309e1941914b5a6912b4
Author:     Kan Liang <kan.liang@linux.intel.com>
AuthorDate: Tue, 25 Jun 2019 07:21:35 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 13 Jul 2019 11:21:29 +0200

perf/x86/intel: Fix spurious NMI on fixed counter

If a user first sample a PEBS event on a fixed counter, then sample a
non-PEBS event on the same fixed counter on Icelake, it will trigger
spurious NMI. For example:

  perf record -e 'cycles:p' -a
  perf record -e 'cycles' -a

The error message for spurious NMI:

  [June 21 15:38] Uhhuh. NMI received for unknown reason 30 on CPU 2.
  [    +0.000000] Do you have a strange power saving mode enabled?
  [    +0.000000] Dazed and confused, but trying to continue

The bug was introduced by the following commit:

  commit 6f55967ad9d9 ("perf/x86/intel: Fix race in intel_pmu_disable_event()")

The commit moves the intel_pmu_pebs_disable() after intel_pmu_disable_fixed(),
which returns immediately.  The related bit of PEBS_ENABLE MSR will never be
cleared for the fixed counter. Then a non-PEBS event runs on the fixed counter,
but the bit on PEBS_ENABLE is still set, which triggers spurious NMIs.

Check and disable PEBS for fixed counters after intel_pmu_disable_fixed().

Reported-by: Yi, Ammy <ammy.yi@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Fixes: 6f55967ad9d9 ("perf/x86/intel: Fix race in intel_pmu_disable_event()")
Link: https://lkml.kernel.org/r/20190625142135.22112-1-kan.liang@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/events/intel/core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index bda450ff51ee..9e911a96972b 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2161,12 +2161,10 @@ static void intel_pmu_disable_event(struct perf_event *event)
 	cpuc->intel_ctrl_host_mask &= ~(1ull << hwc->idx);
 	cpuc->intel_cp_status &= ~(1ull << hwc->idx);
 
-	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
+	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
 		intel_pmu_disable_fixed(hwc);
-		return;
-	}
-
-	x86_pmu_disable_event(event);
+	else
+		x86_pmu_disable_event(event);
 
 	/*
 	 * Needs to be called after x86_pmu_disable_event,
