Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD53541876
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379780AbiFGVMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379775AbiFGVK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:10:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864B0215E55;
        Tue,  7 Jun 2022 11:52:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB0FB61787;
        Tue,  7 Jun 2022 18:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC36C385A2;
        Tue,  7 Jun 2022 18:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627923;
        bh=yWcmRdVyi+FWys7GZ9HWj6oxRlxBcBG6kQKuSmRN7nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlxCumJ7KfDghPj03b5R3q+PCe0sbPpqXFcHnfFJQr5M+97/Zy3LRfwnBZV2OAfEs
         CFT+jdwDkOcEWTZZixHVem4BVUkO6BGpbb7DtzV0G/wHesbCmt+B0BBm3YOUyq/2RB
         2ojD3SOMDlexAQ+b2EksFUJ4jDWnDp02eAaxk/xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Brent Lu <brent.lu@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 141/879] ASoC: Intel: sof_ssp_amp: fix no DMIC BE Link on Chromebooks
Date:   Tue,  7 Jun 2022 18:54:19 +0200
Message-Id: <20220607165006.798317953@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brent Lu <brent.lu@intel.com>

[ Upstream commit d1c808765deb2bcd35d827402ed4d75d068aae18 ]

The SOF topology supports 2 BE Links(dmic01 and dmic16k) and each
link supports up to four DMICs. However, Chromebook does not implement
ACPI NHLT table so the mach->mach_params.dmic_num is always zero. We
add a quirk so machine driver knows it's running on a Chromebook and
need to create BE Links for DMIC.

Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Brent Lu <brent.lu@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220509170922.54868-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_ssp_amp.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/boards/sof_ssp_amp.c b/sound/soc/intel/boards/sof_ssp_amp.c
index 88530e9de543..ef70c6f27fe1 100644
--- a/sound/soc/intel/boards/sof_ssp_amp.c
+++ b/sound/soc/intel/boards/sof_ssp_amp.c
@@ -9,6 +9,7 @@
 
 #include <linux/acpi.h>
 #include <linux/delay.h>
+#include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <sound/core.h>
@@ -78,6 +79,16 @@ struct sof_card_private {
 	bool idisp_codec;
 };
 
+static const struct dmi_system_id chromebook_platforms[] = {
+	{
+		.ident = "Google Chromebooks",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
+		}
+	},
+	{},
+};
+
 static const struct snd_soc_dapm_widget sof_ssp_amp_dapm_widgets[] = {
 	SND_SOC_DAPM_MIC("SoC DMIC", NULL),
 };
@@ -371,7 +382,7 @@ static int sof_ssp_amp_probe(struct platform_device *pdev)
 	struct snd_soc_dai_link *dai_links;
 	struct snd_soc_acpi_mach *mach;
 	struct sof_card_private *ctx;
-	int dmic_be_num, hdmi_num = 0;
+	int dmic_be_num = 0, hdmi_num = 0;
 	int ret, ssp_codec;
 
 	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
@@ -383,7 +394,8 @@ static int sof_ssp_amp_probe(struct platform_device *pdev)
 
 	mach = pdev->dev.platform_data;
 
-	dmic_be_num = mach->mach_params.dmic_num;
+	if (dmi_check_system(chromebook_platforms) || mach->mach_params.dmic_num > 0)
+		dmic_be_num = 2;
 
 	ssp_codec = sof_ssp_amp_quirk & SOF_AMPLIFIER_SSP_MASK;
 
-- 
2.35.1



