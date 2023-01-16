Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46CD566CAE1
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbjAPRI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjAPRHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:07:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53BC2A165
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:48:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30143B81095
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C41AC433EF;
        Mon, 16 Jan 2023 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887699;
        bh=b8SbfTgEmTl8DkZ4JKicSASyVro/9nyCui/U79/opXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYsw/18PPgtqGK7fvgVYjCHNQbDL/fAiBAyd/fotxUL/aYMb7ViUGJ93o3z7OLbpf
         jhBtdGJPq7S66EKW/wRSqPRHs31GjExtSUCVDmZM/5tEoiYAoeaiAIyZRLFCpDHpy6
         yHYe4kgDp+etz5YHgUQVrn6NcF0l39cG7xAOnVTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 248/521] drivers: provide devm_platform_get_and_ioremap_resource()
Date:   Mon, 16 Jan 2023 16:48:30 +0100
Message-Id: <20230116154858.223545424@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Dejin Zheng <zhengdejin5@gmail.com>

[ Upstream commit 890cc39a879906b63912482dfc41944579df2dc6 ]

Since commit "drivers: provide devm_platform_ioremap_resource()",
it was wrap platform_get_resource() and devm_ioremap_resource() as
single helper devm_platform_ioremap_resource(). but now, many drivers
still used platform_get_resource() and devm_ioremap_resource()
together in the kernel tree. The reason can not be replaced is they
still need use the resource variables obtained by platform_get_resource().
so provide this helper.

Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Suggested-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
Link: https://lore.kernel.org/r/20200323160612.17277-2-zhengdejin5@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 2d47b79d2bd3 ("i2c: mux: reg: check return value after calling platform_get_resource()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform.c         | 22 ++++++++++++++++++++++
 include/linux/platform_device.h |  3 +++
 2 files changed, 25 insertions(+)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index ea83c279b8a3..c4e398f3de50 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -80,6 +80,28 @@ struct resource *platform_get_resource(struct platform_device *dev,
 }
 EXPORT_SYMBOL_GPL(platform_get_resource);
 
+/**
+ * devm_platform_get_and_ioremap_resource - call devm_ioremap_resource() for a
+ *					    platform device and get resource
+ *
+ * @pdev: platform device to use both for memory resource lookup as well as
+ *        resource management
+ * @index: resource index
+ * @res: optional output parameter to store a pointer to the obtained resource.
+ */
+void __iomem *
+devm_platform_get_and_ioremap_resource(struct platform_device *pdev,
+				unsigned int index, struct resource **res)
+{
+	struct resource *r;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, index);
+	if (res)
+		*res = r;
+	return devm_ioremap_resource(&pdev->dev, r);
+}
+EXPORT_SYMBOL_GPL(devm_platform_get_and_ioremap_resource);
+
 /**
  * devm_platform_ioremap_resource - call devm_ioremap_resource() for a platform
  *				    device
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 9e5c98fcea8c..1de7ea6efdc9 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -52,6 +52,9 @@ extern void arch_setup_pdev_archdata(struct platform_device *);
 extern struct resource *platform_get_resource(struct platform_device *,
 					      unsigned int, unsigned int);
 extern void __iomem *
+devm_platform_get_and_ioremap_resource(struct platform_device *pdev,
+				unsigned int index, struct resource **res);
+extern void __iomem *
 devm_platform_ioremap_resource(struct platform_device *pdev,
 			       unsigned int index);
 extern int platform_get_irq(struct platform_device *, unsigned int);
-- 
2.35.1



