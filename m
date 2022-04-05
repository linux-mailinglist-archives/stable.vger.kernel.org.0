Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B3F4F3751
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352731AbiDELMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348964AbiDEJsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE79A0BD3;
        Tue,  5 Apr 2022 02:38:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E00B7B81B7F;
        Tue,  5 Apr 2022 09:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E060C385A2;
        Tue,  5 Apr 2022 09:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151496;
        bh=QwLQUT2Jw7vwffeh6OOnj7GZe0N18ZdeXGnosRVYSSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGNkXHpS534sPY4Q13kyXMIIoEHDGbOdLxWE9CZ5DR3SO7cK2mteHbG6I36dG2If/
         hyZKhI8lBcIdh7c3YPvHQmALB9BzOujVt0Rwwwve8t0iCV7g8WEq0eaCm1hC+ndoBC
         IqNfGWxwBZwHraI7jgQlUNFHPa8R/sAM1/53CW6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 436/913] i2c: bcm2835: Fix the error handling in bcm2835_i2c_probe()
Date:   Tue,  5 Apr 2022 09:24:58 +0200
Message-Id: <20220405070352.915051749@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b205f5850263632b6897d8f0bfaeeea4955f8663 ]

Some resource should be released if an error occurs in
'bcm2835_i2c_probe()'.
Add an error handling path and the needed 'clk_disable_unprepare()' and
'clk_rate_exclusive_put()' calls.

While at it, rework the bottom of the function to use this newly added
error handling path and have an explicit and more standard "return 0;" at
the end of the normal path.

Fixes: bebff81fb8b9 ("i2c: bcm2835: Model Divider in CCF")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
[wsa: rebased]
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-bcm2835.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bcm2835.c b/drivers/i2c/busses/i2c-bcm2835.c
index 5149454eef4a..f72c6576d8a3 100644
--- a/drivers/i2c/busses/i2c-bcm2835.c
+++ b/drivers/i2c/busses/i2c-bcm2835.c
@@ -454,18 +454,20 @@ static int bcm2835_i2c_probe(struct platform_device *pdev)
 	ret = clk_prepare_enable(i2c_dev->bus_clk);
 	if (ret) {
 		dev_err(&pdev->dev, "Couldn't prepare clock");
-		return ret;
+		goto err_put_exclusive_rate;
 	}
 
 	i2c_dev->irq = platform_get_irq(pdev, 0);
-	if (i2c_dev->irq < 0)
-		return i2c_dev->irq;
+	if (i2c_dev->irq < 0) {
+		ret = i2c_dev->irq;
+		goto err_disable_unprepare_clk;
+	}
 
 	ret = request_irq(i2c_dev->irq, bcm2835_i2c_isr, IRQF_SHARED,
 			  dev_name(&pdev->dev), i2c_dev);
 	if (ret) {
 		dev_err(&pdev->dev, "Could not request IRQ\n");
-		return -ENODEV;
+		goto err_disable_unprepare_clk;
 	}
 
 	adap = &i2c_dev->adapter;
@@ -489,7 +491,16 @@ static int bcm2835_i2c_probe(struct platform_device *pdev)
 
 	ret = i2c_add_adapter(adap);
 	if (ret)
-		free_irq(i2c_dev->irq, i2c_dev);
+		goto err_free_irq;
+
+	return 0;
+
+err_free_irq:
+	free_irq(i2c_dev->irq, i2c_dev);
+err_disable_unprepare_clk:
+	clk_disable_unprepare(i2c_dev->bus_clk);
+err_put_exclusive_rate:
+	clk_rate_exclusive_put(i2c_dev->bus_clk);
 
 	return ret;
 }
-- 
2.34.1



