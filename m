Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E5A32B018
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbhCCAbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:31:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:60552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351014AbhCBNDQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 08:03:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5413064FC8;
        Tue,  2 Mar 2021 11:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686368;
        bh=5mcuKEFICUkVnXLimjy43/nNMeqFVo/2OMkfWdFFrig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OpxKKiOqP2i2StD+8h6TeAwdrRtkNzCi5fyeOhX3KyuU68k88/EGCkzDWzqVBQLy+
         dbHwzZALm8j1CUA4aoFmvht89YTq3YTccJJrS+vI7Vpke6TlNE5Yq3ZDRGfdyJc2xL
         7XiD/pWl6NJ3hlWLtOdOLrgMaRiMH6R+GkFh1y5J7xhOrgmFYLCkV2hLCaiZ1iInGy
         U1ApxqXpB9WEBpt0XxJfymJDocP64srgElle748t3xUf58NxZDJyxLvlA118Dpgxjj
         ZTm7t2TIC1EpLR48KD8PEeaR5i149T7+chm7WON99EQqQLjAqOT2goFCB/6nG6VfNS
         +t3DUYM/eu2vA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 04/10] powerpc/perf: Record counter overflow always if SAMPLE_IP is unset
Date:   Tue,  2 Mar 2021 06:59:15 -0500
Message-Id: <20210302115921.63636-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115921.63636-1-sashal@kernel.org>
References: <20210302115921.63636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit d137845c973147a22622cc76c7b0bc16f6206323 ]

While sampling for marked events, currently we record the sample only
if the SIAR valid bit of Sampled Instruction Event Register (SIER) is
set. SIAR_VALID bit is used for fetching the instruction address from
Sampled Instruction Address Register(SIAR). But there are some
usecases, where the user is interested only in the PMU stats at each
counter overflow and the exact IP of the overflow event is not
required. Dropping SIAR invalid samples will fail to record some of
the counter overflows in such cases.

Example of such usecase is dumping the PMU stats (event counts) after
some regular amount of instructions/events from the userspace (ex: via
ptrace). Here counter overflow is indicated to userspace via signal
handler, and captured by monitoring and enabling I/O signaling on the
event file descriptor. In these cases, we expect to get
sample/overflow indication after each specified sample_period.

Perf event attribute will not have PERF_SAMPLE_IP set in the
sample_type if exact IP of the overflow event is not requested. So
while profiling if SAMPLE_IP is not set, just record the counter
overflow irrespective of SIAR_VALID check.

Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
[mpe: Reflow comment and if formatting]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1612516492-1428-1-git-send-email-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/core-book3s.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 1f1ac446ace9..f2d8f35c181f 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -2010,7 +2010,17 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 			left += period;
 			if (left <= 0)
 				left = period;
-			record = siar_valid(regs);
+
+			/*
+			 * If address is not requested in the sample via
+			 * PERF_SAMPLE_IP, just record that sample irrespective
+			 * of SIAR valid check.
+			 */
+			if (event->attr.sample_type & PERF_SAMPLE_IP)
+				record = siar_valid(regs);
+			else
+				record = 1;
+
 			event->hw.last_period = event->hw.sample_period;
 		}
 		if (left < 0x80000000LL)
@@ -2028,9 +2038,10 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 	 * MMCR2. Check attr.exclude_kernel and address to drop the sample in
 	 * these cases.
 	 */
-	if (event->attr.exclude_kernel && record)
-		if (is_kernel_addr(mfspr(SPRN_SIAR)))
-			record = 0;
+	if (event->attr.exclude_kernel &&
+	    (event->attr.sample_type & PERF_SAMPLE_IP) &&
+	    is_kernel_addr(mfspr(SPRN_SIAR)))
+		record = 0;
 
 	/*
 	 * Finally record data if requested.
-- 
2.30.1

