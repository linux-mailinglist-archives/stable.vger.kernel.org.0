Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BBF4F30BA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355461AbiDEKT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345297AbiDEJWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:22:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91372BB18;
        Tue,  5 Apr 2022 02:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCAA3B81A12;
        Tue,  5 Apr 2022 09:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C26C385A2;
        Tue,  5 Apr 2022 09:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149815;
        bh=hpbWX8YBC6s4oo45QHF2m7r8EsVxECiMVkMLp+Qwi3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aC6G91vk1Uhlq/gGclet39VO0a6a2olxo5y4P01VDLLN/HOgh4NcHvHiMv3pZbkyF
         IeVOJAa4gmcAa5N+qaghBmP1lfrhbCuUpwxD1pIAIgSo9uzvVSuuCiY00RVFmnHFGW
         4bDA9XFkimBt96XjUXuIyi4ASIudsxDs3jhyFsQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0852/1017] ASoC: Intel: sof_es8336: log all quirks
Date:   Tue,  5 Apr 2022 09:29:25 +0200
Message-Id: <20220405070419.527635255@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

[ Upstream commit 9c818d849192491a8799b1cb14ca0f7aead4fb09 ]

We only logged the SSP quirk, make sure the GPIO and DMIC quirks are
exposed.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220308192610.392950-16-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_es8336.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 46e453915f82..764560439d46 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -63,7 +63,12 @@ static const struct acpi_gpio_mapping *gpio_mapping = acpi_es8336_gpios;
 
 static void log_quirks(struct device *dev)
 {
-	dev_info(dev, "quirk SSP%ld",  SOF_ES8336_SSP_CODEC(quirk));
+	dev_info(dev, "quirk mask %#lx\n", quirk);
+	dev_info(dev, "quirk SSP%ld\n",  SOF_ES8336_SSP_CODEC(quirk));
+	if (quirk & SOF_ES8336_ENABLE_DMIC)
+		dev_info(dev, "quirk DMIC enabled\n");
+	if (quirk & SOF_ES8336_TGL_GPIO_QUIRK)
+		dev_info(dev, "quirk TGL GPIO enabled\n");
 }
 
 static int sof_es8316_speaker_power_event(struct snd_soc_dapm_widget *w,
-- 
2.34.1



