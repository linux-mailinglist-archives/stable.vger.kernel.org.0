Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B575488EF
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352690AbiFMMan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354878AbiFMM2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:28:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FFC58E78;
        Mon, 13 Jun 2022 04:06:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D64E8614C2;
        Mon, 13 Jun 2022 11:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40C0C34114;
        Mon, 13 Jun 2022 11:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118353;
        bh=wBCeYx+pNV/e5mIu30VKRdK4jv593PGbP3FGh/J2fMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jM0HBsF9EfjnxfBFm1NAWWqLDbX4dydtSXmJpQArbR/zIrmhslHMQjeC6ptuhr1EA
         oVzuGW70vwMDkj/ZoEVIEeHYla7ntEZKEfRXNaSIj55cpCq4RlLxDmyBQ+Yng5DgtK
         geo+mQtaMga15DOL2Bw7yta+2pGopvSFWfB+tHAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/172] watchdog: rti-wdt: Fix pm_runtime_get_sync() error checking
Date:   Mon, 13 Jun 2022 12:10:05 +0200
Message-Id: <20220613094901.263466728@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit b3ac0c58fa8934926360268f3d89ec7680644d7b ]

If the device is already in a runtime PM enabled state
pm_runtime_get_sync() will return 1, so a test for negative
value should be used to check for errors.

Fixes: 2d63908bdbfb ("watchdog: Add K3 RTI watchdog support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220412070824.23708-1-linmq006@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rti_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/rti_wdt.c b/drivers/watchdog/rti_wdt.c
index ae7f9357bb87..46c2a4bd9ebe 100644
--- a/drivers/watchdog/rti_wdt.c
+++ b/drivers/watchdog/rti_wdt.c
@@ -227,7 +227,7 @@ static int rti_wdt_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 	ret = pm_runtime_get_sync(dev);
-	if (ret) {
+	if (ret < 0) {
 		pm_runtime_put_noidle(dev);
 		pm_runtime_disable(&pdev->dev);
 		return dev_err_probe(dev, ret, "runtime pm failed\n");
-- 
2.35.1



