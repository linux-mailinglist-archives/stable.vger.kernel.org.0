Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581E459DBE8
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357739AbiHWLiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358047AbiHWLgl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:36:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28EE915D1;
        Tue, 23 Aug 2022 02:27:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F025B81C99;
        Tue, 23 Aug 2022 09:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAB1C43140;
        Tue, 23 Aug 2022 09:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246870;
        bh=wF1A5vtd8tvVocO+QjQ6jbB4zTb2fIRPK/24cR2VM5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBhRv4CmhJrFkacCsnsw5FZZEksGzYQ/FC1iRcNJy/a8uJK7ZyBavNtxBwER99hAR
         86Dr7AOkJZh1Gb8iagk6KGzHZi4chjroB0JBV9Po1gsGa7kzuyp8UqS0DQuzVrx2Wg
         67K+slFuG/c9SyVMROFeedVyYZmniMZ4MaN7eyrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hacash Robot <hacashRobot@santino.com>,
        William Dean <williamsukatube@gmail.com>,
        Marek Beh=C3=BAn <kabel@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 229/389] watchdog: armada_37xx_wdt: check the return value of devm_ioremap() in armada_37xx_wdt_probe()
Date:   Tue, 23 Aug 2022 10:25:07 +0200
Message-Id: <20220823080125.164292444@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: William Dean <williamsukatube@gmail.com>

[ Upstream commit 2d27e52841092e5831dd41f313028c668d816eb0 ]

The function devm_ioremap() in armada_37xx_wdt_probe() can fail, so
its return value should be checked.

Fixes: 54e3d9b518c8a ("watchdog: Add support for Armada 37xx CPU watchdog")
Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: William Dean <williamsukatube@gmail.com>
Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220722030938.2925156-1-williamsukatube@163.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/armada_37xx_wdt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/watchdog/armada_37xx_wdt.c b/drivers/watchdog/armada_37xx_wdt.c
index e5dcb26d85f0..dcb3ffda3fad 100644
--- a/drivers/watchdog/armada_37xx_wdt.c
+++ b/drivers/watchdog/armada_37xx_wdt.c
@@ -274,6 +274,8 @@ static int armada_37xx_wdt_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENODEV;
 	dev->reg = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!dev->reg)
+		return -ENOMEM;
 
 	/* init clock */
 	dev->clk = devm_clk_get(&pdev->dev, NULL);
-- 
2.35.1



