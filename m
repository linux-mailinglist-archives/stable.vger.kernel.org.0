Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615CD540A72
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350823AbiFGSTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352264AbiFGSRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D45379803;
        Tue,  7 Jun 2022 10:51:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33A26B82340;
        Tue,  7 Jun 2022 17:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01A4C3411C;
        Tue,  7 Jun 2022 17:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624275;
        bh=MhY5AKNn21dWYS0iPSQcwo1ibmMkfbI6/CS3dfxBLL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/A4bB9nXSjYlk1r+G0k1nolkh47lJ78geX2N81yrvaUPJYt4v+s0N5OuE8Q9mg7+
         XNN9ffD6jQa8X8k1xfTMZK8TxE9qzbVjbI7grgWFEijvpiowW3fAXItJlIdG+PJcm7
         9ahVujtGWeKF9auDCOFHsaZLmiDDxGDeEgG4vmpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 261/667] mtd: rawnand: intel: fix possible null-ptr-deref in ebu_nand_probe()
Date:   Tue,  7 Jun 2022 18:58:46 +0200
Message-Id: <20220607164942.611137577@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

[ Upstream commit ddf66aefd685fd46500b9917333e1b1e118276dc ]

It will cause null-ptr-deref when using 'res', if platform_get_resource()
returns NULL, so move using 'res' after devm_ioremap_resource() that
will check it to avoid null-ptr-deref.

Fixes: 0b1039f016e8 ("mtd: rawnand: Add NAND controller support on Intel LGM SoC")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220426084913.4021868-2-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/intel-nand-controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/intel-nand-controller.c b/drivers/mtd/nand/raw/intel-nand-controller.c
index 7c1c80dae826..e91b879b32bd 100644
--- a/drivers/mtd/nand/raw/intel-nand-controller.c
+++ b/drivers/mtd/nand/raw/intel-nand-controller.c
@@ -619,9 +619,9 @@ static int ebu_nand_probe(struct platform_device *pdev)
 	resname = devm_kasprintf(dev, GFP_KERNEL, "nand_cs%d", cs);
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, resname);
 	ebu_host->cs[cs].chipaddr = devm_ioremap_resource(dev, res);
-	ebu_host->cs[cs].nand_pa = res->start;
 	if (IS_ERR(ebu_host->cs[cs].chipaddr))
 		return PTR_ERR(ebu_host->cs[cs].chipaddr);
+	ebu_host->cs[cs].nand_pa = res->start;
 
 	ebu_host->clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(ebu_host->clk))
-- 
2.35.1



