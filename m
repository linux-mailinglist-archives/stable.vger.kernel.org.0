Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7235B59ED7F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 22:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbiHWUju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 16:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbiHWUjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 16:39:31 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341842B607;
        Tue, 23 Aug 2022 13:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661286438; x=1692822438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y71gP0Ae8aUSDwayuzuEKBHQLvrxYFIzWLhnaCf887Y=;
  b=fiAXK5bysDbS5vji4BFOPYni+cg44wafZf+Yxq0BfEVbyvSUzhqZiFc2
   Z4a8m9niGLTtANTjuvinIKbHP2JBRmQfmBFAX7c8KyRN8mZ3GuuumEQKX
   RQwouG+tH2UXQ6zfcu4gKZJ/8hccraJi5zeNWjAomPQW99NlHT78p1e3d
   U4AnBRAtN8Vzj6wgVzkttc5FNOfZKvJjbH3iba3RDhPQNLdyMRUPPuM48
   I53u2c4gC+ETHV2ha5e/E3ipISor5aggyQXTExRbAboi4ArTg6RzzlNQh
   x+ACyNY5fFT0cd/nGIZqyHo1/g+I/uCdk9tBmd98T0bkUL+/RXpbAskgE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="293789007"
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="293789007"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 13:27:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="937613242"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by fmsmga005.fm.intel.com with ESMTP; 23 Aug 2022 13:27:03 -0700
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     fweisbec@gmail.com, tglx@linutronix.de, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] tick: Invalid ratelimit check
Date:   Tue, 23 Aug 2022 13:26:43 -0700
Message-Id: <20220823202643.43577-2-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220823202643.43577-1-srinivas.pandruvada@linux.intel.com>
References: <20220823202643.43577-1-srinivas.pandruvada@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the function report_idle_softirq(), ratelimit is a static variable
and checked for < 10 to return false. Since this variable is not
assigned to any other value before the check, this condition will
always be true.

report_idle_softirq() introduced with the
commit 0345691b24c0 ("tick/rcu: Stop allowing RCU_SOFTIRQ in idle")
checks for pending soft irq during stopping of tick and returns true if
tick can't be stopped.

The purpose of ratelimit is to limit printing of warning messages, so
move the check for printing warning message only. Also don't return
false as tick can't be stopped here for pending soft irq.

Fixes: 0345691b24c0 ("tick/rcu: Stop allowing RCU_SOFTIRQ in idle")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org # 5.18+
---

One more change from prior version:
In prior version !local_bh_blocked() check was only used for printing
warning message. The output was not used to decide whether to allow
tick-stop or not.  But with change introduced with 5.18, the output
will also decide whether to stop tick or not even if
local_softirq_pending() return true.

 kernel/time/tick-sched.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index b0e3c9205946..4db634525bf4 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1025,16 +1025,15 @@ static bool report_idle_softirq(void)
 			return false;
 	}
 
-	if (ratelimit < 10)
-		return false;
-
 	/* On RT, softirqs handling may be waiting on some lock */
 	if (!local_bh_blocked())
 		return false;
 
-	pr_warn("NOHZ tick-stop error: local softirq work is pending, handler #%02x!!!\n",
-		pending);
-	ratelimit++;
+	if (ratelimit < 10) {
+		pr_warn("NOHZ tick-stop error: local softirq work is pending, handler #%02x!!!\n",
+			pending);
+		ratelimit++;
+	}
 
 	return true;
 }
-- 
2.35.3

