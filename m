Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3472B60B3B5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 19:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiJXRO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 13:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbiJXRNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 13:13:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88405A8C8;
        Mon, 24 Oct 2022 08:49:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9578D6129A;
        Mon, 24 Oct 2022 11:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A479BC433C1;
        Mon, 24 Oct 2022 11:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612746;
        bh=bZwGPZDTogpLUxzxQ5yHMwfGBVlcNdR2myoMTG7FLZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TH8i8gCU3hrYEcz6rEEgo865pgk7d1YaUVyJ5TvXUFMcwzOjWLkvTNVJauDLlGC79
         cGUGjcb2mcs83nPB8fVmOXouRnWUB2RYRjzNOCdBUplqqbHUlSunwkmm0CBg8z+w5P
         KyxFiXcOSlZhoR1EvKA+nlALyImmBJhkIkBLNgXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Pape <apape@de.adit-jv.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/229] ALSA: dmaengine: increment buffer pointer atomically
Date:   Mon, 24 Oct 2022 13:30:22 +0200
Message-Id: <20221024113002.353044201@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Pape <apape@de.adit-jv.com>

[ Upstream commit d1c442019594692c64a70a86ad88eb5b6db92216 ]

Setting pointer and afterwards checking for wraparound leads
to the possibility of returning the inconsistent pointer position.

This patch increments buffer pointer atomically to avoid this issue.

Fixes: e7f73a1613567a ("ASoC: Add dmaengine PCM helper functions")
Signed-off-by: Andreas Pape <apape@de.adit-jv.com>
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Link: https://lore.kernel.org/r/1664211493-11789-1-git-send-email-erosca@de.adit-jv.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_dmaengine.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/core/pcm_dmaengine.c b/sound/core/pcm_dmaengine.c
index 8eb58c709b14..6f6da1128edc 100644
--- a/sound/core/pcm_dmaengine.c
+++ b/sound/core/pcm_dmaengine.c
@@ -139,12 +139,14 @@ EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_set_config_from_dai_data);
 
 static void dmaengine_pcm_dma_complete(void *arg)
 {
+	unsigned int new_pos;
 	struct snd_pcm_substream *substream = arg;
 	struct dmaengine_pcm_runtime_data *prtd = substream_to_prtd(substream);
 
-	prtd->pos += snd_pcm_lib_period_bytes(substream);
-	if (prtd->pos >= snd_pcm_lib_buffer_bytes(substream))
-		prtd->pos = 0;
+	new_pos = prtd->pos + snd_pcm_lib_period_bytes(substream);
+	if (new_pos >= snd_pcm_lib_buffer_bytes(substream))
+		new_pos = 0;
+	prtd->pos = new_pos;
 
 	snd_pcm_period_elapsed(substream);
 }
-- 
2.35.1



