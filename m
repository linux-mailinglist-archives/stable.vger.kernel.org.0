Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3AD6AEFDC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbjCGS1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbjCGS0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:26:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6F0ACE2A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:20:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 31061CE1C82
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BCBC4339C;
        Tue,  7 Mar 2023 18:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213226;
        bh=sy24AILUPaEfYDFT/WeQ+y/AMwpO/G8nbiq+P1kbGls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yNM/sqml+WBKcXNVm8T78EWuadvwMhcwqqenmLuXc32qD401Xd+W63G+7Wwkm55+/
         ng+qvyM52OcDRDx/8Kz9PwnX72K5GYEn4xNY7LuZTeKAYoAUD6Kro7Ou5Ro02vGOSz
         lG1Zffs24fntjAwaPwQaLxcUz/xyxV4sg+CJAoNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 409/885] usb: gadget: fusb300_udc: free irq on the error path in fusb300_probe()
Date:   Tue,  7 Mar 2023 17:55:43 +0100
Message-Id: <20230307170020.187827325@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit a8d3392e0e5cfeb03f0cea1f2bc3f5f183c1deb4 ]

When request_irq(ires1->start) failed in w5300_hw_probe(), irq
ires->start has not been freed, and on the clean_up3 error path,
we also need to free ires1->start irq, fix it.

In addition, We should add free_irq in fusb300_remove(), and give
the lables a proper name so that they can be understood easily,
so add free_irq in fusb300_remove(), and update clean_up3 to
err_alloc_request.

Fixes: 0fe6f1d1f612 ("usb: udc: add Faraday fusb300 driver")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221123014121.1989721-1-cuigaosheng1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fusb300_udc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/udc/fusb300_udc.c b/drivers/usb/gadget/udc/fusb300_udc.c
index 5954800d652ca..08ba9c8c1e677 100644
--- a/drivers/usb/gadget/udc/fusb300_udc.c
+++ b/drivers/usb/gadget/udc/fusb300_udc.c
@@ -1346,6 +1346,7 @@ static int fusb300_remove(struct platform_device *pdev)
 	usb_del_gadget_udc(&fusb300->gadget);
 	iounmap(fusb300->reg);
 	free_irq(platform_get_irq(pdev, 0), fusb300);
+	free_irq(platform_get_irq(pdev, 1), fusb300);
 
 	fusb300_free_request(&fusb300->ep[0]->ep, fusb300->ep0_req);
 	for (i = 0; i < FUSB300_MAX_NUM_EP; i++)
@@ -1431,7 +1432,7 @@ static int fusb300_probe(struct platform_device *pdev)
 			IRQF_SHARED, udc_name, fusb300);
 	if (ret < 0) {
 		pr_err("request_irq1 error (%d)\n", ret);
-		goto clean_up;
+		goto err_request_irq1;
 	}
 
 	INIT_LIST_HEAD(&fusb300->gadget.ep_list);
@@ -1470,7 +1471,7 @@ static int fusb300_probe(struct platform_device *pdev)
 				GFP_KERNEL);
 	if (fusb300->ep0_req == NULL) {
 		ret = -ENOMEM;
-		goto clean_up3;
+		goto err_alloc_request;
 	}
 
 	init_controller(fusb300);
@@ -1485,7 +1486,10 @@ static int fusb300_probe(struct platform_device *pdev)
 err_add_udc:
 	fusb300_free_request(&fusb300->ep[0]->ep, fusb300->ep0_req);
 
-clean_up3:
+err_alloc_request:
+	free_irq(ires1->start, fusb300);
+
+err_request_irq1:
 	free_irq(ires->start, fusb300);
 
 clean_up:
-- 
2.39.2



