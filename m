Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5645A59D6ED
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237080AbiHWJ0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349360AbiHWJXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:23:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0868FD44;
        Tue, 23 Aug 2022 01:35:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE824B81C55;
        Tue, 23 Aug 2022 08:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B21C433B5;
        Tue, 23 Aug 2022 08:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243632;
        bh=okV8wTqSRwwrc7yagPrgh3wP5C7ga5hywXWTASOpLHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YaEvRlgGRw+6bhG2eWGIuCZ3ouoAUpCZmZ/C0NBiVClD9XqYd8VZ7163kVWrcZjIe
         N6xx7AlR1aEd/luY60RbX2q7spV6hF3IQM9gxerKPBb4y00+jsKAN/AL8U1LYc27yG
         En54bUhb4q7KBK1ozahJ5ANKTDViaDYdBxE6xJLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 339/365] ASoC: SOF: Intel: hda: add sanity check on SSP index reported by NHLT
Date:   Tue, 23 Aug 2022 10:04:00 +0200
Message-Id: <20220823080132.400854557@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index ed495b7ad1a9..17f2f3a982c3 100644
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



