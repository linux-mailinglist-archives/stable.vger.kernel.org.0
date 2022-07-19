Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517FF579EDF
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242610AbiGSNHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242566AbiGSNG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:06:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B961B9A06;
        Tue, 19 Jul 2022 05:27:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E921360908;
        Tue, 19 Jul 2022 12:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BC8C341C6;
        Tue, 19 Jul 2022 12:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233639;
        bh=c2vRCdCE/w30i27ikE5xtULEsIKmoQzS+QUEF+S9oEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0DSQcWeN/5pDQ9Br0q7B83xsLgJQLCSMWXamcFJ1xitbhgy/Cma1Y0RHtuteurdR
         hvUqM7uBci9fo0Fcg7I2RJARKPL9HAsjAFeIiyffrPX6Et+vF0fcHQeQt8z27N96mc
         URASLrWhp+yjVe62cnnU/6uZV77S666TUNoPfUeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 191/231] ASoC: SOF: Intel: hda-dsp: Expose hda_dsp_core_power_up()
Date:   Tue, 19 Jul 2022 13:54:36 +0200
Message-Id: <20220719114730.222766233@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 196494ba1245..db066d094afa 100644
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



