Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8E959ED81
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 22:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiHWUjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 16:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbiHWUjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 16:39:31 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F79933A37;
        Tue, 23 Aug 2022 13:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661286437; x=1692822437;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tgOJhqk0CJW9kR1ayzY1Eva20Cc/QNLAY3p3Jdo15sM=;
  b=AMn7Rwdrhed309dUOd/PwHth6/HQpwMynVOcryw1n4/JJ8q3E48L6ysx
   sBaao9hBy7sSLbQeVS0dzr6UoJRFX8lwQZxq8R5sqXButy3HZX6mCA4Kw
   gaZJCapLvL4kVz/er4Arv89+jAXXPy+dYahKS5oZ/Ip3URUUbdkCpidlj
   c0y0PBYxJ1mHI59JSZO9heD3LPIgaWbP/64OxrjcPuGu/KozHiZst5b1x
   AYk58ndZk8bEt1MLbQC9Tg+pPBVQRZ5wlL7Sl7BtKkWUHZwEShYDT8iaX
   8n+cVRsfJ3RuQLvUjgv+1tlaHEWlkpctnAdeqC8e6tVmuyyQCT8kXXd+M
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="293789006"
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="293789006"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 13:27:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="937613240"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by fmsmga005.fm.intel.com with ESMTP; 23 Aug 2022 13:27:03 -0700
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     fweisbec@gmail.com, tglx@linutronix.de, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] tick: Invalid ratelimit check
Date:   Tue, 23 Aug 2022 13:26:42 -0700
Message-Id: <20220823202643.43577-1-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 2.31.1
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

One more change from the prior version of kernel:
In prior version !local_bh_blocked() check was only used for printing
warning message. The output was not used to decide whether to allow
tick-stop or not.  But with change introduced with 5.18, the output
will also decide whether to stop tick or not even if
local_softirq_pending() returns true.
Not sure if this is intentional change or not.

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

