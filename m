Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2426B4169
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjCJNwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjCJNwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:52:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1674F115641
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:52:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A62846182F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A957AC4339B;
        Fri, 10 Mar 2023 13:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456349;
        bh=9U2y3AmR7U56ZJOBpioLIFTzvCmSqb8Bnjc9hdqcSt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zyND8PLFys8d0S1pIe4dDNw27vW1LYVteS/LQ8xnkxTtzYsu0l9gcrGDr2fPS3bJX
         ucKelap/lVhmlpC21PmqKld20hU5DzzZpAEyRlkm3gr9tmyKiFpF4HoFcO0+a5uEvQ
         xBE71BDtQxfTuLFeJHHAvuxzI5QHmUlv3WWgJULY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ruanjinjie <ruanjinjie@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 165/193] watchdog: at91sam9_wdt: use devm_request_irq to avoid missing free_irq() in error path
Date:   Fri, 10 Mar 2023 14:39:07 +0100
Message-Id: <20230310133716.640134643@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ruanjinjie <ruanjinjie@huawei.com>

[ Upstream commit 07bec0e09c1afbab4c5674fd2341f4f52d594f30 ]

free_irq() is missing in case of error in at91_wdt_init(), use
devm_request_irq to fix that.

Fixes: 5161b31dc39a ("watchdog: at91sam9_wdt: better watchdog support")
Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20221116094950.3141943-1-ruanjinjie@huawei.com
[groeck: Adjust multi-line alignment]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/at91sam9_wdt.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 7e6acaf3ece49..f3d8ae8df7f65 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -209,10 +209,9 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
 			 "min heartbeat and max heartbeat might be too close for the system to handle it correctly\n");
 
 	if ((tmp & AT91_WDT_WDFIEN) && wdt->irq) {
-		err = request_irq(wdt->irq, wdt_interrupt,
-				  IRQF_SHARED | IRQF_IRQPOLL |
-				  IRQF_NO_SUSPEND,
-				  pdev->name, wdt);
+		err = devm_request_irq(dev, wdt->irq, wdt_interrupt,
+				       IRQF_SHARED | IRQF_IRQPOLL | IRQF_NO_SUSPEND,
+				       pdev->name, wdt);
 		if (err)
 			return err;
 	}
-- 
2.39.2



