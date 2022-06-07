Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818E2541348
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357195AbiFGT6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357511AbiFGT4o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:56:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89354AFB2C;
        Tue,  7 Jun 2022 11:24:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2F7961277;
        Tue,  7 Jun 2022 18:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE45AC385A2;
        Tue,  7 Jun 2022 18:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626243;
        bh=CnLwyclVVSbwC4oc11KchLvc8sUbiTu2u0ilES9Syzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAZi4iKdMf3xO77hCqU1BSMlExVY/m1kEx2r4gvrTUJSj4GSf5+de3mdpN1N3tWRv
         ySNRtA/qaT4HpGswyKt9/v65synyNyHNPSBIFskUAlbJzRICDuFycurZOZEfhbetfo
         /esmCyRwJOSZp9YfuGEXxvorjI8bZGQ0dpsUZcG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 309/772] mtd: rawnand: cadence: fix possible null-ptr-deref in cadence_nand_dt_probe()
Date:   Tue,  7 Jun 2022 18:58:21 +0200
Message-Id: <20220607164958.131972127@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit a28ed09dafee20da51eb26452950839633afd824 ]

It will cause null-ptr-deref when using 'res', if platform_get_resource()
returns NULL, so move using 'res' after devm_ioremap_resource() that
will check it to avoid null-ptr-deref.
And use devm_platform_get_and_ioremap_resource() to simplify code.

Fixes: ec4ba01e894d ("mtd: rawnand: Add new Cadence NAND driver to MTD subsystem")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220426084913.4021868-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/cadence-nand-controller.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/raw/cadence-nand-controller.c b/drivers/mtd/nand/raw/cadence-nand-controller.c
index 7eec60ea9056..0d72672f8b64 100644
--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -2983,11 +2983,10 @@ static int cadence_nand_dt_probe(struct platform_device *ofdev)
 	if (IS_ERR(cdns_ctrl->reg))
 		return PTR_ERR(cdns_ctrl->reg);
 
-	res = platform_get_resource(ofdev, IORESOURCE_MEM, 1);
-	cdns_ctrl->io.dma = res->start;
-	cdns_ctrl->io.virt = devm_ioremap_resource(&ofdev->dev, res);
+	cdns_ctrl->io.virt = devm_platform_get_and_ioremap_resource(ofdev, 1, &res);
 	if (IS_ERR(cdns_ctrl->io.virt))
 		return PTR_ERR(cdns_ctrl->io.virt);
+	cdns_ctrl->io.dma = res->start;
 
 	dt->clk = devm_clk_get(cdns_ctrl->dev, "nf_clk");
 	if (IS_ERR(dt->clk))
-- 
2.35.1



