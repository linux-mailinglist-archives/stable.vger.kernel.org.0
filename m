Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFDF4E86E5
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 10:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiC0IUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 04:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiC0IUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 04:20:34 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2853717E11;
        Sun, 27 Mar 2022 01:18:57 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x31so3385733pfh.9;
        Sun, 27 Mar 2022 01:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=FRlj4xMxhi5GXSX1Cps2ByHahJKaninAekH9Bevmx9w=;
        b=fbkCuL3X0EpNGQHTKPQN+J5o1tk1WD1ZvaSnCkLlNZpDKc4eMyPgKFGCQbXnWcFvwb
         33MLo/BbChs+qJaWwTnyYbj3zIPZGsB+hU9b1HftLEiRqDP+s/ukZiVzzB6oDjQX7cuC
         VPNty0xABL2HSE+QkHT1+VTL+RwqVUjtukyrmfy/+AEaz45KxkYx+adzwYkTmmeEURC5
         I40YEYLxdDmlXR7uuv6VK1SpwnAaQBuQkhrbokCGJiP5qzD4HAJgSqf+UDyDKLnfO/lC
         YcTVmUj5nvXw6l3PmuEOtQ9uvRmyTPUMo1wb0GJ/zbvt6mrZY+ekvi+hE3cGbKVxQDmi
         kEng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FRlj4xMxhi5GXSX1Cps2ByHahJKaninAekH9Bevmx9w=;
        b=Yhz2u6adfWSuXAounNnh9lxhWhmxPgKVG43RgAp+EW6/CyD4NSQLTDayPdKfpWG1K0
         hTI+hC14KnKrbDqyGvXHrlKkuRt5HU7UhtWJgANRs4DmEOS0Nr46bGy/XT8ejPGx8th4
         mePzXwIREQXLaLlU5p2TAbL0+azoBISiRO62x0OJwXd/ylhDR3AaZARx0BSGiVDlQw0S
         9v4OZLLWBwBRq1OecOUNfn4GHY4BAnTmEBX+IL4ZsMuypcnY8EOgJdPpCdqgIsQqDz+l
         Gc+7yH5rtvqNyzRbbWLlDBg1m7oW63HxRIIOu3jSB1gFuoQfB7hiDvsesPCUOxqbPEpk
         IAxQ==
X-Gm-Message-State: AOAM530fdWkqtGgIcmK8PJtY/Dj3U2JfDX8GBKyf3scvuiFGeNi8p21h
        SDo4xMmQ2gGMC0QOJ4kB+FgjLEzYj50=
X-Google-Smtp-Source: ABdhPJz2wxWOOC7GRX1rgnX4yaY4pEyOhkAnmMPQd+DoD4Q6rJJmJhlYuKx6PRfaZyj47p55C72mMg==
X-Received: by 2002:a63:4721:0:b0:382:70fa:479d with SMTP id u33-20020a634721000000b0038270fa479dmr6059863pga.259.1648369136640;
        Sun, 27 Mar 2022 01:18:56 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id x14-20020aa784ce000000b004fa79973c94sm11560749pfn.165.2022.03.27.01.18.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 01:18:56 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     jbrunet@baylibre.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.com, narmstrong@baylibre.com,
        khilman@baylibre.com
Cc:     martin.blumenstingl@googlemail.com, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] soc: meson: fix a missing check on list iterator
Date:   Sun, 27 Mar 2022 16:18:50 +0800
Message-Id: <20220327081850.13456-1-xiam0nd.tong@gmail.com>
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

For for_each_component_dais(), just like list_for_each_entry,
the list iterator 'runtime' will point to a bogus position
containing HEAD if the list is empty or no element is found.
This case must be checked before any use of the iterator,
otherwise it will lead to a invalid memory access.

To fix the bug, just move the assignment into loop and return
0 when element is found, otherwise return -EINVAL;

Cc: stable@vger.kernel.org
Fixes: 6ae9ca9ce986b ("ASoC: meson: aiu: add i2s and spdif support")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 sound/soc/meson/aiu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/meson/aiu.c b/sound/soc/meson/aiu.c
index d299a70db7e5..b52915c6f53b 100644
--- a/sound/soc/meson/aiu.c
+++ b/sound/soc/meson/aiu.c
@@ -61,14 +61,14 @@ int aiu_of_xlate_dai_name(struct snd_soc_component *component,
 		return -EINVAL;
 
 	for_each_component_dais(component, dai) {
-		if (id == 0)
-			break;
+		if (id == 0) {
+			*dai_name = dai->driver->name;
+			return 0;
+		}
 		id--;
 	}
 
-	*dai_name = dai->driver->name;
-
-	return 0;
+	return -EINVAL;
 }
 
 static int aiu_cpu_of_xlate_dai_name(struct snd_soc_component *component,
-- 
2.17.1

