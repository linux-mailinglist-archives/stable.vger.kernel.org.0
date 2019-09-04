Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A42AA8C1C
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731900AbfIDQJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732333AbfIDQBK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:01:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 542B422CF7;
        Wed,  4 Sep 2019 16:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612869;
        bh=lHR3gyrMAoaukK9jVDCg6YIyjmbNl/t33FQ9zXEqsQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fHE+VterwEf0tLRdOMriizIWE+JELQ0qPepAcUMw8huZl9cKpvarPJtOJDeMZadD3
         ENDT4IHZrXbxl+htC2Upp3kOKAe/aWDYkU8ICoD2r6lxRgHQ8LTZctetMmeAw9v24f
         9cHbPFSJNLD8Ze2ezfY+XYrt1GT3mdINlHQtPGKY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kim Phillips <kim.phillips@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>, x86@kernel.org,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Borislav Petkov" <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        "Namhyung Kim" <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 45/52] perf/x86/amd/ibs: Fix sample bias for dispatched micro-ops
Date:   Wed,  4 Sep 2019 11:59:57 -0400
Message-Id: <20190904160004.3671-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160004.3671-1-sashal@kernel.org>
References: <20190904160004.3671-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

[ Upstream commit 0f4cd769c410e2285a4e9873a684d90423f03090 ]

When counting dispatched micro-ops with cnt_ctl=1, in order to prevent
sample bias, IBS hardware preloads the least significant 7 bits of
current count (IbsOpCurCnt) with random values, such that, after the
interrupt is handled and counting resumes, the next sample taken
will be slightly perturbed.

The current count bitfield is in the IBS execution control h/w register,
alongside the maximum count field.

Currently, the IBS driver writes that register with the maximum count,
leaving zeroes to fill the current count field, thereby overwriting
the random bits the hardware preloaded for itself.

Fix the driver to actually retain and carry those random bits from the
read of the IBS control register, through to its write, instead of
overwriting the lower current count bits with zeroes.

Tested with:

perf record -c 100001 -e ibs_op/cnt_ctl=1/pp -a -C 0 taskset -c 0 <workload>

'perf annotate' output before:

 15.70  65:   addsd     %xmm0,%xmm1
 17.30        add       $0x1,%rax
 15.88        cmp       %rdx,%rax
              je        82
 17.32  72:   test      $0x1,%al
              jne       7c
  7.52        movapd    %xmm1,%xmm0
  5.90        jmp       65
  8.23  7c:   sqrtsd    %xmm1,%xmm0
 12.15        jmp       65

'perf annotate' output after:

 16.63  65:   addsd     %xmm0,%xmm1
 16.82        add       $0x1,%rax
 16.81        cmp       %rdx,%rax
              je        82
 16.69  72:   test      $0x1,%al
              jne       7c
  8.30        movapd    %xmm1,%xmm0
  8.13        jmp       65
  8.24  7c:   sqrtsd    %xmm1,%xmm0
  8.39        jmp       65

Tested on Family 15h and 17h machines.

Machines prior to family 10h Rev. C don't have the RDWROPCNT capability,
and have the IbsOpCurCnt bitfield reserved, so this patch shouldn't
affect their operation.

It is unknown why commit db98c5faf8cb ("perf/x86: Implement 64-bit
counter support for IBS") ignored the lower 4 bits of the IbsOpCurCnt
field; the number of preloaded random bits has always been 7, AFAICT.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Arnaldo Carvalho de Melo" <acme@kernel.org>
Cc: <x86@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Borislav Petkov" <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: "Namhyung Kim" <namhyung@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: https://lkml.kernel.org/r/20190826195730.30614-1-kim.phillips@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/ibs.c         | 13 ++++++++++---
 arch/x86/include/asm/perf_event.h | 12 ++++++++----
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index d50bb4dc06503..80c6d84cad67b 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -672,10 +672,17 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 
 	throttle = perf_event_overflow(event, &data, &regs);
 out:
-	if (throttle)
+	if (throttle) {
 		perf_ibs_stop(event, 0);
-	else
-		perf_ibs_enable_event(perf_ibs, hwc, period >> 4);
+	} else {
+		period >>= 4;
+
+		if ((ibs_caps & IBS_CAPS_RDWROPCNT) &&
+		    (*config & IBS_OP_CNT_CTL))
+			period |= *config & IBS_OP_CUR_CNT_RAND;
+
+		perf_ibs_enable_event(perf_ibs, hwc, period);
+	}
 
 	perf_event_update_userpage(event);
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 78241b736f2a0..f6c4915a863e0 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -209,16 +209,20 @@ struct x86_pmu_capability {
 #define IBSCTL_LVT_OFFSET_VALID		(1ULL<<8)
 #define IBSCTL_LVT_OFFSET_MASK		0x0F
 
-/* ibs fetch bits/masks */
+/* IBS fetch bits/masks */
 #define IBS_FETCH_RAND_EN	(1ULL<<57)
 #define IBS_FETCH_VAL		(1ULL<<49)
 #define IBS_FETCH_ENABLE	(1ULL<<48)
 #define IBS_FETCH_CNT		0xFFFF0000ULL
 #define IBS_FETCH_MAX_CNT	0x0000FFFFULL
 
-/* ibs op bits/masks */
-/* lower 4 bits of the current count are ignored: */
-#define IBS_OP_CUR_CNT		(0xFFFF0ULL<<32)
+/*
+ * IBS op bits/masks
+ * The lower 7 bits of the current count are random bits
+ * preloaded by hardware and ignored in software
+ */
+#define IBS_OP_CUR_CNT		(0xFFF80ULL<<32)
+#define IBS_OP_CUR_CNT_RAND	(0x0007FULL<<32)
 #define IBS_OP_CNT_CTL		(1ULL<<19)
 #define IBS_OP_VAL		(1ULL<<18)
 #define IBS_OP_ENABLE		(1ULL<<17)
-- 
2.20.1

