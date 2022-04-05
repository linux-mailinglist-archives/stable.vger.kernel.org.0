Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F774F3A4F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379169AbiDELk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354394AbiDEKOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAED692B9;
        Tue,  5 Apr 2022 02:59:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B6E961747;
        Tue,  5 Apr 2022 09:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4B5C385A1;
        Tue,  5 Apr 2022 09:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152794;
        bh=KkXa4M8bh9HoZxGTFoJrJ0d5+mzS+p1f1Yj8rGGIdko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rv4J1Sl8/KxMQqzTgq4l9NS2/Q+bGupBJiL5vy0DfFHpjcziAjMZNXsJ8xmJmfptK
         KvmbEO//dpX+BmhnwiIAmyeisO7hTscxJi2/NqUq0Bf4AHbr8ZNECaWdzcmZe8D56l
         gXUUHEjPPTbNrg+QE0yGslI2atSWCqUXTjLf24hU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 868/913] ASoC: soc-compress: Change the check for codec_dai
Date:   Tue,  5 Apr 2022 09:32:10 +0200
Message-Id: <20220405070405.841824016@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

commit ccb4214f7f2a8b75acf493f31128e464ee1a3536 upstream.

It should be better to reverse the check on codec_dai
and returned early in order to be easier to understand.

Fixes: de2c6f98817f ("ASoC: soc-compress: prevent the potentially use of null pointer")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220310030041.1556323-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-compress.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -534,16 +534,19 @@ int snd_soc_new_compress(struct snd_soc_
 		return -EINVAL;
 	}
 
-	/* check client and interface hw capabilities */
-	if (codec_dai) {
-		if (snd_soc_dai_stream_valid(codec_dai, SNDRV_PCM_STREAM_PLAYBACK) &&
-		    snd_soc_dai_stream_valid(cpu_dai,   SNDRV_PCM_STREAM_PLAYBACK))
-			playback = 1;
-		if (snd_soc_dai_stream_valid(codec_dai, SNDRV_PCM_STREAM_CAPTURE) &&
-		    snd_soc_dai_stream_valid(cpu_dai,   SNDRV_PCM_STREAM_CAPTURE))
-			capture = 1;
+	if (!codec_dai) {
+		dev_err(rtd->card->dev, "Missing codec\n");
+		return -EINVAL;
 	}
 
+	/* check client and interface hw capabilities */
+	if (snd_soc_dai_stream_valid(codec_dai, SNDRV_PCM_STREAM_PLAYBACK) &&
+	    snd_soc_dai_stream_valid(cpu_dai,   SNDRV_PCM_STREAM_PLAYBACK))
+		playback = 1;
+	if (snd_soc_dai_stream_valid(codec_dai, SNDRV_PCM_STREAM_CAPTURE) &&
+	    snd_soc_dai_stream_valid(cpu_dai,   SNDRV_PCM_STREAM_CAPTURE))
+		capture = 1;
+
 	/*
 	 * Compress devices are unidirectional so only one of the directions
 	 * should be set, check for that (xor)


