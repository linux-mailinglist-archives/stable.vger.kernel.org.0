Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C895DC91F9
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbfJBTNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:13:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35378 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729097AbfJBTIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:10 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyn-00035W-QK; Wed, 02 Oct 2019 20:08:05 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyn-0003az-A6; Wed, 02 Oct 2019 20:08:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Madhavan Srinivasan" <maddy@linux.vnet.ibm.com>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Ravi Bangoria" <ravi.bangoria@linux.ibm.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.890916317@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 15/87] powerpc/perf: Fix MMCRA corruption by bhrb_filter
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

commit 3202e35ec1c8fc19cea24253ff83edf702a60a02 upstream.

Consider a scenario where user creates two events:

  1st event:
    attr.sample_type |= PERF_SAMPLE_BRANCH_STACK;
    attr.branch_sample_type = PERF_SAMPLE_BRANCH_ANY;
    fd = perf_event_open(attr, 0, 1, -1, 0);

  This sets cpuhw->bhrb_filter to 0 and returns valid fd.

  2nd event:
    attr.sample_type |= PERF_SAMPLE_BRANCH_STACK;
    attr.branch_sample_type = PERF_SAMPLE_BRANCH_CALL;
    fd = perf_event_open(attr, 0, 1, -1, 0);

  It overrides cpuhw->bhrb_filter to -1 and returns with error.

Now if power_pmu_enable() gets called by any path other than
power_pmu_add(), ppmu->config_bhrb(-1) will set MMCRA to -1.

Fixes: 3925f46bb590 ("powerpc/perf: Enable branch stack sampling framework")
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Reviewed-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
[bwh: Backported to 3.16: drop changes in power9-pmu.c]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1726,6 +1726,7 @@ static int power_pmu_event_init(struct p
 	int n;
 	int err;
 	struct cpu_hw_events *cpuhw;
+	u64 bhrb_filter;
 
 	if (!ppmu)
 		return -ENOENT;
@@ -1822,13 +1823,14 @@ static int power_pmu_event_init(struct p
 	err = power_check_constraints(cpuhw, events, cflags, n + 1);
 
 	if (has_branch_stack(event)) {
-		cpuhw->bhrb_filter = ppmu->bhrb_filter_map(
+		bhrb_filter = ppmu->bhrb_filter_map(
 					event->attr.branch_sample_type);
 
-		if (cpuhw->bhrb_filter == -1) {
+		if (bhrb_filter == -1) {
 			put_cpu_var(cpu_hw_events);
 			return -EOPNOTSUPP;
 		}
+		cpuhw->bhrb_filter = bhrb_filter;
 	}
 
 	put_cpu_var(cpu_hw_events);
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -175,6 +175,7 @@
 #define	POWER8_MMCRA_IFM1		0x0000000040000000UL
 #define	POWER8_MMCRA_IFM2		0x0000000080000000UL
 #define	POWER8_MMCRA_IFM3		0x00000000C0000000UL
+#define	POWER8_MMCRA_BHRB_MASK		0x00000000C0000000UL
 
 #define ONLY_PLM \
 	(PERF_SAMPLE_BRANCH_USER        |\
@@ -666,6 +667,8 @@ static u64 power8_bhrb_filter_map(u64 br
 
 static void power8_config_bhrb(u64 pmu_bhrb_filter)
 {
+	pmu_bhrb_filter &= POWER8_MMCRA_BHRB_MASK;
+
 	/* Enable BHRB filter in PMU */
 	mtspr(SPRN_MMCRA, (mfspr(SPRN_MMCRA) | pmu_bhrb_filter));
 }

