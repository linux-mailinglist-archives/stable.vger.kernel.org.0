Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DE1537C43
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbiE3NbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237357AbiE3NaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:30:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD298BD31;
        Mon, 30 May 2022 06:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58695B80D89;
        Mon, 30 May 2022 13:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C671C36AE3;
        Mon, 30 May 2022 13:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917231;
        bh=lYHN3M9R/cWlaC8P7t69WHiCUtqTwEPDM2IyLMD+e50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IaaSqpowAjRUYcKt+LL2VT34HU/uXqNEWJVXL1WP8V3uth690uVx62QCICLkojkZZ
         WVFMzjmvlQCnEJQ82YKaN5yADT3fbxC19O20D19EmhwFd0sljuG82sATNWBIgjd5DW
         O+93XWSqtNjPvBqBX0oFBWqvboVyWbGGUugJJXtp24igvDpGPFElmaRGQnnFFcOZGm
         x+Zch73KFX+fKosa/9W90TZUeQwcHk+UHwAr+m/u5hoZJ5bFk22TUhdbaR8KL4kpHY
         slwlT6krBWzQPRJzj3vPGiYL6Adaf8NItKGitkPM/AdndY1joqz5le3bzi4Q4qKHUQ
         VwCksP5kA/G2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, yang.jie@linux.intel.com,
        perex@perex.cz, tiwai@suse.com, andriy.shevchenko@linux.intel.com,
        peter.ujfalusi@linux.intel.com, akihiko.odaki@gmail.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 064/159] ASoC: Intel: bytcr_rt5640: Add quirk for the HP Pro Tablet 408
Date:   Mon, 30 May 2022 09:22:49 -0400
Message-Id: <20220530132425.1929512-64-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit ce216cfa84a4e1c23b105e652c550bdeaac9e922 ]

Add a quirk for the HP Pro Tablet 408, this BYTCR tablet has no CHAN
package in its ACPI tables and uses SSP0-AIF1 rather then SSP0-AIF2 which
is the default for BYTCR devices.

It also uses DMIC1 for the internal mic rather then the default IN3
and it uses JD2 rather then the default JD1 for jack-detect.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211485
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220427134918.527381-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index d76a505052fb..f81ae742faa7 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -773,6 +773,18 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_OVCD_SF_0P75 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{	/* HP Pro Tablet 408 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pro Tablet 408"),
+		},
+		.driver_data = (void *)(BYT_RT5640_DMIC1_MAP |
+					BYT_RT5640_JD_SRC_JD2_IN4N |
+					BYT_RT5640_OVCD_TH_1500UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{	/* HP Stream 7 */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-- 
2.35.1

