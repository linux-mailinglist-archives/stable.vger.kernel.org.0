Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA52B574264
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbiGNEYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234535AbiGNEXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:23:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B84328724;
        Wed, 13 Jul 2022 21:22:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2DDFB8237B;
        Thu, 14 Jul 2022 04:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A929FC34114;
        Thu, 14 Jul 2022 04:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772570;
        bh=Nu25KeaHG2mnQyV9qxyD+sSs3aEncDCtP3ul7XyJKUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3ATAGcdUPwz+nXXpeuywy83gbMh4aFXTorFJe39sy38pQKHi314+M8YFTthADAac
         HOPVzQcSTPCC5Pwcgg+6ySnjISc5ycD/QZeU2c0XeHGmzLlwWBf65F2UksDt+mh6NE
         an9YG/ZXStv/EbPbx3vHwy3NdkbhXXFJoNP5jMjvLTkl+6zZxL9TiYPKTQfI+sLPfl
         ct48QndUMNcXKpH3S3WCBF9NKjNbEZq+kXmtjQhSa0al4Zzy5TbHrZRxji/7dweHN/
         oz2NKIU6nUnSBXgdMrvRF6E7gdbRGDr+6FCq+LUKiyEHAI11pYz4l7r7KuvT04hdOW
         3ra5QSm8KyQ0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        daniel.baluta@nxp.com, perex@perex.cz, tiwai@suse.com,
        kai.vehmanen@linux.intel.com, yang.jie@linux.intel.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 10/41] ASoC: SOF: Intel: hda-loader: Make sure that the fw load sequence is followed
Date:   Thu, 14 Jul 2022 00:21:50 -0400
Message-Id: <20220714042221.281187-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit c31691e0d126ec5d60d2b6b03f699c11b613b219 ]

The hda_dsp_enable_core() is powering up _and_ unstall the core in one
call while the first step of the firmware loading  must not unstall the
core.
The core can be unstalled only after the set cpb_cfp and the configuration
of the IPC register for the ROM_CONTROL message.

Complements: 2a68ff846164 ("ASoC: SOF: Intel: hda: Revisit IMR boot sequence")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20220609085949.29062-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-loader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda-loader.c b/sound/soc/sof/intel/hda-loader.c
index 2ac5d9d0719b..9f624a84182b 100644
--- a/sound/soc/sof/intel/hda-loader.c
+++ b/sound/soc/sof/intel/hda-loader.c
@@ -112,7 +112,7 @@ static int cl_dsp_init(struct snd_sof_dev *sdev, int stream_tag)
 	int ret;
 
 	/* step 1: power up corex */
-	ret = hda_dsp_enable_core(sdev, chip->host_managed_cores_mask);
+	ret = hda_dsp_core_power_up(sdev, chip->host_managed_cores_mask);
 	if (ret < 0) {
 		if (hda->boot_iteration == HDA_FW_BOOT_ATTEMPTS)
 			dev_err(sdev->dev, "error: dsp core 0/1 power up failed\n");
-- 
2.35.1

