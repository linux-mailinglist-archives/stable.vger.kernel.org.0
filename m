Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25BC15015BF
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343503AbiDNOIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238894AbiDNNwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:52:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDFE31929;
        Thu, 14 Apr 2022 06:44:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBE9761D68;
        Thu, 14 Apr 2022 13:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DD2C385A5;
        Thu, 14 Apr 2022 13:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943873;
        bh=cmQjIDOiyu6i0WOxV+vP3qJn8wa2woRKYCESBKH7hvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nczZKgwY2/XkhUNqUz8N9GsOOdXt5f2xO5P0t8MZkn/QCoG/PUG0RBJHX3Y4aHjE3
         uOsY7xLLptg9nmfaLPOakCLkqbhrQd7FP+QqnPiqnYFkZeY/dWi7yW3XgxDHmVaMiu
         eJXdh6SJf1NeAyqR4473RcUMYluBLbk4IkHOPEFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 305/475] ARM: mmp: Fix failure to remove sram device
Date:   Thu, 14 Apr 2022 15:11:30 +0200
Message-Id: <20220414110903.627433029@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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



