Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A9B4AA7F7
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 10:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358624AbiBEJqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 04:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344127AbiBEJqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 04:46:17 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFF4C061347;
        Sat,  5 Feb 2022 01:46:15 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id j5-20020a05600c1c0500b0034d2e956aadso5195933wms.4;
        Sat, 05 Feb 2022 01:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pwI2AGdZ3e9zwkGSdRCkR4G49V9s8brVa+MvmNHFW4g=;
        b=KwV/+pUvAhLN7tzUlhzPP863DpZnS0LT3q6mXynfZpRFhTkl9XDz4ui4Nup1ccYBxK
         HgokAJ3V6XkY2Z0ncsZPrJHCNbQk4VhY5rS8TzZ+J3fWr5Sbq49YG2qHm2z1kM/3WUch
         QhKRbTGOnRIk92B3kxRuHI96Gf1dCFhOTKWltEWiF/vsFo4zYfq60dkoGXQyfbRCF2zX
         zP+LzMEB8UKH7zTv0OTDHR++WnKnbTR4orKJ4QAs2DsjiIG/tmg+48yfiFZWlh3GadeC
         MHFKhl+3iDut7u2Fl6h6kNu/tRn3DPmLlsMlcAopMDH+ggZR22NnMFJ4+J1laGu1LCF1
         i1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pwI2AGdZ3e9zwkGSdRCkR4G49V9s8brVa+MvmNHFW4g=;
        b=cQrguHB9qKC/RZBhMluqXrUbkPFiNKaengCdg14NI9U5APL5NN4+gkyDHYHZyeOxKu
         nOt5ckm8lDf5x/E2xqrRO7u9q8mBRhZITPXI63YpEI3u3ANon8l2NxrQUt6He0GMm9/T
         U8bAEfEASTqAMgZ1l2rxbapX7yQjNkbKG5az++vuSKCrrx3wll/9ppANUbABE1d4B/QA
         NRGwUazZOAizeOsROg/SbzSz/gYk5SdK2Iov1n1YAfNQbtqxstXOmeJU+/A7pqAkfso4
         gPJln5zfbBe2Q6pIl7EuNMn6Bml+1RvycFMpiCiqHWNJbBYt+ECyiQwzHeVnlnX1RLFR
         4Yig==
X-Gm-Message-State: AOAM533k/JolREOgjGqxOcMPyN9w8feFM5X2JGV7JyGcj284nFIIEq7W
        71VclT19RZCB8JW07ftPx3w=
X-Google-Smtp-Source: ABdhPJy06T0iM5fHli6NNkKQY61A8QB8/HNA+5uv9aUT046AedQl1yJAjI61ltqkRtb/d6ggGn7d1A==
X-Received: by 2002:a05:600c:2b89:: with SMTP id j9mr2381573wmc.190.1644054374560;
        Sat, 05 Feb 2022 01:46:14 -0800 (PST)
Received: from hp-power-15.localdomain (mm-89-21-212-37.vitebsk.dynamic.pppoe.byfly.by. [37.212.21.89])
        by smtp.gmail.com with ESMTPSA id n2sm4679828wrx.108.2022.02.05.01.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 01:46:14 -0800 (PST)
From:   Siarhei Volkau <lis8215@gmail.com>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-mips@vger.kernel.org,
        linux-clk@vger.kernel.org, stable@vger.kernel.org,
        Siarhei Volkau <lis8215@gmail.com>
Subject: [PATCH v3 1/1] clk: jz4725b: fix mmc0 clock gating
Date:   Sat,  5 Feb 2022 12:45:31 +0300
Message-Id: <20220205094531.676371-2-lis8215@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220205094531.676371-1-lis8215@gmail.com>
References: <4FSS6R.0A48V2ZMZD7X1@crapouillou.net>
 <20220205094531.676371-1-lis8215@gmail.com>
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

