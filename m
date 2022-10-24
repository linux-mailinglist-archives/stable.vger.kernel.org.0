Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927C160A45C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiJXMKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbiJXMI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:08:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27777E036;
        Mon, 24 Oct 2022 04:52:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3158CB811A1;
        Mon, 24 Oct 2022 11:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FABEC433B5;
        Mon, 24 Oct 2022 11:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612273;
        bh=bZwGPZDTogpLUxzxQ5yHMwfGBVlcNdR2myoMTG7FLZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1S+8W9DTxoUU0Q+1mQATXu0c0KULHHXi5G2Qah1lXHWsTyqYCb0Zq1vtevwZgXDW
         uGAzvxbHDbX6RSdOTGGgVzV/luUw8JPOXiyPBrL2yu8JjHoYniEYQYJEkzZs2Rd47x
         N7ISjJC1w+maDC5ylLQ9HvPnOKIVsiaBgMJBN6G0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Pape <apape@de.adit-jv.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 104/210] ALSA: dmaengine: increment buffer pointer atomically
Date:   Mon, 24 Oct 2022 13:30:21 +0200
Message-Id: <20221024113000.387398401@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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



