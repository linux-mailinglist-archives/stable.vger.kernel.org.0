Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7FC4E86E8
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 10:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiC0IWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 04:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiC0IWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 04:22:04 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC202653;
        Sun, 27 Mar 2022 01:20:25 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id w21so9893442pgm.7;
        Sun, 27 Mar 2022 01:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=iQQ+IOJD8woJe4Cpni8NJ/Jh5Shpl0rcuLhtMKYlCKE=;
        b=C4/csvfMTnPgRmrp6b0hSz55zfUOjucPIygLPMoAFdpf/mf8cfZ5uaKc2XsrBVJGDw
         1UFFBIkCGoZaeqG6HJ0eJwEkUgkjm+/M71eaHw3ShJpH3fvpKh8AQlmzIr+s7zjgJeGc
         BUfUHgZgc3aXDKLXy51waL0eESjiXyWBF2OJ5IMcOUXbts/QR71+0G6TCkUE1pNq5gIR
         TfZZXy40zj7JNGNgKQTFPn5JSagRXLGmtUjuU5MwNEFk3Anfx8Do79XM6JEXLy+crlmm
         2WY0E/iTKId+cs4brT1976qOIbexdNLbkfNsP4sUjnz7c0dTLTv7TUOv94gn0brjH4Bj
         IXtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iQQ+IOJD8woJe4Cpni8NJ/Jh5Shpl0rcuLhtMKYlCKE=;
        b=LqulVJoqC0yiKL3FUX3cyliiJkPtQ7wbJt1D76Pjh7oLZWMuqYByNyyDRmg4NJ2jDp
         WGmdUsA4+/xu66omuYZozztzFvaM3xHf2QXqFeHpKUNLz0AmYS2EC9kBR714LFVZkq1w
         /DNtJzXDXDsJ0cr0erwBuM/iVL0aDns65gcO298pMf+Kpv5F/CtWWhIRSCmJCAQ75MQA
         Eyhp2htpyBP0CqIpj7WOJBGjPGnyzs/1xRDNNonaQik2dRRIjPflg6s2JkDC6CLQSKfT
         MIXZra6521wLXIUiQFTIotNtvlHgZ9LgoTPiI/JfxqcDs5w1AZgpGMtbqBROtUTn0snj
         nTSQ==
X-Gm-Message-State: AOAM530cNoRFOUBbgAmSqz+9wHcxKisb5sjuDJEE0vTFunfNM9hrlTfZ
        gdEmRqHFoSGGg+KTnGBlGhE=
X-Google-Smtp-Source: ABdhPJwbp3kze+Q3ithWE8CbHeNMYcS362en2Df3psbrfIL/PeoiasPCpV/OGshUDQeCQe9vAw45fQ==
X-Received: by 2002:a63:1459:0:b0:381:7672:e79f with SMTP id 25-20020a631459000000b003817672e79fmr6069259pgu.214.1648369224925;
        Sun, 27 Mar 2022 01:20:24 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id w6-20020a17090a460600b001bf355e964fsm17099915pjg.0.2022.03.27.01.20.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 01:20:24 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.com
Cc:     kuninori.morimoto.gx@renesas.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] soc: soc-core: fix a missing check on list iterator
Date:   Sun, 27 Mar 2022 16:20:18 +0800
Message-Id: <20220327082018.13585-1-xiam0nd.tong@gmail.com>
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
	*dai_name = dai->driver->name;

For for_each_component_dais, just like list_for_each_entry,
the list iterator 'dai' will point to a bogus position
containing HEAD if the list is empty or no element is found.
This case must be checked before any use of the iterator,
otherwise it will lead to a invalid memory access.

To fix the bug, use a new variable 'iter' as the list iterator,
while use the original variable 'dai' as a dedicated pointer
to point to the found element.

Cc: stable@vger.kernel.org
Fixes: 58bf4179000a3 ("ASoC: soc-core: remove dai_drv from snd_soc_component")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 sound/soc/soc-core.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 434e61b46983..064fc0347868 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3238,7 +3238,7 @@ int snd_soc_get_dai_name(const struct of_phandle_args *args,
 
 		ret = snd_soc_component_of_xlate_dai_name(pos, args, dai_name);
 		if (ret == -ENOTSUPP) {
-			struct snd_soc_dai *dai;
+			struct snd_soc_dai *dai = NULL, *iter;
 			int id = -1;
 
 			switch (args->args_count) {
@@ -3261,12 +3261,19 @@ int snd_soc_get_dai_name(const struct of_phandle_args *args,
 			ret = 0;
 
 			/* find target DAI */
-			for_each_component_dais(pos, dai) {
-				if (id == 0)
+			for_each_component_dais(pos, iter) {
+				if (id == 0) {
+					dai = iter;
 					break;
+				}
 				id--;
 			}
 
+			if (!dai) {
+				ret = -EINVAL;
+				continue;
+			}
+
 			*dai_name = dai->driver->name;
 			if (!*dai_name)
 				*dai_name = pos->name;
-- 
2.17.1

