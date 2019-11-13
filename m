Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42633FB171
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 14:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKMNh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 08:37:29 -0500
Received: from mga07.intel.com ([134.134.136.100]:44270 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbfKMNh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Nov 2019 08:37:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2019 05:37:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,300,1569308400"; 
   d="scan'208";a="207452896"
Received: from otc-lr-04.jf.intel.com ([10.54.39.81])
  by orsmga003.jf.intel.com with ESMTP; 13 Nov 2019 05:37:27 -0800
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@kernel.org, sashal@kernel.org,
        gregkh@linuxfoundation.org, pavel@denx.de,
        linux-kernel@vger.kernel.org
Cc:     ak@linux.intel.com, alexander.shishkin@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH] perf/x86/uncore: Remove unnecessary check for uncore_pmu
Date:   Wed, 13 Nov 2019 05:35:02 -0800
Message-Id: <1573652102-131731-1-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

The uncore_pmu pointer in uncore_pmu_enable/disable() is from
container_of, which never be NULL.

Remove the unnecessary check for uncore_pmu.

Fixes: 75be6f703a14 ("perf/x86/uncore: Fix event group support")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/uncore.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index 86467f8..81eed07 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -780,9 +780,6 @@ static void uncore_pmu_enable(struct pmu *pmu)
 	struct intel_uncore_box *box;
 
 	uncore_pmu = container_of(pmu, struct intel_uncore_pmu, pmu);
-	if (!uncore_pmu)
-		return;
-
 	box = uncore_pmu_to_box(uncore_pmu, smp_processor_id());
 	if (!box)
 		return;
@@ -797,9 +794,6 @@ static void uncore_pmu_disable(struct pmu *pmu)
 	struct intel_uncore_box *box;
 
 	uncore_pmu = container_of(pmu, struct intel_uncore_pmu, pmu);
-	if (!uncore_pmu)
-		return;
-
 	box = uncore_pmu_to_box(uncore_pmu, smp_processor_id());
 	if (!box)
 		return;
-- 
2.7.4

