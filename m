Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358D84E86D9
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 10:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbiC0IL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 04:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiC0ILz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 04:11:55 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E488B4EF73;
        Sun, 27 Mar 2022 01:10:17 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id w8so12237399pll.10;
        Sun, 27 Mar 2022 01:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=I209+IAp2J40nkpM0RDSrYtutE4hanVMPBM3jUoLkOo=;
        b=CorJydGuWbpBLptQES0lIYPHSX347xTaMw1Sk2SkCs6fzw4msOZh2MpVN3AGKd6mjF
         UHwkI43v50nxY22D36ezJIGpCpIN0DYliXHFy9f+WO/63qhPqPzVIJe40C/drJgjuzSO
         ZAaofmmyh2oID+sameso90LvpPKGlCqsRGHivbQ7IDtUUP6Xn6qZF4okz9jO3Bdmnyip
         1roaiT9NX/we0WM8EluW9OELn9Vc25IVPc3h/+XaYSV6rHlqgFh7HXFPuC97ibaylJTz
         xA2pyj4fpXGEyJGmyifqcnH8OgNZeZLIzPtZsy0QazlMfD80Gag2v+8HzdPV+macj6Cl
         ulSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=I209+IAp2J40nkpM0RDSrYtutE4hanVMPBM3jUoLkOo=;
        b=3yvelSLkX1jBf0654oD/VSlxclWGp6wUks8mO5R6FDa7PWgv9xsGm2hYq6MaPX/lnz
         WrPyIAQwsxZUxVxGE66YrmNPwcuFxtbufWjKKuP4FpULpA+hZKlS015sRR9m/4envf54
         r0dQIp02dWnbjW3IgXcHaFFn+dyMzEzpd0aY0SD06r7b2E0WGO/g7lZTRUpbd94cHx/J
         ntM6xjn6rtOO7zTnC0Vgdu+smJvOOVn4+Z3SkVSJEbL0WGfgWhIjMPhvF/ynUX5QrREn
         7/DUDwslVCcDs7EFMErEUtUb4m0pXbhCDGt+lGuQlFT/G/cA5CXRCwyqX8rwdbj56fCE
         +2mA==
X-Gm-Message-State: AOAM532cu+WadRaymVjfFlAOSwiKeolDLnKlOpe5J+W+MCLGKGACn+EN
        Ik937M+F3BozMFjhhpaNMG/uxxENY3Y=
X-Google-Smtp-Source: ABdhPJyeYcEUJKV2iJ85uQKvTTnRsUSASXeeh0pFRxzZpGOxsJZMFZco2VjE0HpPVwf67S0u05yGUA==
X-Received: by 2002:a17:902:daca:b0:154:aa89:f12f with SMTP id q10-20020a170902daca00b00154aa89f12fmr21057923plx.98.1648368617435;
        Sun, 27 Mar 2022 01:10:17 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id g6-20020a056a000b8600b004faa49add69sm11898172pfj.107.2022.03.27.01.10.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 01:10:16 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     oder_chiou@realtek.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.com
Cc:     derek.fang@realtek.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] codecs: rt5682: fix an incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 16:10:02 +0800
Message-Id: <20220327081002.12684-1-xiam0nd.tong@gmail.com>
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
	if (!dai) {

The list iterator value 'dai' will *always* be set and non-NULL
by for_each_component_dais(), so it is incorrect to assume that
the iterator value will be NULL if the list is empty or no element
is found (In fact, it will be a bogus pointer to an invalid struct
object containing the HEAD). Otherwise it will bypass the check
'if (!dai) {' (never call dev_err() and never return -ENODEV;)
and lead to invalid memory access lately when calling
'rt5682_set_bclk1_ratio(dai, factor);'.

To fix the bug, just return rt5682_set_bclk1_ratio(dai, factor);
when found the 'dai', otherwise dev_err() and return -ENODEV;

Cc: stable@vger.kernel.org
Fixes: ebbfabc16d23d ("ASoC: rt5682: Add CCF usage for providing I2S clks")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 sound/soc/codecs/rt5682.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index be68d573a490..c9ff9c89adf7 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -2822,14 +2822,11 @@ static int rt5682_bclk_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	for_each_component_dais(component, dai)
 		if (dai->id == RT5682_AIF1)
-			break;
-	if (!dai) {
-		dev_err(rt5682->i2c_dev, "dai %d not found in component\n",
-			RT5682_AIF1);
-		return -ENODEV;
-	}
+			return rt5682_set_bclk1_ratio(dai, factor);
 
-	return rt5682_set_bclk1_ratio(dai, factor);
+	dev_err(rt5682->i2c_dev, "dai %d not found in component\n",
+		RT5682_AIF1);
+	return -ENODEV;
 }
 
 static const struct clk_ops rt5682_dai_clk_ops[RT5682_DAI_NUM_CLKS] = {
-- 
2.17.1

