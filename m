Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D80574261
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbiGNEYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234349AbiGNEXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:23:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB302870C;
        Wed, 13 Jul 2022 21:22:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BB24B82373;
        Thu, 14 Jul 2022 04:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263A0C36AE2;
        Thu, 14 Jul 2022 04:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772566;
        bh=UpQ/PiWTfgffrul+4T3wofLjGERA+VhB84Fv6WEr838=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AF+qLsVYO5U36JlcR9SornLMYDsaHT45SYmaLCM9wFg9416bUBV+VJpJiNIvn+HUZ
         8mDUlsySbH1Cw0EgkytlMFYhQfiDiLth90Rh8MiLbfUqYoJPvcvC7kLbISX/9aOUA7
         5wICy0BWGpRbT+BxokbK7sVUlN0KzExvxWnhGZNLYZFmWhnfpDOxADZ6JglYzhuuUb
         td2c9xKJf0nluRCLQQUlgJP7EXlg/RsOB8Tothp6M+3oRmRwT4Xzt7WCfl/uv8cJIq
         mOmyOOcRrpMx5l/LWvQ/hCLwR1WQcR51j5nVJ3rbu4JrEdQFyPFI/oCCtcoZM9A5lp
         HnA4bBig21emA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        daniel.baluta@nxp.com, perex@perex.cz, tiwai@suse.com,
        kai.vehmanen@linux.intel.com,
        guennadi.liakhovetski@linux.intel.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 09/41] ASoC: SOF: Intel: hda-dsp: Expose hda_dsp_core_power_up()
Date:   Thu, 14 Jul 2022 00:21:49 -0400
Message-Id: <20220714042221.281187-9-sashal@kernel.org>
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

[ Upstream commit 08f8a93198e300dff9649bbae424cd805d313326 ]

The hda_dsp_core_power_up() needs to be exposed so that it can be used in
hda-loader.c to correct the boot flow.
The first step must not unstall the core, it should only power up the
core(s).

Add sanity check for the core_mask while exposing it to be safe.

Complements: 2a68ff846164 ("ASoC: SOF: Intel: hda: Revisit IMR boot sequence")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20220609085949.29062-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dsp.c | 10 +++++++++-
 sound/soc/sof/intel/hda.h     |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda-dsp.c b/sound/soc/sof/intel/hda-dsp.c
index 8ddde60c56b3..68a8074c956a 100644
--- a/sound/soc/sof/intel/hda-dsp.c
+++ b/sound/soc/sof/intel/hda-dsp.c
@@ -181,12 +181,20 @@ int hda_dsp_core_run(struct snd_sof_dev *sdev, unsigned int core_mask)
  * Power Management.
  */
 
-static int hda_dsp_core_power_up(struct snd_sof_dev *sdev, unsigned int core_mask)
+int hda_dsp_core_power_up(struct snd_sof_dev *sdev, unsigned int core_mask)
 {
+	struct sof_intel_hda_dev *hda = sdev->pdata->hw_pdata;
+	const struct sof_intel_dsp_desc *chip = hda->desc;
 	unsigned int cpa;
 	u32 adspcs;
 	int ret;
 
+	/* restrict core_mask to host managed cores mask */
+	core_mask &= chip->host_managed_cores_mask;
+	/* return if core_mask is not valid */
+	if (!core_mask)
+		return 0;
+
 	/* update bits */
 	snd_sof_dsp_update_bits(sdev, HDA_DSP_BAR, HDA_DSP_REG_ADSPCS,
 				HDA_DSP_ADSPCS_SPA_MASK(core_mask),
diff --git a/sound/soc/sof/intel/hda.h b/sound/soc/sof/intel/hda.h
index 05e5e158614a..b80fa5c77cf7 100644
--- a/sound/soc/sof/intel/hda.h
+++ b/sound/soc/sof/intel/hda.h
@@ -490,6 +490,7 @@ struct sof_intel_hda_stream {
  */
 int hda_dsp_probe(struct snd_sof_dev *sdev);
 int hda_dsp_remove(struct snd_sof_dev *sdev);
+int hda_dsp_core_power_up(struct snd_sof_dev *sdev, unsigned int core_mask);
 int hda_dsp_core_run(struct snd_sof_dev *sdev, unsigned int core_mask);
 int hda_dsp_enable_core(struct snd_sof_dev *sdev, unsigned int core_mask);
 int hda_dsp_core_reset_power_down(struct snd_sof_dev *sdev,
-- 
2.35.1

