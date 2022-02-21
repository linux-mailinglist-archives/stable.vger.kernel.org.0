Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE904BE30F
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350335AbiBUJdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:33:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350364AbiBUJcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:32:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BD027FF6;
        Mon, 21 Feb 2022 01:13:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11F4C60DDD;
        Mon, 21 Feb 2022 09:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4EEC340F1;
        Mon, 21 Feb 2022 09:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434820;
        bh=MpEIPhkzQOZpoFUN2LKDl0Xl8eV+Srl14bKJWpvSQxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9GPAnxlWk8dIljNTw9WmmnuYFU2iCEp0fWJmzJ4S5oCEvQhovNlJySm5qWJH/0bk
         RH4CSGhUbVS7hPiWxP+HVdMw4OgqyEfIbp3sw26LjJakBdwgQ6fSV1vodhSMBoJtuy
         mATKV1hjai1vBtZ1GN733iKZE+3Xf3f6d6sAvepY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/196] mtd: rawnand: ingenic: Fix missing put_device in ingenic_ecc_get
Date:   Mon, 21 Feb 2022 09:49:34 +0100
Message-Id: <20220221084935.670823690@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit ba1b71b008e97fd747845ff3a818420b11bbe830 ]

If of_find_device_by_node() succeeds, ingenic_ecc_get() doesn't have
a corresponding put_device(). Thus add put_device() to fix the exception
handling.

Fixes: 15de8c6efd0e ("mtd: rawnand: ingenic: Separate top-level and SoC specific code")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211230072751.21622-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/ingenic/ingenic_ecc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c b/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c
index efe0ffe4f1abc..9054559e52dda 100644
--- a/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c
+++ b/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c
@@ -68,9 +68,14 @@ static struct ingenic_ecc *ingenic_ecc_get(struct device_node *np)
 	struct ingenic_ecc *ecc;
 
 	pdev = of_find_device_by_node(np);
-	if (!pdev || !platform_get_drvdata(pdev))
+	if (!pdev)
 		return ERR_PTR(-EPROBE_DEFER);
 
+	if (!platform_get_drvdata(pdev)) {
+		put_device(&pdev->dev);
+		return ERR_PTR(-EPROBE_DEFER);
+	}
+
 	ecc = platform_get_drvdata(pdev);
 	clk_prepare_enable(ecc->clk);
 
-- 
2.34.1



