Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B680B5923C0
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240258AbiHNQYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241812AbiHNQWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:22:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F22E1033;
        Sun, 14 Aug 2022 09:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DF8A60F72;
        Sun, 14 Aug 2022 16:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CC3C433D6;
        Sun, 14 Aug 2022 16:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494075;
        bh=W1kQkvtWGwbqL+LApdyAl6C20hT+IRfBd+s3KUr4l6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QfgYc3Ox9dtV3EmM8Xarcs0ii/8P/PhDiq6lY6ig4qA9oAJasuS+VP1/80hercv99
         9Oaw/i8ZTt6T+jNQgFNXckojykUnMn9fWBQo7x5B8GgJ0DJgm97tIs2l2js+wyW5vn
         cvMy9TQWWRbPNJLXXhWGkKclcLId0PP/BrKIsVhZrrkJG1nmtJ3/LbuQTgER1RBbvA
         eVhpCbGlLqowoPx+5ZZuAyITxY4Jx9CepDZN7v74+ZT3vKSb/p5n/Hk9GeYwAQ/ZBP
         wxTs1iehkg3d6s+80GJwOpZ1fZ7+0DqrynetdvM2jA208qRnq77E7uJXeOswW0BScd
         SfoG6BdTT+fiQ==
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
Subject: [PATCH AUTOSEL 5.19 24/48] ASoC: SOF: Intel: hda: add sanity check on SSP index reported by NHLT
Date:   Sun, 14 Aug 2022 12:19:17 -0400
Message-Id: <20220814161943.2394452-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814161943.2394452-1-sashal@kernel.org>
References: <20220814161943.2394452-1-sashal@kernel.org>
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
index bc07df1fc39f..328be26e2dbb 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -1395,6 +1395,7 @@ struct snd_soc_acpi_mach *hda_machine_select(struct snd_sof_dev *sdev)
 
 		if (mach->tplg_quirk_mask & SND_SOC_ACPI_TPLG_INTEL_SSP_NUMBER &&
 		    mach->mach_params.i2s_link_mask) {
+			const struct sof_intel_dsp_desc *chip = get_chip_info(sdev->pdata);
 			int ssp_num;
 
 			if (hweight_long(mach->mach_params.i2s_link_mask) > 1 &&
@@ -1404,6 +1405,12 @@ struct snd_soc_acpi_mach *hda_machine_select(struct snd_sof_dev *sdev)
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

