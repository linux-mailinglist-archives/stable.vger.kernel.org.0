Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F232F6B43ED
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbjCJOUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbjCJOTf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:19:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC76C17CD5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:18:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF8AF6195C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D2FC433D2;
        Fri, 10 Mar 2023 14:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457875;
        bh=agRvrc553inuw8bLKRfOvr93QnBTsezd3/j6fB9nvHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KopcQVj7aUrvbNTRhOWBM8Ll4qIh5a53vggROGtU30qeRzyrgxjixmuvsyRLzsStx
         TE1oc/TQ4m3nFIggfa1RJaSV3uCoB/GwUEZ4JQm0ucS+1+ehlDvWjQsQyQA5swgHRA
         FKHh4CpZiJOHeooOslSSFQ2+sGBi3W4gBLzResC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/252] spi: bcm63xx-hsspi: fix pm_runtime
Date:   Fri, 10 Mar 2023 14:37:36 +0100
Message-Id: <20230310133721.429431000@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 216e8e80057a9f0b6366327881acf88eaf9f1fd4 ]

The driver sets auto_runtime_pm to true, but it doesn't call
pm_runtime_enable(), which results in "Failed to power device" when PM support
is enabled.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Link: https://lore.kernel.org/r/20210223151851.4110-3-noltari@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 811ff802aaf8 ("spi: bcm63xx-hsspi: Fix multi-bit mode setting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx-hsspi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index 443a480767e09..f45df86cc95a0 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -20,6 +20,8 @@
 #include <linux/spi/spi.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
+#include <linux/reset.h>
+#include <linux/pm_runtime.h>
 
 #define HSSPI_GLOBAL_CTRL_REG			0x0
 #define GLOBAL_CTRL_CS_POLARITY_SHIFT		0
@@ -432,13 +434,17 @@ static int bcm63xx_hsspi_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_put_master;
 
+	pm_runtime_enable(&pdev->dev);
+
 	/* register and we are done */
 	ret = devm_spi_register_master(dev, master);
 	if (ret)
-		goto out_put_master;
+		goto out_pm_disable;
 
 	return 0;
 
+out_pm_disable:
+	pm_runtime_disable(&pdev->dev);
 out_put_master:
 	spi_master_put(master);
 out_disable_pll_clk:
-- 
2.39.2



