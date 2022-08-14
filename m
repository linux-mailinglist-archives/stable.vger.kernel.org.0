Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927D8592445
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241751AbiHNQaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242419AbiHNQ3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:29:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EFD1EEF3;
        Sun, 14 Aug 2022 09:24:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC29660F76;
        Sun, 14 Aug 2022 16:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD64C433D6;
        Sun, 14 Aug 2022 16:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494266;
        bh=bfcOz9zsKVPqIE/edsGfGC3+4XG2YhdpQJo5xjBlGBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCezi9lbLAOpFOAW9wMS+e+EX7CMW1olijK0e9zOzu6t/wd+qjVBc9Cpv+FySpM5N
         +x7EDdpeAXT+nnd/mvxsS9msKXsTASysIbfcFEjk21/APJ++8c6VnScaNfIyWXI707
         ZslNWpJhLdsq/jEW4gIEjRfGaUHucD9qlmbvoJdRdUuAjlfOVHqWasmQV3F7tYMOkm
         OzokI/4oEdvEXitx28eXzuWSYWjXOZoLmFDUFUBLavdF+yZj5pRgLeWIr3FxmJZpvq
         hSA/bGohoya0EEEn+lAb0LROVzYaH9RoB+UIlikrwFwsGgL1jgfdDE2p/muSSwk3iM
         qVUMR1rOV6FSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        peter.ujfalusi@linux.intel.com, daniel.baluta@nxp.com,
        perex@perex.cz, tiwai@suse.com, kai.vehmanen@linux.intel.com,
        guennadi.liakhovetski@linux.intel.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 17/39] ASoC: SOF: Intel: hda: add sanity check on SSP index reported by NHLT
Date:   Sun, 14 Aug 2022 12:23:06 -0400
Message-Id: <20220814162332.2396012-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162332.2396012-1-sashal@kernel.org>
References: <20220814162332.2396012-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit e51699505042fb365df3a0ce68b850ccd9ad0108 ]

We should have a limited trust in the BIOS and verify that the SSP
index reported in NHLT is valid for each platform.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220725195343.145603-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 9c97c80a7f48..b688caa34774 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -1375,6 +1375,7 @@ struct snd_soc_acpi_mach *hda_machine_select(struct snd_sof_dev *sdev)
 
 		if (mach->tplg_quirk_mask & SND_SOC_ACPI_TPLG_INTEL_SSP_NUMBER &&
 		    mach->mach_params.i2s_link_mask) {
+			const struct sof_intel_dsp_desc *chip = get_chip_info(sdev->pdata);
 			int ssp_num;
 
 			if (hweight_long(mach->mach_params.i2s_link_mask) > 1 &&
@@ -1384,6 +1385,12 @@ struct snd_soc_acpi_mach *hda_machine_select(struct snd_sof_dev *sdev)
 			/* fls returns 1-based results, SSPs indices are 0-based */
 			ssp_num = fls(mach->mach_params.i2s_link_mask) - 1;
 
+			if (ssp_num >= chip->ssp_count) {
+				dev_err(sdev->dev, "Invalid SSP %d, max on this platform is %d\n",
+					ssp_num, chip->ssp_count);
+				return NULL;
+			}
+
 			tplg_filename = devm_kasprintf(sdev->dev, GFP_KERNEL,
 						       "%s%s%d",
 						       sof_pdata->tplg_filename,
-- 
2.35.1

