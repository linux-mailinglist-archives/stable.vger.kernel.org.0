Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B67650550C
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241174AbiDRNPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242086AbiDRNNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:13:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D323A1AE;
        Mon, 18 Apr 2022 05:51:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD28D61287;
        Mon, 18 Apr 2022 12:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DE9C385A8;
        Mon, 18 Apr 2022 12:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286261;
        bh=FJARBZBjsKTFIZCwEbBcLJQp8/d4yzz5kJwdbs6GYbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ei3kUWxwt+VM3jeF+FgOyCJ2sZ/+oxzOxHEIkEGWlZ/r96EMPqQyqN67mMIByjNMh
         erxm3TZi4TLrktSMQyUJAqkQdhwGjGnq5HJBSwrB+4ZSVAG9YRA3r1ADw/UDJa33Qt
         8eajziq4RWonUZ/8v7KBLrJRiPEAmgTFcQmApro4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 077/284] ASoC: ti: davinci-i2s: Add check for clk_enable()
Date:   Mon, 18 Apr 2022 14:10:58 +0200
Message-Id: <20220418121212.876495581@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit ed7c9fef11931fc5d32a83d68017ff390bf5c280 ]

As the potential failure of the clk_enable(),
it should be better to check it and return error
if fails.

Fixes: 5f9a50c3e55e ("ASoC: Davinci: McBSP: add device tree support for McBSP")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20220228031540.3571959-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/davinci/davinci-i2s.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/davinci/davinci-i2s.c b/sound/soc/davinci/davinci-i2s.c
index 384961651904..e5f61f1499c6 100644
--- a/sound/soc/davinci/davinci-i2s.c
+++ b/sound/soc/davinci/davinci-i2s.c
@@ -719,7 +719,9 @@ static int davinci_i2s_probe(struct platform_device *pdev)
 	dev->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(dev->clk))
 		return -ENODEV;
-	clk_enable(dev->clk);
+	ret = clk_enable(dev->clk);
+	if (ret)
+		goto err_put_clk;
 
 	dev->dev = &pdev->dev;
 	dev_set_drvdata(&pdev->dev, dev);
@@ -741,6 +743,7 @@ static int davinci_i2s_probe(struct platform_device *pdev)
 	snd_soc_unregister_component(&pdev->dev);
 err_release_clk:
 	clk_disable(dev->clk);
+err_put_clk:
 	clk_put(dev->clk);
 	return ret;
 }
-- 
2.34.1



