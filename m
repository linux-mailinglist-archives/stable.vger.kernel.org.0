Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF04574283
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbiGNEZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbiGNEYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:24:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E35429CA3;
        Wed, 13 Jul 2022 21:23:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AE0E61E1C;
        Thu, 14 Jul 2022 04:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C398C34114;
        Thu, 14 Jul 2022 04:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772584;
        bh=U3MgG21b5SazhZDFf0lLfuAYMuBp9MqEc7e1BPZoKXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=incIr6Yb1kuIym+Onkrklx4Szpjn16g6ilN8ivXHMdD2QvOCPshbDhS81FJfPjA8+
         Q3M1AEOcur2TiLx5vX1aeKJEuQRfiRq4yZG1O4DKSM2mzsKRwlO9IkddV0vI9f7j01
         dR4Adp6grI9N/98j9i+5uod+1bMXywG9KpvjdQarTpSjw484MWEy/PbH0nO92GFEH9
         s3o8TvtFd1LaAAYZXzO8AXBP/CglQ/+WYhgzHxsiByJ0FID6S9JVGqTu8wrj0Dv005
         zGNumtGEx8cUsv27Z20yWnQzPDWCnLFhe2nYUM1eMIvYGsNZj2jAj2DVDGmratLICa
         Tcx+z+wQauUYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, peter.ujfalusi@linux.intel.com,
        yung-chuan.liao@linux.intel.com, ranjani.sridharan@linux.intel.com,
        kai.vehmanen@linux.intel.com, perex@perex.cz, tiwai@suse.com,
        akihiko.odaki@gmail.com, Julia.Lawall@inria.fr,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 15/41] ASoC: Intel: bytcr_wm5102: Fix GPIO related probe-ordering problem
Date:   Thu, 14 Jul 2022 00:21:55 -0400
Message-Id: <20220714042221.281187-15-sashal@kernel.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 4e07479eab8a044cc9542414ccb4aeb8eb033bde ]

The "wlf,spkvdd-ena" GPIO needed by the bytcr_wm5102 driver
is made available through a gpio-lookup table.

This gpio-lookup table is registered by drivers/mfd/arizona-spi.c, which
may get probed after the bytcr_wm5102 driver.

If the gpio-lookup table has not registered yet then the gpiod_get()
will return -ENOENT. Treat -ENOENT as -EPROBE_DEFER to still keep
things working in this case.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220612155652.107310-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_wm5102.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/boards/bytcr_wm5102.c b/sound/soc/intel/boards/bytcr_wm5102.c
index 8d8e96e3cd2d..f6d0cef1b28c 100644
--- a/sound/soc/intel/boards/bytcr_wm5102.c
+++ b/sound/soc/intel/boards/bytcr_wm5102.c
@@ -421,8 +421,17 @@ static int snd_byt_wm5102_mc_probe(struct platform_device *pdev)
 	priv->spkvdd_en_gpio = gpiod_get(codec_dev, "wlf,spkvdd-ena", GPIOD_OUT_LOW);
 	put_device(codec_dev);
 
-	if (IS_ERR(priv->spkvdd_en_gpio))
-		return dev_err_probe(dev, PTR_ERR(priv->spkvdd_en_gpio), "getting spkvdd-GPIO\n");
+	if (IS_ERR(priv->spkvdd_en_gpio)) {
+		ret = PTR_ERR(priv->spkvdd_en_gpio);
+		/*
+		 * The spkvdd gpio-lookup is registered by: drivers/mfd/arizona-spi.c,
+		 * so -ENOENT means that arizona-spi hasn't probed yet.
+		 */
+		if (ret == -ENOENT)
+			ret = -EPROBE_DEFER;
+
+		return dev_err_probe(dev, ret, "getting spkvdd-GPIO\n");
+	}
 
 	/* override platform name, if required */
 	byt_wm5102_card.dev = dev;
-- 
2.35.1

