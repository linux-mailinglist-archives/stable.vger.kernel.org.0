Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632992E40F6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440317AbgL1OOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:14:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:47866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440312AbgL1OOD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:14:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 153072063A;
        Mon, 28 Dec 2020 14:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164827;
        bh=0Xx3W/NvxGwP3VY3b5ZTXyDM0VIJqqbXCGWGIKUJuTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vdY8yhhJZUJm8nF7Bt6SuWslRRx6FC6ZVNtIMb4XWYTah1fghhlpbzxWkJE4WYJ2
         Ri44iuzRVJTe9p6y8kxTFMSodbdulvzmv9h/R8JkIkRn3KhKoiYekymC/fTzh0o+i0
         eqXkMEMyZcahqkozxbKOJRZfHnhJSsO4fjYz8mWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 282/717] powerpc/perf: Fix to update radix_scope_qual in power10
Date:   Mon, 28 Dec 2020 13:44:40 +0100
Message-Id: <20201228125034.538118348@linuxfoundation.org>
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

[ Upstream commit d3afd28cd2f35b2a1046b76e0cf010b684da2e84 ]

power10 uses bit 9 of the raw event code as RADIX_SCOPE_QUAL.
This bit is used for enabling the radix process events.
Patch fixes the PMU counter support functions to program bit
18 of MMCR1 ( Monitor Mode Control Register1 ) with the
RADIX_SCOPE_QUAL bit value. Since this field is not per-pmc,
add this to PMU group constraints to make sure events in a
group will have same bit value for this field. Use bit 21 as
constraint bit field for radix_scope_qual. Patch also updates
the power10 raw event encoding layout information, format field
and constraints bit layout to include the radix_scope_qual bit.

Fixes: a64e697cef23 ("powerpc/perf: power10 Performance Monitoring support")
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1606409684-1589-2-git-send-email-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/isa207-common.c | 12 ++++++++++++
 arch/powerpc/perf/isa207-common.h | 13 ++++++++++---
 arch/powerpc/perf/power10-pmu.c   | 11 +++++++----
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/perf/isa207-common.c b/arch/powerpc/perf/isa207-common.c
index 2848904df6383..f57f54f92c10f 100644
--- a/arch/powerpc/perf/isa207-common.c
+++ b/arch/powerpc/perf/isa207-common.c
@@ -339,6 +339,11 @@ int isa207_get_constraint(u64 event, unsigned long *maskp, unsigned long *valp)
 		value |= CNST_L1_QUAL_VAL(cache);
 	}
 
+	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+		mask |= CNST_RADIX_SCOPE_GROUP_MASK;
+		value |= CNST_RADIX_SCOPE_GROUP_VAL(event >> p10_EVENT_RADIX_SCOPE_QUAL_SHIFT);
+	}
+
 	if (is_event_marked(event)) {
 		mask  |= CNST_SAMPLE_MASK;
 		value |= CNST_SAMPLE_VAL(event >> EVENT_SAMPLE_SHIFT);
@@ -456,6 +461,13 @@ int isa207_compute_mmcr(u64 event[], int n_ev,
 			}
 		}
 
+		/* Set RADIX_SCOPE_QUAL bit */
+		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+			val = (event[i] >> p10_EVENT_RADIX_SCOPE_QUAL_SHIFT) &
+				p10_EVENT_RADIX_SCOPE_QUAL_MASK;
+			mmcr1 |= val << p10_MMCR1_RADIX_SCOPE_QUAL_SHIFT;
+		}
+
 		if (is_event_marked(event[i])) {
 			mmcra |= MMCRA_SAMPLE_ENABLE;
 
diff --git a/arch/powerpc/perf/isa207-common.h b/arch/powerpc/perf/isa207-common.h
index 7025de5e60e7d..dc9c3d22fb38d 100644
--- a/arch/powerpc/perf/isa207-common.h
+++ b/arch/powerpc/perf/isa207-common.h
@@ -101,6 +101,9 @@
 #define p10_EVENT_CACHE_SEL_MASK	0x3ull
 #define p10_EVENT_MMCR3_MASK		0x7fffull
 #define p10_EVENT_MMCR3_SHIFT		45
+#define p10_EVENT_RADIX_SCOPE_QUAL_SHIFT	9
+#define p10_EVENT_RADIX_SCOPE_QUAL_MASK	0x1
+#define p10_MMCR1_RADIX_SCOPE_QUAL_SHIFT	45
 
 #define p10_EVENT_VALID_MASK		\
 	((p10_SDAR_MODE_MASK   << p10_SDAR_MODE_SHIFT		|	\
@@ -112,6 +115,7 @@
 	(p9_EVENT_COMBINE_MASK << p9_EVENT_COMBINE_SHIFT)	|	\
 	(p10_EVENT_MMCR3_MASK  << p10_EVENT_MMCR3_SHIFT)	|	\
 	(EVENT_MARKED_MASK     << EVENT_MARKED_SHIFT)		|	\
+	(p10_EVENT_RADIX_SCOPE_QUAL_MASK << p10_EVENT_RADIX_SCOPE_QUAL_SHIFT)	|	\
 	 EVENT_LINUX_MASK					|	\
 	EVENT_PSEL_MASK))
 /*
@@ -125,9 +129,9 @@
  *
  *        28        24        20        16        12         8         4         0
  * | - - - - | - - - - | - - - - | - - - - | - - - - | - - - - | - - - - | - - - - |
- *               [ ] |   [ ]   [  sample ]   [     ]   [6] [5]   [4] [3]   [2] [1]
- *                |  |    |                     |
- *      BHRB IFM -*  |    |                     |      Count of events for each PMC.
+ *               [ ] |   [ ] |  [  sample ]   [     ]   [6] [5]   [4] [3]   [2] [1]
+ *                |  |    |  |                  |
+ *      BHRB IFM -*  |    |  |*radix_scope      |      Count of events for each PMC.
  *              EBB -*    |                     |        p1, p2, p3, p4, p5, p6.
  *      L1 I/D qualifier -*                     |
  *                     nc - number of counters -*
@@ -165,6 +169,9 @@
 #define CNST_L2L3_GROUP_VAL(v)	(((v) & 0x1full) << 55)
 #define CNST_L2L3_GROUP_MASK	CNST_L2L3_GROUP_VAL(0x1f)
 
+#define CNST_RADIX_SCOPE_GROUP_VAL(v)	(((v) & 0x1ull) << 21)
+#define CNST_RADIX_SCOPE_GROUP_MASK	CNST_RADIX_SCOPE_GROUP_VAL(1)
+
 /*
  * For NC we are counting up to 4 events. This requires three bits, and we need
  * the fifth event to overflow and set the 4th bit. To achieve that we bias the
diff --git a/arch/powerpc/perf/power10-pmu.c b/arch/powerpc/perf/power10-pmu.c
index 9dbe8f9b89b4f..cf44fb7446130 100644
--- a/arch/powerpc/perf/power10-pmu.c
+++ b/arch/powerpc/perf/power10-pmu.c
@@ -23,10 +23,10 @@
  *
  *        28        24        20        16        12         8         4         0
  * | - - - - | - - - - | - - - - | - - - - | - - - - | - - - - | - - - - | - - - - |
- *   [   ] [  sample ]   [ ] [ ]   [ pmc ]   [unit ]   [ ]   m   [    pmcxsel    ]
- *     |        |        |    |                        |     |
- *     |        |        |    |                        |     *- mark
- *     |        |        |    *- L1/L2/L3 cache_sel    |
+ *   [   ] [  sample ]   [ ] [ ]   [ pmc ]   [unit ]   [ ] |  m   [    pmcxsel    ]
+ *     |        |        |    |                        |   |  |
+ *     |        |        |    |                        |   |  *- mark
+ *     |        |        |    *- L1/L2/L3 cache_sel    |   |*-radix_scope_qual
  *     |        |        sdar_mode                     |
  *     |        *- sampling mode for marked events     *- combine
  *     |
@@ -59,6 +59,7 @@
  *
  * MMCR1[16] = cache_sel[0]
  * MMCR1[17] = cache_sel[1]
+ * MMCR1[18] = radix_scope_qual
  *
  * if mark:
  *	MMCRA[63]    = 1		(SAMPLE_ENABLE)
@@ -175,6 +176,7 @@ PMU_FORMAT_ATTR(src_sel,        "config:45-46");
 PMU_FORMAT_ATTR(invert_bit,     "config:47");
 PMU_FORMAT_ATTR(src_mask,       "config:48-53");
 PMU_FORMAT_ATTR(src_match,      "config:54-59");
+PMU_FORMAT_ATTR(radix_scope,	"config:9");
 
 static struct attribute *power10_pmu_format_attr[] = {
 	&format_attr_event.attr,
@@ -194,6 +196,7 @@ static struct attribute *power10_pmu_format_attr[] = {
 	&format_attr_invert_bit.attr,
 	&format_attr_src_mask.attr,
 	&format_attr_src_match.attr,
+	&format_attr_radix_scope.attr,
 	NULL,
 };
 
-- 
2.27.0



