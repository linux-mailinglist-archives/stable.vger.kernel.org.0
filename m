Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB324F3702
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbiDELJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348820AbiDEJsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAA3AFAC8;
        Tue,  5 Apr 2022 02:36:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC71561680;
        Tue,  5 Apr 2022 09:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CF8C385A2;
        Tue,  5 Apr 2022 09:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151377;
        bh=xZFlO/Ssj0ilwMz4LbbFsHCf7q/ubFY/jXMHM64j43U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pCBJjGAQuM+YAd+I5Vh8jCSDeV3J91J2lxmUYLjc8i2UW0DcI8YugfdHPRjt/BzG/
         tKm74q69LCXn/qDlTiYjDU8CZTYifBMuCGYqpk/yU1MtMuxFxKPR3QuVhWdx77Tmni
         0IoM1TWQR7TItR1Y84XtW1NRgoQqZbKegjgeT5rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 393/913] mtd: onenand: Check for error irq
Date:   Tue,  5 Apr 2022 09:24:15 +0200
Message-Id: <20220405070351.628038201@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 3e68f331c8c759c0daa31cc92c3449b23119a215 ]

For the possible failure of the platform_get_irq(), the returned irq
could be error number and will finally cause the failure of the
request_irq().
Consider that platform_get_irq() can now in certain cases return
-EPROBE_DEFER, and the consequences of letting request_irq() effectively
convert that into -EINVAL, even at probe time rather than later on.
So it might be better to check just now.

Fixes: 2c22120fbd01 ("MTD: OneNAND: interrupt based wait support")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220104162658.1988142-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/onenand/generic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/onenand/generic.c b/drivers/mtd/nand/onenand/generic.c
index 8b6f4da5d720..a4b8b65fe15f 100644
--- a/drivers/mtd/nand/onenand/generic.c
+++ b/drivers/mtd/nand/onenand/generic.c
@@ -53,7 +53,12 @@ static int generic_onenand_probe(struct platform_device *pdev)
 	}
 
 	info->onenand.mmcontrol = pdata ? pdata->mmcontrol : NULL;
-	info->onenand.irq = platform_get_irq(pdev, 0);
+
+	err = platform_get_irq(pdev, 0);
+	if (err < 0)
+		goto out_iounmap;
+
+	info->onenand.irq = err;
 
 	info->mtd.dev.parent = &pdev->dev;
 	info->mtd.priv = &info->onenand;
-- 
2.34.1



