Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0956166C6FD
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbjAPQ1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbjAPQ0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:26:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC342BF03
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:14:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACCED61031
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD06C433D2;
        Mon, 16 Jan 2023 16:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885696;
        bh=S8B+7BUL+uRwVISrw8I+/MgAHOjDqUc4NVsmGQ2/cNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mycge1tlPOoas08AXEPt5bdSEPDR01YXkseoPfxPqvOMJ1MeB8MeQdIYm1LQblyWt
         sA92itjDnyGNtNGKux1LKZcOKJwMSnR0fb8HNkkTFQRz3mxfIgu6XyvtLiAWOCF4xV
         nKJjxtZDvKZOs/39mYYauIMi0WMeDFI1XEeOx8fE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 149/658] mtd: maps: pxa2xx-flash: fix memory leak in probe
Date:   Mon, 16 Jan 2023 16:43:57 +0100
Message-Id: <20230116154916.280372615@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 7d96758a8f04..6e5e55755970 100644
--- a/drivers/mtd/maps/pxa2xx-flash.c
+++ b/drivers/mtd/maps/pxa2xx-flash.c
@@ -66,6 +66,7 @@ static int pxa2xx_flash_probe(struct platform_device *pdev)
 	if (!info->map.virt) {
 		printk(KERN_WARNING "Failed to ioremap %s\n",
 		       info->map.name);
+		kfree(info);
 		return -ENOMEM;
 	}
 	info->map.cached = ioremap_cache(info->map.phys, info->map.size);
@@ -87,6 +88,7 @@ static int pxa2xx_flash_probe(struct platform_device *pdev)
 		iounmap((void *)info->map.virt);
 		if (info->map.cached)
 			iounmap(info->map.cached);
+		kfree(info);
 		return -EIO;
 	}
 	info->mtd->dev.parent = &pdev->dev;
-- 
2.35.1



