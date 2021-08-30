Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523BB3FB574
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbhH3MDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:03:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236846AbhH3MB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 08:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91FCD61184;
        Mon, 30 Aug 2021 12:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324827;
        bh=i/jPnbG65hNRemE2NxRsUKQpGhviYG1HVVUFW4DdBEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVFTcEde5eXJirz0o8Sxx+ZWDGX9AOCvILbOZtEkU4tV8HgzgUsrwU2VMNYnd4avH
         L80+bI8dRg1fWehEWXuyarWcw5O6NNg7Se6ogWSuzw31Jn5YQ9ApHHa2FjW5yOkTnn
         OtvT+dedpsPqPCPvZg/F21KgU3j/cvS3oB6GzAe92StbeJ1A9ajKfW98qCnKFXkTpd
         UdQ7Uj8uhbi0uZ9QK3hAUPDr1WkNlsH8cJsurj49XbzYFiR52DNsSp7u25hix/E0z4
         p3hgLPZJtRnRutrlrBjWUu2E+HEiHAYOWRcRqzNeBxi2DuaeUVfmQFeWW2CvTkiJuc
         j2y9xZV4VHLkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kim Phillips <kim.phillips@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/10] perf/x86/amd/ibs: Work around erratum #1197
Date:   Mon, 30 Aug 2021 08:00:14 -0400
Message-Id: <20210830120018.1017841-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830120018.1017841-1-sashal@kernel.org>
References: <20210830120018.1017841-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

[ Upstream commit 26db2e0c51fe83e1dd852c1321407835b481806e ]

Erratum #1197 "IBS (Instruction Based Sampling) Register State May be
Incorrect After Restore From CC6" is published in a document:

  "Revision Guide for AMD Family 19h Models 00h-0Fh Processors" 56683 Rev. 1.04 July 2021

  https://bugzilla.kernel.org/show_bug.cgi?id=206537

Implement the erratum's suggested workaround and ignore IBS samples if
MSRC001_1031 == 0.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210817221048.88063-3-kim.phillips@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/ibs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 39169885adfa..ff07040287c4 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -90,6 +90,7 @@ struct perf_ibs {
 	unsigned long			offset_mask[1];
 	int				offset_max;
 	unsigned int			fetch_count_reset_broken : 1;
+	unsigned int			fetch_ignore_if_zero_rip : 1;
 	struct cpu_perf_ibs __percpu	*pcpu;
 
 	struct attribute		**format_attrs;
@@ -663,6 +664,10 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	if (check_rip && (ibs_data.regs[2] & IBS_RIP_INVALID)) {
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 	} else {
+		/* Workaround for erratum #1197 */
+		if (perf_ibs->fetch_ignore_if_zero_rip && !(ibs_data.regs[1]))
+			goto out;
+
 		set_linear_ip(&regs, ibs_data.regs[1]);
 		regs.flags |= PERF_EFLAGS_EXACT;
 	}
@@ -756,6 +761,9 @@ static __init void perf_event_ibs_init(void)
 	if (boot_cpu_data.x86 >= 0x16 && boot_cpu_data.x86 <= 0x18)
 		perf_ibs_fetch.fetch_count_reset_broken = 1;
 
+	if (boot_cpu_data.x86 == 0x19 && boot_cpu_data.x86_model < 0x10)
+		perf_ibs_fetch.fetch_ignore_if_zero_rip = 1;
+
 	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
 
 	if (ibs_caps & IBS_CAPS_OPCNT) {
-- 
2.30.2

