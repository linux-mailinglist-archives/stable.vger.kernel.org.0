Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651575107D5
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349057AbiDZTE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240598AbiDZTE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:04:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4191569F6;
        Tue, 26 Apr 2022 12:01:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D3B061989;
        Tue, 26 Apr 2022 19:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C062CC385A4;
        Tue, 26 Apr 2022 19:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999706;
        bh=DjznMDAhNEc5QHd2KrCHEg4wQdCk7DPbt7gwniVkN/s=;
        h=From:To:Cc:Subject:Date:From;
        b=GdDtxLvWCm2p9L+TKMn3QHxUTstwKOmYho8DE1xmbozSIq3P8aKZBR0RkuT1Unn1y
         ZtEt0J7ecXbZs10FxKF+B+OX8fqaBvQtqxG3lPqpjnGZBz+jNjrdBU5OK27FJNQSZB
         bU+cQ7+QzcRdlrgziV0BdVVQnPDeiboB88F1tr4pGNBxXquoyUQ4KyWlqu6dG4ThBo
         Oy1vOMECzgJIMe3cRka3eNF9Ezkk1KYBac8iRMFw37A3SExIarfjxYYMv0ZvSYnGSt
         Bq6RTJRPpOc9BMByQndT0MJM/yTsoLjaFG8JebqZnKy1WJMG82NJLoBAA7lnj2TF58
         AFA5Oq2YIemnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 01/22] ASoC: soc-pcm: use GFP_KERNEL when the code is sleepable
Date:   Tue, 26 Apr 2022 15:01:24 -0400
Message-Id: <20220426190145.2351135-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

