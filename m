Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2770063DE42
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiK3SfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiK3SfK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:35:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003DE2611F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:35:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 900C361D6A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889D1C433D6;
        Wed, 30 Nov 2022 18:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833309;
        bh=+cC/2A0O1a+NCRlywGAt4AB719e1jYGnJMf/hFAt0po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kfwS8HFXRAw1zIe2CQ45vj81HP/GrcZypIpD+vI+CgzSev80CEtyjDjmEcobrzGHy
         T19/TTXpEm6wEUJveg4W94U7yxL0iaU8SQFznU0X3zd5xiLa4rtawpvtR4mVt7xCiv
         D6yfmsDYdMFciK844pNi0qRc9uSOMZKeB2eh6rXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/206] ASoC: soc-pcm: Dont zero TDM masks in __soc_pcm_open()
Date:   Wed, 30 Nov 2022 19:21:53 +0100
Message-Id: <20221130180534.554967684@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 39bd801d6908900e9ab0cdc2655150f95ddd4f1a ]

The DAI tx_mask and rx_mask are set by snd_soc_dai_set_tdm_slot()
and used by later code that depends on the TDM settings. So
__soc_pcm_open() should not be obliterating those mask values.

The code in __soc_pcm_hw_params() uses these masks to calculate the
active channels so that only the AIF_IN/AIF_OUT widgets for the
active TDM slots are enabled. The zeroing of the masks in
__soc_pcm_open() disables this functionality so all AIF widgets
were enabled even for channels that are not assigned to a TDM slot.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 2e5894d73789 ("ASoC: pcm: Add support for DAI multicodec")
Link: https://lore.kernel.org/r/20221104132213.121847-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 48f71bb81a2f..f6dc71e8ea87 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -759,11 +759,6 @@ static int soc_pcm_open(struct snd_pcm_substream *substream)
 		ret = snd_soc_dai_startup(dai, substream);
 		if (ret < 0)
 			goto err;
-
-		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-			dai->tx_mask = 0;
-		else
-			dai->rx_mask = 0;
 	}
 
 	/* Dynamic PCM DAI links compat checks use dynamic capabilities */
-- 
2.35.1



