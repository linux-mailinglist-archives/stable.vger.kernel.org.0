Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C532E40F3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440290AbgL1ON5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:13:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:48566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440283AbgL1ONz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 652BB20791;
        Mon, 28 Dec 2020 14:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164819;
        bh=LuCfF+Xzrjs1dNnQyLjcvWfeaoI+MMU+/dYfWKcA+Ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfuiLxSh6W0oyF7QVC7TnPONrr66SucbcxQzfJdkXbu/e0mby0MS0Qaa4x5YhjG4n
         nMbFipGSa/vrdNxdSPbAbTwUTFPoPh00wKWYN0H/+WD/naXel0tf9RSBcBizR38fqC
         x0d62IxW7JDjj9qIne1nxYOieFtLdPa/btr5QLBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 279/717] powerpc/perf: Fix crash with is_sier_available when pmu is not set
Date:   Mon, 28 Dec 2020 13:44:37 +0100
Message-Id: <20201228125034.387934879@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit f75e7d73bdf73f07b0701a6d21c111ef5d9021dd ]

On systems without any specific PMU driver support registered, running
'perf record' with —intr-regs  will crash ( perf record -I <workload> ).

The relevant portion from crash logs and Call Trace:

Unable to handle kernel paging request for data at address 0x00000068
Faulting instruction address: 0xc00000000013eb18
Oops: Kernel access of bad area, sig: 11 [#1]
CPU: 2 PID: 13435 Comm: kill Kdump: loaded Not tainted 4.18.0-193.el8.ppc64le #1
NIP:  c00000000013eb18 LR: c000000000139f2c CTR: c000000000393d80
REGS: c0000004a07ab4f0 TRAP: 0300   Not tainted  (4.18.0-193.el8.ppc64le)
NIP [c00000000013eb18] is_sier_available+0x18/0x30
LR [c000000000139f2c] perf_reg_value+0x6c/0xb0
Call Trace:
[c0000004a07ab770] [c0000004a07ab7c8] 0xc0000004a07ab7c8 (unreliable)
[c0000004a07ab7a0] [c0000000003aa77c] perf_output_sample+0x60c/0xac0
[c0000004a07ab840] [c0000000003ab3f0] perf_event_output_forward+0x70/0xb0
[c0000004a07ab8c0] [c00000000039e208] __perf_event_overflow+0x88/0x1a0
[c0000004a07ab910] [c00000000039e42c] perf_swevent_hrtimer+0x10c/0x1d0
[c0000004a07abc50] [c000000000228b9c] __hrtimer_run_queues+0x17c/0x480
[c0000004a07abcf0] [c00000000022aaf4] hrtimer_interrupt+0x144/0x520
[c0000004a07abdd0] [c00000000002a864] timer_interrupt+0x104/0x2f0
[c0000004a07abe30] [c0000000000091c4] decrementer_common+0x114/0x120

When perf record session is started with "-I" option, capturing registers
on each sample calls is_sier_available() to check for the
SIER (Sample Instruction Event Register) availability in the platform.
This function in core-book3s accesses 'ppmu->flags'. If a platform specific
PMU driver is not registered, ppmu is set to NULL and accessing its
members results in a crash. Fix the crash by returning false in
is_sier_available() if ppmu is not set.

Fixes: 333804dc3b7a ("powerpc/perf: Update perf_regs structure to include SIER")
Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1606185640-1720-1-git-send-email-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/core-book3s.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 08643cba14948..1de4770c2194b 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -137,6 +137,9 @@ static void pmao_restore_workaround(bool ebb) { }
 
 bool is_sier_available(void)
 {
+	if (!ppmu)
+		return false;
+
 	if (ppmu->flags & PPMU_HAS_SIER)
 		return true;
 
-- 
2.27.0



