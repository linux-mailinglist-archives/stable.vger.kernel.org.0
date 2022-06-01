Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8F453A6CA
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348155AbiFANzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353797AbiFANzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:55:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB638CCC8;
        Wed,  1 Jun 2022 06:54:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13ED2B81AE7;
        Wed,  1 Jun 2022 13:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4BEC3411D;
        Wed,  1 Jun 2022 13:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091589;
        bh=MzavRj9nrP27S+bq6CPB0yuwsmyvhj3CJKBoxHtwgwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMjCZxeWNLUrg2XTU8JS1XKUF5e96t3Xsj6D7SI3ROzGhrkx+/ntHhcwJ1Y0h1luF
         yz2i4EF4hBsHlZe58ugdk+n0ExRtG54BsWn66IMTb0unEl7oLIsA+7QT7Tb0NFPkz9
         YdOc9O9rZfca7QkPJToW/nxQEHU8CRM5Ts2dsuJdldtkFAAFIHuZCe1x56PsTqyR4i
         bF+OKwStqIIUrh+g8Ak5VozOvTEk5szV2ZcHghVkUYhUSkR8+xPtRSn1RxlKlY8tOV
         VZmatdJBkvFiVVds9gdChsXZj+hjoeroZQ9Ulp+4nCJsuL30YeY1POgrvN01CkR9Rj
         gZloub7acvS+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>, linus.walleij@linaro.org,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 22/49] pinctrl: renesas: rzn1: Fix possible null-ptr-deref in sh_pfc_map_resources()
Date:   Wed,  1 Jun 2022 09:51:46 -0400
Message-Id: <20220601135214.2002647-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135214.2002647-1-sashal@kernel.org>
References: <20220601135214.2002647-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 2f661477c2bb8068194dbba9738d05219f111c6e ]

It will cause null-ptr-deref when using 'res', if platform_get_resource()
returns NULL, so move using 'res' after devm_ioremap_resource() that
will check it to avoid null-ptr-deref.
And use devm_platform_get_and_ioremap_resource() to simplify code.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220429082637.1308182-2-yangyingliang@huawei.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzn1.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzn1.c b/drivers/pinctrl/renesas/pinctrl-rzn1.c
index ef5fb25b6016..849d091205d4 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzn1.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzn1.c
@@ -865,17 +865,15 @@ static int rzn1_pinctrl_probe(struct platform_device *pdev)
 	ipctl->mdio_func[0] = -1;
 	ipctl->mdio_func[1] = -1;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	ipctl->lev1_protect_phys = (u32)res->start + 0x400;
-	ipctl->lev1 = devm_ioremap_resource(&pdev->dev, res);
+	ipctl->lev1 = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(ipctl->lev1))
 		return PTR_ERR(ipctl->lev1);
+	ipctl->lev1_protect_phys = (u32)res->start + 0x400;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	ipctl->lev2_protect_phys = (u32)res->start + 0x400;
-	ipctl->lev2 = devm_ioremap_resource(&pdev->dev, res);
+	ipctl->lev2 = devm_platform_get_and_ioremap_resource(pdev, 1, &res);
 	if (IS_ERR(ipctl->lev2))
 		return PTR_ERR(ipctl->lev2);
+	ipctl->lev2_protect_phys = (u32)res->start + 0x400;
 
 	ipctl->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(ipctl->clk))
-- 
2.35.1

