Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657424EC119
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344176AbiC3L4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344796AbiC3Lxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AB927973D;
        Wed, 30 Mar 2022 04:49:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50B0761640;
        Wed, 30 Mar 2022 11:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CE2C34115;
        Wed, 30 Mar 2022 11:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640979;
        bh=cmQjIDOiyu6i0WOxV+vP3qJn8wa2woRKYCESBKH7hvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szzKjdLFw51xygWvZp84AG2D5Gve2l7CrmRA94s7VKh7WJ+ZniM1wpvr6SBP6Z96r
         4TT8+LDu5SnUDllBBXt3aIJXg9dIyEkKhmJyi8PVla84ueyzDxsvMJJeNFc7QV+DV0
         eoF4K6Zjrkr6Ks2/3SW69cjzAIom5HKYn2ucdSkUytMuvQPSTzhiPtLyxfe14ViMSR
         yYAI8vImHdGaEDymSvB0vqy+li0gW+mfEtzX/zmXCPqT07RMr8vkpQeEGG0qF7loDG
         cXFR8fItR0RcYYb8AXmYx4b6GlO9EpDHknxyDmLvpbP9fnBWr5BuZhd5NXWhFl/pIM
         WR01QBlqpal1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        eric.y.miao@gmail.com, haojian.zhuang@gmail.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 43/59] ARM: mmp: Fix failure to remove sram device
Date:   Wed, 30 Mar 2022 07:48:15 -0400
Message-Id: <20220330114831.1670235-43-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index 6794e2db1ad5..ecc46c31004f 100644
--- a/arch/arm/mach-mmp/sram.c
+++ b/arch/arm/mach-mmp/sram.c
@@ -72,6 +72,8 @@ static int sram_probe(struct platform_device *pdev)
 	if (!info)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, info);
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "no memory resource defined\n");
@@ -107,8 +109,6 @@ static int sram_probe(struct platform_device *pdev)
 	list_add(&info->node, &sram_bank_list);
 	mutex_unlock(&sram_lock);
 
-	platform_set_drvdata(pdev, info);
-
 	dev_info(&pdev->dev, "initialized\n");
 	return 0;
 
@@ -127,17 +127,19 @@ static int sram_remove(struct platform_device *pdev)
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

