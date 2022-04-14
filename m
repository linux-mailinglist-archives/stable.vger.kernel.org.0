Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E26500F1B
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244106AbiDNNYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244219AbiDNNX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:23:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A3A9AE5F;
        Thu, 14 Apr 2022 06:18:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7222FB82983;
        Thu, 14 Apr 2022 13:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0631C385A5;
        Thu, 14 Apr 2022 13:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942328;
        bh=O+h3gYtfzfXbxc990FEKqfbwEe8smAZIQ1rCMsTfi+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r8xvgK86zxf/8CS+u5sbTwsd/Nw5epSNdHgfqlyHo4TZkRchBMG/HywowOdNMXoe7
         gSNmy8g3cjHxU9Ft9lTzx4wSfpsuOOZsYOgjle9UPtkDnhfm6VinMhNmgDIdU85xHH
         kxF9+4mF/JHnuCrNuCeRr1w2U9hDOU8FAf2PNBMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/338] ASoC: ti: davinci-i2s: Add check for clk_enable()
Date:   Thu, 14 Apr 2022 15:09:58 +0200
Message-Id: <20220414110841.603300271@linuxfoundation.org>
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
index a3206e65e5e5..205841e46046 100644
--- a/sound/soc/davinci/davinci-i2s.c
+++ b/sound/soc/davinci/davinci-i2s.c
@@ -721,7 +721,9 @@ static int davinci_i2s_probe(struct platform_device *pdev)
 	dev->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(dev->clk))
 		return -ENODEV;
-	clk_enable(dev->clk);
+	ret = clk_enable(dev->clk);
+	if (ret)
+		goto err_put_clk;
 
 	dev->dev = &pdev->dev;
 	dev_set_drvdata(&pdev->dev, dev);
@@ -743,6 +745,7 @@ static int davinci_i2s_probe(struct platform_device *pdev)
 	snd_soc_unregister_component(&pdev->dev);
 err_release_clk:
 	clk_disable(dev->clk);
+err_put_clk:
 	clk_put(dev->clk);
 	return ret;
 }
-- 
2.34.1



