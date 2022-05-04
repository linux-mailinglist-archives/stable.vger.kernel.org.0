Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A97951A9A7
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356352AbiEDRSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357368AbiEDRPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5884C780;
        Wed,  4 May 2022 09:58:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5614B827A1;
        Wed,  4 May 2022 16:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CABEC385A4;
        Wed,  4 May 2022 16:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683499;
        bh=DjznMDAhNEc5QHd2KrCHEg4wQdCk7DPbt7gwniVkN/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ew4fukM9TTu/jnIkZY76FnjggoV/UJjj/mwI2e29wCg2QrJWdUBJ0o5+F7R/F6IKP
         LJiJAds8QGC94+MoIfnSsbZBD2ylfAxKfwFOfrNeeKTPTWA86VQP2ySYH4vEJYMZhj
         1FuykORCunr+jvAxOhVuhilYzPVoisbAaxw9Y0rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 157/225] ASoC: soc-pcm: use GFP_KERNEL when the code is sleepable
Date:   Wed,  4 May 2022 18:46:35 +0200
Message-Id: <20220504153124.054399091@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit fb6d679fee95d272c0a94912c4e534146823ee89 ]

At the kzalloc() call in dpcm_be_connect(), there is no spin lock involved.
It's merely protected by card->pcm_mutex, instead.  The spinlock is applied
at the later call with snd_soc_pcm_stream_lock_irq() only for the list
manipulations.  (See it's *_irq(), not *_irqsave(); that means the context
being sleepable at that point.)  So, we can use GFP_KERNEL safely there.

This patch revert commit d8a9c6e1f676 ("ASoC: soc-pcm: use GFP_ATOMIC for
dpcm structure") which is no longer needed since commit b7898396f4bb
("ASoC: soc-pcm: Fix and cleanup DPCM locking").

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/e740f1930843060e025e3c0f17ec1393cfdafb26.1648757961.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 9a954680d492..11c9853e9e80 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1214,7 +1214,7 @@ static int dpcm_be_connect(struct snd_soc_pcm_runtime *fe,
 		be_substream->pcm->nonatomic = 1;
 	}
 
-	dpcm = kzalloc(sizeof(struct snd_soc_dpcm), GFP_ATOMIC);
+	dpcm = kzalloc(sizeof(struct snd_soc_dpcm), GFP_KERNEL);
 	if (!dpcm)
 		return -ENOMEM;
 
-- 
2.35.1



