Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88247637868
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 13:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiKXMDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 07:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiKXMDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 07:03:01 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB42B5B58D;
        Thu, 24 Nov 2022 04:03:00 -0800 (PST)
Date:   Thu, 24 Nov 2022 12:02:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669291379;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/AsHyRa5ka7wg31SysBBkGMgGHhK5IkhmY95gZ89H8c=;
        b=FnhF8fYSEg0FmHHyZ1xdJZMCbsHVQRmlP94LQhV1PTQR+diBw/TNlmREjGe3PROOiEYFmA
        eerSAUEgNjJo+CY9pWSFlU1lv79BhRqm44m4Ki0aCdafk4OfUxhlDre1i5BtQoWcNj3Lci
        SDVaUnSgYC36jpOp17ChMtzlr0n9gO9T4c5UIzxzK4XZiFlLJFIou30CWUMFKZ0fYcAy1O
        emO1trW41v8Rq34RFov8GHxuzSYNOtbY/wsmtbemsebG8brvzXt5MDTCBjki0Dy9U9VvNU
        uXXSNTYVIEFy+7EzDWfsnOhkAFeXOHNRhMTB/7dikx8lXCYJrhqwY0Z5PmAeEw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669291379;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/AsHyRa5ka7wg31SysBBkGMgGHhK5IkhmY95gZ89H8c=;
        b=Gs80L+aAa3I4UEvnE7/gSBUpDmo+t8BQqXX006M2H9dPBzhGBxPhEDYoOODFFDq1m9zCMq
        AgkxFDZlRXw51sAA==
From:   "tip-bot2 for Alexander Antonov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/intel/uncore: Disable I/O stacks to PMU
 mapping on ICX-D
Cc:     Alexander Antonov <alexander.antonov@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20221117122833.3103580-5-alexander.antonov@linux.intel.com>
References: <20221117122833.3103580-5-alexander.antonov@linux.intel.com>
MIME-Version: 1.0
Message-ID: <166929137806.4906.7484681468845511217.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     efe062705d149b20a15498cb999a9edbb8241e6f
Gitweb:        https://git.kernel.org/tip/efe062705d149b20a15498cb999a9edbb8241e6f
Author:        Alexander Antonov <alexander.antonov@linux.intel.com>
AuthorDate:    Thu, 17 Nov 2022 12:28:26 
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Thu, 24 Nov 2022 11:09:21 +01:00

perf/x86/intel/uncore: Disable I/O stacks to PMU mapping on ICX-D

Current implementation of I/O stacks to PMU mapping doesn't support ICX-D.
Detect ICX-D system to disable mapping.

Fixes: 10337e95e04c ("perf/x86/intel/uncore: Enable I/O stacks to IIO PMON mapping on ICX")
Signed-off-by: Alexander Antonov <alexander.antonov@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221117122833.3103580-5-alexander.antonov@linux.intel.com
---
 arch/x86/events/intel/uncore.h       | 1 +
 arch/x86/events/intel/uncore_snbep.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/events/intel/uncore.h b/arch/x86/events/intel/uncore.h
index ef14149..fac3612 100644
--- a/arch/x86/events/intel/uncore.h
+++ b/arch/x86/events/intel/uncore.h
@@ -2,6 +2,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <asm/apicdef.h>
+#include <asm/intel-family.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 
 #include <linux/perf_event.h>
diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 0d06b56..e14b963 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5226,6 +5226,11 @@ static int icx_iio_get_topology(struct intel_uncore_type *type)
 
 static int icx_iio_set_mapping(struct intel_uncore_type *type)
 {
+	/* Detect ICX-D system. This case is not supported */
+	if (boot_cpu_data.x86_model == INTEL_FAM6_ICELAKE_D) {
+		pmu_clear_mapping_attr(type->attr_update, &icx_iio_mapping_group);
+		return -EPERM;
+	}
 	return pmu_iio_set_mapping(type, &icx_iio_mapping_group);
 }
 
