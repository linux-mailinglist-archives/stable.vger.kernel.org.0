Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4549F1C1278
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 14:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgEAM4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 08:56:04 -0400
Received: from mga04.intel.com ([192.55.52.120]:6076 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728443AbgEAM4E (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 08:56:04 -0400
IronPort-SDR: wsEfjivoHtQiaXrgPWugWUD2CEUEw6YaVlrcqgoBPHj7uUXy4fwG6sKgmG57jOiibH9DbcXDyC
 qiZHBDW373Yg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 05:56:03 -0700
IronPort-SDR: O1sHduvFuwfKtaL4uz4pw1IBSDCYH9a0CZOcFxZ+onPDZCl2PtAWDmbITI5Pah1hopL9FkkfJN
 zVv5v1bQqW/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,339,1583222400"; 
   d="scan'208";a="258606958"
Received: from ssp-jcv-cdi286.jf.intel.com ([10.54.39.33])
  by orsmga003.jf.intel.com with ESMTP; 01 May 2020 05:56:03 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     ak@linux.intel.com, eranian@google.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [RESEND PATCH] perf/x86/intel: Add more available bits for OFFCORE_RESPONSE of Intel Tremont
Date:   Fri,  1 May 2020 05:54:42 -0700
Message-Id: <20200501125442.7030-1-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

The mask in the extra_regs for Intel Tremont need to be extended to
allow more defined bits.

"Outstanding Requests" (bit 63) is only available on MSR_OFFCORE_RSP0;

Fixes: 6daeb8737f8a ("perf/x86/intel: Add Tremont core PMU support")
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 3be51aa06e67..ba08ad1f560b 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -1892,8 +1892,8 @@ static __initconst const u64 tnt_hw_cache_extra_regs
 
 static struct extra_reg intel_tnt_extra_regs[] __read_mostly = {
 	/* must define OFFCORE_RSP_X first, see intel_fixup_er() */
-	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0xffffff9fffull, RSP_0),
-	INTEL_UEVENT_EXTRA_REG(0x02b7, MSR_OFFCORE_RSP_1, 0xffffff9fffull, RSP_1),
+	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x800ff0ffffff9fffull, RSP_0),
+	INTEL_UEVENT_EXTRA_REG(0x02b7, MSR_OFFCORE_RSP_1, 0xff0ffffff9fffull, RSP_1),
 	EVENT_EXTRA_END
 };
 
-- 
2.21.1

