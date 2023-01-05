Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914EA65EBA1
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbjAENA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbjAENAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:00:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434C64C71E
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:00:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D55E1619F3
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94BCC433EF;
        Thu,  5 Jan 2023 13:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923639;
        bh=J6xsp873/jo4GaYvsmcYlIGL1olWzVbmYpd9tAwzbYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzRSQ+Hr9NvfsjrfdV5SlLSnjqAmAzXd5moYSRauJPGC8gnLUY0VLmhE0Fs0EH2SK
         xlkzFWpTHfxRdSqDO+GXcV8dCBMCxM1YdC5sI6Cd+0QiMFHZzqZ4EQZbZ+klbeCkVM
         R6RftBlpG5fw6pm+25vl2P1Y5aJUaHcGPj4TSsTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 084/251] mmc: rtsx_usb_sdmmc: fix return value check of mmc_add_host()
Date:   Thu,  5 Jan 2023 13:53:41 +0100
Message-Id: <20230105125338.636657147@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit fc38a5a10e9e5a75eb9189854abeb8405b214cc9 ]

mmc_add_host() may return error, if we ignore its return value, the memory
that allocated in mmc_alloc_host() will be leaked and it will lead a kernel
crash because of deleting not added device in the remove path.

So fix this by checking the return value and calling mmc_free_host() in the
error path, besides, led_classdev_unregister() and pm_runtime_disable() also
need be called.

Fixes: c7f6558d84af ("mmc: Add realtek USB sdmmc host driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221101063023.1664968-7-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/rtsx_usb_sdmmc.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c b/drivers/mmc/host/rtsx_usb_sdmmc.c
index 6e9c0f8fddb1..817fbf510d1e 100644
--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -1355,6 +1355,7 @@ static int rtsx_usb_sdmmc_drv_probe(struct platform_device *pdev)
 #ifdef RTSX_USB_USE_LEDS_CLASS
 	int err;
 #endif
+	int ret;
 
 	ucr = usb_get_intfdata(to_usb_interface(pdev->dev.parent));
 	if (!ucr)
@@ -1391,7 +1392,15 @@ static int rtsx_usb_sdmmc_drv_probe(struct platform_device *pdev)
 	INIT_WORK(&host->led_work, rtsx_usb_update_led);
 
 #endif
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret) {
+#ifdef RTSX_USB_USE_LEDS_CLASS
+		led_classdev_unregister(&host->led);
+#endif
+		mmc_free_host(mmc);
+		pm_runtime_disable(&pdev->dev);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.35.1



