Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19B04F3C19
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237504AbiDEMEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358197AbiDEK2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:28:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31951205EB;
        Tue,  5 Apr 2022 03:16:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5AAA61562;
        Tue,  5 Apr 2022 10:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D947AC385A1;
        Tue,  5 Apr 2022 10:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153810;
        bh=bJ4pzWP873/SXGNUTzG7+GAv1s1i+Ck5sZq98p1Sp4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JTAo2zjLdZq2MeyGtTJWBIffou7Dv/SssarTYPmK4KmmDR7we1/klMzxrYslUU2xJ
         GYosoagRm7MZSahOihnfMeRP1bgABJvLZg1lF/vJfTDklr/TCaBLYyCGUhPsDPBL6+
         vFXM+JFTgZWGncHOzWGAq7ZFMID1UXZtEamazQo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 354/599] mtd: rawnand: atmel: fix refcount issue in atmel_nand_controller_init
Date:   Tue,  5 Apr 2022 09:30:48 +0200
Message-Id: <20220405070309.360589501@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Xiong <xiongx18@fudan.edu.cn>

[ Upstream commit fecbd4a317c95d73c849648c406bcf1b6a0ec1cf ]

The reference counting issue happens in several error handling paths
on a refcounted object "nc->dmac". In these paths, the function simply
returns the error code, forgetting to balance the reference count of
"nc->dmac", increased earlier by dma_request_channel(), which may
cause refcount leaks.

Fix it by decrementing the refcount of specific object in those error
paths.

Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
Co-developed-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Co-developed-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220304085330.3610-1-xiongx18@fudan.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/atmel/nand-controller.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c b/drivers/mtd/nand/raw/atmel/nand-controller.c
index 8aab1017b460..c048e826746a 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -2057,13 +2057,15 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
 	nc->mck = of_clk_get(dev->parent->of_node, 0);
 	if (IS_ERR(nc->mck)) {
 		dev_err(dev, "Failed to retrieve MCK clk\n");
-		return PTR_ERR(nc->mck);
+		ret = PTR_ERR(nc->mck);
+		goto out_release_dma;
 	}
 
 	np = of_parse_phandle(dev->parent->of_node, "atmel,smc", 0);
 	if (!np) {
 		dev_err(dev, "Missing or invalid atmel,smc property\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_release_dma;
 	}
 
 	nc->smc = syscon_node_to_regmap(np);
@@ -2071,10 +2073,16 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
 	if (IS_ERR(nc->smc)) {
 		ret = PTR_ERR(nc->smc);
 		dev_err(dev, "Could not get SMC regmap (err = %d)\n", ret);
-		return ret;
+		goto out_release_dma;
 	}
 
 	return 0;
+
+out_release_dma:
+	if (nc->dmac)
+		dma_release_channel(nc->dmac);
+
+	return ret;
 }
 
 static int
-- 
2.34.1



