Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC09F5803C1
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 20:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236275AbiGYSGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 14:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235959AbiGYSFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 14:05:10 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7673A1BEA6
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 11:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658772304; x=1690308304;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4QWPocfwSBpAAeJWBssM/ThTCR/A9ichKfmlljwoObI=;
  b=aO79eL/fitZ9tOzgI1ZQ9q+lFPHPjQqkad91T6RUhj73bAoDGBWsHz20
   cFzJtUgbakwvUd57H/ZKYll9QNClTyHVCw12D/ukz9leFMW0nFpIngLiz
   sfZQbxXE8vLUhkS20kDamdKi3+9DKKCKyHW9IpAtEZod4O8h7SzI3q7Dx
   QTORaxt/4gx8OXqFm3xVrOA2Dcrtvv+La4QsQjhXfjfS9SN7vBf0PjUrk
   9z+Ur/oBcqb/uTEQ+0cbFrPRrJraLBFWkmfJ7rE5KfqZKaiVEjcyb6KKd
   bE3JQVu5GiZoCSZ679KcS2ijCtPM4Fof794T9Wr18Ous8PYCrHw9SnTBx
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="274627576"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="274627576"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 11:05:03 -0700
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="632449973"
Received: from jxzhao-mobl.amr.corp.intel.com (HELO pbossart-mobl3.intel.com) ([10.212.0.178])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 11:05:02 -0700
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, broonie@kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>
Subject: [PATCH v2 3/3] ASoC: SOF: Intel: disable IMR boot when resuming from ACPI S4 and S5 states
Date:   Mon, 25 Jul 2022 13:04:49 -0500
Message-Id: <20220725180449.12742-4-pierre-louis.bossart@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220725180449.12742-1-pierre-louis.bossart@linux.intel.com>
References: <20220725180449.12742-1-pierre-louis.bossart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 391153522d186f19a008d824bb3a05950351ce6c upstream.

The IMR was assumed to be preserved when suspending to S4 and S5
states, but community reports invalidate that assumption, the hardware
seems to be powered off and the IMR memory content cleared.

Make sure regular boot with firmware download is used for S4 and S5.

BugLink: https://github.com/thesofproject/sof/issues/5892
Fixes: 5fb5f51185126 ("ASoC: SOF: Intel: hda-loader: add IMR restore support")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
---
 sound/soc/sof/intel/hda-loader.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda-loader.c b/sound/soc/sof/intel/hda-loader.c
index 2ac5d9d0719b..bb7726830c25 100644
--- a/sound/soc/sof/intel/hda-loader.c
+++ b/sound/soc/sof/intel/hda-loader.c
@@ -397,7 +397,8 @@ int hda_dsp_cl_boot_firmware(struct snd_sof_dev *sdev)
 	struct firmware stripped_firmware;
 	int ret, ret1, i;
 
-	if ((sdev->fw_ready.flags & SOF_IPC_INFO_D3_PERSISTENT) &&
+	if ((sdev->system_suspend_target < SOF_SUSPEND_S4) &&
+	    (sdev->fw_ready.flags & SOF_IPC_INFO_D3_PERSISTENT) &&
 	    !(sof_debug_check_flag(SOF_DBG_IGNORE_D3_PERSISTENT)) &&
 	    !sdev->first_boot) {
 		dev_dbg(sdev->dev, "IMR restore supported, booting from IMR directly\n");
-- 
2.34.1

