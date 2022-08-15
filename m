Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC01594683
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352327AbiHOW5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352718AbiHOW4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:56:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194A346DB8;
        Mon, 15 Aug 2022 12:55:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83E926113B;
        Mon, 15 Aug 2022 19:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F40DC433D6;
        Mon, 15 Aug 2022 19:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593353;
        bh=XaWrafOU5DIdzkvtKxrTyXkKxC1Ft11aAwTJwMtn/v8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qmse1TJtl15Sl48/B7Ruc8nDDX8sM7gx6oEw1Xv1YJmgn0SAjV9QuA6R273CZphdZ
         wcAIoC87C0zpg1UzgXgKAdsxYl2Iqd17JSCumnGLZpZBPVqM/oBtHTN/Wm/OT1NBMV
         2CESmkGPMRPLLr1hfNAP0vcoqgKMuVtKJcx7Jqu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0255/1157] m68k: virt: Fix missing platform_device_unregister() on error in virt_platform_init()
Date:   Mon, 15 Aug 2022 19:53:31 +0200
Message-Id: <20220815180449.795267297@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 566a2d6d8e429727832c7e347cbe736b12ad7297 ]

Add the missing platform_device_unregister() before return
from virt_platform_init() in the error handling case.

Fixes: 05d51e42df06 ("m68k: Introduce a virtual m68k machine")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Link: https://lore.kernel.org/r/20220628084903.3147123-1-yangyingliang@huawei.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/virt/platform.c | 58 ++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 25 deletions(-)

diff --git a/arch/m68k/virt/platform.c b/arch/m68k/virt/platform.c
index cb820f19a221..1560c4140ab9 100644
--- a/arch/m68k/virt/platform.c
+++ b/arch/m68k/virt/platform.c
@@ -8,20 +8,15 @@
 
 #define VIRTIO_BUS_NB	128
 
-static int __init virt_virtio_init(unsigned int id)
+static struct platform_device * __init virt_virtio_init(unsigned int id)
 {
 	const struct resource res[] = {
 		DEFINE_RES_MEM(virt_bi_data.virtio.mmio + id * 0x200, 0x200),
 		DEFINE_RES_IRQ(virt_bi_data.virtio.irq + id),
 	};
-	struct platform_device *pdev;
 
-	pdev = platform_device_register_simple("virtio-mmio", id,
+	return platform_device_register_simple("virtio-mmio", id,
 					       res, ARRAY_SIZE(res));
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
-
-	return 0;
 }
 
 static int __init virt_platform_init(void)
@@ -35,8 +30,10 @@ static int __init virt_platform_init(void)
 		DEFINE_RES_MEM(virt_bi_data.rtc.mmio + 0x1000, 0x1000),
 		DEFINE_RES_IRQ(virt_bi_data.rtc.irq + 1),
 	};
-	struct platform_device *pdev;
+	struct platform_device *pdev1, *pdev2;
+	struct platform_device *pdevs[VIRTIO_BUS_NB];
 	unsigned int i;
+	int ret = 0;
 
 	if (!MACH_IS_VIRT)
 		return -ENODEV;
@@ -44,29 +41,40 @@ static int __init virt_platform_init(void)
 	/* We need this to have DMA'able memory provided to goldfish-tty */
 	min_low_pfn = 0;
 
-	pdev = platform_device_register_simple("goldfish_tty",
-					       PLATFORM_DEVID_NONE,
-					       goldfish_tty_res,
-					       ARRAY_SIZE(goldfish_tty_res));
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
+	pdev1 = platform_device_register_simple("goldfish_tty",
+						PLATFORM_DEVID_NONE,
+						goldfish_tty_res,
+						ARRAY_SIZE(goldfish_tty_res));
+	if (IS_ERR(pdev1))
+		return PTR_ERR(pdev1);
 
-	pdev = platform_device_register_simple("goldfish_rtc",
-					       PLATFORM_DEVID_NONE,
-					       goldfish_rtc_res,
-					       ARRAY_SIZE(goldfish_rtc_res));
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
+	pdev2 = platform_device_register_simple("goldfish_rtc",
+						PLATFORM_DEVID_NONE,
+						goldfish_rtc_res,
+						ARRAY_SIZE(goldfish_rtc_res));
+	if (IS_ERR(pdev2)) {
+		ret = PTR_ERR(pdev2);
+		goto err_unregister_tty;
+	}
 
 	for (i = 0; i < VIRTIO_BUS_NB; i++) {
-		int err;
-
-		err = virt_virtio_init(i);
-		if (err)
-			return err;
+		pdevs[i] = virt_virtio_init(i);
+		if (IS_ERR(pdevs[i])) {
+			ret = PTR_ERR(pdevs[i]);
+			goto err_unregister_rtc_virtio;
+		}
 	}
 
 	return 0;
+
+err_unregister_rtc_virtio:
+	while (i > 0)
+		platform_device_unregister(pdevs[--i]);
+	platform_device_unregister(pdev2);
+err_unregister_tty:
+	platform_device_unregister(pdev1);
+
+	return ret;
 }
 
 arch_initcall(virt_platform_init);
-- 
2.35.1



