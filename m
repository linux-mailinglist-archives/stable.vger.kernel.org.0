Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5525013DE
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345025AbiDNNtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344328AbiDNNkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:40:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33828120;
        Thu, 14 Apr 2022 06:38:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 987A5CE29B0;
        Thu, 14 Apr 2022 13:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96A4C385A1;
        Thu, 14 Apr 2022 13:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943504;
        bh=WHqzE88lBVJT1xJ8LvBQh6M3R/S5kvHmeEmCJDIqYXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnJQU2qgiBIM0liQO2+I+2fiYWAHrdghxYFXbkbI4Q4gwTefEs6iDsthRjZVgc8SD
         aNJhv1AGnryAD4XDmub2wmjgeY+QvwBWxQ2LDVkLO55Yz2WXHdYGowOdLAadiXk64A
         B8ZBt2/YULvVMbpWho2rREasoYbF9c0AAcMMzLVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/475] ASoC: soc-compress: prevent the potentially use of null pointer
Date:   Thu, 14 Apr 2022 15:08:43 +0200
Message-Id: <20220414110859.010008924@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit de2c6f98817fa5decb9b7d3b3a8a3ab864c10588 ]

There is one call trace that snd_soc_register_card()
->snd_soc_bind_card()->soc_init_pcm_runtime()
->snd_soc_dai_compress_new()->snd_soc_new_compress().
In the trace the 'codec_dai' transfers from card->dai_link,
and we can see from the snd_soc_add_pcm_runtime() in
snd_soc_bind_card() that, if value of card->dai_link->num_codecs
is 0, then 'codec_dai' could be null pointer caused
by index out of bound in 'asoc_rtd_to_codec(rtd, 0)'.
And snd_soc_register_card() is called by various platforms.
Therefore, it is better to add the check in the case of misusing.
And because 'cpu_dai' has already checked in soc_init_pcm_runtime(),
there is no need to check again.
Adding the check as follow, then if 'codec_dai' is null,
snd_soc_new_compress() will not pass through the check
'if (playback + capture != 1)', avoiding the leftover use of
'codec_dai'.

Fixes: 467fece ("ASoC: soc-dai: move snd_soc_dai_stream_valid() to soc-dai.c")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/1634285633-529368-1-git-send-email-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-compress.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/soc/soc-compress.c b/sound/soc/soc-compress.c
index 9e54d8ae6d2c..fec736c8c45f 100644
--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -872,12 +872,14 @@ int snd_soc_new_compress(struct snd_soc_pcm_runtime *rtd, int num)
 	}
 
 	/* check client and interface hw capabilities */
-	if (snd_soc_dai_stream_valid(codec_dai, SNDRV_PCM_STREAM_PLAYBACK) &&
-	    snd_soc_dai_stream_valid(cpu_dai,   SNDRV_PCM_STREAM_PLAYBACK))
-		playback = 1;
-	if (snd_soc_dai_stream_valid(codec_dai, SNDRV_PCM_STREAM_CAPTURE) &&
-	    snd_soc_dai_stream_valid(cpu_dai,   SNDRV_PCM_STREAM_CAPTURE))
-		capture = 1;
+	if (codec_dai) {
+		if (snd_soc_dai_stream_valid(codec_dai, SNDRV_PCM_STREAM_PLAYBACK) &&
+		    snd_soc_dai_stream_valid(cpu_dai,   SNDRV_PCM_STREAM_PLAYBACK))
+			playback = 1;
+		if (snd_soc_dai_stream_valid(codec_dai, SNDRV_PCM_STREAM_CAPTURE) &&
+		    snd_soc_dai_stream_valid(cpu_dai,   SNDRV_PCM_STREAM_CAPTURE))
+			capture = 1;
+	}
 
 	/*
 	 * Compress devices are unidirectional so only one of the directions
-- 
2.34.1



