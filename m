Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC8D2659EB
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 09:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbgIKHDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 03:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgIKHCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 03:02:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6004C061757;
        Fri, 11 Sep 2020 00:02:30 -0700 (PDT)
Date:   Fri, 11 Sep 2020 07:02:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1599807748;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=5d9fe4eytXUd+WWgl53CTGZ6C41OK0l4pfyvLMLPzBM=;
        b=4TWbKgyRoZNfR5l/x3w4Rbu6kLx/7nZbRQDIX/2K8IU16HKyyid7/pRWNedHLRzGXaEZQv
        FU6LvZIATgXUAfG/adezZs9wa9JH9uXnxDgQws83e+Vfhxj2rzzYU6lq245Dq30QoQozHG
        5zcrMoP8EX/DGa3G6u5kyoFCy935HJ0lUz5zWp+ixCJHT1x87S0ZiMBzj1xUfdSXoN8OhK
        jR8snlgvG6ngcKj+unlZMAfNtp83NHmyArAmA98rWEBnL3WHS10ZndnIz3Dr91AOmrMGbh
        +3+a8P7xEksMu6q4G9LYrIJgLzR1NyLsCect0i2RWEdgvFhj+PNx00ytj03y4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1599807748;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=5d9fe4eytXUd+WWgl53CTGZ6C41OK0l4pfyvLMLPzBM=;
        b=0AbQ0w3TMfUVq71qvyxszMHlmJPLSV2Boh5q2uchp9g2xYKxpNoGpG/AIqoF0t7pz4hH4T
        PIW5N55gXM23oNDA==
From:   "tip-bot2 for Kim Phillips" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/amd: Fix sampling Large Increment per Cycle events
Cc:     Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <159980774821.20229.7720841504258329146.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     26e52558ead4b39c0e0fe7bf08f82f5a9777a412
Gitweb:        https://git.kernel.org/tip/26e52558ead4b39c0e0fe7bf08f82f5a9777a412
Author:        Kim Phillips <kim.phillips@amd.com>
AuthorDate:    Tue, 08 Sep 2020 16:47:35 -05:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Thu, 10 Sep 2020 11:19:35 +02:00

perf/x86/amd: Fix sampling Large Increment per Cycle events

Commit 5738891229a2 ("perf/x86/amd: Add support for Large Increment
per Cycle Events") mistakenly zeroes the upper 16 bits of the count
in set_period().  That's fine for counting with perf stat, but not
sampling with perf record when only Large Increment events are being
sampled.  To enable sampling, we sign extend the upper 16 bits of the
merged counter pair as described in the Family 17h PPRs:

"Software wanting to preload a value to a merged counter pair writes the
high-order 16-bit value to the low-order 16 bits of the odd counter and
then writes the low-order 48-bit value to the even counter. Reading the
even counter of the merged counter pair returns the full 64-bit value."

Fixes: 5738891229a2 ("perf/x86/amd: Add support for Large Increment per Cycle Events")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
---
 arch/x86/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 0f3d015..cb5cfef 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1326,11 +1326,11 @@ int x86_perf_event_set_period(struct perf_event *event)
 	wrmsrl(hwc->event_base, (u64)(-left) & x86_pmu.cntval_mask);
 
 	/*
-	 * Clear the Merge event counter's upper 16 bits since
+	 * Sign extend the Merge event counter's upper 16 bits since
 	 * we currently declare a 48-bit counter width
 	 */
 	if (is_counter_pair(hwc))
-		wrmsrl(x86_pmu_event_addr(idx + 1), 0);
+		wrmsrl(x86_pmu_event_addr(idx + 1), 0xffff);
 
 	/*
 	 * Due to erratum on certan cpu we need
