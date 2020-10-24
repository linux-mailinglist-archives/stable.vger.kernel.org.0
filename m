Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53EF297D75
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 18:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760388AbgJXQ1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 12:27:49 -0400
Received: from mga18.intel.com ([134.134.136.126]:49816 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760111AbgJXQ1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Oct 2020 12:27:48 -0400
IronPort-SDR: GB9ympbJs4IqkzUlPd+XTSG5YdzL9rP7rELDxZZinI0+9Mww4lRs3mw2clC2b0NGMfj0+wJVwz
 JX6MOp7M1+WQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9784"; a="155568293"
X-IronPort-AV: E=Sophos;i="5.77,412,1596524400"; 
   d="scan'208";a="155568293"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2020 09:27:48 -0700
IronPort-SDR: q/d4CGkNYsO2YETvtlAgGKKbbVKRamwEtUfMYy3pMEPizZxoUnFSU1CAKAzr7noqKuzqXxxXLV
 TpJm+LhjjdPQ==
X-IronPort-AV: E=Sophos;i="5.77,412,1596524400"; 
   d="scan'208";a="534797141"
Received: from chenyu-office.sh.intel.com ([10.239.158.173])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2020 09:27:46 -0700
From:   Chen Yu <yu.c.chen@intel.com>
To:     Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Yu <yu.c.chen@intel.com>,
        "5 . 6+" <stable@vger.kernel.org>
Subject: [PATCH] intel_idle: Fix max_cstate for processor models without C-state tables
Date:   Sun, 25 Oct 2020 00:29:53 +0800
Message-Id: <20201024162953.14142-1-yu.c.chen@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently intel_idle driver gets the c-state information from ACPI
_CST if the processor model is not recognized by it. However the
c-state in _CST starts with index 1 which is different from the
index in intel_idle driver's internal c-state table. While
intel_idle_max_cstate_reached() was previously introduced to
deal with intel_idle driver's internal c-state table, re-using
this function directly on _CST might get wrong. Fix this by
subtracting the index by 1 when checking max cstate via _CST.
For example, append intel_idle.max_cstate=1 in boot command line,
Before the patch:
grep . /sys/devices/system/cpu/cpu0/cpuidle/state*/name
POLL
After the patch:
grep . /sys/devices/system/cpu/cpu0/cpuidle/state*/name
/sys/devices/system/cpu/cpu0/cpuidle/state0/name:POLL
/sys/devices/system/cpu/cpu0/cpuidle/state1/name:C1_ACPI

Fixes: 18734958e9bf ("intel_idle: Use ACPI _CST for processor models without C-state tables")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Cc: 5.6+ <stable@vger.kernel.org> # 5.6+
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
---
 drivers/idle/intel_idle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 9a810e4a7946..dbd4be1c271b 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1236,7 +1236,7 @@ static void __init intel_idle_init_cstates_acpi(struct cpuidle_driver *drv)
 		struct acpi_processor_cx *cx;
 		struct cpuidle_state *state;
 
-		if (intel_idle_max_cstate_reached(cstate))
+		if (intel_idle_max_cstate_reached(cstate - 1))
 			break;
 
 		cx = &acpi_state_table.states[cstate];
-- 
2.17.1

