Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29AC0642E49
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 18:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiLERG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 12:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiLERGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 12:06:52 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E3318B14
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 09:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670260011; x=1701796011;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8GvupLP2UuW2/ZlFNXn1zKOTS302YhXxrzMduDFtapA=;
  b=gTv0cksYpfLOLKDzV9xe3aD6lipRUpujByQjZfIZdAL7ujnu2WiHxqtF
   EsJamYDgeXyI1cdNGT7yd9rO1N2yWnYyRY1Vg8T9Shu4n0WTAwirUfDjy
   TiLVRcmsicZHbk+MMxtgbcunrQ0YQWx9GkHQ5+BpjB8Uz0dGvGPD4tSpG
   IwjkH3YXJrHcsBjLIo3vCtbahgDggfX/bj5izkfzAXTKe1+ExGOZRGo7h
   4++6GL5f3vSSr4O0OE4Q4fXO0S6ofmm5C15zXWM8a1AKTE08N8mO8DhG2
   VZfDK6umskOTuyYb9xFgiyjjB8JurFGbG3asBVa6NGR2N51ajpGk+OQr5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="318259387"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="318259387"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 09:06:08 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="676655418"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="676655418"
Received: from ysuvarna-mobl1.amr.corp.intel.com (HELO pbossart-mobl3.intel.com) ([10.212.123.127])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 09:06:07 -0800
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, vkoul@kernel.org,
        Sjoerd Simons <sjoerd@collabora.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Chao Song <chao.song@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>
Subject: [PATCH] soundwire: intel: Initialize clock stop timeout
Date:   Mon,  5 Dec 2022 11:06:00 -0600
Message-Id: <20221205170600.15002-1-pierre-louis.bossart@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sjoerd Simons <sjoerd@collabora.com>

commit 13c30a755847c7e804e1bf755e66e3ff7b7f9367 upstream

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
Link: https://lore.kernel.org/r/20221020015624.1703950-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
---

This should be applied to all stable kernels between 5.13.x and
6.0.x. Backporting to avoid a conflict with 1f2dcf3a154ac ("soundwire:
intel: set dev_num_ida_min") already added for 6.1


 drivers/soundwire/intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index af6c1a93372d9..002bc26b525e8 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1307,6 +1307,7 @@ static int intel_link_probe(struct auxiliary_device *auxdev,
 	cdns->msg_count = 0;
 
 	bus->link_id = auxdev->id;
+	bus->clk_stop_timeout = 1;
 
 	sdw_cdns_probe(cdns);
 
-- 
2.34.1

