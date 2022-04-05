Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E395A4F2B89
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241597AbiDEIed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239457AbiDEIUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98E76A43C;
        Tue,  5 Apr 2022 01:13:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77D7AB81A37;
        Tue,  5 Apr 2022 08:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC66DC385A0;
        Tue,  5 Apr 2022 08:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146416;
        bh=MgDDT8VuQWca49TghJ4tLzY7YNfYN4Yv/TzRySXi/dQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azuykinysNGxWi1fY1clezDdzjHz7ckJrLM38Z7dNGdo2Vn3bLK4n/HoREYpecomY
         f2IIDBw5t2v8RzYE4d+6WUMfg4eltGeG9v8XMTwJs//MBDPjWkm5NVfXp8mNVZ+CUx
         Fqg8hw+bgCWcE1sLhobXllJPEAHxK02gtNuo9JIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0718/1126] fsi: Aspeed: Fix a potential double free
Date:   Tue,  5 Apr 2022 09:24:25 +0200
Message-Id: <20220405070428.669582485@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 83ba7e895debc529803a7a258653f2fe9bf3bf40 ]

A struct device can never be devm_alloc()'ed.
Here, it is embedded in "struct fsi_master", and "struct fsi_master" is
embedded in "struct fsi_master_aspeed".

Since "struct device" is embedded, the data structure embedding it must be
released with the release function, as is already done here.

So use kzalloc() instead of devm_kzalloc() when allocating "aspeed" and
update all error handling branches accordingly.

This prevent a potential double free().

This also fix another issue if opb_readl() fails. Instead of a direct
return, it now jumps in the error handling path.

Fixes: 606397d67f41 ("fsi: Add ast2600 master driver")
Suggested-by: Greg KH <gregkh@linuxfoundation.org>
Suggested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/2c123f8b0a40dc1a061fae982169fe030b4f47e6.1641765339.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-master-aspeed.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/fsi/fsi-master-aspeed.c b/drivers/fsi/fsi-master-aspeed.c
index 8606e55c1721..0bed2fab8055 100644
--- a/drivers/fsi/fsi-master-aspeed.c
+++ b/drivers/fsi/fsi-master-aspeed.c
@@ -542,25 +542,28 @@ static int fsi_master_aspeed_probe(struct platform_device *pdev)
 		return rc;
 	}
 
-	aspeed = devm_kzalloc(&pdev->dev, sizeof(*aspeed), GFP_KERNEL);
+	aspeed = kzalloc(sizeof(*aspeed), GFP_KERNEL);
 	if (!aspeed)
 		return -ENOMEM;
 
 	aspeed->dev = &pdev->dev;
 
 	aspeed->base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(aspeed->base))
-		return PTR_ERR(aspeed->base);
+	if (IS_ERR(aspeed->base)) {
+		rc = PTR_ERR(aspeed->base);
+		goto err_free_aspeed;
+	}
 
 	aspeed->clk = devm_clk_get(aspeed->dev, NULL);
 	if (IS_ERR(aspeed->clk)) {
 		dev_err(aspeed->dev, "couldn't get clock\n");
-		return PTR_ERR(aspeed->clk);
+		rc = PTR_ERR(aspeed->clk);
+		goto err_free_aspeed;
 	}
 	rc = clk_prepare_enable(aspeed->clk);
 	if (rc) {
 		dev_err(aspeed->dev, "couldn't enable clock\n");
-		return rc;
+		goto err_free_aspeed;
 	}
 
 	rc = setup_cfam_reset(aspeed);
@@ -595,7 +598,7 @@ static int fsi_master_aspeed_probe(struct platform_device *pdev)
 	rc = opb_readl(aspeed, ctrl_base + FSI_MVER, &raw);
 	if (rc) {
 		dev_err(&pdev->dev, "failed to read hub version\n");
-		return rc;
+		goto err_release;
 	}
 
 	reg = be32_to_cpu(raw);
@@ -634,6 +637,8 @@ static int fsi_master_aspeed_probe(struct platform_device *pdev)
 
 err_release:
 	clk_disable_unprepare(aspeed->clk);
+err_free_aspeed:
+	kfree(aspeed);
 	return rc;
 }
 
-- 
2.34.1



