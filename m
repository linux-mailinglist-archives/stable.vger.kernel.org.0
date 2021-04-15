Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F513609AB
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 14:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhDOMpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 08:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232675AbhDOMpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 08:45:06 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F76DC061756
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 05:44:42 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id j18so39047002lfg.5
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 05:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QTZuOLyTeSPqIxpmQtTpEHkmOSrRy44Y0KTmGLHsQTA=;
        b=KBMvfITJ6P1GJl3X+OkppIQD4G7uFHtheljIHTq0mOPMl/1ji4DLUkXc5yDJp0wy3/
         0w/SUUMyyxBFbPW/XYzjkinIvEXA/usUJSZuAKalmXOWKJD0c43ztneuZToJ+KVByU7t
         lr0TTWpnZbIwRpXA7U6/ELvRgiYAcbm+nezEqjjCwDyPPveS9APdAE67+CqWFA/F+cc1
         cLqPICHZlo4+GJXjzewKHWtwuTkCe1t9xCaVoBTMy4hiBFfYSmll7QW0mnBF3zg+FHEl
         UnoyygocULl7tMQvPwSvHqBrcFTXKY4/V9HoOgcfRRCN6CRc6T99OOsp5P6hQa6WQaJ3
         bFYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QTZuOLyTeSPqIxpmQtTpEHkmOSrRy44Y0KTmGLHsQTA=;
        b=pGempkI0xWTrsHKadR++7HdFEVFg6hb2+t88JrmxjEOS4q5hsWGAMhPniCviu3rlPE
         PrJStftrCwMiTxz2GZqeFKVd0HTSSs08Ok8xsZYIWRt3iVUKr4vb31kcfQu5NtUNfoHv
         PMPje6b6nv5JrSs6WcwqJm+SRcJnUCu+dNx1lIRCBYU/3Wjfk+YgqrDvokQMY2ACG+XN
         9ot0xSi+V34SaBBhFr+BrzomJSw68dxqTRcQ93a1sHLEmMmh5sOCGo5FdaCRhLjHXZCq
         YcTzo+FDdwAW6KQVcY2ZrOKvdRW8CIXf5xz/LiAS0kFNFOVhIWOvo98ra/rM9y3GV4fG
         kDmA==
X-Gm-Message-State: AOAM5326sdaHT8QjGNbBSHZk+Lyeoi56mYE7DJNMyR5ifmVcGYCL/N3n
        lkVcm04M72plteExkIghLmLX7A==
X-Google-Smtp-Source: ABdhPJx/JsoSsokvTGNO9NBxDRpe6VnMzzOOJdkz0CEWSlLS/dpp0SisW5W3I7anbKMDuXCfS726lg==
X-Received: by 2002:a05:6512:c02:: with SMTP id z2mr2522381lfu.595.1618490680625;
        Thu, 15 Apr 2021 05:44:40 -0700 (PDT)
Received: from localhost.localdomain (89-70-221-122.dynamic.chello.pl. [89.70.221.122])
        by smtp.gmail.com with ESMTPSA id j2sm667820lfm.210.2021.04.15.05.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 05:44:40 -0700 (PDT)
From:   Lukasz Majczak <lma@semihalf.com>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Harsha Priya <harshapriya.n@intel.com>,
        Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>
Cc:     upstream@semihalf.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v1] ASoC: Intel: kbl_da7219_max98927: Fix kabylake_ssp_fixup function
Date:   Thu, 15 Apr 2021 14:43:47 +0200
Message-Id: <20210415124347.475432-1-lma@semihalf.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

kabylake_ssp_fixup function uses snd_soc_dpcm to identify the
codecs DAIs. The HW parameters are changed based on the codec DAI of the
stream. The earlier approach to get snd_soc_dpcm was using container_of()
macro on snd_pcm_hw_params.

The structures have been modified over time and snd_soc_dpcm does not have
snd_pcm_hw_params as a reference but as a copy. This causes the current
driver to crash when used.

This patch changes the way snd_soc_dpcm is extracted. snd_soc_pcm_runtime
holds 2 dpcm instances (one for playback and one for capture). 2 codecs
on the SSP are dmic (capture) and speakers (playback). Based on the
stream direction, snd_soc_dpcm is extracted from snd_soc_pcm_runtime.

Tested for all use cases of the driver.
Based on similar fix in kbl_rt5663_rt5514_max98927.c
from Harsha Priya <harshapriya.n@intel.com> and
Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>

Cc: <stable@vger.kernel.org> # 5.4+
Signed-off-by: Lukasz Majczak <lma@semihalf.com>
---
Hi,
This is basically a cherry-pick of this change:
https://patchwork.kernel.org/project/alsa-devel/patch/1595432147-11166-1-git-send-email-harshapriya.n@intel.com/
just applied to the kbl_da7219_max98927.
Best regards,
Lukasz

 sound/soc/intel/boards/kbl_da7219_max98927.c | 38 +++++++++++++++-----
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/sound/soc/intel/boards/kbl_da7219_max98927.c b/sound/soc/intel/boards/kbl_da7219_max98927.c
index 9dfe5bd9180d..4b7b4a044f81 100644
--- a/sound/soc/intel/boards/kbl_da7219_max98927.c
+++ b/sound/soc/intel/boards/kbl_da7219_max98927.c
@@ -284,11 +284,33 @@ static int kabylake_ssp_fixup(struct snd_soc_pcm_runtime *rtd,
 	struct snd_interval *chan = hw_param_interval(params,
 			SNDRV_PCM_HW_PARAM_CHANNELS);
 	struct snd_mask *fmt = hw_param_mask(params, SNDRV_PCM_HW_PARAM_FORMAT);
-	struct snd_soc_dpcm *dpcm = container_of(
-			params, struct snd_soc_dpcm, hw_params);
-	struct snd_soc_dai_link *fe_dai_link = dpcm->fe->dai_link;
-	struct snd_soc_dai_link *be_dai_link = dpcm->be->dai_link;
+	struct snd_soc_dpcm *dpcm, *rtd_dpcm = NULL;
 
+	/*
+	 * The following loop will be called only for playback stream
+	 * In this platform, there is only one playback device on every SSP
+	 */
+	for_each_dpcm_fe(rtd, SNDRV_PCM_STREAM_PLAYBACK, dpcm) {
+		rtd_dpcm = dpcm;
+		break;
+	}
+
+	/*
+	 * This following loop will be called only for capture stream
+	 * In this platform, there is only one capture device on every SSP
+	 */
+	for_each_dpcm_fe(rtd, SNDRV_PCM_STREAM_CAPTURE, dpcm) {
+		rtd_dpcm = dpcm;
+		break;
+	}
+
+	if (!rtd_dpcm)
+		return -EINVAL;
+
+	/*
+	 * The above 2 loops are mutually exclusive based on the stream direction,
+	 * thus rtd_dpcm variable will never be overwritten
+	 */
 	/*
 	 * Topology for kblda7219m98373 & kblmax98373 supports only S24_LE,
 	 * where as kblda7219m98927 & kblmax98927 supports S16_LE by default.
@@ -311,9 +333,9 @@ static int kabylake_ssp_fixup(struct snd_soc_pcm_runtime *rtd,
 	/*
 	 * The ADSP will convert the FE rate to 48k, stereo, 24 bit
 	 */
-	if (!strcmp(fe_dai_link->name, "Kbl Audio Port") ||
-	    !strcmp(fe_dai_link->name, "Kbl Audio Headset Playback") ||
-	    !strcmp(fe_dai_link->name, "Kbl Audio Capture Port")) {
+	if (!strcmp(rtd_dpcm->fe->dai_link->name, "Kbl Audio Port") ||
+	    !strcmp(rtd_dpcm->fe->dai_link->name, "Kbl Audio Headset Playback") ||
+	    !strcmp(rtd_dpcm->fe->dai_link->name, "Kbl Audio Capture Port")) {
 		rate->min = rate->max = 48000;
 		chan->min = chan->max = 2;
 		snd_mask_none(fmt);
@@ -324,7 +346,7 @@ static int kabylake_ssp_fixup(struct snd_soc_pcm_runtime *rtd,
 	 * The speaker on the SSP0 supports S16_LE and not S24_LE.
 	 * thus changing the mask here
 	 */
-	if (!strcmp(be_dai_link->name, "SSP0-Codec"))
+	if (!strcmp(rtd_dpcm->be->dai_link->name, "SSP0-Codec"))
 		snd_mask_set_format(fmt, SNDRV_PCM_FORMAT_S16_LE);
 
 	return 0;
-- 
2.25.1

