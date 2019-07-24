Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C32747AB
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 09:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbfGYHBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 03:01:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfGYHBK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 03:01:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 348012070B;
        Thu, 25 Jul 2019 07:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564038069;
        bh=86HcYU9n0mFTGn6uNTIrrfgOLIWTZfG6iObg0q1mcx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cePPolY7UxQpBhZF3A4pxWoR4DEAj9TOgo09xWL4qYU0P1YcYfN0FIjWq6KD6MeaO
         HT+URvLxe4C3Ehahsb7McKVQ/La4nnrZ6GrKOAxWHXxTYWMTEoKxUu4Z4zMOrgqu0o
         a7yxCoeiIQjMb1U62hD02dWnSIKiR5ve66tamdiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Yi, Ammy" <ammy.yi@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.2 354/413] perf/x86/intel: Fix spurious NMI on fixed counter
Date:   Wed, 24 Jul 2019 21:20:45 +0200
Message-Id: <20190724191801.057976495@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit e4557c1a46b0d32746bd309e1941914b5a6912b4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/intel/core.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2161,12 +2161,10 @@ static void intel_pmu_disable_event(stru
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


