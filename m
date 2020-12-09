Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FADA2D4952
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 19:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732952AbgLISqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 13:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728997AbgLISqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 13:46:01 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C2AC0617A6;
        Wed,  9 Dec 2020 10:44:42 -0800 (PST)
Date:   Wed, 09 Dec 2020 18:44:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607539480;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BfFS48eStY2H5Vt9t6udqjhiUv/iHMkqEmQUhUIAAN8=;
        b=SSZ8jbvN6Du9k3LxH5fGP/aXMyP8lp+mEJfdfDL03CiblFYTQsBjOclKD7EF9tUbcFQ3/E
        Z8ts4eVrLS4bLo3Wd3tAVrWBCs/+sRRCVoE3BVJWU/lRIZJlU0BIYaQg+eU6YfL7FBSXFN
        g/W0pvOb9lwqwTzTAbg8fvw7udUjMPVvyeF8HhLE2CY0w5prk4JIOg42xuSy4Y29vsUkT5
        4hG0p9xgliVOLAYfW1fPkw4mGstoVtQe1cTCFTKfL87TwfvhN2euzV0hYT2mIU4QQRAOm9
        pZzV3mOqjPOACpJTY3gulTwO4VSPgQsAvnslN6nyq7ezIBO25kD/WkVutNH4/A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607539480;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BfFS48eStY2H5Vt9t6udqjhiUv/iHMkqEmQUhUIAAN8=;
        b=xtueNYlVOjVeDNeTpA7qcvtJpeRWTnhlaoXAjMPtCi5AIQnyiErLLIDOS3h2apzmdqnSHX
        Sr0x84nydnrKcQCA==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/intel: Fix rtm_abort_event encoding on Ice Lake
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20201125213720.15692-1-kan.liang@linux.intel.com>
References: <20201125213720.15692-1-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <160753948006.3364.10518320542900897323.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     46b72e1bf4fc571da0c29c6fb3e5b2a2107a4c26
Gitweb:        https://git.kernel.org/tip/46b72e1bf4fc571da0c29c6fb3e5b2a2107a4c26
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Wed, 25 Nov 2020 13:37:19 -08:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 09 Dec 2020 17:08:57 +01:00

perf/x86/intel: Fix rtm_abort_event encoding on Ice Lake

According to the event list from icelake_core_v1.09.json, the encoding
of the RTM_RETIRED.ABORTED event on Ice Lake should be,
    "EventCode": "0xc9",
    "UMask": "0x04",
    "EventName": "RTM_RETIRED.ABORTED",

Correct the wrong encoding.

Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20201125213720.15692-1-kan.liang@linux.intel.com
---
 arch/x86/events/intel/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 546cc89..6c0d18f 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5466,7 +5466,7 @@ __init int intel_pmu_init(void)
 		mem_attr = icl_events_attrs;
 		td_attr = icl_td_events_attrs;
 		tsx_attr = icl_tsx_events_attrs;
-		x86_pmu.rtm_abort_event = X86_CONFIG(.event=0xca, .umask=0x02);
+		x86_pmu.rtm_abort_event = X86_CONFIG(.event=0xc9, .umask=0x04);
 		x86_pmu.lbr_pt_coexist = true;
 		intel_pmu_pebs_data_source_skl(pmem);
 		x86_pmu.update_topdown_event = icl_update_topdown_event;
