Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F0827AFB9
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 16:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgI1OLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 10:11:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:58042 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbgI1OLB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 10:11:01 -0400
IronPort-SDR: xNHtA9DeooBbOf9+MfKdaXZcH56/O5w9pTzbnc2wutQmL4lnVfctScgI9mITTIUknZN/Q83KML
 k2S1zkUfkQVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9757"; a="142011881"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="142011881"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 06:48:55 -0700
IronPort-SDR: ae4nM+oY40MpkgYNvhgSpAdehPh3FZ5xBRUiOfd0mcDMea1OcqdeU2jh/h1Es4x28maZfdq4kZ
 /KogavtkaM6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="488586381"
Received: from unknown (HELO labuser-Ice-Lake-Client-Platform.jf.intel.com) ([10.54.55.65])
  by orsmga005.jf.intel.com with ESMTP; 28 Sep 2020 06:48:55 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     ak@linux.intel.com, Kan Liang <kan.liang@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] perf/x86/intel: Fix Ice Lake event constraint table
Date:   Mon, 28 Sep 2020 06:47:26 -0700
Message-Id: <20200928134726.13090-1-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

An error occues when sampling non-PEBS INST_RETIRED.PREC_DIST(0x01c0)
event.

  perf record -e cpu/event=0xc0,umask=0x01/ -- sleep 1
  Error:
  The sys_perf_event_open() syscall returned with 22 (Invalid argument)
  for event (cpu/event=0xc0,umask=0x01/).
  /bin/dmesg | grep -i perf may provide additional information.

The idxmsk64 of the event is set to 0. The event never be successfully
scheduled.

The event should be limit to the fixed counter 0.

Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
Reported-by: Yi, Ammy <ammy.yi@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index c72e4904e056..93d6d5eadb6d 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -243,7 +243,7 @@ static struct extra_reg intel_skl_extra_regs[] __read_mostly = {
 
 static struct event_constraint intel_icl_event_constraints[] = {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0),	/* INST_RETIRED.ANY */
-	INTEL_UEVENT_CONSTRAINT(0x1c0, 0),	/* INST_RETIRED.PREC_DIST */
+	FIXED_EVENT_CONSTRAINT(0x01c0, 0),	/* INST_RETIRED.PREC_DIST */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1),	/* CPU_CLK_UNHALTED.CORE */
 	FIXED_EVENT_CONSTRAINT(0x0300, 2),	/* CPU_CLK_UNHALTED.REF */
 	FIXED_EVENT_CONSTRAINT(0x0400, 3),	/* SLOTS */
-- 
2.17.1

