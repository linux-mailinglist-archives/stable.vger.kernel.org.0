Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0295F2D9FC1
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502237AbgLNRha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:37:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502189AbgLNRhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:25 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Sperbeck <jsperbeck@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 034/105] perf/x86/intel: Fix a warning on x86_pmu_stop() with large PEBS
Date:   Mon, 14 Dec 2020 18:28:08 +0100
Message-Id: <20201214172556.924588371@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 5debf02131227d39988e44adf5090fb796fa8466 ]

The commit 3966c3feca3f ("x86/perf/amd: Remove need to check "running"
bit in NMI handler") introduced this.  It seems x86_pmu_stop can be
called recursively (like when it losts some samples) like below:

  x86_pmu_stop
    intel_pmu_disable_event  (x86_pmu_disable)
      intel_pmu_pebs_disable
        intel_pmu_drain_pebs_nhm  (x86_pmu_drain_pebs_buffer)
          x86_pmu_stop

While commit 35d1ce6bec13 ("perf/x86/intel/ds: Fix x86_pmu_stop
warning for large PEBS") fixed it for the normal cases, there's
another path to call x86_pmu_stop() recursively when a PEBS error was
detected (like two or more counters overflowed at the same time).

Like in the Kan's previous fix, we can skip the interrupt accounting
for large PEBS, so check the iregs which is set for PMI only.

Fixes: 3966c3feca3f ("x86/perf/amd: Remove need to check "running" bit in NMI handler")
Reported-by: John Sperbeck <jsperbeck@google.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201126110922.317681-1-namhyung@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/ds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 404315df1e167..4c84b87904930 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1937,7 +1937,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 		if (error[bit]) {
 			perf_log_lost_samples(event, error[bit]);
 
-			if (perf_event_account_interrupt(event))
+			if (iregs && perf_event_account_interrupt(event))
 				x86_pmu_stop(event, 0);
 		}
 
-- 
2.27.0



