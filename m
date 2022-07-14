Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E079C574322
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236911AbiGNEai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237079AbiGNE3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:29:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F45928E14;
        Wed, 13 Jul 2022 21:25:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5C6461E96;
        Thu, 14 Jul 2022 04:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA75CC34114;
        Thu, 14 Jul 2022 04:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772699;
        bh=/sX5PM90a21Ru7lX9KW7DDa/MPScR0rwjAmahjAtP5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nEzu94ORRCmPPb6ync3Dx8wx45qLyjIHGeaIvfuoQXRL6Rxpa2/l0pCzDPEhsPumf
         7kMqKOpr8kKdLvLqzxr17Dno2VTuUBLXitPyTD52csNnfIhZewn8Ge9UzjJzPUgIEW
         ZQ611HW2pXQ7VS6Ru33ltfuVLm2fSRqnozjdcmUih5raBsGxrr3yX21OgtqvdIJEnC
         2JqjmxYrfSehLIPqyzU8/lInGQDv0mnMMwVvjXFKhP4sH09nfg2qId0siBAEqKofMj
         g2+iG9HlxDaihvAK65+/l4uqr4vwUPTPT1yQlY1X5ceXoRKhb6kUGUxBrYQmKBcov8
         wY7fw2lxDjHrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, peter.ujfalusi@linux.intel.com,
        yung-chuan.liao@linux.intel.com, ranjani.sridharan@linux.intel.com,
        kai.vehmanen@linux.intel.com, perex@perex.cz, tiwai@suse.com,
        Julia.Lawall@inria.fr, akihiko.odaki@gmail.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 11/28] ASoC: Intel: bytcr_wm5102: Fix GPIO related probe-ordering problem
Date:   Thu, 14 Jul 2022 00:24:12 -0400
Message-Id: <20220714042429.281816-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042429.281816-1-sashal@kernel.org>
References: <20220714042429.281816-1-sashal@kernel.org>
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
index 580d5fddae5a..bb669d58eb8b 100644
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

