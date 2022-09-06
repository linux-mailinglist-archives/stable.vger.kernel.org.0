Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34B15ADF63
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 08:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238475AbiIFGI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 02:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238390AbiIFGIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 02:08:48 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD0D66102
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 23:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662444527; x=1693980527;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZalxVJzAcO/EhVu0DiqqC3410ECrzJv4tvQseQGQGT4=;
  b=F/bp4nskLx0pVje3L2V5hQRV99d8c7ys0GhwNHTixK6aR2Vz8R3M2ObE
   VJAaD8OfRTmlyb5+CDqKKXZYvRuYT7DF4WBSs7r7GdB+Ss8dz8ckUIKkI
   /67yvbiw1R2AtQ3/n6/dETsl1Cyt4KSQBbhGeSAUUADPtwpHMJiJqlRCC
   yk7AW1IWKT15Kk0B+F3hBj2lMTDjYE50gWTh24fCiQD45q/f/C7D8kozw
   TuUYNCItdUuHBy2eaMXrda8G+pdz0gudg/JjvBIcjCW+sRhJPOGt8fcp9
   4THpC+4gis91+UcqFyGpOqbXO0TVG7t17KITpAFmA30HHVbxxFGows02E
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="283507704"
X-IronPort-AV: E=Sophos;i="5.93,293,1654585200"; 
   d="scan'208";a="283507704"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 23:08:46 -0700
X-IronPort-AV: E=Sophos;i="5.93,293,1654585200"; 
   d="scan'208";a="609848731"
Received: from jzablotn-mobl.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.57.122])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 23:08:45 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Seunghui Lee <sh043.lee@samsung.com>
Subject: [PATCH 5.10] mmc: core: Fix UHS-I SD 1.8V workaround branch
Date:   Tue,  6 Sep 2022 09:08:34 +0300
Message-Id: <20220906060834.58305-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 15c56208c79c340686869c31595c209d1431c5e8 upstream.

When introduced, upon success, the 1.8V fixup workaround in
mmc_sd_init_card() would branch to practically the end of the function, to
a label named "done". Unfortunately, perhaps due to the label name, over
time new code has been added that really should have come after "done" not
before it. Let's fix the problem by moving the label to the correct place
and rename it "cont".

Fixes: 045d705dc1fb ("mmc: core: Enable the MMC host software queue for the SD card")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Seunghui Lee <sh043.lee@samsung.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220815073321.63382-2-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[Backport to 5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/mmc/core/sd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index bac343a8d569..0b09cdaaeb6c 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -1107,7 +1107,7 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 					mmc_remove_card(card);
 				goto retry;
 			}
-			goto done;
+			goto cont;
 		}
 	}
 
@@ -1143,7 +1143,7 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 			mmc_set_bus_width(host, MMC_BUS_WIDTH_4);
 		}
 	}
-
+cont:
 	if (host->cqe_ops && !host->cqe_enabled) {
 		err = host->cqe_ops->cqe_enable(host, card);
 		if (!err) {
@@ -1161,7 +1161,7 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 		err = -EINVAL;
 		goto free_card;
 	}
-done:
+
 	host->card = card;
 	return 0;
 
-- 
2.25.1

