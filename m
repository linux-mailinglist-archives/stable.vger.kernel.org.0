Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D269B52969F
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 03:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiEQBSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 21:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiEQBSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 21:18:06 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F1E1FCEF
        for <stable@vger.kernel.org>; Mon, 16 May 2022 18:18:05 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id j28so6450706eda.13
        for <stable@vger.kernel.org>; Mon, 16 May 2022 18:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UJNPFC3CeDSNqqGUH4ql5DApCLRNT8G9vJ7nfo2b2oQ=;
        b=kvaTLukoDxQ2EHWsD5GQR49yqK6PfkNpSNBzzwLRUs4ONqt3csIVELufV740O0MaIg
         VJ5IdtwZBiYzvPOwkcUQon7ovqQ1Q1Sy+6ZNf4bCGHVvF4tLsDscY3cMKCmO917gOIFk
         3HguC7ZgndpWNGs/33lxkdQGUiwTH/Xw4sebgOCHKfEoFa6OuJViC2AeyqGqUBFA+1Lr
         /T4TK7PhZwvT/u+I1he7JqIixJOKkgTDyYtDAJ4XTz/BI5mv13JnNeK873e+dszPe1CB
         st2nyp2cmT16UgPyzx1F7TzOUXRoeqApxvb33tG/ZawoJlA/WCLjAD1mm/5iPgGGfobD
         kQUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UJNPFC3CeDSNqqGUH4ql5DApCLRNT8G9vJ7nfo2b2oQ=;
        b=sIFiMAgM2KF2/SxU3rgkwD3Rh0PxSqy2xFSWkG27MDsg13RJF1O75TBnQTGIwCAtF4
         ra8NTDO7nyDIdOqMbyZ8IyuCRvuj63VpjplPD7KqD06fNbReDeHgOh4pg4duCl0xz/MR
         TvovHynI6yevCsuyEtI7prCiF2X5X3ScErygA1VHRS+lbaMb05mktUuN0byk1OlGoLbH
         067KnzfPslNUC07bV3w8848HsTvEvlZIq9yKvofX1PIYbZJfgoZen+Rg3nT3qXDhJTW+
         3jERLSFsj+QsOaJqPccejluCNHAk5HQbAies+IBnZANJuus9QSyC+F+J8xD0Pssa85Lj
         meKg==
X-Gm-Message-State: AOAM532SHWpp4bFFkCFRE8Ysxg6bC9X4uP05OOv9QACq+sTd2FRRfu+N
        FCZ9rJ1F9O8EwnTBswfe4P0=
X-Google-Smtp-Source: ABdhPJxORibv/T7DUCBNlC8C2wiaADsTyW/tx1WkupojvwG6DD1Z5rim/1vwFpxlHZ6gF5rAnhuYeA==
X-Received: by 2002:a05:6402:26d6:b0:428:c30:3a45 with SMTP id x22-20020a05640226d600b004280c303a45mr16292094edd.210.1652750283948;
        Mon, 16 May 2022 18:18:03 -0700 (PDT)
Received: from void.localdomain ([178.233.88.73])
        by smtp.googlemail.com with ESMTPSA id hy6-20020a1709068a6600b006f3ef214e70sm352626ejc.214.2022.05.16.18.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 18:18:03 -0700 (PDT)
From:   Tan Nayir <tannayir@gmail.com>
To:     alsa-devel@alsa-project.org
Cc:     stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Tan Nayir <tannayir@gmail.com>, Marek Vasut <marex@denx.de>
Subject: [PATCH] ASoC: ops: Fix the bounds checking in snd_soc_put_volsw_sx and snd_soc_put_xr_sx
Date:   Tue, 17 May 2022 04:12:04 +0300
Message-Id: <20220517011201.23530-1-tannayir@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <c2163c71-2f71-9011-3966-baeab8e8dc8f@gmail.com>
References: <c2163c71-2f71-9011-3966-baeab8e8dc8f@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The $val in both functions has a range between 0 and an arbitrary limit
whereas the range specified with the $min and $max can start
from a negative number. To do the out of bound check correctly, the
$val must be added the $min offset.

Previous-discussion: https://lore.kernel.org/all/c2163c71-2f71-9011-3966-baeab8e8dc8f@gmail.com/
Fixes: 4f1e50d6a9cf9 ("ASoC: ops: Reject out of bounds values in snd_soc_put_volsw_sx()")
Fixes: 4cf28e9ae6e2e ("ASoC: ops: Reject out of bounds values in snd_soc_put_xr_sx()")
Signed-off-by: Tan Nayir <tannayir@gmail.com>
---
 sound/soc/soc-ops.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index e693070f5..42191968c 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -433,7 +433,7 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 	if (ucontrol->value.integer.value[0] < 0)
 		return -EINVAL;
 	val = ucontrol->value.integer.value[0];
-	if (mc->platform_max && val > mc->platform_max)
+	if (mc->platform_max && ((int)val + min) > mc->platform_max)
 		return -EINVAL;
 	if (val > max - min)
 		return -EINVAL;
@@ -910,11 +910,12 @@ int snd_soc_put_xr_sx(struct snd_kcontrol *kcontrol,
 	unsigned int invert = mc->invert;
 	unsigned long mask = (1UL<<mc->nbits)-1;
 	long max = mc->max;
+	long min = mc->min;
 	long val = ucontrol->value.integer.value[0];
 	int ret = 0;
 	unsigned int i;
 
-	if (val < mc->min || val > mc->max)
+	if (val < mc->min || ((int)val + min) > mc->max)
 		return -EINVAL;
 	if (invert)
 		val = max - val;
-- 
2.25.1

