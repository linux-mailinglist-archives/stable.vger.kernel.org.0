Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FA053A7A7
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354223AbiFAOCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355218AbiFAOBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:01:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87499A5A92;
        Wed,  1 Jun 2022 06:58:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 767E0CE1C34;
        Wed,  1 Jun 2022 13:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08720C36AE2;
        Wed,  1 Jun 2022 13:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091823;
        bh=MzavRj9nrP27S+bq6CPB0yuwsmyvhj3CJKBoxHtwgwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/F6aAWir/sS6Qdn/oFyv2cg77Ctt28Xhtr1QcrhlHTgYM4kOjwCS9NtBH+vRx6JM
         JyXfYj+RYd/4b/uCkioZR4gPMFn2tj8xJLD75HjDDXblLkIGegf558ohE3aOHrI+WU
         gyFhUglwDtAI+JukflMOhp58l0jN+IpiB+dDFzZd764fK2dngilikqRjsdYb6HtHod
         XMfPCSSPzjGEuWC6XViV99myv0zrgiXr7oRC+qIt5j+zIfgXA9tnnXXqi7AeFOwzHN
         G0aceN2m2gW0jcNe21keVhez09vz3mVRig/jzUSbKJCkbdrJb63gkSZKAra3xZlY37
         DjykfZRdf31tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>, linus.walleij@linaro.org,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 19/37] pinctrl: renesas: rzn1: Fix possible null-ptr-deref in sh_pfc_map_resources()
Date:   Wed,  1 Jun 2022 09:56:04 -0400
Message-Id: <20220601135622.2003939-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135622.2003939-1-sashal@kernel.org>
References: <20220601135622.2003939-1-sashal@kernel.org>
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

