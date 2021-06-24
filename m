Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B3E3B2497
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 03:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhFXBj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 21:39:29 -0400
Received: from mga17.intel.com ([192.55.52.151]:8667 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230073AbhFXBjY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 21:39:24 -0400
IronPort-SDR: ACeMn9Q5keVvZ8GDXirNaBFpB4JCrVjLiO3jOV4xVGREiUW7VIyzdQDM+o4hu/WY7KOujsLHc5
 QroIMRrKM9/Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="187757008"
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="187757008"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 18:37:06 -0700
IronPort-SDR: /prgj+bOua6hpWNlY0xsQht/knDxpSKZPknnLggEf1HlP7WTcgJL5G64yZxwzFRnYbI6ZfwKOL
 tDNUGkTEpUZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="490928501"
Received: from otc-lr-04.jf.intel.com ([10.54.39.41])
  by fmsmga002.fm.intel.com with ESMTP; 23 Jun 2021 18:37:05 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     eranian@google.com, namhyung@kernel.org, acme@kernel.org,
        jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 7/7] perf/x86/intel/uncore: Fix invalid unit check
Date:   Wed, 23 Jun 2021 18:22:09 -0700
Message-Id: <1624497729-158864-8-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624497729-158864-1-git-send-email-kan.liang@linux.intel.com>
References: <1624497729-158864-1-git-send-email-kan.liang@linux.intel.com>
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

