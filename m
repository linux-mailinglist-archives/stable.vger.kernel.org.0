Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D66C59463D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351540AbiHOWsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352127AbiHOWry (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:47:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25269135AEB;
        Mon, 15 Aug 2022 12:53:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DB83B81142;
        Mon, 15 Aug 2022 19:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732B8C433D7;
        Mon, 15 Aug 2022 19:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593205;
        bh=T42vtNvZmfSxu+bANyz8LMcHBQaRj4p58WGreN/apcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQiGIVoODbvERF3HwuD1il+ULip4uAdR6ihoWydV6veR+i4WUI1d4KZIgkpU4XY0l
         yknOlajUhtY4A5TiyKYvxkUt9KplWN6akYkvry+k93L+zUQyPKsEfRoOCI8A9oie3F
         5KDvRstWONLuWDJrfrYiJlhSssYPvalpbIeeTVl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0911/1095] ASoC: Intel: sof_rt5682: Perform quirk check first in card late probe
Date:   Mon, 15 Aug 2022 20:05:10 +0200
Message-Id: <20220815180506.966324573@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Yong Zhi <yong.zhi@intel.com>

[ Upstream commit 371a3f01fc1862c23fae35cb2c98ffb2eec143f1 ]

The check of sof_rt5682_quirk should not be skipped unless the HDMI
handling code exits with error, fix by moving the quirk check to the front.

Fixes: 94d2d0897474 ("ASoC: Intel: Boards: tgl_max98373: add dai_trigger function")
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220725194909.145418-10-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_rt5682.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/sound/soc/intel/boards/sof_rt5682.c b/sound/soc/intel/boards/sof_rt5682.c
index 7126fcb63d90..d9f83b04be87 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -435,6 +435,15 @@ static int sof_card_late_probe(struct snd_soc_card *card)
 	int err;
 	int i = 0;
 
+	if (sof_rt5682_quirk & SOF_MAX98373_SPEAKER_AMP_PRESENT) {
+		/* Disable Left and Right Spk pin after boot */
+		snd_soc_dapm_disable_pin(dapm, "Left Spk");
+		snd_soc_dapm_disable_pin(dapm, "Right Spk");
+		err = snd_soc_dapm_sync(dapm);
+		if (err < 0)
+			return err;
+	}
+
 	/* HDMI is not supported by SOF on Baytrail/CherryTrail */
 	if (is_legacy_cpu || !ctx->idisp_codec)
 		return 0;
@@ -468,15 +477,6 @@ static int sof_card_late_probe(struct snd_soc_card *card)
 		i++;
 	}
 
-	if (sof_rt5682_quirk & SOF_MAX98373_SPEAKER_AMP_PRESENT) {
-		/* Disable Left and Right Spk pin after boot */
-		snd_soc_dapm_disable_pin(dapm, "Left Spk");
-		snd_soc_dapm_disable_pin(dapm, "Right Spk");
-		err = snd_soc_dapm_sync(dapm);
-		if (err < 0)
-			return err;
-	}
-
 	return hdac_hdmi_jack_port_init(component, &card->dapm);
 }
 
-- 
2.35.1



