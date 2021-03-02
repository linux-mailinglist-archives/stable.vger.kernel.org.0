Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A624632B01D
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237190AbhCCAb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:31:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351029AbhCBNDQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 08:03:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F86D64FBC;
        Tue,  2 Mar 2021 11:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686350;
        bh=MmzIUQi4WSmgCuB9jJMRQiChPqM8XxCBhyI/NSHeqgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuc4JNiM+dibxg1btPq8fH6EQ7cIN+XvmY/Cmo89bBGbU5TFIvVVkuaFCpP8HBrSc
         hmZ2LtULzmq+CP8vmaSZTNz6MM8Ij+nkjkNp5sEIum3WY02TZHTNXeHF7SJpiKwDwF
         GeMtD1mSV0CSovNQXBljuwv8fK70inGMVYHpBhRWvmFwLpbfn65dYR2dtju8z4f0CK
         KMqGxxlSPCsMH6jjlsK/b0+IP0QnWIAGqCD8OguqohQg3T8wRyHA8g+VAcM4VsmJgX
         IRXXCo1agIp2RMXXD60cX49W/cgSKtSNezrBeGBAZsIWVbsKwTl4NYB+vMvi8ni2SZ
         pS0u357s4+aOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 05/13] powerpc/perf: Record counter overflow always if SAMPLE_IP is unset
Date:   Tue,  2 Mar 2021 06:58:55 -0500
Message-Id: <20210302115903.63458-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115903.63458-1-sashal@kernel.org>
References: <20210302115903.63458-1-sashal@kernel.org>
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
index 56f16c803590..2669847434b8 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -2055,7 +2055,17 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
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
@@ -2073,9 +2083,10 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
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

