Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA97769CE45
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbjBTN6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbjBTN6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:58:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FF71DBBF
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:57:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5493BB80D55
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965A7C4339B;
        Mon, 20 Feb 2023 13:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901411;
        bh=no4cdOodLPhePDBbb8ecaOeVYSnr/IvRvC8q+0Gr2Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vFzIIXRaaiGGwypJlKZ1FZK202P7tcHn7MxhjjPOFZMgcG6mG7lGfQNkAJ5yB4Q7G
         Iqb6+xs0DUR4y73U7CuyvZz4TxlaFuXgwqIENgicXOPmDqAhkkTqrt0Nmcy1giZWgz
         ixSzZ2VWMbneMBycZNlow0On9wstg/XIYlL6hHbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 55/57] ASoC: SOF: Intel: hda-dai: fix possible stream_tag leak
Date:   Mon, 20 Feb 2023 14:37:03 +0100
Message-Id: <20230220133551.293477057@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit 1f810d2b6b2fbdc5279644d8b2c140b1f7c9d43d upstream.

The HDaudio stream allocation is done first, and in a second step the
LOSIDV parameter is programmed for the multi-link used by a codec.

This leads to a possible stream_tag leak, e.g. if a DisplayAudio link
is not used. This would happen when a non-Intel graphics card is used
and userspace unconditionally uses the Intel Display Audio PCMs without
checking if they are connected to a receiver with jack controls.

We should first check that there is a valid multi-link entry to
configure before allocating a stream_tag. This change aligns the
dma_assign and dma_cleanup phases.

Complements: b0cd60f3e9f5 ("ALSA/ASoC: hda: clarify bus_get_link() and bus_link_get() helpers")
Link: https://github.com/thesofproject/linux/issues/4151
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230216162340.19480-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-dai.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -212,6 +212,10 @@ static int hda_link_hw_params(struct snd
 	int stream_tag;
 	int ret;
 
+	link = snd_hdac_ext_bus_get_link(bus, codec_dai->component->name);
+	if (!link)
+		return -EINVAL;
+
 	/* get stored dma data if resuming from system suspend */
 	link_dev = snd_soc_dai_get_dma_data(dai, substream);
 	if (!link_dev) {
@@ -232,10 +236,6 @@ static int hda_link_hw_params(struct snd
 	if (ret < 0)
 		return ret;
 
-	link = snd_hdac_ext_bus_get_link(bus, codec_dai->component->name);
-	if (!link)
-		return -EINVAL;
-
 	/* set the hdac_stream in the codec dai */
 	snd_soc_dai_set_stream(codec_dai, hdac_stream(link_dev), substream->stream);
 


