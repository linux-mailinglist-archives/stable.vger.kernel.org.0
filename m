Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A9B65A68F
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 21:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbiLaUEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 15:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235785AbiLaUEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 15:04:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FD56242;
        Sat, 31 Dec 2022 12:04:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95C1D60C21;
        Sat, 31 Dec 2022 20:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C611C433EF;
        Sat, 31 Dec 2022 20:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672517089;
        bh=aLbKv6XLfTue2wCV/nY8BTSu4/Ky1k+5ZDJqu7uYoi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5PAp8bwSXh/lOFNK6rkTwjlDiVJ4cCEbNUf/Z86PqTEf/nmikv0bIPmpleU+i1w9
         gT76MklSDowZ/RmOOz0Ljnkk3vT+cIXlIO1uTLxHv3/bup9HAA4chlBqbfRsf0CYSz
         VUmfRiBZ09nYUClz12SDJ1QVOjhN46B3eD0zTgvMYPq6c5gru2Ec+8EGXQoA8iW2VG
         tURpHoK/s0b2dkme/RxPHmMVsknZxZEpv/9iXgWZL4YBSA9AVI9RCuVWlm6dHmlypi
         hzwVXXDleKsihLbXj0T2f5wvV9eXQ0a3khDgJIy0N/9xkFCVzZ64ZpEPyQlobfCAgg
         xr1Fa6UIv2MmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, peter.ujfalusi@linux.intel.com,
        yung-chuan.liao@linux.intel.com, ranjani.sridharan@linux.intel.com,
        kai.vehmanen@linux.intel.com, perex@perex.cz, tiwai@suse.com,
        oder_chiou@realtek.com, akihiko.odaki@gmail.com,
        ckeepax@opensource.cirrus.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 3/7] ASoC: Intel: bytcr_rt5640: Add quirk for the Advantech MICA-071 tablet
Date:   Sat, 31 Dec 2022 15:04:35 -0500
Message-Id: <20221231200439.1748686-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221231200439.1748686-1-sashal@kernel.org>
References: <20221231200439.1748686-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a1dec9d70b6ad97087b60b81d2492134a84208c6 ]

The Advantech MICA-071 tablet deviates from the defaults for
a non CR Bay Trail based tablet in several ways:

1. It uses an analog MIC on IN3 rather then using DMIC1
2. It only has 1 speaker
3. It needs the OVCD current threshold to be set to 1500uA instead of
   the default 2000uA to reliable differentiate between headphones vs
   headsets

Add a quirk with these settings for this tablet.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20221213123246.11226-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index fb9d9e271845..ddd2625bed90 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -570,6 +570,21 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_SSP0_AIF1 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{
+		/* Advantech MICA-071 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Advantech"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "MICA-071"),
+		},
+		/* OVCD Th = 1500uA to reliable detect head-phones vs -set */
+		.driver_data = (void *)(BYT_RT5640_IN3_MAP |
+					BYT_RT5640_JD_SRC_JD2_IN4N |
+					BYT_RT5640_OVCD_TH_1500UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_MONO_SPEAKER |
+					BYT_RT5640_DIFF_MIC |
+					BYT_RT5640_MCLK_EN),
+	},
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ARCHOS"),
-- 
2.35.1

