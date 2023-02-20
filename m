Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40AD69C996
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 12:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbjBTLRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 06:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbjBTLRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 06:17:35 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D66D1ADD2
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 03:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676891835; x=1708427835;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rOMCxEo459LVKFnJiE2YpRPZKTpzgalBc7uTVfzETJE=;
  b=KC9TPcSzaRa+oDZJyETExFBNbl0STjAcU/ZAt07TP8LG178YCzCHv1aE
   xY2TkInAYF41Maha4qzU0bofMLuLFfwrXOCS3qXqBZ4AUoOzWql2bAKFk
   2jTTvvsHtcNSPY3ltuyGYrReWILJ0JfFpVfan6vixHqAPJRbdQa07c1bx
   OKa+nMlcpNdEzd78reWiu0CmWyih+IHmdUq1+spWOFDFowxyDnXC+WsaU
   JEicxBupPZr+OrZs3MQZKaB17fkuT4U2dq+AiVX/dtXrxxMwo1vU4Jc6i
   pKgQOw5EFXCJlUBl6vLUJfCTWOzZ4EmlltigfBlZCWbuIdRVEm0dFZZ6/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10626"; a="334578770"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; 
   d="scan'208";a="334578770"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 03:16:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10626"; a="814109139"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; 
   d="scan'208";a="814109139"
Received: from mmocanu-mobl1.ger.corp.intel.com (HELO pujfalus-desk.ger.corp.intel.com) ([10.251.214.33])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 03:16:43 -0800
From:   Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     sashal@kernel.org, broonie@kernel.org, alsa-devel@alsa-project.org,
        pierre-louis.bossart@linux.intel.com,
        ranjani.sridharan@linux.intel.com, gregkh@linuxfoundation.org
Subject: [PATCH BACKPORT 6.0, 6.1] ASoC: SOF: Intel: hda-dai: fix possible stream_tag leak
Date:   Mon, 20 Feb 2023 13:16:58 +0200
Message-Id: <20230220111658.32256-1-peter.ujfalusi@linux.intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1f810d2b6b2fbdc5279644d8b2c140b1f7c9d43d ]

The reason for manual backport is that in 6.2 there were a naming cleanup
around hdac, link, hlink, for example snd_hdac_ext_bus_get_link is renamed
to snd_hdac_ext_bus_get_hlink_by_name in 6.2.

The HDaudio stream allocation is done first, and in a second step the
LOSIDV parameter is programmed for the multi-link used by a codec.

This leads to a possible stream_tag leak, e.g. if a DisplayAudio link
is not used. This would happen when a non-Intel graphics card is used
and userspace unconditionally uses the Intel Display Audio PCMs without
checking if they are connected to a receiver with jack controls.

We should first check that there is a valid multi-link entry to
configure before allocating a stream_tag. This change aligns the
dma_assign and dma_cleanup phases.

Cc: stable@vger.kernel.org # 6.1.x 6.0.x
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
index 556e883a32ed..5f03ee390d54 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -216,6 +216,10 @@ static int hda_link_dma_hw_params(struct snd_pcm_substream *substream,
 	struct hdac_bus *bus = hstream->bus;
 	struct hdac_ext_link *link;
 
+	link = snd_hdac_ext_bus_get_link(bus, codec_dai->component->name);
+	if (!link)
+		return -EINVAL;
+
 	hext_stream = snd_soc_dai_get_dma_data(cpu_dai, substream);
 	if (!hext_stream) {
 		hext_stream = hda_link_stream_assign(bus, substream);
@@ -225,10 +229,6 @@ static int hda_link_dma_hw_params(struct snd_pcm_substream *substream,
 		snd_soc_dai_set_dma_data(cpu_dai, substream, (void *)hext_stream);
 	}
 
-	link = snd_hdac_ext_bus_get_link(bus, codec_dai->component->name);
-	if (!link)
-		return -EINVAL;
-
 	/* set the hdac_stream in the codec dai */
 	snd_soc_dai_set_stream(codec_dai, hdac_stream(hext_stream), substream->stream);
 
-- 
2.39.2

