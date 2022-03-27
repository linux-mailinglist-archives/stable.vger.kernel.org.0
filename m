Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491754E86E2
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 10:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiC0IS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 04:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiC0IS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 04:18:57 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F62EDFA5;
        Sun, 27 Mar 2022 01:17:19 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id o13so9879917pgc.12;
        Sun, 27 Mar 2022 01:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=gk8h605KYyOaQkK8GayRXSvbqa84qjOB4akygZBA5nk=;
        b=LAKy3CHdIodKnQ+HOvEdnnQw8iw0xZlKosPEZUSXrRkUWJ//+VKiQd+cbIOeoUtP52
         mlhuysstOCwAXn5c91thFW8SkNi9dow/rkpmbHGiAdEIN4KTu3GRUjrZQvxe8VRw/Oxv
         cwaYHBmYnZc/HsT2Gr4R4laxRymuYI4ge9siqHlW6di2hYPeh/Rk9Rs8nM52er9vs4VT
         3UxD9EntXWGIT1gcuL3NsVPLLmgN06blXZ32mHwiL4p5sY7D7nUrqQcpFw5RbLdCwwpy
         ahJhKdWHiJQwtlkRjHMd0zvbZScUnCGNJ2LActIbvm4S4fWhtZZ58C6e05wH3xR3M6Xo
         M23w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gk8h605KYyOaQkK8GayRXSvbqa84qjOB4akygZBA5nk=;
        b=38/hiU2l92dHo0ACG08UcilEqOGGnkc33G6Noae7caUbHcGOc16WZRBOOW7F8oV3A1
         Gh+M08taAnORCxAxC0zbVegGa2XWVUcrZHW0oIa9/3Eb4XhHQ1Yja1mu848hCuk3Wzfe
         gDTs7sGNZU/kKx0yPJpal04YcNedyqxxGst0TwyTluMfayv2pqAWxAuKkQIlQeI48Rut
         X7pRU7Xkz2klO+0VYvRxQGU/Al6QQfdl8iObRZICyIuQ1dUA9nUTN7v2t17sr8p1g8uo
         c6MrQ0HxqxEeIA0PPNrPPJLX1hEuhEu0PpNHgX3bo4hgzVzcyLM8GjYFZ8eqj86KpVDg
         AvGw==
X-Gm-Message-State: AOAM533eFSqHR6HEby39YqR7UJWiKNbzMXrWubrkKcawSvtKWZvA4WwX
        tY/CqE1aoffjmFRsUa1F2Xg=
X-Google-Smtp-Source: ABdhPJzrMtufiuUSfPFRFyW/Lmgnl8OMtHUoxn5VcC8mJqseO1qEDX8kB+apZiI5JWTCwNez2mCBfA==
X-Received: by 2002:a05:6a02:105:b0:381:fd01:330f with SMTP id bg5-20020a056a02010500b00381fd01330fmr5885943pgb.483.1648369039023;
        Sun, 27 Mar 2022 01:17:19 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id a7-20020a056a000c8700b004fb55798f64sm453861pfv.90.2022.03.27.01.17.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 01:17:18 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.com, matthias.bgg@gmail.com
Cc:     trevor.wu@mediatek.com, tzungbi@google.com,
        dan.carpenter@oracle.com, jiaxin.yu@mediatek.com,
        rikard.falkeborn@gmail.com, yc.hung@mediatek.com,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] mediatek: mt8195: fix a missing check on list iterator
Date:   Sun, 27 Mar 2022 16:17:12 +0800
Message-Id: <20220327081712.13341-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
 mt8195_etdm_hw_params_fixup(runtime, params);

For the for_each_card_rtds(), just like list_for_each_entry(),
the list iterator 'runtime' will point to a bogus position
containing HEAD if the list is empty or no element is found.
This case must be checked before any use of the iterator,
otherwise it will lead to a invalid memory access.

To fix the bug, use a new variable 'iter' as the list iterator,
while use the original variable 'runtime' as a dedicated pointer
to point to the found element.

Cc: stable@vger.kernel.org
Fixes: 3d00d2c07f04f ("ASoC: mediatek: mt8195: add sof support on mt8195-mt6359-rt1019-rt5682")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 .../mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c  | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c b/sound/soc/mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c
index 29c2d3407cc7..dc91877e4c3c 100644
--- a/sound/soc/mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c
+++ b/sound/soc/mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c
@@ -814,7 +814,7 @@ static int mt8195_dai_link_fixup(struct snd_soc_pcm_runtime *rtd,
 {
 	struct snd_soc_card *card = rtd->card;
 	struct snd_soc_dai_link *sof_dai_link = NULL;
-	struct snd_soc_pcm_runtime *runtime;
+	struct snd_soc_pcm_runtime *runtime = NULL, *iter;
 	struct snd_soc_dai *cpu_dai;
 	int i, j, ret = 0;
 
@@ -824,16 +824,17 @@ static int mt8195_dai_link_fixup(struct snd_soc_pcm_runtime *rtd,
 		if (strcmp(rtd->dai_link->name, conn->normal_link))
 			continue;
 
-		for_each_card_rtds(card, runtime) {
-			if (strcmp(runtime->dai_link->name, conn->sof_link))
+		for_each_card_rtds(card, iter) {
+			if (strcmp(iter->dai_link->name, conn->sof_link))
 				continue;
 
-			for_each_rtd_cpu_dais(runtime, j, cpu_dai) {
+			for_each_rtd_cpu_dais(iter, j, cpu_dai) {
 				if (cpu_dai->stream_active[conn->stream_dir] > 0) {
-					sof_dai_link = runtime->dai_link;
+					sof_dai_link = iter->dai_link;
 					break;
 				}
 			}
+			runtime = iter;
 			break;
 		}
 
@@ -845,7 +846,8 @@ static int mt8195_dai_link_fixup(struct snd_soc_pcm_runtime *rtd,
 
 	if (!strcmp(rtd->dai_link->name, "ETDM2_IN_BE") ||
 	    !strcmp(rtd->dai_link->name, "ETDM1_OUT_BE")) {
-		mt8195_etdm_hw_params_fixup(runtime, params);
+		if (runtime)
+			mt8195_etdm_hw_params_fixup(runtime, params);
 	}
 
 	return ret;
-- 
2.17.1

