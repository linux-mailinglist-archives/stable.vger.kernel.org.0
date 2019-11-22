Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C55510635C
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbfKVGJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:09:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:34968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728874AbfKVF45 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:56:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 237252070A;
        Fri, 22 Nov 2019 05:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402216;
        bh=FN9DNkhjWE4bOqv/LD+u4tQ3YYJgjKGVp+RlCgJQZJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkPwLsFuTUDraMoD6A+zJf1C0KeugFZbZ9yOtaMwPTGzfNiwLQww9pxReT4EBBkF3
         xVih6CNznM4KgLnAT3rQv/TXolTU7AvY38cC2ZbC63ETP2fqZtQMwUE62twF2y/ZrL
         jXm/djnaRbVZYy8Kj7zWsrXq33fP4gFtb+nIVUl4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 064/127] powerpc/perf: Fix unit_sel/cache_sel checks
Date:   Fri, 22 Nov 2019 00:54:42 -0500
Message-Id: <20191122055544.3299-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>

[ Upstream commit 2d46d4877b1afd14059393a48bdb8ce27955174c ]

Raw event code has couple of fields "unit" and "cache" in it, to capture
the "unit" to monitor for a given pmcxsel and cache reload qualifier to
program in MMCR1.

isa207_get_constraint() refers "unit" field to update the MMCRC (L2/L3)
Event bus control fields with "cache" bits of the raw event code.
These are power8 specific and not supported by PowerISA v3.0 pmu. So wrap
the checks to be power8 specific. Also, "cache" bit field is referred to
update MMCR1[16:17] and this check can be power8 specific.

Fixes: 7ffd948fae4cd ('powerpc/perf: factor out power8 pmu functions')
Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/isa207-common.c | 25 ++++++++++++++++++-------
 arch/powerpc/perf/isa207-common.h |  4 ++--
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/perf/isa207-common.c b/arch/powerpc/perf/isa207-common.c
index cf9c35aa0cf45..7ecea7143e587 100644
--- a/arch/powerpc/perf/isa207-common.c
+++ b/arch/powerpc/perf/isa207-common.c
@@ -150,6 +150,14 @@ static bool is_thresh_cmp_valid(u64 event)
 	return true;
 }
 
+static unsigned int dc_ic_rld_quad_l1_sel(u64 event)
+{
+	unsigned int cache;
+
+	cache = (event >> EVENT_CACHE_SEL_SHIFT) & MMCR1_DC_IC_QUAL_MASK;
+	return cache;
+}
+
 static inline u64 isa207_find_source(u64 idx, u32 sub_idx)
 {
 	u64 ret = PERF_MEM_NA;
@@ -290,10 +298,10 @@ int isa207_get_constraint(u64 event, unsigned long *maskp, unsigned long *valp)
 		 * have a cache selector of zero. The bank selector (bit 3) is
 		 * irrelevant, as long as the rest of the value is 0.
 		 */
-		if (cache & 0x7)
+		if (!cpu_has_feature(CPU_FTR_ARCH_300) && (cache & 0x7))
 			return -1;
 
-	} else if (event & EVENT_IS_L1) {
+	} else if (cpu_has_feature(CPU_FTR_ARCH_300) || (event & EVENT_IS_L1)) {
 		mask  |= CNST_L1_QUAL_MASK;
 		value |= CNST_L1_QUAL_VAL(cache);
 	}
@@ -396,11 +404,14 @@ int isa207_compute_mmcr(u64 event[], int n_ev,
 		/* In continuous sampling mode, update SDAR on TLB miss */
 		mmcra_sdar_mode(event[i], &mmcra);
 
-		if (event[i] & EVENT_IS_L1) {
-			cache = event[i] >> EVENT_CACHE_SEL_SHIFT;
-			mmcr1 |= (cache & 1) << MMCR1_IC_QUAL_SHIFT;
-			cache >>= 1;
-			mmcr1 |= (cache & 1) << MMCR1_DC_QUAL_SHIFT;
+		if (cpu_has_feature(CPU_FTR_ARCH_300)) {
+			cache = dc_ic_rld_quad_l1_sel(event[i]);
+			mmcr1 |= (cache) << MMCR1_DC_IC_QUAL_SHIFT;
+		} else {
+			if (event[i] & EVENT_IS_L1) {
+				cache = dc_ic_rld_quad_l1_sel(event[i]);
+				mmcr1 |= (cache) << MMCR1_DC_IC_QUAL_SHIFT;
+			}
 		}
 
 		if (is_event_marked(event[i])) {
diff --git a/arch/powerpc/perf/isa207-common.h b/arch/powerpc/perf/isa207-common.h
index 6c737d675792e..493e5cc5fa8a6 100644
--- a/arch/powerpc/perf/isa207-common.h
+++ b/arch/powerpc/perf/isa207-common.h
@@ -232,8 +232,8 @@
 #define MMCR1_COMBINE_SHIFT(pmc)	(35 - ((pmc) - 1))
 #define MMCR1_PMCSEL_SHIFT(pmc)		(24 - (((pmc) - 1)) * 8)
 #define MMCR1_FAB_SHIFT			36
-#define MMCR1_DC_QUAL_SHIFT		47
-#define MMCR1_IC_QUAL_SHIFT		46
+#define MMCR1_DC_IC_QUAL_MASK		0x3
+#define MMCR1_DC_IC_QUAL_SHIFT		46
 
 /* MMCR1 Combine bits macro for power9 */
 #define p9_MMCR1_COMBINE_SHIFT(pmc)	(38 - ((pmc - 1) * 2))
-- 
2.20.1

