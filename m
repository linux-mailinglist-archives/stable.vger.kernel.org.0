Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398DF5707C4
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 17:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiGKP5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 11:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiGKP5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 11:57:37 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F8D2F3AC
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 08:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657555056; x=1689091056;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0hyCklMbwAyZ4i45OrLE8SDCAHcsX1TDvsXP/FgauSs=;
  b=OFFFAPLPA8V621PZysfsz9/VXPrkyf6xlGeH9tjSZt4MAOfD2Ekk4FXA
   ZLlEBKQk8CIRgK09iAqV9+MUTPzP15x08lKC3UfCZ1oSHccNqOID0dqll
   15534CqEwULdgY3F6SFJSqRH7uzffQH8HHRmsKYrZtMpZiPbYYvyDpRzr
   ZDgDkdRMT/88GLOi1NNczq9YCuykb1Th2UdfCxn1kfxuPvVryJdaXWqEl
   7cip7pMevRLzaoPA4Wg2H2KceBhDcGhFLjA9vsVcbU1y4V3SVGjfwqOVk
   kc0N89UIyLXoFLPZ9UwIGt5ea/Pv/vealY1VlE82MA1fklJV18H5B7Sqs
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="264479653"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="264479653"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 08:57:35 -0700
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="771553862"
Received: from jbeecha-mobl.amr.corp.intel.com (HELO pbossart-mobl3.intel.com) ([10.209.161.159])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 08:57:34 -0700
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, broonie@kernel.org,
        peter.ujfalusi@linux.intel.com, ranjani.sridharan@linux.intel.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Subject: [PATCH 3/3] ASoC: SOF: Intel: disable IMR boot when resuming from ACPI S4 and S5 states
Date:   Mon, 11 Jul 2022 10:57:19 -0500
Message-Id: <20220711155719.104952-4-pierre-louis.bossart@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220711155719.104952-1-pierre-louis.bossart@linux.intel.com>
References: <20220711155719.104952-1-pierre-louis.bossart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 58ecb11eab44dd5d64e35664ac4d62fecb6328f4 upstream.

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

