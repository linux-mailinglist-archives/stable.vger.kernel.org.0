Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F6250116C
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244400AbiDNNe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343518AbiDNN3W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:29:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9D1259;
        Thu, 14 Apr 2022 06:24:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29D94618F8;
        Thu, 14 Apr 2022 13:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE07C385A1;
        Thu, 14 Apr 2022 13:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942660;
        bh=7lqMYDTm3lYWziLp6V7LYNrbssEWtBwFxXMmrJaKMzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqglW2adeoGUKe/DulBAigRs2xKlZSESpJrMrQSjGIcetcJyQ3jgSU4wbMBKcm3Pw
         DxY0+6lZMle4D2qOK8U8vswUgVOMM8XU9gETciuhBa4uumAB3YZdBxdzyQdhXX9ugV
         00oXHqzH4w2yHKxzf1ugzI5qgisjh7OEwZSLb5mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 215/338] ARM: mmp: Fix failure to remove sram device
Date:   Thu, 14 Apr 2022 15:11:58 +0200
Message-Id: <20220414110845.013575969@linuxfoundation.org>
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 4036b29a146b2749af3bb213b003eb69f3e5ecc4 ]

Make sure in .probe() to set driver data before the function is left to
make it possible in .remove() to undo the actions done.

This fixes a potential memory leak and stops returning an error code in
.remove() that is ignored by the driver core anyhow.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-mmp/sram.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-mmp/sram.c b/arch/arm/mach-mmp/sram.c
index ba91e4fe444d..3c4e41dabb02 100644
--- a/arch/arm/mach-mmp/sram.c
+++ b/arch/arm/mach-mmp/sram.c
@@ -76,6 +76,8 @@ static int sram_probe(struct platform_device *pdev)
 	if (!info)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, info);
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "no memory resource defined\n");
@@ -111,8 +113,6 @@ static int sram_probe(struct platform_device *pdev)
 	list_add(&info->node, &sram_bank_list);
 	mutex_unlock(&sram_lock);
 
-	platform_set_drvdata(pdev, info);
-
 	dev_info(&pdev->dev, "initialized\n");
 	return 0;
 
@@ -131,17 +131,19 @@ static int sram_remove(struct platform_device *pdev)
 	struct sram_bank_info *info;
 
 	info = platform_get_drvdata(pdev);
-	if (info == NULL)
-		return -ENODEV;
 
-	mutex_lock(&sram_lock);
-	list_del(&info->node);
-	mutex_unlock(&sram_lock);
+	if (info->sram_size) {
+		mutex_lock(&sram_lock);
+		list_del(&info->node);
+		mutex_unlock(&sram_lock);
+
+		gen_pool_destroy(info->gpool);
+		iounmap(info->sram_virt);
+		kfree(info->pool_name);
+	}
 
-	gen_pool_destroy(info->gpool);
-	iounmap(info->sram_virt);
-	kfree(info->pool_name);
 	kfree(info);
+
 	return 0;
 }
 
-- 
2.34.1



