Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3847854193F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378467AbiFGVTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380687AbiFGVQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130C521F9A3;
        Tue,  7 Jun 2022 11:56:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 925A36176D;
        Tue,  7 Jun 2022 18:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CCCC385A2;
        Tue,  7 Jun 2022 18:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628164;
        bh=MzavRj9nrP27S+bq6CPB0yuwsmyvhj3CJKBoxHtwgwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w041QQuW6VPPKnz6xlCcxmlN1O2RT79aXuY/nCUxIrrkqJuJUTAdJYVrZRs5hDYvf
         KWNRTjT2tWaGmMNT9H3Od/Q2Czx8h0cYxajiw/IxJK4QXYCbxKX+XMyP6mHwfrzjej
         u3SeK4M+0ioHyXeQwdlA322fM1y/k3+s4lNCInUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 228/879] pinctrl: renesas: rzn1: Fix possible null-ptr-deref in sh_pfc_map_resources()
Date:   Tue,  7 Jun 2022 18:55:46 +0200
Message-Id: <20220607165009.471207468@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



