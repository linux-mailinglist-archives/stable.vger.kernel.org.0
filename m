Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB44560A84E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbiJXNFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbiJXND7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:03:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C46F520A3;
        Mon, 24 Oct 2022 05:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 495C2612BF;
        Mon, 24 Oct 2022 12:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5566AC433C1;
        Mon, 24 Oct 2022 12:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614000;
        bh=HOZhK5nwydeR/Bd8FjHVUeZa+EqAKfMdTpBZvPcFDdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHe9yUtPwic5G43el58ZVHEySR1L47q1UlR1uDb2gkfLCDVVyDGiQWbM2tAhGfem2
         7pzBr9TUV/WlkNooivOhbyC5jljPshYa7GnM154AqfFpdshJsO+F9ipj+UYvStFcyk
         srP0Fd+uYdMdwhkiIdcFUo3CUgM8Fk26feuOwqsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Yujun <linyujun809@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/390] MIPS: SGI-IP27: Fix platform-device leak in bridge_platform_create()
Date:   Mon, 24 Oct 2022 13:28:12 +0200
Message-Id: <20221024113026.686783570@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Yujun <linyujun809@huawei.com>

[ Upstream commit 11bec9cba4de06b3c0e9e4041453c2caaa1cbec1 ]

In error case in bridge_platform_create after calling
platform_device_add()/platform_device_add_data()/
platform_device_add_resources(), release the failed
'pdev' or it will be leak, call platform_device_put()
to fix this problem.

Besides, 'pdev' is divided into 'pdev_wd' and 'pdev_bd',
use platform_device_unregister() to release sgi_w1
resources when xtalk-bridge registration fails.

Fixes: 5dc76a96e95a ("MIPS: PCI: use information from 1-wire PROM for IOC3 detection")
Signed-off-by: Lin Yujun <linyujun809@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/sgi-ip27/ip27-xtalk.c | 70 +++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 20 deletions(-)

diff --git a/arch/mips/sgi-ip27/ip27-xtalk.c b/arch/mips/sgi-ip27/ip27-xtalk.c
index e762886d1dda..5143d1cf8984 100644
--- a/arch/mips/sgi-ip27/ip27-xtalk.c
+++ b/arch/mips/sgi-ip27/ip27-xtalk.c
@@ -27,15 +27,18 @@ static void bridge_platform_create(nasid_t nasid, int widget, int masterwid)
 {
 	struct xtalk_bridge_platform_data *bd;
 	struct sgi_w1_platform_data *wd;
-	struct platform_device *pdev;
+	struct platform_device *pdev_wd;
+	struct platform_device *pdev_bd;
 	struct resource w1_res;
 	unsigned long offset;
 
 	offset = NODE_OFFSET(nasid);
 
 	wd = kzalloc(sizeof(*wd), GFP_KERNEL);
-	if (!wd)
-		goto no_mem;
+	if (!wd) {
+		pr_warn("xtalk:n%d/%x bridge create out of memory\n", nasid, widget);
+		return;
+	}
 
 	snprintf(wd->dev_id, sizeof(wd->dev_id), "bridge-%012lx",
 		 offset + (widget << SWIN_SIZE_BITS));
@@ -46,24 +49,35 @@ static void bridge_platform_create(nasid_t nasid, int widget, int masterwid)
 	w1_res.end = w1_res.start + 3;
 	w1_res.flags = IORESOURCE_MEM;
 
-	pdev = platform_device_alloc("sgi_w1", PLATFORM_DEVID_AUTO);
-	if (!pdev) {
-		kfree(wd);
-		goto no_mem;
+	pdev_wd = platform_device_alloc("sgi_w1", PLATFORM_DEVID_AUTO);
+	if (!pdev_wd) {
+		pr_warn("xtalk:n%d/%x bridge create out of memory\n", nasid, widget);
+		goto err_kfree_wd;
+	}
+	if (platform_device_add_resources(pdev_wd, &w1_res, 1)) {
+		pr_warn("xtalk:n%d/%x bridge failed to add platform resources.\n", nasid, widget);
+		goto err_put_pdev_wd;
+	}
+	if (platform_device_add_data(pdev_wd, wd, sizeof(*wd))) {
+		pr_warn("xtalk:n%d/%x bridge failed to add platform data.\n", nasid, widget);
+		goto err_put_pdev_wd;
+	}
+	if (platform_device_add(pdev_wd)) {
+		pr_warn("xtalk:n%d/%x bridge failed to add platform device.\n", nasid, widget);
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
+		pr_warn("xtalk:n%d/%x bridge create out of memory\n", nasid, widget);
+		goto err_unregister_pdev_wd;
+	}
+	pdev_bd = platform_device_alloc("xtalk-bridge", PLATFORM_DEVID_AUTO);
+	if (!pdev_bd) {
+		pr_warn("xtalk:n%d/%x bridge create out of memory\n", nasid, widget);
+		goto err_kfree_bd;
 	}
 
 
@@ -84,15 +98,31 @@ static void bridge_platform_create(nasid_t nasid, int widget, int masterwid)
 	bd->io.flags	= IORESOURCE_IO;
 	bd->io_offset	= offset;
 
-	platform_device_add_data(pdev, bd, sizeof(*bd));
+	if (platform_device_add_data(pdev_bd, bd, sizeof(*bd))) {
+		pr_warn("xtalk:n%d/%x bridge failed to add platform data.\n", nasid, widget);
+		goto err_put_pdev_bd;
+	}
+	if (platform_device_add(pdev_bd)) {
+		pr_warn("xtalk:n%d/%x bridge failed to add platform device.\n", nasid, widget);
+		goto err_put_pdev_bd;
+	}
 	/* platform_device_add_data() duplicates the data */
 	kfree(bd);
-	platform_device_add(pdev);
 	pr_info("xtalk:n%d/%x bridge widget\n", nasid, widget);
 	return;
 
-no_mem:
-	pr_warn("xtalk:n%d/%x bridge create out of memory\n", nasid, widget);
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
 
 static int probe_one_port(nasid_t nasid, int widget, int masterwid)
-- 
2.35.1



