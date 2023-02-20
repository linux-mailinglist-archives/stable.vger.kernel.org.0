Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE7169C999
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 12:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbjBTLSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 06:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbjBTLSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 06:18:12 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6545C6A7A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 03:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676891875; x=1708427875;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VsJRm2lzSODecEFJUfZ3q0dGV7Yw8mvC8iNuWfHwosk=;
  b=jl3D6F8Vpoy1mwh/xVWuB3gGNlAUV96hiuyXjEquoXS+NTb2u82dYNsO
   qThr3pB4In0z908rj3SRu+r+vRgpnr4HEIWUUZVBQdcmNU5q2uHC7z1fZ
   IoFyqiaLOYBVmls9pTOebmh5ZoLm1TF4OcEIMx3LS26uRzQ9tvIEoYJSA
   8NWy9Dxg7ME0Ja4iLtYpoHXYOviiL9y/TetAm9G+RVC4dLk7vaDvAJZTN
   o5UAk2q6jwJS/PZYi/9Ix+tlyckhbuUD0fxInB+yBwpqLqMo/JzLoCXAm
   h7rpboBUuqsAlGu2OtjpF7DRXV8PD3fJ6zU3Hy8dx3MGWjO8UBnnjtjwi
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10626"; a="333739471"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; 
   d="scan'208";a="333739471"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 03:16:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10626"; a="795150943"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; 
   d="scan'208";a="795150943"
Received: from mmocanu-mobl1.ger.corp.intel.com (HELO pujfalus-desk.ger.corp.intel.com) ([10.251.214.33])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 03:16:55 -0800
From:   Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     sashal@kernel.org, broonie@kernel.org, alsa-devel@alsa-project.org,
        pierre-louis.bossart@linux.intel.com,
        ranjani.sridharan@linux.intel.com, gregkh@linuxfoundation.org
Subject: [PATCH BACKPORT 5.10, 5.15] ASoC: SOF: Intel: hda-dai: fix possible stream_tag leak
Date:   Mon, 20 Feb 2023 13:17:10 +0200
Message-Id: <20230220111710.32438-1-peter.ujfalusi@linux.intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1f810d2b6b2fbdc5279644d8b2c140b1f7c9d43d ]

There were just too many code changes since 5.10/5.15 stable to prevent
clean picking the fix from mainline.

The HDaudio stream allocation is done first, and in a second step the
LOSIDV parameter is programmed for the multi-link used by a codec.

This leads to a possible stream_tag leak, e.g. if a DisplayAudio link
is not used. This would happen when a non-Intel graphics card is used
and userspace unconditionally uses the Intel Display Audio PCMs without
checking if they are connected to a receiver with jack controls.

We should first check that there is a valid multi-link entry to
configure before allocating a stream_tag. This change aligns the
dma_assign and dma_cleanup phases.

Cc: stable@vger.kernel.org # 5.15.x 5.10.x
Complements: b0cd60f3e9f5 ("ALSA/ASoC: hda: clarify bus_get_link() and bus_link_get() helpers")
Link: https://github.com/thesofproject/linux/issues/4151
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230216162340.19480-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/sof/intel/hda-dai.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index de80f1b3d7f2..a6275cc92a40 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -212,6 +212,10 @@ static int hda_link_hw_params(struct snd_pcm_substream *substream,
 	int stream_tag;
 	int ret;
 
+	link = snd_hdac_ext_bus_get_link(bus, codec_dai->component->name);
+	if (!link)
+		return -EINVAL;
+
 	/* get stored dma data if resuming from system suspend */
 	link_dev = snd_soc_dai_get_dma_data(dai, substream);
 	if (!link_dev) {
@@ -232,10 +236,6 @@ static int hda_link_hw_params(struct snd_pcm_substream *substream,
 	if (ret < 0)
 		return ret;
 
-	link = snd_hdac_ext_bus_get_link(bus, codec_dai->component->name);
-	if (!link)
-		return -EINVAL;
-
 	/* set the hdac_stream in the codec dai */
 	snd_soc_dai_set_stream(codec_dai, hdac_stream(link_dev), substream->stream);
 
-- 
2.39.2

