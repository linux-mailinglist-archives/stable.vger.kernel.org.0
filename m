Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01531CAC3F
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgEHMv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729910AbgEHMv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:51:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B17EE24958;
        Fri,  8 May 2020 12:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942285;
        bh=jlxp6bHqaL5SLGNE4+p8W1vuvAGZv7qXffR7022qqeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDfL2/52IUsEKcQMz34xoyPGJPvHDiQyFPsZgsw/dcneufsmIgSqbxQyY9/NaJVj6
         fj2XavLa4mZbxEPgEyMIfRESgJyyyaVzLuycxibp88b7WWP+IGRcm91zLNnqcPMlHE
         7imSglbigrHPX1X5CFgw23o/0AtJ2LoFgSBiDt6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Rudo <prudo@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/32] s390/ftrace: fix potential crashes when switching tracers
Date:   Fri,  8 May 2020 14:35:30 +0200
Message-Id: <20200508123037.116783881@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123034.886699170@linuxfoundation.org>
References: <20200508123034.886699170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 35c842aa87058..4c7cf8787a848 100644
--- a/arch/s390/kernel/diag.c
+++ b/arch/s390/kernel/diag.c
@@ -128,7 +128,7 @@ void diag_stat_inc(enum diag_stat_enum nr)
 }
 EXPORT_SYMBOL(diag_stat_inc);
 
-void diag_stat_inc_norecursion(enum diag_stat_enum nr)
+void notrace diag_stat_inc_norecursion(enum diag_stat_enum nr)
 {
 	this_cpu_inc(diag_stat.counter[nr]);
 	trace_s390_diagnose_norecursion(diag_map[nr].code);
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index ecd24711f3aa9..8e31dfd85de32 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -393,7 +393,7 @@ int smp_find_processor_id(u16 address)
 	return -1;
 }
 
-bool arch_vcpu_is_preempted(int cpu)
+bool notrace arch_vcpu_is_preempted(int cpu)
 {
 	if (test_cpu_flag_of(CIF_ENABLED_WAIT, cpu))
 		return false;
@@ -403,7 +403,7 @@ bool arch_vcpu_is_preempted(int cpu)
 }
 EXPORT_SYMBOL(arch_vcpu_is_preempted);
 
-void smp_yield_cpu(int cpu)
+void notrace smp_yield_cpu(int cpu)
 {
 	if (MACHINE_HAS_DIAG9C) {
 		diag_stat_inc_norecursion(DIAG_STAT_X09C);
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



