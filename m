Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE153ACEFA
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 17:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbhFRPcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 11:32:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:7103 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235285AbhFRPb2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 11:31:28 -0400
IronPort-SDR: MgQ5ZCxjNAFS7/vz0kphj771n7b1AugnoPbXZd2t75njCz+5yuxf4+pHRysSA6Ya93YmzjFJy4
 XAWNFhnIsu2Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="228099639"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="228099639"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 08:27:38 -0700
IronPort-SDR: r8HS9NGeR6AV/PCqnu0qtWuyQ4OrVqc1qFvOvO1v+K3Y7Cnl5BNYtJapsKTskIEujVzKl+tTia
 q9m/u86F77+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="405004810"
Received: from otc-lr-04.jf.intel.com ([10.54.39.41])
  by orsmga006.jf.intel.com with ESMTP; 18 Jun 2021 08:27:32 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     acme@kernel.org, jolsa@redhat.com, namhyung@kernel.org,
        ak@linux.intel.com, Kan Liang <kan.liang@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] perf/x86/intel: Add more events requires FRONTEND MSR on Sapphire Rapids
Date:   Fri, 18 Jun 2021 08:12:53 -0700
Message-Id: <1624029174-122219-3-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624029174-122219-1-git-send-email-kan.liang@linux.intel.com>
References: <1624029174-122219-1-git-send-email-kan.liang@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

On Sapphire Rapids, there are two more events 0x40ad and 0x04c2 which
rely on the FRONTEND MSR. If the FRONTEND MSR is not set correctly, the
count value is not correct.

Update intel_spr_extra_regs[] to support them.

Fixes: 61b985e3e775 ("perf/x86/intel: Add perf core PMU support for Sapphire Rapids")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index d39991b..e442b55 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -280,6 +280,8 @@ static struct extra_reg intel_spr_extra_regs[] __read_mostly = {
 	INTEL_UEVENT_EXTRA_REG(0x012b, MSR_OFFCORE_RSP_1, 0x3fffffffffull, RSP_1),
 	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
 	INTEL_UEVENT_EXTRA_REG(0x01c6, MSR_PEBS_FRONTEND, 0x7fff17, FE),
+	INTEL_UEVENT_EXTRA_REG(0x40ad, MSR_PEBS_FRONTEND, 0x7, FE),
+	INTEL_UEVENT_EXTRA_REG(0x04c2, MSR_PEBS_FRONTEND, 0x8, FE),
 	EVENT_EXTRA_END
 };
 
-- 
2.7.4

