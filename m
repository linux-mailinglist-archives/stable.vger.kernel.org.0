Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F464E9BA9
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 17:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239013AbiC1PwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 11:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238921AbiC1PwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 11:52:11 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20129D6;
        Mon, 28 Mar 2022 08:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648482630; x=1680018630;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=5APHoFbk7G7jETQ4Y5bypAJ0rLBR2rx/iuJr+VXpxoM=;
  b=TF4D7B8eNclXxFCFNs3RKVqdLEP3ZY5WFCtkdtiX3/0Eu7o6swohZ0M0
   G0uQjkURLN70JH9zHe5k7oDne87r0gHBLZlwbJxEZk7/Tm+6APhxp0Qcn
   TgBQW0f2s1+bjFupH75WMJ6W/xr7APzVKh1dNIYgjUFsok5ijsDJuBPrb
   d1ziWcNDdiU0UaZlFeII+lvB9OhfkH1jfNJSC8S+g2iM0QRV3/wn0khv8
   zjJWgQ5hIxIuaRx2VmMfJwdIRzDRoUZ1Bb/Q0QHKrWZnCCA3xUZ2QR3pu
   MDkkxjNRR0ztv5Dvd84UGrdVXOx8Kpp54/cvWdMgv9YtDCYrBMMBcHifn
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="257863555"
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="257863555"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 08:50:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="617824943"
Received: from otc-lr-04.jf.intel.com ([10.54.39.41])
  by fmsmga004.fm.intel.com with ESMTP; 28 Mar 2022 08:50:23 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     eranian@google.com, Kan Liang <kan.liang@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] perf/x86/intel: Update the FRONTEND MSR mask on Sapphire Rapids
Date:   Mon, 28 Mar 2022 08:49:03 -0700
Message-Id: <1648482543-14923-2-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1648482543-14923-1-git-send-email-kan.liang@linux.intel.com>
References: <1648482543-14923-1-git-send-email-kan.liang@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

On Sapphire Rapids, the FRONTEND_RETIRED.MS_FLOWS event requires the
FRONTEND MSR value 0x8. However, the current FRONTEND MSR mask doesn't
support it.

Update intel_spr_extra_regs[] to support it.

Fixes: 61b985e3e775 ("perf/x86/intel: Add perf core PMU support for Sapphire Rapids")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 696d036..db32ef6 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -282,7 +282,7 @@ static struct extra_reg intel_spr_extra_regs[] __read_mostly = {
 	INTEL_UEVENT_EXTRA_REG(0x012a, MSR_OFFCORE_RSP_0, 0x3fffffffffull, RSP_0),
 	INTEL_UEVENT_EXTRA_REG(0x012b, MSR_OFFCORE_RSP_1, 0x3fffffffffull, RSP_1),
 	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
-	INTEL_UEVENT_EXTRA_REG(0x01c6, MSR_PEBS_FRONTEND, 0x7fff17, FE),
+	INTEL_UEVENT_EXTRA_REG(0x01c6, MSR_PEBS_FRONTEND, 0x7fff1f, FE),
 	INTEL_UEVENT_EXTRA_REG(0x40ad, MSR_PEBS_FRONTEND, 0x7, FE),
 	INTEL_UEVENT_EXTRA_REG(0x04c2, MSR_PEBS_FRONTEND, 0x8, FE),
 	EVENT_EXTRA_END
-- 
2.7.4

