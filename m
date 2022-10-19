Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C32603CF7
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbiJSIzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbiJSIyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:54:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E675C84E5D;
        Wed, 19 Oct 2022 01:51:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B99D961820;
        Wed, 19 Oct 2022 08:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4D5C433C1;
        Wed, 19 Oct 2022 08:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169254;
        bh=kNhHrO3zOwOCwUFqeWaMpjDE+M8BL55uYkKdhNtLPMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yugxtAkXfkrA63j1ZxDumbghendjCBZVGtScWk/Ekdlhrc/4RFYqughHMyEtQVCvu
         8WS1QivcsNBuO2VXDN3hkOOQdnnZoMx1r1t46FRIA9GAz0cqnAJKSDwzYhWcC3JPkj
         P+pOvKZKIr4Yl2++PjdeQSSfr5WVDo5UqRDr5Mss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Yujun <linyujun809@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 210/862] MIPS: SGI-IP30: Fix platform-device leak in bridge_platform_create()
Date:   Wed, 19 Oct 2022 10:24:57 +0200
Message-Id: <20221019083259.297704109@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Yujun <linyujun809@huawei.com>

[ Upstream commit 1e6d11fe72e311c1989991ee318d239f650fa318 ]

In error case in bridge_platform_create after calling
platform_device_add()/platform_device_add_data()/
platform_device_add_resources(), release the failed
'pdev' or it will be leak, call platform_device_put()
to fix this problem.

Besides, 'pdev' is divided into 'pdev_wd' and 'pdev_bd',
use platform_device_unregister() to release sgi_w1
resources when xtalk-bridge registration fails.

Fixes: fd27234f24ae ("MIPS: add support for SGI Octane (IP30)")
Signed-off-by: Lin Yujun <linyujun809@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/sgi-ip30/ip30-xtalk.c | 70 +++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 20 deletions(-)

diff --git a/arch/mips/sgi-ip30/ip30-xtalk.c b/arch/mips/sgi-ip30/ip30-xtalk.c
index 8129524421cb..7ceb2b23ea1c 100644
--- a/arch/mips/sgi-ip30/ip30-xtalk.c
+++ b/arch/mips/sgi-ip30/ip30-xtalk.c
@@ -40,12 +40,15 @@ static void bridge_platform_create(int widget, int masterwid)
 {
 	struct xtalk_bridge_platform_data *bd;
 	struct sgi_w1_platform_data *wd;
-	struct platform_device *pdev;
+	struct platform_device *pdev_wd;
+	struct platform_device *pdev_bd;
 	struct resource w1_res;
 
 	wd = kzalloc(sizeof(*wd), GFP_KERNEL);
-	if (!wd)
-		goto no_mem;
+	if (!wd) {
+		pr_warn("xtalk:%x bridge create out of memory\n", widget);
+		return;
+	}
 
 	snprintf(wd->dev_id, sizeof(wd->dev_id), "bridge-%012lx",
 		 IP30_SWIN_BASE(widget));
@@ -56,24 +59,35 @@ static void bridge_platform_create(int widget, int masterwid)
 	w1_res.end = w1_res.start + 3;
 	w1_res.flags = IORESOURCE_MEM;
 
-	pdev = platform_device_alloc("sgi_w1", PLATFORM_DEVID_AUTO);
-	if (!pdev) {
-		kfree(wd);
-		goto no_mem;
+	pdev_wd = platform_device_alloc("sgi_w1", PLATFORM_DEVID_AUTO);
+	if (!pdev_wd) {
+		pr_warn("xtalk:%x bridge create out of memory\n", widget);
+		goto err_kfree_wd;
+	}
+	if (platform_device_add_resources(pdev_wd, &w1_res, 1)) {
+		pr_warn("xtalk:%x bridge failed to add platform resources.\n", widget);
+		goto err_put_pdev_wd;
+	}
+	if (platform_device_add_data(pdev_wd, wd, sizeof(*wd))) {
+		pr_warn("xtalk:%x bridge failed to add platform data.\n", widget);
+		goto err_put_pdev_wd;
+	}
+	if (platform_device_add(pdev_wd)) {
+		pr_warn("xtalk:%x bridge failed to add platform device.\n", widget);
+		goto err_put_pdev_wd;
 	}
-	platform_device_add_resources(pdev, &w1_res, 1);
-	platform_device_add_data(pdev, wd, sizeof(*wd));
 	/* platform_device_add_data() duplicates the data */
 	kfree(wd);
-	platform_device_add(pdev);
 
 	bd = kzalloc(sizeof(*bd), GFP_KERNEL);
-	if (!bd)
-		goto no_mem;
-	pdev = platform_device_alloc("xtalk-bridge", PLATFORM_DEVID_AUTO);
-	if (!pdev) {
-		kfree(bd);
-		goto no_mem;
+	if (!bd) {
+		pr_warn("xtalk:%x bridge create out of memory\n", widget);
+		goto err_unregister_pdev_wd;
+	}
+	pdev_bd = platform_device_alloc("xtalk-bridge", PLATFORM_DEVID_AUTO);
+	if (!pdev_bd) {
+		pr_warn("xtalk:%x bridge create out of memory\n", widget);
+		goto err_kfree_bd;
 	}
 
 	bd->bridge_addr	= IP30_RAW_SWIN_BASE(widget);
@@ -93,15 +107,31 @@ static void bridge_platform_create(int widget, int masterwid)
 	bd->io.flags	= IORESOURCE_IO;
 	bd->io_offset	= IP30_SWIN_BASE(widget);
 
-	platform_device_add_data(pdev, bd, sizeof(*bd));
+	if (platform_device_add_data(pdev_bd, bd, sizeof(*bd))) {
+		pr_warn("xtalk:%x bridge failed to add platform data.\n", widget);
+		goto err_put_pdev_bd;
+	}
+	if (platform_device_add(pdev_bd)) {
+		pr_warn("xtalk:%x bridge failed to add platform device.\n", widget);
+		goto err_put_pdev_bd;
+	}
 	/* platform_device_add_data() duplicates the data */
 	kfree(bd);
-	platform_device_add(pdev);
 	pr_info("xtalk:%x bridge widget\n", widget);
 	return;
 
-no_mem:
-	pr_warn("xtalk:%x bridge create out of memory\n", widget);
+err_put_pdev_bd:
+	platform_device_put(pdev_bd);
+err_kfree_bd:
+	kfree(bd);
+err_unregister_pdev_wd:
+	platform_device_unregister(pdev_wd);
+	return;
+err_put_pdev_wd:
+	platform_device_put(pdev_wd);
+err_kfree_wd:
+	kfree(wd);
+	return;
 }
 
 static unsigned int __init xbow_widget_active(s8 wid)
-- 
2.35.1



