Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A926B4496
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbjCJOZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbjCJOZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:25:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F7211FFA4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:24:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8865861745
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEAAC433EF;
        Fri, 10 Mar 2023 14:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458259;
        bh=ZdaC4PGnt6MPhz2HbSdrbLzl3q1rV3Tki+qYXp4gZ8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/xHINkK9I4LDv6/aMxnCs8Op9oLyInMQ0hgw5FsiqhTbqKS3HUrz7FeY1v3KuSwN
         r2OnhaKFcfHsXkPEI3n+3zOmb71GcueAD2uTCarc+Bpvtf39j5f7hf7J9JxufiVEYY
         MjPYXwE/YzIR5eyQG/g6+Z3V5B4icsrQC1zwaVLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ruanjinjie <ruanjinjie@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 216/252] watchdog: at91sam9_wdt: use devm_request_irq to avoid missing free_irq() in error path
Date:   Fri, 10 Mar 2023 14:39:46 +0100
Message-Id: <20230310133725.699837206@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index f4050a229eb58..aaa3c5a8c4570 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -206,10 +206,9 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
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



