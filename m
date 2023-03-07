Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 234816AEF29
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbjCGSVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbjCGSUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:20:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DF6A8C7A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:14:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38C07B8184E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8677C433EF;
        Tue,  7 Mar 2023 18:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212885;
        bh=SUFcJfOu9dfoBU42QEpzSYyJPCJoenflbLERqEE+C+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdMzYr9X7a4vI7Moby0Dz3KaMJQxohgKl7oPmRKW7J5Bu9YP5z91ywJsQkiY5Xsyt
         IlciDSfA6zTR2UlZuWYicKCwCLSvkmmfgTRgBpYga6KN6W982QbW0P10YDqPWJFWSA
         mLCRSkzbr+syYp25ZZ6goTYG2LBA+LMVtaYE4e6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 328/885] ASoC: soc-compress.c: fixup private_data on snd_soc_new_compress()
Date:   Tue,  7 Mar 2023 17:54:22 +0100
Message-Id: <20230307170016.429892603@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit ffe4c0f0bfaa571a676a0e946d4a6a0607f94294 ]

commit d3268a40d4b19f ("ASoC: soc-compress.c: fix NULL dereference")
enables DPCM capture, but it should independent from playback.
This patch fixup it.

Fixes: d3268a40d4b1 ("ASoC: soc-compress.c: fix NULL dereference")
Link: https://lore.kernel.org/r/87tu0i6j7j.wl-kuninori.morimoto.gx@renesas.com
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/871qnkvo1s.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-compress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-compress.c b/sound/soc/soc-compress.c
index 870f13e1d389c..cb0ed2fea893a 100644
--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -623,7 +623,7 @@ int snd_soc_new_compress(struct snd_soc_pcm_runtime *rtd, int num)
 		rtd->fe_compr = 1;
 		if (rtd->dai_link->dpcm_playback)
 			be_pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream->private_data = rtd;
-		else if (rtd->dai_link->dpcm_capture)
+		if (rtd->dai_link->dpcm_capture)
 			be_pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream->private_data = rtd;
 		memcpy(compr->ops, &soc_compr_dyn_ops, sizeof(soc_compr_dyn_ops));
 	} else {
-- 
2.39.2



