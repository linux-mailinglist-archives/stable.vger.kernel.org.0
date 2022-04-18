Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B78750584A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244957AbiDROAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244856AbiDRN6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:58:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80115E6B;
        Mon, 18 Apr 2022 06:08:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1602760F24;
        Mon, 18 Apr 2022 13:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C590C385A7;
        Mon, 18 Apr 2022 13:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287288;
        bh=TCCHLWZjI2lOSY90qAUVqxi++CpwCH2A11H+mYpGMHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDbOR7HMznvD82PdYEy1Lgyaeve3FfM+EA0YCPGtEp8TYYOuZHwhI1kEPZTaUR0lx
         nf5pkQ4HzZ8zUK7mgCLvCmIQi2QOm8stuhnQc+yPTHh2T8vLqZqeZmIfqXcFybUvKO
         TFuEz19hhuzoUJ9eSnqmkL7tfuxrGty+e0O2vN3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 114/218] pinctrl/rockchip: Add missing of_node_put() in rockchip_pinctrl_probe
Date:   Mon, 18 Apr 2022 14:13:00 +0200
Message-Id: <20220418121202.857520763@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 89388f8730699c259f8090ec435fb43569efe4ac ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.

Fixes: 1e747e59cc4d ("pinctrl: rockchip: base regmap supplied by a syscon")
Fixes: 14dee8677e19 ("pinctrl: rockchip: let pmu registers be supplied by a syscon")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220307120234.28657-1-linmq006@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 17827a88b85e..9bcb238c2e12 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2414,6 +2414,7 @@ static int rockchip_pinctrl_probe(struct platform_device *pdev)
 	node = of_parse_phandle(np, "rockchip,grf", 0);
 	if (node) {
 		info->regmap_base = syscon_node_to_regmap(node);
+		of_node_put(node);
 		if (IS_ERR(info->regmap_base))
 			return PTR_ERR(info->regmap_base);
 	} else {
@@ -2450,6 +2451,7 @@ static int rockchip_pinctrl_probe(struct platform_device *pdev)
 	node = of_parse_phandle(np, "rockchip,pmu", 0);
 	if (node) {
 		info->regmap_pmu = syscon_node_to_regmap(node);
+		of_node_put(node);
 		if (IS_ERR(info->regmap_pmu))
 			return PTR_ERR(info->regmap_pmu);
 	}
-- 
2.34.1



