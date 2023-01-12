Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D69667809
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjALOvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240022AbjALOvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:51:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B7C14035
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:38:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7CE46203C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C7EC433D2;
        Thu, 12 Jan 2023 14:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534289;
        bh=GxaxqPW3u45nNr+ODfXGWGQFFhxVzQPtxd9ex9+Uy+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pO1y8vlfJn7lVJmFoycozRsMC06RaaxIuGVSvN4T+8Ss+vj3BAmzC1ZI+58s3xxKh
         IOB62ys4mKnV0gbtBC0c6IlsoAV8Ztz/DR6i80zoUcfiQeocf9hcaXttxkl9MSPOXT
         QtuqBzkqCRHdd9c3Lse38yx8yflc1aevK2Kc7yTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 758/783] ASoC: Intel: bytcr_rt5640: Add quirk for the Advantech MICA-071 tablet
Date:   Thu, 12 Jan 2023 14:57:54 +0100
Message-Id: <20230112135559.504522754@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3020a993f6ef..8a99cb6dfcd6 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -430,6 +430,21 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
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



