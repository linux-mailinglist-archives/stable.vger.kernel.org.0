Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8D933BA70
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhCOOJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231387AbhCOODg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E05B64F0D;
        Mon, 15 Mar 2021 14:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817016;
        bh=F2XfBiiVRJnCI5oXCFxS44h7hKUw94JQWOPU9mOA1Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nmeiKSZhOqQ7oIwkJpAIM2D0cWyjB8gtf6OOBPuSOzaylEHfislQYOTlfGV0YSSqA
         BQKweNLCh1p8sCYbl5w3oOitX1CY3E4oBbiVoxMcbGSl13LaGL8z2y4IFrTbg32bau
         3wGYVdTu6aOljb3C+AR2uvYfbSTqaucqEK5aY7Oc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 261/306] perf/x86/intel: Set PERF_ATTACH_SCHED_CB for large PEBS and LBR
Date:   Mon, 15 Mar 2021 14:55:24 +0100
Message-Id: <20210315135516.468851372@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit afbef30149587ad46f4780b1e0cc5e219745ce90 ]

To supply a PID/TID for large PEBS, it requires flushing the PEBS buffer
in a context switch.

For normal LBRs, a context switch can flip the address space and LBR
entries are not tagged with an identifier, we need to wipe the LBR, even
for per-cpu events.

For LBR callstack, save/restore the stack is required during a context
switch.

Set PERF_ATTACH_SCHED_CB for the event with large PEBS & LBR.

Fixes: 9c964efa4330 ("perf/x86/intel: Drain the PEBS buffer during context switches")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/20201130193842.10569-2-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 4faaef3a8f6c..d3f5cf70c1a0 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3578,8 +3578,10 @@ static int intel_pmu_hw_config(struct perf_event *event)
 		if (!(event->attr.freq || (event->attr.wakeup_events && !event->attr.watermark))) {
 			event->hw.flags |= PERF_X86_EVENT_AUTO_RELOAD;
 			if (!(event->attr.sample_type &
-			      ~intel_pmu_large_pebs_flags(event)))
+			      ~intel_pmu_large_pebs_flags(event))) {
 				event->hw.flags |= PERF_X86_EVENT_LARGE_PEBS;
+				event->attach_state |= PERF_ATTACH_SCHED_CB;
+			}
 		}
 		if (x86_pmu.pebs_aliases)
 			x86_pmu.pebs_aliases(event);
@@ -3592,6 +3594,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
 		ret = intel_pmu_setup_lbr_filter(event);
 		if (ret)
 			return ret;
+		event->attach_state |= PERF_ATTACH_SCHED_CB;
 
 		/*
 		 * BTS is set up earlier in this path, so don't account twice
-- 
2.30.1



