Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 829C54AAA7A
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 18:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380656AbiBERTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 12:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380671AbiBERTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 12:19:04 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF864C061353;
        Sat,  5 Feb 2022 09:19:03 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id s18so17145500wrv.7;
        Sat, 05 Feb 2022 09:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vTIAn0Yjfxsd5NvSF8MM6DbMWwzm91GVkUP26EsO578=;
        b=K2bs+GtkV2obUmjOsZQ2yZY6hsEpNTH7SakFEh//5jWCxu9TVcdMSdoA7nPC+sF9SV
         MKTjuZTosL1yRQWvLJ4KMs+kV0BinmOsi+IZjZlKW33OyscmJAiPlfflceTSyZDghS/Z
         GfVz8a9qxRd9vvbTz93qI88Ks4Y3DN5PPOxR0TX/6oyc/mS+jrMDSV3jbAIiJsEw3ZVo
         MPejQy9QKKnXEHQkggXR4GmCuv6lXpXQqWMNH29fZN63/mFY8CzGpjAtRFHcvwm3Pqw2
         HuDtJbAat92sjZcvRzhzll+hC04gRcGvaT5oz0UaG/gkUH9NHs8KPvxYebKZiomEF4gX
         M8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vTIAn0Yjfxsd5NvSF8MM6DbMWwzm91GVkUP26EsO578=;
        b=gt2EdKHFCHzIrGE1aYnxOwoROZR4/tXVeaxJr8Q5K+qMxIj1HQfmqb5ZDj5AqgKBaH
         pCI6AalFXwKxfwkPIiTOKismSOzyBgQNOSpYMiSKdl9fY6sz+CPdCq5VfrAWE+d73H1k
         F65CuNIJ1mvkAdiBO1fWWLRKSYOi6wim5DFXXan8jHDVJJ3N0eYbR1RUMYtB561AQ6uZ
         0OvhDAyJxXrsZf5N0LzIn2IqFtzYpNG8vKBMSjtiqswcNJFtbxKPXYbJTkKeY+Kz2QIX
         p8T/uRpSiGrEOminY9JPIfEerKpcBKjSdhuq9WwD+dWxeWrRK/Co6divJ/zuPneXSGAu
         578w==
X-Gm-Message-State: AOAM530R5k7Y8CQAyHzH6yXFbwCR/Z+Wi6inpxuOy9qV55aLk8RXYNwu
        9HifZ85+PHAV28KIha2dh4w=
X-Google-Smtp-Source: ABdhPJwdFR4K+RV0yDiEvs5+Q/ko0mXFuWx9s2H4MAYiJT8GsQtWsHPW6fwu0/gB0DBq2krBMYKvZg==
X-Received: by 2002:a5d:4cc3:: with SMTP id c3mr3794907wrt.303.1644081542382;
        Sat, 05 Feb 2022 09:19:02 -0800 (PST)
Received: from hp-power-15.localdomain (mm-89-21-212-37.vitebsk.dynamic.pppoe.byfly.by. [37.212.21.89])
        by smtp.gmail.com with ESMTPSA id q140sm1860372wme.16.2022.02.05.09.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 09:19:02 -0800 (PST)
From:   Siarhei Volkau <lis8215@gmail.com>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-mips@vger.kernel.org,
        linux-clk@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Siarhei Volkau <lis8215@gmail.com>
Subject: [PATCH v4 1/1] clk: jz4725b: fix mmc0 clock gating
Date:   Sat,  5 Feb 2022 20:18:49 +0300
Message-Id: <20220205171849.687805-2-lis8215@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220205171849.687805-1-lis8215@gmail.com>
References: <Yf5yJKWAfxfQUVHU@kroah.com>
 <20220205171849.687805-1-lis8215@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The mmc0 clock gate bit was mistakenly assigned to "i2s" clock.
You can find that the same bit is assigned to "mmc0" too.
It leads to mmc0 hang for a long time after any sound activity
also it  prevented PM_SLEEP to work properly.
I guess it was introduced by copy-paste from jz4740 driver
where it is really controls I2S clock gate.

Fixes: 226dfa4726eb ("clk: Add Ingenic jz4725b CGU driver")
Signed-off-by: Siarhei Volkau <lis8215@gmail.com>
Tested-by: Siarhei Volkau <lis8215@gmail.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Cc: stable@vger.kernel.org
---
 drivers/clk/ingenic/jz4725b-cgu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/ingenic/jz4725b-cgu.c b/drivers/clk/ingenic/jz4725b-cgu.c
index 744d136..15d6179 100644
--- a/drivers/clk/ingenic/jz4725b-cgu.c
+++ b/drivers/clk/ingenic/jz4725b-cgu.c
@@ -139,11 +139,10 @@ static const struct ingenic_cgu_clk_info jz4725b_cgu_clocks[] = {
 	},
 
 	[JZ4725B_CLK_I2S] = {
-		"i2s", CGU_CLK_MUX | CGU_CLK_DIV | CGU_CLK_GATE,
+		"i2s", CGU_CLK_MUX | CGU_CLK_DIV,
 		.parents = { JZ4725B_CLK_EXT, JZ4725B_CLK_PLL_HALF, -1, -1 },
 		.mux = { CGU_REG_CPCCR, 31, 1 },
 		.div = { CGU_REG_I2SCDR, 0, 1, 9, -1, -1, -1 },
-		.gate = { CGU_REG_CLKGR, 6 },
 	},
 
 	[JZ4725B_CLK_SPI] = {
-- 
2.35.1

