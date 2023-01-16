Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EEC66CA2B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbjAPRAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbjAPQ7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:59:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2470274AA
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:42:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F06D6104F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3ABBC433EF;
        Mon, 16 Jan 2023 16:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887345;
        bh=joO2+CCVxFkxLe3TsGb1maLTiOpsi1iXRg/tzScuud8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TAaYhzXNX54U4q/iF4bGY5QiqDy487xyXE61TiQXOP+4GEddIDH8m6rP/x1JaZdr2
         2nqDE63nFNSWZSgAlJUHeF5Jgz8nmith5IKFGcGNjIEkt6EhGzYCMI7F/w5GAAlRpc
         v2jruOBTDZxWtvyUAS1Tyf7Q2nU75UB9DraU1KtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/521] mtd: maps: pxa2xx-flash: fix memory leak in probe
Date:   Mon, 16 Jan 2023 16:46:16 +0100
Message-Id: <20230116154852.336621647@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 2399401feee27c639addc5b7e6ba519d3ca341bf ]

Free 'info' upon remapping error to avoid a memory leak.

Fixes: e644f7d62894 ("[MTD] MAPS: Merge Lubbock and Mainstone drivers into common PXA2xx driver")
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
[<miquel.raynal@bootlin.com>: Reword the commit log]
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221119073307.22929-1-zhengyongjun3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/pxa2xx-flash.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/maps/pxa2xx-flash.c b/drivers/mtd/maps/pxa2xx-flash.c
index 2cde28ed95c9..59d2fe1f46e1 100644
--- a/drivers/mtd/maps/pxa2xx-flash.c
+++ b/drivers/mtd/maps/pxa2xx-flash.c
@@ -69,6 +69,7 @@ static int pxa2xx_flash_probe(struct platform_device *pdev)
 	if (!info->map.virt) {
 		printk(KERN_WARNING "Failed to ioremap %s\n",
 		       info->map.name);
+		kfree(info);
 		return -ENOMEM;
 	}
 	info->map.cached =
@@ -91,6 +92,7 @@ static int pxa2xx_flash_probe(struct platform_device *pdev)
 		iounmap((void *)info->map.virt);
 		if (info->map.cached)
 			iounmap(info->map.cached);
+		kfree(info);
 		return -EIO;
 	}
 	info->mtd->dev.parent = &pdev->dev;
-- 
2.35.1



