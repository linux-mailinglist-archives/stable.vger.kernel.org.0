Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2334D6C3
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbfFTSLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:11:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728954AbfFTSLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:11:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B96802070B;
        Thu, 20 Jun 2019 18:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054307;
        bh=95GPIigMvlLUlVMsW6pUoxXKIsw1/FBEZC9liyRnEaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJB1y2ObySN3LJd1CoI7+foHVRTn4AhOaLarK0Hj9YXNc2gy0DIHBdCqwPympOGEo
         Ge2CbQhP3J7CDbu1ewEkZ+JMnXik+BjXSeW60qSn/4jBCMuzVwxO5bCrrV8H8r57fH
         deZb+v+mcygR9ZLGoFRi7ZkKG0T7MhSETAJdjgfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>, kan.liang@intel.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/61] perf/x86/intel/ds: Fix EVENT vs. UEVENT PEBS constraints
Date:   Thu, 20 Jun 2019 19:57:13 +0200
Message-Id: <20190620174340.281076789@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
References: <20190620174336.357373754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 23e3983a466cd540ffdd2bbc6e0c51e31934f941 ]

This patch fixes an bug revealed by the following commit:

  6b89d4c1ae85 ("perf/x86/intel: Fix INTEL_FLAGS_EVENT_CONSTRAINT* masking")

That patch modified INTEL_FLAGS_EVENT_CONSTRAINT() to only look at the event code
when matching a constraint. If code+umask were needed, then the
INTEL_FLAGS_UEVENT_CONSTRAINT() macro was needed instead.
This broke with some of the constraints for PEBS events.

Several of them, including the one used for cycles:p, cycles:pp, cycles:ppp
fell in that category and caused the event to be rejected in PEBS mode.
In other words, on some platforms a cmdline such as:

  $ perf top -e cycles:pp

would fail with -EINVAL.

This patch fixes this bug by properly using INTEL_FLAGS_UEVENT_CONSTRAINT()
when needed in the PEBS constraint tables.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: kan.liang@intel.com
Link: http://lkml.kernel.org/r/20190521005246.423-1-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/ds.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index b7b01d762d32..e91814d1a27f 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -684,7 +684,7 @@ struct event_constraint intel_core2_pebs_event_constraints[] = {
 	INTEL_FLAGS_UEVENT_CONSTRAINT(0x1fc7, 0x1), /* SIMD_INST_RETURED.ANY */
 	INTEL_FLAGS_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
 	/* INST_RETIRED.ANY_P, inv=1, cmask=16 (cycles:p). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108000c0, 0x01),
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x108000c0, 0x01),
 	EVENT_CONSTRAINT_END
 };
 
@@ -693,7 +693,7 @@ struct event_constraint intel_atom_pebs_event_constraints[] = {
 	INTEL_FLAGS_UEVENT_CONSTRAINT(0x00c5, 0x1), /* MISPREDICTED_BRANCH_RETIRED */
 	INTEL_FLAGS_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
 	/* INST_RETIRED.ANY_P, inv=1, cmask=16 (cycles:p). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108000c0, 0x01),
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x108000c0, 0x01),
 	/* Allow all events as PEBS with no flags */
 	INTEL_ALL_EVENT_CONSTRAINT(0, 0x1),
 	EVENT_CONSTRAINT_END
@@ -701,7 +701,7 @@ struct event_constraint intel_atom_pebs_event_constraints[] = {
 
 struct event_constraint intel_slm_pebs_event_constraints[] = {
 	/* INST_RETIRED.ANY_P, inv=1, cmask=16 (cycles:p). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108000c0, 0x1),
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x108000c0, 0x1),
 	/* Allow all events as PEBS with no flags */
 	INTEL_ALL_EVENT_CONSTRAINT(0, 0x1),
 	EVENT_CONSTRAINT_END
@@ -726,7 +726,7 @@ struct event_constraint intel_nehalem_pebs_event_constraints[] = {
 	INTEL_FLAGS_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
 	INTEL_FLAGS_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
 	/* INST_RETIRED.ANY_P, inv=1, cmask=16 (cycles:p). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108000c0, 0x0f),
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x108000c0, 0x0f),
 	EVENT_CONSTRAINT_END
 };
 
@@ -743,7 +743,7 @@ struct event_constraint intel_westmere_pebs_event_constraints[] = {
 	INTEL_FLAGS_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
 	INTEL_FLAGS_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
 	/* INST_RETIRED.ANY_P, inv=1, cmask=16 (cycles:p). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108000c0, 0x0f),
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x108000c0, 0x0f),
 	EVENT_CONSTRAINT_END
 };
 
@@ -752,7 +752,7 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
 	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x108001c2, 0xf),
         INTEL_EXCLEVT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
         INTEL_EXCLEVT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
         INTEL_EXCLEVT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
@@ -767,9 +767,9 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
         INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
 	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x108001c2, 0xf),
 	/* INST_RETIRED.PREC_DIST, inv=1, cmask=16 (cycles:ppp). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c0, 0x2),
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x108001c0, 0x2),
 	INTEL_EXCLEVT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
 	INTEL_EXCLEVT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
 	INTEL_EXCLEVT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
@@ -783,9 +783,9 @@ struct event_constraint intel_hsw_pebs_event_constraints[] = {
 	INTEL_FLAGS_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
 	INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.* */
 	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x108001c2, 0xf),
 	/* INST_RETIRED.PREC_DIST, inv=1, cmask=16 (cycles:ppp). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c0, 0x2),
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x108001c0, 0x2),
 	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_NA(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
 	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_XLD(0x11d0, 0xf), /* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
 	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_XLD(0x21d0, 0xf), /* MEM_UOPS_RETIRED.LOCK_LOADS */
@@ -806,9 +806,9 @@ struct event_constraint intel_bdw_pebs_event_constraints[] = {
 	INTEL_FLAGS_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
 	INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.* */
 	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x108001c2, 0xf),
 	/* INST_RETIRED.PREC_DIST, inv=1, cmask=16 (cycles:ppp). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c0, 0x2),
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x108001c0, 0x2),
 	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_NA(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
 	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x11d0, 0xf), /* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
 	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x21d0, 0xf), /* MEM_UOPS_RETIRED.LOCK_LOADS */
@@ -829,9 +829,9 @@ struct event_constraint intel_bdw_pebs_event_constraints[] = {
 struct event_constraint intel_skl_pebs_event_constraints[] = {
 	INTEL_FLAGS_UEVENT_CONSTRAINT(0x1c0, 0x2),	/* INST_RETIRED.PREC_DIST */
 	/* INST_RETIRED.PREC_DIST, inv=1, cmask=16 (cycles:ppp). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c0, 0x2),
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x108001c0, 0x2),
 	/* INST_RETIRED.TOTAL_CYCLES_PS (inv=1, cmask=16) (cycles:p). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108000c0, 0x0f),
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x108000c0, 0x0f),
 	INTEL_PLD_CONSTRAINT(0x1cd, 0xf),		      /* MEM_TRANS_RETIRED.* */
 	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x11d0, 0xf), /* MEM_INST_RETIRED.STLB_MISS_LOADS */
 	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x12d0, 0xf), /* MEM_INST_RETIRED.STLB_MISS_STORES */
-- 
2.20.1



