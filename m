Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E0E6047FC
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbiJSNrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiJSNqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:46:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1341C8D5F;
        Wed, 19 Oct 2022 06:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84954B8238E;
        Wed, 19 Oct 2022 08:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6613C433C1;
        Wed, 19 Oct 2022 08:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169774;
        bh=auWKAyOEcstI5M0Up/N11Wg8er7p4yNk4AWhb3Gv2v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnG5ABJnUqeT0HZMIFowigIm/rbydeqM1wHl7SFcZjppex9hDPgpvKqPqDzJJDupB
         fjgyueYdP8YyCZr6806z2vHd14F3jEYLtRkmrfzm1tuyMDnlSwLub9jZ1+BkduTmnR
         EpHrHFD2v3xd4qzPNuN3Lf9Ss/nQY1cAo+4L3Su4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Pape <apape@de.adit-jv.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 403/862] ALSA: dmaengine: increment buffer pointer atomically
Date:   Wed, 19 Oct 2022 10:28:10 +0200
Message-Id: <20221019083307.739428529@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 5b2ca028f5aa..494ec0c207fa 100644
--- a/sound/core/pcm_dmaengine.c
+++ b/sound/core/pcm_dmaengine.c
@@ -133,12 +133,14 @@ EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_set_config_from_dai_data);
 
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



