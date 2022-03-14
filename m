Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC9E4D8F4C
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 23:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237860AbiCNWKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 18:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiCNWKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 18:10:11 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2334AB7E0;
        Mon, 14 Mar 2022 15:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647295740; x=1678831740;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EUw8rurVhbDdmgGRbM46p4wxYi9Udic9elQ4MGFi23s=;
  b=J9eFPkWm6v0ADAwLHpzk0baE3Mz7vnVyKAMbNuuy8Ce/o5Ea1KjiyPvR
   gxKj0RExKZUsnXIroSrOMW9r585S6hKeRWrSFyNxrn2gu6XwU9WEil7Li
   VkF3PFMmwjVUJR5kX5tYzD/Lsd+O4uKCjf8kAS9Y3G+rA+eQBvjla3Xam
   4Zd2LheZ9Zq4yNOhFmzBA06+m7WcQwlvASD4L+8ZvHfKwPPf6/BDm3hWy
   jHFLHZK2Mi1fUA1SxfRrKWzt0zWVPN01bk36PsbLBQm8ssywpb8+I3Zr+
   8NlkQspcxJNeca6YRIpnI3Kh9LVvQtTfb3lEtta/T1q0HGzczP+luGQqP
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="243605284"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="243605284"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 15:08:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="689986951"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by fmsmga001.fm.intel.com with ESMTP; 14 Mar 2022 15:08:59 -0700
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     rafael@kernel.org, daniel.lezcano@linaro.org, amitk@kernel.org,
        rui.zhang@intel.com
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David.Laight@ACULAB.COM,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] thermal: int340x: Increase bitmap size
Date:   Mon, 14 Mar 2022 15:08:55 -0700
Message-Id: <20220314220855.939823-1-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The number of policies are 10, so can't be supported by the bitmap size
of u8. Even though there are no platfoms with these many policies, but
as correctness increase to u32.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Fixes: 16fc8eca1975 ("thermal/int340x_thermal: Add additional UUIDs")
Cc: stable@vger.kernel.org
---
v2
- Changed u16 to u32 for better alignment as suggested by David

 drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index 72acb1f61849..348b1f4ef801 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -53,7 +53,7 @@ struct int3400_thermal_priv {
 	struct art *arts;
 	int trt_count;
 	struct trt *trts;
-	u8 uuid_bitmap;
+	u32 uuid_bitmap;
 	int rel_misc_dev_res;
 	int current_uuid_index;
 	char *data_vault;
-- 
2.31.1

