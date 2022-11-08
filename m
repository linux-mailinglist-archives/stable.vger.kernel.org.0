Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851BF62152F
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235071AbiKHOJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbiKHOJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:09:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B24BF7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:09:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5DB36152D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D3DC433D6;
        Tue,  8 Nov 2022 14:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916547;
        bh=Q4wSqSx1JQsdTRhNPlEyhn8kYMQAQQG1jW1ZPVAGzRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFtjv6oHUKXjPl4d2E8x0vok65PIkT/j+7vGi5SyZW8+ur0Sy+bPKIVyi1zS65R9L
         rn+TWZVW7YZPNbjJ/ZWAJhLJuL4QkVpwwFOHuZV4zZ8ZybrYD6gjDBlB28BFy7m8Mu
         vDys1QQokGncE+5mbkvvkmgvyEYiLh7AVtLxz+J8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 027/197] ata: palmld: fix return value check in palmld_pata_probe()
Date:   Tue,  8 Nov 2022 14:37:45 +0100
Message-Id: <20221108133356.026074581@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 015618c3ec19584c83ff179fa631be8cec906aaf ]

If devm_platform_ioremap_resource() fails, it never return
NULL pointer, replace the check with IS_ERR().

Fixes: 57bf0f5a162d ("ARM: pxa: use pdev resource for palmld mmio")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_palmld.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_palmld.c b/drivers/ata/pata_palmld.c
index 400e65190904..51caa2a427dd 100644
--- a/drivers/ata/pata_palmld.c
+++ b/drivers/ata/pata_palmld.c
@@ -63,8 +63,8 @@ static int palmld_pata_probe(struct platform_device *pdev)
 
 	/* remap drive's physical memory address */
 	mem = devm_platform_ioremap_resource(pdev, 0);
-	if (!mem)
-		return -ENOMEM;
+	if (IS_ERR(mem))
+		return PTR_ERR(mem);
 
 	/* request and activate power and reset GPIOs */
 	lda->power = devm_gpiod_get(dev, "power", GPIOD_OUT_HIGH);
-- 
2.35.1



