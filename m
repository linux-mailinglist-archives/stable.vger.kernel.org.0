Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4006ADB61
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 11:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjCGKHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 05:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjCGKHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 05:07:19 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36C45617E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 02:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678183634; x=1709719634;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JNsieOpaOS/dFOPQ5VOR1/sKUl6juzRq5h5lHKjXo6s=;
  b=Un2qm3o3OBxHp4zCUtmGVWb8lK98A/glzHqPNnkqInB0X//vdtfimp82
   ggCPY4Kur79Gz1CzMHeAMco7D0d5Xwam8vOnkv6+5FoGpHskrSQB8ZZva
   rcLbAhVqEmPN/GkpRDaJjj6C1nqCmAZZSd2P5/Fl7gBZ35XZKygGuN2uX
   XhFwYHjik1UeSVVgAEpe+avnSNlVbPucVYRmsTb75Tm7FQ8ViOm0LzQJP
   FXHi5Uvq6Tc9V3DvkUDZyIe/ulBI2ohx5iasifp5OX8XlmSqjs/THCH0s
   OMSACTvMYsEm94oOl+1p8M2XsRDpuFSFmaPrz/ut1V4K7oDYO1pSHPlLS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="335835942"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="335835942"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 02:07:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="922297688"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="922297688"
Received: from rganesh-mobl.ger.corp.intel.com (HELO pujfalus-desk.ger.corp.intel.com) ([10.252.47.75])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 02:07:12 -0800
From:   Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
To:     lgirdwood@gmail.com, broonie@kernel.org
Cc:     alsa-devel@alsa-project.org, pierre-louis.bossart@linux.intel.com,
        ranjani.sridharan@linux.intel.com, kai.vehmanen@linux.intel.com,
        yung-chuan.liao@linux.intel.com, stable@vger.kernel.org
Subject: [PATCH] ASoC: Intel: soc-acpi: fix copy-paste issue in topology names
Date:   Tue,  7 Mar 2023 12:07:33 +0200
Message-Id: <20230307100733.15025-1-peter.ujfalusi@linux.intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

For some reason the convention for topology names was not followed and
the name inspired by another unrelated hardware configuration. As a
result, the kernel will request a non-existent topology file.

Link: https://github.com/thesofproject/sof/pull/6878
Fixes: 2ec8b081d59f ("ASoC: Intel: soc-acpi: Add entry for sof_es8336 in ADL match table")
Cc: stable@vger.kernel.org
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
---
 sound/soc/intel/common/soc-acpi-intel-adl-match.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-adl-match.c b/sound/soc/intel/common/soc-acpi-intel-adl-match.c
index 56ee5fef66a8..28dd2046e4ac 100644
--- a/sound/soc/intel/common/soc-acpi-intel-adl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-adl-match.c
@@ -559,7 +559,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_adl_machines[] = {
 	{
 		.comp_ids = &essx_83x6,
 		.drv_name = "sof-essx8336",
-		.sof_tplg_filename = "sof-adl-es83x6", /* the tplg suffix is added at run time */
+		.sof_tplg_filename = "sof-adl-es8336", /* the tplg suffix is added at run time */
 		.tplg_quirk_mask = SND_SOC_ACPI_TPLG_INTEL_SSP_NUMBER |
 					SND_SOC_ACPI_TPLG_INTEL_SSP_MSB |
 					SND_SOC_ACPI_TPLG_INTEL_DMIC_NUMBER,
-- 
2.39.2

