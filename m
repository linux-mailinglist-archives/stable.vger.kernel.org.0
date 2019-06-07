Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33A7938F9C
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730798AbfFGPnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730805AbfFGPnP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:43:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69D7A2146F;
        Fri,  7 Jun 2019 15:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922194;
        bh=/PYpOuWtbavN9xB2JzD9aSkp9gW4QFJNMRvXyQgn8PE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZypwXPyY86jVdBqfsWcVk0fC7SKCiQwIxzlTx1vBkrQESbsMEfZjUJa3DM8xjKUD5
         w03AFQdUpuIwNdQokkiK+EsN68LyWWQWu7IbdsX4WOmAVDZiZN3189AQj2o5XEngnI
         ahcQqhb1rN2eaZs+J7uB2WCcjW8ksvf2BaQzi5lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 44/69] powerpc/perf: Fix MMCRA corruption by bhrb_filter
Date:   Fri,  7 Jun 2019 17:39:25 +0200
Message-Id: <20190607153853.820106294@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org # v3.10+
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Reviewed-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/perf/core-book3s.c |    6 ++++--
 arch/powerpc/perf/power8-pmu.c  |    3 +++
 arch/powerpc/perf/power9-pmu.c  |    3 +++
 3 files changed, 10 insertions(+), 2 deletions(-)

--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1845,6 +1845,7 @@ static int power_pmu_event_init(struct p
 	int n;
 	int err;
 	struct cpu_hw_events *cpuhw;
+	u64 bhrb_filter;
 
 	if (!ppmu)
 		return -ENOENT;
@@ -1941,13 +1942,14 @@ static int power_pmu_event_init(struct p
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
@@ -29,6 +29,7 @@ enum {
 #define	POWER8_MMCRA_IFM1		0x0000000040000000UL
 #define	POWER8_MMCRA_IFM2		0x0000000080000000UL
 #define	POWER8_MMCRA_IFM3		0x00000000C0000000UL
+#define	POWER8_MMCRA_BHRB_MASK		0x00000000C0000000UL
 
 /* PowerISA v2.07 format attribute structure*/
 extern struct attribute_group isa207_pmu_format_group;
@@ -179,6 +180,8 @@ static u64 power8_bhrb_filter_map(u64 br
 
 static void power8_config_bhrb(u64 pmu_bhrb_filter)
 {
+	pmu_bhrb_filter &= POWER8_MMCRA_BHRB_MASK;
+
 	/* Enable BHRB filter in PMU */
 	mtspr(SPRN_MMCRA, (mfspr(SPRN_MMCRA) | pmu_bhrb_filter));
 }
--- a/arch/powerpc/perf/power9-pmu.c
+++ b/arch/powerpc/perf/power9-pmu.c
@@ -100,6 +100,7 @@ enum {
 #define POWER9_MMCRA_IFM1		0x0000000040000000UL
 #define POWER9_MMCRA_IFM2		0x0000000080000000UL
 #define POWER9_MMCRA_IFM3		0x00000000C0000000UL
+#define POWER9_MMCRA_BHRB_MASK		0x00000000C0000000UL
 
 /* PowerISA v2.07 format attribute structure*/
 extern struct attribute_group isa207_pmu_format_group;
@@ -289,6 +290,8 @@ static u64 power9_bhrb_filter_map(u64 br
 
 static void power9_config_bhrb(u64 pmu_bhrb_filter)
 {
+	pmu_bhrb_filter &= POWER9_MMCRA_BHRB_MASK;
+
 	/* Enable BHRB filter in PMU */
 	mtspr(SPRN_MMCRA, (mfspr(SPRN_MMCRA) | pmu_bhrb_filter));
 }


