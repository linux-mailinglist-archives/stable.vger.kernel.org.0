Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71A4114E5A
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbfEFOl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbfEFOl5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:41:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDC2C21019;
        Mon,  6 May 2019 14:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153716;
        bh=K/eYivXf82GFX2kf6Z4VYFuRzs72z3s89WK5qdBB9is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iehFyW2L/Cs2KhHTOxq/Y1+BOFBKmezET37XdQP027FXA7lKFVVTtGq8+Z+AoqOzD
         LS08as53HxJHjc8fUqKgUW2OsEVYB4XyK5MhEaDWUhorFxk89ZA2gDgP7nmhTh8sjf
         XOc80VIjaVDsF1Cruq+AEstvJlrivjVqRHZAj9mQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?q?Martin=20Li=C5=A1ka?= <mliska@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Pu Wen <puwen@hygon.cn>,
        Stephane Eranian <eranian@google.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        linux-perf-users@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.19 70/99] perf/x86/amd: Update generic hardware cache events for Family 17h
Date:   Mon,  6 May 2019 16:32:43 +0200
Message-Id: <20190506143100.497749258@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

commit 0e3b74e26280f2cf8753717a950b97d424da6046 upstream.

Add a new amd_hw_cache_event_ids_f17h assignment structure set
for AMD families 17h and above, since a lot has changed.  Specifically:

L1 Data Cache

The data cache access counter remains the same on Family 17h.

For DC misses, PMCx041's definition changes with Family 17h,
so instead we use the L2 cache accesses from L1 data cache
misses counter (PMCx060,umask=0xc8).

For DC hardware prefetch events, Family 17h breaks compatibility
for PMCx067 "Data Prefetcher", so instead, we use PMCx05a "Hardware
Prefetch DC Fills."

L1 Instruction Cache

PMCs 0x80 and 0x81 (32-byte IC fetches and misses) are backward
compatible on Family 17h.

For prefetches, we remove the erroneous PMCx04B assignment which
counts how many software data cache prefetch load instructions were
dispatched.

LL - Last Level Cache

Removing PMCs 7D, 7E, and 7F assignments, as they do not exist
on Family 17h, where the last level cache is L3.  L3 counters
can be accessed using the existing AMD Uncore driver.

Data TLB

On Intel machines, data TLB accesses ("dTLB-loads") are assigned
to counters that count load/store instructions retired.  This
is inconsistent with instruction TLB accesses, where Intel
implementations report iTLB misses that hit in the STLB.

Ideally, dTLB-loads would count higher level dTLB misses that hit
in lower level TLBs, and dTLB-load-misses would report those
that also missed in those lower-level TLBs, therefore causing
a page table walk.  That would be consistent with instruction
TLB operation, remove the redundancy between dTLB-loads and
L1-dcache-loads, and prevent perf from producing artificially
low percentage ratios, i.e. the "0.01%" below:

        42,550,869      L1-dcache-loads
        41,591,860      dTLB-loads
             4,802      dTLB-load-misses          #    0.01% of all dTLB cache hits
         7,283,682      L1-dcache-stores
         7,912,392      dTLB-stores
               310      dTLB-store-misses

On AMD Families prior to 17h, the "Data Cache Accesses" counter is
used, which is slightly better than load/store instructions retired,
but still counts in terms of individual load/store operations
instead of TLB operations.

So, for AMD Families 17h and higher, this patch assigns "dTLB-loads"
to a counter for L1 dTLB misses that hit in the L2 dTLB, and
"dTLB-load-misses" to a counter for L1 DTLB misses that caused
L2 DTLB misses and therefore also caused page table walks.  This
results in a much more accurate view of data TLB performance:

        60,961,781      L1-dcache-loads
             4,601      dTLB-loads
               963      dTLB-load-misses          #   20.93% of all dTLB cache hits

Note that for all AMD families, data loads and stores are combined
in a single accesses counter, so no 'L1-dcache-stores' are reported
separately, and stores are counted with loads in 'L1-dcache-loads'.

Also note that the "% of all dTLB cache hits" string is misleading
because (a) "dTLB cache": although TLBs can be considered caches for
page tables, in this context, it can be misinterpreted as data cache
hits because the figures are similar (at least on Intel), and (b) not
all those loads (technically accesses) technically "hit" at that
hardware level.  "% of all dTLB accesses" would be more clear/accurate.

Instruction TLB

On Intel machines, 'iTLB-loads' measure iTLB misses that hit in the
STLB, and 'iTLB-load-misses' measure iTLB misses that also missed in
the STLB and completed a page table walk.

For AMD Family 17h and above, for 'iTLB-loads' we replace the
erroneous instruction cache fetches counter with PMCx084
"L1 ITLB Miss, L2 ITLB Hit".

For 'iTLB-load-misses' we still use PMCx085 "L1 ITLB Miss,
L2 ITLB Miss", but set a 0xff umask because without it the event
does not get counted.

Branch Predictor (BPU)

PMCs 0xc2 and 0xc3 continue to be valid across all AMD Families.

Node Level Events

Family 17h does not have a PMCx0e9 counter, and corresponding counters
have not been made available publicly, so for now, we mark them as
unsupported for Families 17h and above.

Reference:

  "Open-Source Register Reference For AMD Family 17h Processors Models 00h-2Fh"
  Released 7/17/2018, Publication #56255, Revision 3.03:
  https://www.amd.com/system/files/TechDocs/56255_OSRR.pdf

[ mingo: tidied up the line breaks. ]
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Cc: <stable@vger.kernel.org> # v4.9+
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Liška <mliska@suse.cz>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pu Wen <puwen@hygon.cn>
Cc: Stephane Eranian <eranian@google.com>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Lendacky <Thomas.Lendacky@amd.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org
Cc: linux-perf-users@vger.kernel.org
Fixes: e40ed1542dd7 ("perf/x86: Add perf support for AMD family-17h processors")
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/amd/core.c |  111 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 108 insertions(+), 3 deletions(-)

--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -116,6 +116,110 @@ static __initconst const u64 amd_hw_cach
  },
 };
 
+static __initconst const u64 amd_hw_cache_event_ids_f17h
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] = {
+[C(L1D)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)] = 0x0040, /* Data Cache Accesses */
+		[C(RESULT_MISS)]   = 0xc860, /* L2$ access from DC Miss */
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)] = 0,
+		[C(RESULT_MISS)]   = 0,
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)] = 0xff5a, /* h/w prefetch DC Fills */
+		[C(RESULT_MISS)]   = 0,
+	},
+},
+[C(L1I)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)] = 0x0080, /* Instruction cache fetches  */
+		[C(RESULT_MISS)]   = 0x0081, /* Instruction cache misses   */
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)] = -1,
+		[C(RESULT_MISS)]   = -1,
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)] = 0,
+		[C(RESULT_MISS)]   = 0,
+	},
+},
+[C(LL)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)] = 0,
+		[C(RESULT_MISS)]   = 0,
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)] = 0,
+		[C(RESULT_MISS)]   = 0,
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)] = 0,
+		[C(RESULT_MISS)]   = 0,
+	},
+},
+[C(DTLB)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)] = 0xff45, /* All L2 DTLB accesses */
+		[C(RESULT_MISS)]   = 0xf045, /* L2 DTLB misses (PT walks) */
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)] = 0,
+		[C(RESULT_MISS)]   = 0,
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)] = 0,
+		[C(RESULT_MISS)]   = 0,
+	},
+},
+[C(ITLB)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)] = 0x0084, /* L1 ITLB misses, L2 ITLB hits */
+		[C(RESULT_MISS)]   = 0xff85, /* L1 ITLB misses, L2 misses */
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)] = -1,
+		[C(RESULT_MISS)]   = -1,
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)] = -1,
+		[C(RESULT_MISS)]   = -1,
+	},
+},
+[C(BPU)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)] = 0x00c2, /* Retired Branch Instr.      */
+		[C(RESULT_MISS)]   = 0x00c3, /* Retired Mispredicted BI    */
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)] = -1,
+		[C(RESULT_MISS)]   = -1,
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)] = -1,
+		[C(RESULT_MISS)]   = -1,
+	},
+},
+[C(NODE)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)] = 0,
+		[C(RESULT_MISS)]   = 0,
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)] = -1,
+		[C(RESULT_MISS)]   = -1,
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)] = -1,
+		[C(RESULT_MISS)]   = -1,
+	},
+},
+};
+
 /*
  * AMD Performance Monitor K7 and later, up to and including Family 16h:
  */
@@ -861,9 +965,10 @@ __init int amd_pmu_init(void)
 		x86_pmu.amd_nb_constraints = 0;
 	}
 
-	/* Events are common for all AMDs */
-	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
-	       sizeof(hw_cache_event_ids));
+	if (boot_cpu_data.x86 >= 0x17)
+		memcpy(hw_cache_event_ids, amd_hw_cache_event_ids_f17h, sizeof(hw_cache_event_ids));
+	else
+		memcpy(hw_cache_event_ids, amd_hw_cache_event_ids, sizeof(hw_cache_event_ids));
 
 	return 0;
 }


