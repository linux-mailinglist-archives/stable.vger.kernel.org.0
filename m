Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB49411CED
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344579AbhITRPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:15:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346069AbhITRNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:13:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 695FA619E8;
        Mon, 20 Sep 2021 16:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157067;
        bh=JQGF92WIBj9tvjPoOjzECkBMVVr00cJOwyadSGrXDKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mylA4Kr37o6icBJOCTRs9zFFrY7i7hN5fyHzddUC1JwFacle5LDSmMUISiCNvnzJ0
         PfhaPa7uN05HCdBw5+COX5q01C6tk7WG8hUbKs6Ct+ydk79t/Pr9CwWOORgOApRRfI
         /VUH8YtTzWhD/T7H39mDAtbZry/rP4831Cn1fEAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 007/217] perf/x86/amd/ibs: Work around erratum #1197
Date:   Mon, 20 Sep 2021 18:40:28 +0200
Message-Id: <20210920163924.853848195@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3fe68f7f9d5e..5043425ced6b 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -90,6 +90,7 @@ struct perf_ibs {
 	unsigned long			offset_mask[1];
 	int				offset_max;
 	unsigned int			fetch_count_reset_broken : 1;
+	unsigned int			fetch_ignore_if_zero_rip : 1;
 	struct cpu_perf_ibs __percpu	*pcpu;
 
 	struct attribute		**format_attrs;
@@ -674,6 +675,10 @@ fail:
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
@@ -767,6 +772,9 @@ static __init void perf_event_ibs_init(void)
 	if (boot_cpu_data.x86 >= 0x16 && boot_cpu_data.x86 <= 0x18)
 		perf_ibs_fetch.fetch_count_reset_broken = 1;
 
+	if (boot_cpu_data.x86 == 0x19 && boot_cpu_data.x86_model < 0x10)
+		perf_ibs_fetch.fetch_ignore_if_zero_rip = 1;
+
 	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
 
 	if (ibs_caps & IBS_CAPS_OPCNT) {
-- 
2.30.2



