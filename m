Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B7A1AF021
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgDROsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728711AbgDROn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:43:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF16F2224F;
        Sat, 18 Apr 2020 14:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587221038;
        bh=8TbDRuEl7SW/hnCTYxbSPFoal6+jcufVGTTSkOU1tjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/M8gx6V0cYlpYW6iDN/0APR+Ca9msBTt5b6jQBfhKppERULdVGashjaRBNuiVRuA
         XA9TmVsv9LpC+DJgEMTKqcrV9y8EZgDMERFKJVdHCmOf0I5bOh1jAngU1gFXYE9uH0
         T3Y+QYwTII+grR7PtEKsl9i2n433fe/PIUeIT3ic=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 23/28] perf/core: Disable page faults when getting phys address
Date:   Sat, 18 Apr 2020 10:43:23 -0400
Message-Id: <20200418144328.10265-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144328.10265-1-sashal@kernel.org>
References: <20200418144328.10265-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit d3296fb372bf7497b0e5d0478c4e7a677ec6f6e9 ]

We hit following warning when running tests on kernel
compiled with CONFIG_DEBUG_ATOMIC_SLEEP=y:

 WARNING: CPU: 19 PID: 4472 at mm/gup.c:2381 __get_user_pages_fast+0x1a4/0x200
 CPU: 19 PID: 4472 Comm: dummy Not tainted 5.6.0-rc6+ #3
 RIP: 0010:__get_user_pages_fast+0x1a4/0x200
 ...
 Call Trace:
  perf_prepare_sample+0xff1/0x1d90
  perf_event_output_forward+0xe8/0x210
  __perf_event_overflow+0x11a/0x310
  __intel_pmu_pebs_event+0x657/0x850
  intel_pmu_drain_pebs_nhm+0x7de/0x11d0
  handle_pmi_common+0x1b2/0x650
  intel_pmu_handle_irq+0x17b/0x370
  perf_event_nmi_handler+0x40/0x60
  nmi_handle+0x192/0x590
  default_do_nmi+0x6d/0x150
  do_nmi+0x2f9/0x3c0
  nmi+0x8e/0xd7

While __get_user_pages_fast() is IRQ-safe, it calls access_ok(),
which warns on:

  WARN_ON_ONCE(!in_task() && !pagefault_disabled())

Peter suggested disabling page faults around __get_user_pages_fast(),
which gets rid of the warning in access_ok() call.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/20200407141427.3184722-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 845c8a1a9d30a..c16ce11049de3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6119,9 +6119,12 @@ static u64 perf_virt_to_phys(u64 virt)
 		 * Try IRQ-safe __get_user_pages_fast first.
 		 * If failed, leave phys_addr as 0.
 		 */
-		if ((current->mm != NULL) &&
-		    (__get_user_pages_fast(virt, 1, 0, &p) == 1))
-			phys_addr = page_to_phys(p) + virt % PAGE_SIZE;
+		if (current->mm != NULL) {
+			pagefault_disable();
+			if (__get_user_pages_fast(virt, 1, 0, &p) == 1)
+				phys_addr = page_to_phys(p) + virt % PAGE_SIZE;
+			pagefault_enable();
+		}
 
 		if (p)
 			put_page(p);
-- 
2.20.1

