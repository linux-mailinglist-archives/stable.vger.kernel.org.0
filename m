Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6E74F276A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbiDEIGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235685AbiDEIAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:00:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09EFB99;
        Tue,  5 Apr 2022 00:57:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F999B81B16;
        Tue,  5 Apr 2022 07:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1F7C340EE;
        Tue,  5 Apr 2022 07:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145452;
        bh=9La6SCa3iEbbtNO240Hq3u7J4ewuMmRoXHaWBmYfpBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kH8M+69NOH8cdc+STBFiDX9Pa8Gb1yX2t8wgqHG9JNzi8hZoaryFP+1/lkRTgKkqW
         WvosxXljeIMGl/ndzb4aOJJgcN2na/byCQiywCcbWMHgup2GnzBWtQFlFJhKELZwLb
         M0IJowjDWuCGqqkr23JzdVQ8jHwE8DSWxdN5SiPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0410/1126] ASoC: SOF: Intel: enable DMI L1 for playback streams
Date:   Tue,  5 Apr 2022 09:19:17 +0200
Message-Id: <20220405070419.660157365@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit a174e72e2355b9025205b4b6727bf43047eac6c6 ]

Add back logic to mark all playback streams as L1 compatible.

Fixes: 246dd4287dfb ("ASoC: SOF: Intel: make DMI L1 selection more robust")
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220310171651.249385-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-pcm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/intel/hda-pcm.c b/sound/soc/sof/intel/hda-pcm.c
index d78aa5d8552d..8aeb00eacd21 100644
--- a/sound/soc/sof/intel/hda-pcm.c
+++ b/sound/soc/sof/intel/hda-pcm.c
@@ -315,6 +315,7 @@ int hda_dsp_pcm_open(struct snd_sof_dev *sdev,
 		runtime->hw.info &= ~SNDRV_PCM_INFO_PAUSE;
 
 	if (hda_always_enable_dmi_l1 ||
+	    direction == SNDRV_PCM_STREAM_PLAYBACK ||
 	    spcm->stream[substream->stream].d0i3_compatible)
 		flags |= SOF_HDA_STREAM_DMI_L1_COMPATIBLE;
 
-- 
2.34.1



