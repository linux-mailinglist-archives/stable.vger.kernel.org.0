Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29EF33F079
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 13:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhCQMie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 08:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhCQMi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 08:38:27 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C29C06175F;
        Wed, 17 Mar 2021 05:38:27 -0700 (PDT)
Date:   Wed, 17 Mar 2021 12:38:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615984706;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b7tQGYlUswiXbyNAMMhbY05Q+Vlm5r3os4rSYHVdeis=;
        b=TeJShnmIE9ykppikO5RMnw1Q88DS1o5EFYeLN+Mw135KxOMZkQqXEaW2lfCBF4A6rxTnEv
        P8bbGSaiQEv1jpvVuffOPJR0ExjQf7ABgU+Fjv7SGM5uD8Y8uFNoRi5t7cfQNw7TJgG0a0
        LF7DyadLLgdOVek0WPmWCoH7063K0xon7OxLy09sZ9UDlg3M7CH8JbWQoajVgWfLbugBBc
        M6pkJ7Sj5f/c99XHTbrNe2GSsiN2fPMvHQDvslUCW9QfeDfvSdopomo3Llfu99r0U0VDa+
        U6HTFgEqdqlBKmzPrPvi/ek0R2jKbMYb8F/B9znhurtTqEyKOjznuJchIjD1nA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615984706;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b7tQGYlUswiXbyNAMMhbY05Q+Vlm5r3os4rSYHVdeis=;
        b=3PlyDCxcXJmwHBJGR5qXLuIH8NYs9NmUTMj2V2rc/GdXywEyY6UL14Tr6q2v2MuRjBVxLK
        z/CDmNjDBugPG7Cw==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/intel: Fix a crash caused by zero PEBS status
Cc:     Vince Weaver <vincent.weaver@maine.edu>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1615555298-140216-1-git-send-email-kan.liang@linux.intel.com>
References: <1615555298-140216-1-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <161598470586.398.5955283931725612425.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     d88d05a9e0b6d9356e97129d4ff9942d765f46ea
Gitweb:        https://git.kernel.org/tip/d88d05a9e0b6d9356e97129d4ff9942d765f46ea
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Fri, 12 Mar 2021 05:21:37 -08:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 16 Mar 2021 21:44:39 +01:00

perf/x86/intel: Fix a crash caused by zero PEBS status

A repeatable crash can be triggered by the perf_fuzzer on some Haswell
system.
https://lore.kernel.org/lkml/7170d3b-c17f-1ded-52aa-cc6d9ae999f4@maine.edu/

For some old CPUs (HSW and earlier), the PEBS status in a PEBS record
may be mistakenly set to 0. To minimize the impact of the defect, the
commit was introduced to try to avoid dropping the PEBS record for some
cases. It adds a check in the intel_pmu_drain_pebs_nhm(), and updates
the local pebs_status accordingly. However, it doesn't correct the PEBS
status in the PEBS record, which may trigger the crash, especially for
the large PEBS.

It's possible that all the PEBS records in a large PEBS have the PEBS
status 0. If so, the first get_next_pebs_record_by_bit() in the
__intel_pmu_pebs_event() returns NULL. The at = NULL. Since it's a large
PEBS, the 'count' parameter must > 1. The second
get_next_pebs_record_by_bit() will crash.

Besides the local pebs_status, correct the PEBS status in the PEBS
record as well.

Fixes: 01330d7288e0 ("perf/x86: Allow zero PEBS status with only single active event")
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1615555298-140216-1-git-send-email-kan.liang@linux.intel.com
---
 arch/x86/events/intel/ds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 7ebae18..d32b302 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2010,7 +2010,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, struct perf_sample_d
 		 */
 		if (!pebs_status && cpuc->pebs_enabled &&
 			!(cpuc->pebs_enabled & (cpuc->pebs_enabled-1)))
-			pebs_status = cpuc->pebs_enabled;
+			pebs_status = p->status = cpuc->pebs_enabled;
 
 		bit = find_first_bit((unsigned long *)&pebs_status,
 					x86_pmu.max_pebs_events);
