Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BC834433C
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhCVMtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232390AbhCVMrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:47:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D6F8619C2;
        Mon, 22 Mar 2021 12:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417003;
        bh=JXea8Et57GFBQl0wa1CNabQQ9N3HePuueSwXvNQgqfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOMD/DFdR9QO0xsnD9FO5Ef0ePO7pm+BjsDjvoiYv1JWFsWmBo+m5aR2TBpwn5rku
         IX1d4gI5WW5STorFkjJ5L0HF/NikG1wWN9LE8XkQK1SapCCMTtMdomy6gtXtr8vmBU
         jcQQE3Ybh4JmSLirDxUEtW5Wae8jhRr/KPLkdYU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vince Weaver <vincent.weaver@maine.edu>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH 5.4 49/60] perf/x86/intel: Fix a crash caused by zero PEBS status
Date:   Mon, 22 Mar 2021 13:28:37 +0100
Message-Id: <20210322121924.003759280@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit d88d05a9e0b6d9356e97129d4ff9942d765f46ea upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/ds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1890,7 +1890,7 @@ static void intel_pmu_drain_pebs_nhm(str
 		 */
 		if (!pebs_status && cpuc->pebs_enabled &&
 			!(cpuc->pebs_enabled & (cpuc->pebs_enabled-1)))
-			pebs_status = cpuc->pebs_enabled;
+			pebs_status = p->status = cpuc->pebs_enabled;
 
 		bit = find_first_bit((unsigned long *)&pebs_status,
 					x86_pmu.max_pebs_events);


