Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A64D3F8B26
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 17:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242975AbhHZPgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 11:36:50 -0400
Received: from mga05.intel.com ([192.55.52.43]:41889 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242939AbhHZPgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 11:36:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="303345475"
X-IronPort-AV: E=Sophos;i="5.84,353,1620716400"; 
   d="scan'208";a="303345475"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 08:36:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,353,1620716400"; 
   d="scan'208";a="426824698"
Received: from otc-lr-04.jf.intel.com ([10.54.39.41])
  by orsmga003.jf.intel.com with ESMTP; 26 Aug 2021 08:36:02 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     eranian@google.com, ak@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 2/7] perf/x86/intel/uncore: Fix invalid unit check
Date:   Thu, 26 Aug 2021 08:32:38 -0700
Message-Id: <1629991963-102621-3-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629991963-102621-1-git-send-email-kan.liang@linux.intel.com>
References: <1629991963-102621-1-git-send-email-kan.liang@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

The uncore unit with the type ID 0 and the unit ID 0 is missed.

The table3 of the uncore unit maybe 0. The
uncore_discovery_invalid_unit() mistakenly treated it as an invalid
value.

Remove the !unit.table3 check.

Fixes: edae1f06c2cd ("perf/x86/intel/uncore: Parse uncore discovery tables")
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---

The patch was posted as a part of the "perf: Add Sapphire Rapids server
uncore support" patch set. But it doesn't depend on the other patches in
the patch set. The bugfix can be accepted and merged separately. 

https://lore.kernel.org/lkml/cb0d2d43-102a-994c-f777-e11d61c77bf5@linux.intel.com/

 arch/x86/events/intel/uncore_discovery.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_discovery.h b/arch/x86/events/intel/uncore_discovery.h
index 7280c8a..6d735611 100644
--- a/arch/x86/events/intel/uncore_discovery.h
+++ b/arch/x86/events/intel/uncore_discovery.h
@@ -30,7 +30,7 @@
 
 
 #define uncore_discovery_invalid_unit(unit)			\
-	(!unit.table1 || !unit.ctl || !unit.table3 ||	\
+	(!unit.table1 || !unit.ctl || \
 	 unit.table1 == -1ULL || unit.ctl == -1ULL ||	\
 	 unit.table3 == -1ULL)
 
-- 
2.7.4

