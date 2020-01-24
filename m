Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08D6F148244
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391545AbgAXL0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:26:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391565AbgAXL0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:26:35 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED10522522;
        Fri, 24 Jan 2020 11:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865194;
        bh=WLedvEAo3d4TFywakfUeBYv6rMarcSdRIwMo3BJ8wT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vn8d9+kdsz6jo2tFNclwBCO6YsexiiBXfEURjk9eFOkdduuc2UxQXwz0qrU6Ud7Ut
         tBCvCAtS3+kSIBGmfdEEDhRRMTDruBn3gCphhGR+iVomgSnKIcCVvKy7mUWFZ3vfyn
         ooFFSYe1CVmFuQ6RK3RmtWfIeJ/6GmwdW40zfGkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Enrico Weigelt <info@metux.net>
Subject: [PATCH 4.19 466/639] devres: allow const resource arguments
Date:   Fri, 24 Jan 2020 10:30:36 +0100
Message-Id: <20200124093145.663016156@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9dea44c91469512d346e638694c22c30a5273992 ]

devm_ioremap_resource() does not currently take 'const' arguments,
which results in a warning from the first driver trying to do it
anyway:

drivers/gpio/gpio-amd-fch.c: In function 'amd_fch_gpio_probe':
drivers/gpio/gpio-amd-fch.c:171:49: error: passing argument 2 of 'devm_ioremap_resource' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]
  priv->base = devm_ioremap_resource(&pdev->dev, &amd_fch_gpio_iores);
                                                 ^~~~~~~~~~~~~~~~~~~

Change the prototype to allow it, as there is no real reason not to.

Fixes: 9bb2e0452508 ("gpio: amd: Make resource struct const")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20190628150049.1108048-1-arnd@arndb.de
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviwed-By: Enrico Weigelt <info@metux.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/device.h | 3 ++-
 lib/devres.c           | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index e9d1c768f972a..c74ce473589ae 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -701,7 +701,8 @@ extern unsigned long devm_get_free_pages(struct device *dev,
 					 gfp_t gfp_mask, unsigned int order);
 extern void devm_free_pages(struct device *dev, unsigned long addr);
 
-void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
+void __iomem *devm_ioremap_resource(struct device *dev,
+				    const struct resource *res);
 
 void __iomem *devm_of_iomap(struct device *dev,
 			    struct device_node *node, int index,
diff --git a/lib/devres.c b/lib/devres.c
index faccf1a037d05..aa0f5308ac6be 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -131,7 +131,8 @@ EXPORT_SYMBOL(devm_iounmap);
  *	if (IS_ERR(base))
  *		return PTR_ERR(base);
  */
-void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res)
+void __iomem *devm_ioremap_resource(struct device *dev,
+				    const struct resource *res)
 {
 	resource_size_t size;
 	const char *name;
-- 
2.20.1



