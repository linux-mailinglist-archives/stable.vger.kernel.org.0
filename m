Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C318F60553A
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 03:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiJTBxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 21:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbiJTBxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 21:53:13 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6BF1C3E7D;
        Wed, 19 Oct 2022 18:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666230791; x=1697766791;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hfWjYaVPC1jR2bOcPd6wO2+FVIEpJFXHmpCSZH0ayOk=;
  b=Zn1yfRx0T7aLVCEiLn6KrBi9mOWgotUohRaFiwT8D/xCD8wNjRDK/269
   3Dt2NkzOYaQ32cqfY9IxulZzNeGnHlfFt5L+tpD8rG1gn5OKnot+tvxcn
   /Wt16ejh6sFkbaG7JnRMzVD4ruYo6WpUj6GpfnIJMLdNJzqiTccKEJWd/
   mbh+++Jm5ksNWh6om9NETKLdm1HC578uRWFJuZWlbP3IpyL0XO1neSvLm
   31ptYCFBm8pld1OCa9qO/pB4SahhnHU4Lrl+1bH1R9vM8IhdC8P/n7onr
   413qQCrK0NMxluyCiJ0OOpEWNd+BRdFptx21gMR1+CdKUFC8SbcJc3Gti
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="333143313"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="333143313"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 18:52:52 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="662755519"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="662755519"
Received: from bard-ubuntu.sh.intel.com ([10.239.185.57])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 18:52:49 -0700
From:   Bard Liao <yung-chuan.liao@linux.intel.com>
To:     alsa-devel@alsa-project.org, vkoul@kernel.org
Cc:     vinod.koul@linaro.org, linux-kernel@vger.kernel.org,
        pierre-louis.bossart@linux.intel.com, bard.liao@intel.com,
        stable@vger.kernel.org
Subject: [PATCH] soundwire: intel: Initialize clock stop timeout
Date:   Thu, 20 Oct 2022 09:56:24 +0800
Message-Id: <20221020015624.1703950-1-yung-chuan.liao@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sjoerd Simons <sjoerd@collabora.com>

The bus->clk_stop_timeout member is only initialized to a non-zero value
during the codec driver probe. This can lead to corner cases where this
value remains pegged at zero when the bus suspends, which results in an
endless loop in sdw_bus_wait_for_clk_prep_deprep().

Corner cases include configurations with no codecs described in the
firmware, or delays in probing codec drivers.

Initializing the default timeout to the smallest non-zero value avoid this
problem and allows for the existing logic to be preserved: the
bus->clk_stop_timeout is set as the maximum required by all codecs
connected on the bus.

Fixes: 1f2dcf3a154ac ("soundwire: intel: set dev_num_ida_min")
Signed-off-by: Sjoerd Simons <sjoerd@collabora.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Chao Song <chao.song@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
---
 drivers/soundwire/intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 25ec9c272239..78d35bb4852c 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1311,6 +1311,7 @@ static int intel_link_probe(struct auxiliary_device *auxdev,
 
 	bus->link_id = auxdev->id;
 	bus->dev_num_ida_min = INTEL_DEV_NUM_IDA_MIN;
+	bus->clk_stop_timeout = 1;
 
 	sdw_cdns_probe(cdns);
 
-- 
2.25.1

