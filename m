Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC0FB8454
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405505AbfISWJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405493AbfISWJz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:09:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B090F218AF;
        Thu, 19 Sep 2019 22:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930994;
        bh=TuQF33/lKNBJ+SLWKBz0W/EM/1TqEHgqJdvn2dmtTc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQLZwj/yemJZ2ZsP1kak4U1jHZaTZ8jJIX9ddflY6RxbcaZjWmHaTarHnZzeWcujv
         MFu0WKa3proUNHUk4wULOJdEo5oUqv2k71ZLE1TLaqEe99+fGnhd3dWSsNfPH8vcKa
         Wzvv0hV1j+6yrrB8421vAuGkrySgvCVZRxt815IM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>, x86@kernel.org,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Borislav Petkov" <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        "Namhyung Kim" <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 089/124] perf/x86/amd/ibs: Fix sample bias for dispatched micro-ops
Date:   Fri, 20 Sep 2019 00:02:57 +0200
Message-Id: <20190919214822.274687501@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 62f317c9113af..5b35b7ea5d728 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -661,10 +661,17 @@ fail:
 
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
index 1392d5e6e8d67..ee26e9215f187 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -252,16 +252,20 @@ struct pebs_lbr {
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



