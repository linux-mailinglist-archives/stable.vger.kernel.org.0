Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F621BFCEC
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgD3Nvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:51:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbgD3Nvv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B290624956;
        Thu, 30 Apr 2020 13:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254711;
        bh=BtlbYbV7ZTLuPWVpFdkjQxXtr0m1GdmEM+9Jp5gVnkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBiVR1vXuhuBMPdlrx9Fyn7nH6pP0WTdSOq1K8odQh2JIDHRGaXpS7fTaN6GsycZJ
         I9yTNo+FrKccfH76JryEPxeJHfgJamtYX93lD7w3PJGizbVTDbXdWwdnvUJq2eNPw4
         /pInd2tXVBxAurTv+MPMlCN/JuhslrFZmqsfhPIs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Rudo <prudo@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 59/79] s390/ftrace: fix potential crashes when switching tracers
Date:   Thu, 30 Apr 2020 09:50:23 -0400
Message-Id: <20200430135043.19851-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Rudo <prudo@linux.ibm.com>

[ Upstream commit 8ebf6da9db1b2a20bb86cc1bee2552e894d03308 ]

Switching tracers include instruction patching. To prevent that a
instruction is patched while it's read the instruction patching is done
in stop_machine 'context'. This also means that any function called
during stop_machine must not be traced. Thus add 'notrace' to all
functions called within stop_machine.

Fixes: 1ec2772e0c3c ("s390/diag: add a statistic for diagnose calls")
Fixes: 38f2c691a4b3 ("s390: improve wait logic of stop_machine")
Fixes: 4ecf0a43e729 ("processor: get rid of cpu_relax_yield")
Signed-off-by: Philipp Rudo <prudo@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/diag.c  | 2 +-
 arch/s390/kernel/smp.c   | 4 ++--
 arch/s390/kernel/trace.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kernel/diag.c b/arch/s390/kernel/diag.c
index 61f2b0412345a..ccba63aaeb470 100644
--- a/arch/s390/kernel/diag.c
+++ b/arch/s390/kernel/diag.c
@@ -133,7 +133,7 @@ void diag_stat_inc(enum diag_stat_enum nr)
 }
 EXPORT_SYMBOL(diag_stat_inc);
 
-void diag_stat_inc_norecursion(enum diag_stat_enum nr)
+void notrace diag_stat_inc_norecursion(enum diag_stat_enum nr)
 {
 	this_cpu_inc(diag_stat.counter[nr]);
 	trace_s390_diagnose_norecursion(diag_map[nr].code);
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index f87d4e14269c9..4f8cb8d1c51b9 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -403,7 +403,7 @@ int smp_find_processor_id(u16 address)
 	return -1;
 }
 
-bool arch_vcpu_is_preempted(int cpu)
+bool notrace arch_vcpu_is_preempted(int cpu)
 {
 	if (test_cpu_flag_of(CIF_ENABLED_WAIT, cpu))
 		return false;
@@ -413,7 +413,7 @@ bool arch_vcpu_is_preempted(int cpu)
 }
 EXPORT_SYMBOL(arch_vcpu_is_preempted);
 
-void smp_yield_cpu(int cpu)
+void notrace smp_yield_cpu(int cpu)
 {
 	if (!MACHINE_HAS_DIAG9C)
 		return;
diff --git a/arch/s390/kernel/trace.c b/arch/s390/kernel/trace.c
index 490b52e850145..11a669f3cc93c 100644
--- a/arch/s390/kernel/trace.c
+++ b/arch/s390/kernel/trace.c
@@ -14,7 +14,7 @@ EXPORT_TRACEPOINT_SYMBOL(s390_diagnose);
 
 static DEFINE_PER_CPU(unsigned int, diagnose_trace_depth);
 
-void trace_s390_diagnose_norecursion(int diag_nr)
+void notrace trace_s390_diagnose_norecursion(int diag_nr)
 {
 	unsigned long flags;
 	unsigned int *depth;
-- 
2.20.1

