Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1532C4A28
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 22:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732586AbgKYViw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 16:38:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:15611 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731952AbgKYViv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 16:38:51 -0500
IronPort-SDR: 8KFyL92giCb7xdyAv2AQJDqmyAJ0vE8U0o0LF9DjJMdhhIfXmSbdw9U4/aAV5PfrfGcgKrxLwj
 w0vGvaiOFocw==
X-IronPort-AV: E=McAfee;i="6000,8403,9816"; a="159250094"
X-IronPort-AV: E=Sophos;i="5.78,370,1599548400"; 
   d="scan'208";a="159250094"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2020 13:38:51 -0800
IronPort-SDR: xAkW4EEbAfuQ9dG7CkDWRIPjjDpdTwtK3L8AxhmN63GBd2sH650dYHwK/k0sqiV+ZEWQLiAlX8
 vkx/db1hkcpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,370,1599548400"; 
   d="scan'208";a="365579848"
Received: from unknown (HELO labuser-Ice-Lake-Client-Platform.jf.intel.com) ([10.54.55.65])
  by fmsmga002.fm.intel.com with ESMTP; 25 Nov 2020 13:38:51 -0800
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     eranian@google.com, ak@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] perf/x86/intel/lbr: Fix the return type of get_lbr_cycles()
Date:   Wed, 25 Nov 2020 13:37:20 -0800
Message-Id: <20201125213720.15692-2-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201125213720.15692-1-kan.liang@linux.intel.com>
References: <20201125213720.15692-1-kan.liang@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

The cycle count of a timed LBR is always 1 in perf record -D.

The cycle count is stored in the first 16 bits of the IA32_LBR_x_INFO
register, but the get_lbr_cycles() return Boolean type.

Use u16 to replace the Boolean type.

Fixes: 47125db27e47 ("perf/x86/intel/lbr: Support Architectural LBR")
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/lbr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 1aadb253d296..21890dacfcfe 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -919,7 +919,7 @@ static __always_inline bool get_lbr_predicted(u64 info)
 	return !(info & LBR_INFO_MISPRED);
 }
 
-static __always_inline bool get_lbr_cycles(u64 info)
+static __always_inline u16 get_lbr_cycles(u64 info)
 {
 	if (static_cpu_has(X86_FEATURE_ARCH_LBR) &&
 	    !(x86_pmu.lbr_timed_lbr && info & LBR_INFO_CYC_CNT_VALID))
-- 
2.17.1

