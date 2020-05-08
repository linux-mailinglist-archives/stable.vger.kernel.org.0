Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02411CB007
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgEHNXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728361AbgEHMic (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4B4524972;
        Fri,  8 May 2020 12:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941511;
        bh=q5Ygbk+w548IQB/NYhh/aD57NKJMl1Z9hCS4bUAq8iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rwn4HBR/egYEly15Hr4MLNBzq4finn1LkhITh0RcKFBG80DhKi1+8Fa0fPGj1ALyS
         +3cs6kHKLuZLUU5QAsS7l4slrQnUoXDnuPgtAyR+uO+lOYlgr6IrUE2X6jQQuxIc59
         4LnSJztJKdmEB+dLvGUuReHJPFh6laEyP9WMkgFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 023/312] MIPS: perf: Fix I6400 event numbers
Date:   Fri,  8 May 2020 14:30:14 +0200
Message-Id: <20200508123126.121847455@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Hogan <james.hogan@imgtec.com>

commit fd716fca10fc3dc0f18b8c16d4ecfa6d93f010d2 upstream.

Fix perf hardware performance counter event numbers for I6400. This core
does not follow the performance event numbering scheme of previous MIPS
cores. All performance counters (both odd and even) are capable of
counting any of the available events.

Fixes: 4e88a8621301 ("MIPS: Add cases for CPU_I6400")
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Patchwork: https://patchwork.linux-mips.org/patch/13259/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/perf_event_mipsxx.c |   54 +++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -825,6 +825,16 @@ static const struct mips_perf_event mips
 	[PERF_COUNT_HW_BRANCH_MISSES] = { 0x27, CNTR_ODD, T },
 };
 
+static const struct mips_perf_event i6400_event_map[PERF_COUNT_HW_MAX] = {
+	[PERF_COUNT_HW_CPU_CYCLES]          = { 0x00, CNTR_EVEN | CNTR_ODD },
+	[PERF_COUNT_HW_INSTRUCTIONS]        = { 0x01, CNTR_EVEN | CNTR_ODD },
+	/* These only count dcache, not icache */
+	[PERF_COUNT_HW_CACHE_REFERENCES]    = { 0x45, CNTR_EVEN | CNTR_ODD },
+	[PERF_COUNT_HW_CACHE_MISSES]        = { 0x48, CNTR_EVEN | CNTR_ODD },
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = { 0x15, CNTR_EVEN | CNTR_ODD },
+	[PERF_COUNT_HW_BRANCH_MISSES]       = { 0x16, CNTR_EVEN | CNTR_ODD },
+};
+
 static const struct mips_perf_event loongson3_event_map[PERF_COUNT_HW_MAX] = {
 	[PERF_COUNT_HW_CPU_CYCLES] = { 0x00, CNTR_EVEN },
 	[PERF_COUNT_HW_INSTRUCTIONS] = { 0x00, CNTR_ODD },
@@ -1015,6 +1025,46 @@ static const struct mips_perf_event mips
 },
 };
 
+static const struct mips_perf_event i6400_cache_map
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] = {
+[C(L1D)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)]	= { 0x46, CNTR_EVEN | CNTR_ODD },
+		[C(RESULT_MISS)]	= { 0x49, CNTR_EVEN | CNTR_ODD },
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)]	= { 0x47, CNTR_EVEN | CNTR_ODD },
+		[C(RESULT_MISS)]	= { 0x4a, CNTR_EVEN | CNTR_ODD },
+	},
+},
+[C(L1I)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)]	= { 0x84, CNTR_EVEN | CNTR_ODD },
+		[C(RESULT_MISS)]	= { 0x85, CNTR_EVEN | CNTR_ODD },
+	},
+},
+[C(DTLB)] = {
+	/* Can't distinguish read & write */
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)]	= { 0x40, CNTR_EVEN | CNTR_ODD },
+		[C(RESULT_MISS)]	= { 0x41, CNTR_EVEN | CNTR_ODD },
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)]	= { 0x40, CNTR_EVEN | CNTR_ODD },
+		[C(RESULT_MISS)]	= { 0x41, CNTR_EVEN | CNTR_ODD },
+	},
+},
+[C(BPU)] = {
+	/* Conditional branches / mispredicted */
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)]	= { 0x15, CNTR_EVEN | CNTR_ODD },
+		[C(RESULT_MISS)]	= { 0x16, CNTR_EVEN | CNTR_ODD },
+	},
+},
+};
+
 static const struct mips_perf_event loongson3_cache_map
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -1720,8 +1770,8 @@ init_hw_perf_events(void)
 		break;
 	case CPU_I6400:
 		mipspmu.name = "mips/I6400";
-		mipspmu.general_event_map = &mipsxxcore_event_map2;
-		mipspmu.cache_event_map = &mipsxxcore_cache_map2;
+		mipspmu.general_event_map = &i6400_event_map;
+		mipspmu.cache_event_map = &i6400_cache_map;
 		break;
 	case CPU_1004K:
 		mipspmu.name = "mips/1004K";


