Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296DA4F2D52
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245479AbiDEI4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241182AbiDEIcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:53 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A125A1705C;
        Tue,  5 Apr 2022 01:29:09 -0700 (PDT)
Date:   Tue, 05 Apr 2022 08:29:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649147348;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=scYHAXGa/0fvVqkzj7iTiyF7lJ4/pkg20Qlu7GjepjI=;
        b=cpcP8F7LKJ2xe564KJQOMvQW9g+lmF19TOrdMg9m2eBvu/a8VolzYOjgvM5+GiQC2BzQt2
        4WnEjG6hAVARvnR7yBN3nkbnTqVctlbmGaJgt3rmgdlANrqs77KGcjQd7iweQmiPeQVeKE
        LndjBITJNf74zDytn8FyX8xJeSWbPAB82WsgpR1xb2chm/XfKfKCLZr5EN94rDo0kdzJI6
        +Bc+6Djm01nIj7iyf/e2UPh4wUQukJrCs2d/YOLCzMtMptvN7CFX8UnUqRO83IvckGYLE0
        Zv0omSyDDpgPzlfAKXBFYLUGO+ZEx+mqGIM7h8Wxc0zTQZ+6+e2t6eXwMqW7nA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649147348;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=scYHAXGa/0fvVqkzj7iTiyF7lJ4/pkg20Qlu7GjepjI=;
        b=b1sD60hTqRFaVqSuR3AUswkaEWRFlsjtsAcVzzwN4tgFujyEkKWek/rzt7Ov+E5Py6FSHg
        hb9c7isLyskLP6Dw==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/intel: Don't extend the pseudo-encoding
 to GP counters
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1648482543-14923-1-git-send-email-kan.liang@linux.intel.com>
References: <1648482543-14923-1-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <164914734724.389.2883979109723202576.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     4a263bf331c512849062805ef1b4ac40301a9829
Gitweb:        https://git.kernel.org/tip/4a263bf331c512849062805ef1b4ac40301a9829
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Mon, 28 Mar 2022 08:49:02 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 05 Apr 2022 09:59:44 +02:00

perf/x86/intel: Don't extend the pseudo-encoding to GP counters

The INST_RETIRED.PREC_DIST event (0x0100) doesn't count on SPR.
perf stat -e cpu/event=0xc0,umask=0x0/,cpu/event=0x0,umask=0x1/ -C0

 Performance counter stats for 'CPU(s) 0':

           607,246      cpu/event=0xc0,umask=0x0/
                 0      cpu/event=0x0,umask=0x1/

The encoding for INST_RETIRED.PREC_DIST is pseudo-encoding, which
doesn't work on the generic counters. However, current perf extends its
mask to the generic counters.

The pseudo event-code for a fixed counter must be 0x00. Check and avoid
extending the mask for the fixed counter event which using the
pseudo-encoding, e.g., ref-cycles and PREC_DIST event.

With the patch,
perf stat -e cpu/event=0xc0,umask=0x0/,cpu/event=0x0,umask=0x1/ -C0

 Performance counter stats for 'CPU(s) 0':

           583,184      cpu/event=0xc0,umask=0x0/
           583,048      cpu/event=0x0,umask=0x1/

Fixes: 2de71ee153ef ("perf/x86/intel: Fix ICL/SPR INST_RETIRED.PREC_DIST encodings")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1648482543-14923-1-git-send-email-kan.liang@linux.intel.com
---
 arch/x86/events/intel/core.c      | 6 +++++-
 arch/x86/include/asm/perf_event.h | 5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 28f075e..eb17b96 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5536,7 +5536,11 @@ static void intel_pmu_check_event_constraints(struct event_constraint *event_con
 			/* Disabled fixed counters which are not in CPUID */
 			c->idxmsk64 &= intel_ctrl;
 
-			if (c->idxmsk64 != INTEL_PMC_MSK_FIXED_REF_CYCLES)
+			/*
+			 * Don't extend the pseudo-encoding to the
+			 * generic counters
+			 */
+			if (!use_fixed_pseudo_encoding(c->code))
 				c->idxmsk64 |= (1ULL << num_counters) - 1;
 		}
 		c->idxmsk64 &=
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 58d9e4b..b06e4c5 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -241,6 +241,11 @@ struct x86_pmu_capability {
 #define INTEL_PMC_IDX_FIXED_SLOTS	(INTEL_PMC_IDX_FIXED + 3)
 #define INTEL_PMC_MSK_FIXED_SLOTS	(1ULL << INTEL_PMC_IDX_FIXED_SLOTS)
 
+static inline bool use_fixed_pseudo_encoding(u64 code)
+{
+	return !(code & 0xff);
+}
+
 /*
  * We model BTS tracing as another fixed-mode PMC.
  *
