Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCE85012BE
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244374AbiDNNdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244966AbiDNN2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:28:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E9C996A4;
        Thu, 14 Apr 2022 06:21:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC848B8296A;
        Thu, 14 Apr 2022 13:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28063C385A1;
        Thu, 14 Apr 2022 13:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942482;
        bh=BhpvmllLx9VJewFsOFhBeJtqVDutmHhAbX04VqL6EGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aCYp+Itx5R5uPaeKQDxiBRrWiI6HJQRQJEB5qx8ExApTT+AQdzf47PsShMMIedv1N
         /EIqnbfTyR40uJXE/tc78j9dNhp8/JLJVAd27vYd75kF2xlEOLKE2E/XKWzamyEfr9
         MZ3vpzCyO616N0wIwAYd8RyfM1N7EmcARvw8GyIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 150/338] mtd: rawnand: atmel: fix refcount issue in atmel_nand_controller_init
Date:   Thu, 14 Apr 2022 15:10:53 +0200
Message-Id: <20220414110843.172618701@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
index 788762930487..b2ffd22fec31 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -1984,13 +1984,15 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
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
@@ -1998,10 +2000,16 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
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



