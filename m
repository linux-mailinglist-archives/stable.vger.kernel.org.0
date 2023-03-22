Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC576C55B5
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjCVUAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbjCVT7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 15:59:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4A057091;
        Wed, 22 Mar 2023 12:58:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68E78622B2;
        Wed, 22 Mar 2023 19:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DFDC433EF;
        Wed, 22 Mar 2023 19:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515093;
        bh=O/mOkDZ/o5RV/YSv+1yrLgRr2ghtm1kQQ5uzPclGIAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gpzf8q0wD2Wx2Rmxw+F8Zuj2vsuibPmY+6A4e0Afy4Vz097/z4nl3vq9DqMTJ89Sv
         ZmjhUVT2cs/IIGugnirabAIPN2z9HqbSEb1+1gcOGL/kNVUkd6oL4F87WIzCp/pQI1
         AcDleaND9NiFP2M6KoropgWpdrd4B3HVUUBmj4dPSMoQuuL6kfoJCiHv2vgePc2Cro
         o839pQHli9MIiRD8qfx5/0g85yiv1CEgCtlptdzZhlNRg/AXOz97YVDjOAnt/FWLBw
         guZDrLqAFwjL4G9EbRX5DYcKc88TWndpTS9versDMttOcOqvHNHlLCI1tE6cMmJtKC
         yzcT+raajwO9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rander Wang <rander.wang@intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        yung-chuan.liao@linux.intel.com, daniel.baluta@nxp.com,
        perex@perex.cz, tiwai@suse.com, kai.vehmanen@linux.intel.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.2 17/45] ASoC: SOF: Intel: hda-dsp: harden D0i3 programming sequence
Date:   Wed, 22 Mar 2023 15:56:11 -0400
Message-Id: <20230322195639.1995821-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rander Wang <rander.wang@intel.com>

[ Upstream commit 52a55779ed14792a150421339664193d6eb8e036 ]

Add delay between set and wait command according to hardware programming
sequence. Also add debug log to detect error.

Signed-off-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307095453.3719-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dsp.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/sof/intel/hda-dsp.c b/sound/soc/sof/intel/hda-dsp.c
index b4eacae8564c8..6b2094f74c9c0 100644
--- a/sound/soc/sof/intel/hda-dsp.c
+++ b/sound/soc/sof/intel/hda-dsp.c
@@ -399,6 +399,12 @@ static int hda_dsp_update_d0i3c_register(struct snd_sof_dev *sdev, u8 value)
 	snd_sof_dsp_update8(sdev, HDA_DSP_HDA_BAR, chip->d0i3_offset,
 			    SOF_HDA_VS_D0I3C_I3, value);
 
+	/*
+	 * The value written to the D0I3C::I3 bit may not be taken into account immediately.
+	 * A delay is recommended before checking if D0I3C::CIP is cleared
+	 */
+	usleep_range(30, 40);
+
 	/* Wait for cmd in progress to be cleared before exiting the function */
 	ret = hda_dsp_wait_d0i3c_done(sdev);
 	if (ret < 0) {
@@ -407,6 +413,12 @@ static int hda_dsp_update_d0i3c_register(struct snd_sof_dev *sdev, u8 value)
 	}
 
 	reg = snd_sof_dsp_read8(sdev, HDA_DSP_HDA_BAR, chip->d0i3_offset);
+	/* Confirm d0i3 state changed with paranoia check */
+	if ((reg ^ value) & SOF_HDA_VS_D0I3C_I3) {
+		dev_err(sdev->dev, "failed to update D0I3C!\n");
+		return -EIO;
+	}
+
 	trace_sof_intel_D0I3C_updated(sdev, reg);
 
 	return 0;
-- 
2.39.2

