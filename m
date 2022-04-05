Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F4C4F2785
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbiDEIHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbiDEIAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:00:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143CEB48;
        Tue,  5 Apr 2022 00:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A708B61668;
        Tue,  5 Apr 2022 07:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CF2C340EE;
        Tue,  5 Apr 2022 07:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145455;
        bh=jnIWHDgOZkh/R09nfdNYG2FZyVhHJZY2eXP9w+iXCQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TEDtbmEdA1ui/UJlEpvGyF3eob33/wPVehj667KNWrpocUfEayPi7tI3CGOZBaZRG
         lW2vm2YLA4nXS72w4P5UQSTZGcymUjjAFW/DFLp82mbQm9ldhLFT8qlMapyY+LRZry
         xWWtQyDDbAEel3lqmYXupdjOi9fpkQb4813EXp6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0384/1126] ASoC: soc-compress: prevent the potentially use of null pointer
Date:   Tue,  5 Apr 2022 09:18:51 +0200
Message-Id: <20220405070418.897681538@linuxfoundation.org>
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
index 8e2494a9f3a7..f4b376a71be8 100644
--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -568,12 +568,14 @@ int snd_soc_new_compress(struct snd_soc_pcm_runtime *rtd, int num)
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



