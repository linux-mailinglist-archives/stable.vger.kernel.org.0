Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9008E50F67A
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbiDZIsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346916AbiDZIpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFB913DD8;
        Tue, 26 Apr 2022 01:36:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0AA06185C;
        Tue, 26 Apr 2022 08:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DADBC385A0;
        Tue, 26 Apr 2022 08:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962199;
        bh=LNen/Hol42nJKmCO91F1P60/W/lNiA3tn9i6VwXxB0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2UrutGPySF6NkR3ee6eZ8xZW0bvaLGv79ODSop2B4fuMSU+eiN6RqNj+dd5+lOkbj
         A4TIx8erexbJMjzz3AKhdG2DEKfK/9in6qVzccckO6Shxdt+FaXopm17pmWeM1HYJo
         BMx1h1B4ZEQLV+7DkxV8PB0HujF18giXEyzyv58M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/124] ASoC: rk817: Use devm_clk_get() in rk817_platform_probe
Date:   Tue, 26 Apr 2022 10:20:20 +0200
Message-Id: <20220426081747.851459886@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 8ba08d3a367a70f707b7c5d53ad92b98b960ee88 ]

We need to call clk_put() to undo clk_get() in the error path.
Use devm_clk_get() to obtain a reference to the clock, It has
the benefit that clk_put() is no longer required.

Fixes: 0d6a04da9b25 ("ASoC: Add Rockchip rk817 audio CODEC support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220404090753.17940-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rk817_codec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rk817_codec.c b/sound/soc/codecs/rk817_codec.c
index 8fffe378618d..cce6f4e7992f 100644
--- a/sound/soc/codecs/rk817_codec.c
+++ b/sound/soc/codecs/rk817_codec.c
@@ -489,7 +489,7 @@ static int rk817_platform_probe(struct platform_device *pdev)
 
 	rk817_codec_parse_dt_property(&pdev->dev, rk817_codec_data);
 
-	rk817_codec_data->mclk = clk_get(pdev->dev.parent, "mclk");
+	rk817_codec_data->mclk = devm_clk_get(pdev->dev.parent, "mclk");
 	if (IS_ERR(rk817_codec_data->mclk)) {
 		dev_dbg(&pdev->dev, "Unable to get mclk\n");
 		ret = -ENXIO;
-- 
2.35.1



