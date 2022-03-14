Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8F94D875F
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 15:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237728AbiCNOvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 10:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235505AbiCNOvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 10:51:33 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3013A5D4;
        Mon, 14 Mar 2022 07:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647269423; x=1678805423;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MaP7ctIKlcuT7SRciVsk6QccSOq2Ru2A8FRQI79ZlYw=;
  b=jNuQvKBqFGxVsQuqSaJ9sNgsF4rEWKdtxi//Fgou8Oh4PSIXBnxWlzRy
   GG/g+DDPW4WKXNhBjf7BevXudTV79mR7J9oRejKG/5htz/4M+K9/pziTx
   1afwWPhdttN+ngL0EJvcfI2EZLW/sHLa0dSy4X5ghgN0vlU3FMl5Pf4FW
   TzceW8ZEzRWOvb5NlvmLKzUaZDVa9tU6KR46VQ4vbMF6xHhtr2xIKxuHb
   aoc93stYM9SUP00df5R8A0c3v45Y+yJkkIBgxMl/sU4hHu/vFzTzz5B28
   e3TsmthB2cbmLb+zLDrPX+2aVN+96SEbrG5otyJOc/0Tv0mPfBv432h7s
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10285"; a="235993050"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="235993050"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 07:50:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="689841086"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by fmsmga001.fm.intel.com with ESMTP; 14 Mar 2022 07:50:22 -0700
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     rafael@kernel.org, daniel.lezcano@linaro.org, amitk@kernel.org,
        rui.zhang@intel.com
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthewgarrett@google.com,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] thermal: int340x: Increase bitmap size
Date:   Mon, 14 Mar 2022 07:50:17 -0700
Message-Id: <20220314145017.928550-1-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The number of policies are 10, so can't be supported by the bitmap size
of u8. Even though there are no platfoms with these many policies, but
as correctness increase to u16.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Fixes: 16fc8eca1975 ("thermal/int340x_thermal: Add additional UUIDs")
Cc: stable@vger.kernel.org
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index 72acb1f61849..c2d3df302214 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -53,7 +53,7 @@ struct int3400_thermal_priv {
 	struct art *arts;
 	int trt_count;
 	struct trt *trts;
-	u8 uuid_bitmap;
+	u16 uuid_bitmap;
 	int rel_misc_dev_res;
 	int current_uuid_index;
 	char *data_vault;
-- 
2.31.1

