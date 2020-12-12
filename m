Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963932D884F
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 17:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407571AbgLLQfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 11:35:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:57722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439406AbgLLQJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 11:09:56 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 21/23] perf/x86/intel: Check PEBS status correctly
Date:   Sat, 12 Dec 2020 11:08:02 -0500
Message-Id: <20201212160804.2334982-21-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160804.2334982-1-sashal@kernel.org>
References: <20201212160804.2334982-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

[ Upstream commit fc17db8aa4c53cbd2d5469bb0521ea0f0a6dbb27 ]

The kernel cannot disambiguate when 2+ PEBS counters overflow at the
same time. This is what the comment for this code suggests.  However,
I see the comparison is done with the unfiltered p->status which is a
copy of IA32_PERF_GLOBAL_STATUS at the time of the sample. This
register contains more than the PEBS counter overflow bits. It also
includes many other bits which could also be set.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201126110922.317681-2-namhyung@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/ds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 404315df1e167..cf12e5a956f7e 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1913,7 +1913,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 		 * that caused the PEBS record. It's called collision.
 		 * If collision happened, the record will be dropped.
 		 */
-		if (p->status != (1ULL << bit)) {
+		if (pebs_status != (1ULL << bit)) {
 			for_each_set_bit(i, (unsigned long *)&pebs_status, size)
 				error[i]++;
 			continue;
-- 
2.27.0

