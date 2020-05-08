Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3B61CAD1D
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgEHMvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:51:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbgEHMvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:51:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C857218AC;
        Fri,  8 May 2020 12:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942304;
        bh=KrhjgCPKMberTqvFLNzwp6iWdSbl/MN6j5trdSmwi/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loxQJvIQHjgFe8nLvmvJznt0HZQ0JKLjoyliH9/6Ky3Gkj3teel4+PEL2xbZrMehV
         MSWVZEjELljbFg1v6abIcX4zPKy4lJvL+jLEnPhAIPNAN2+XJF73sVUAlurzT+MjcT
         QYHtSgcACFBgeCIz9YeMpAnNcUuL7ou7RCxnN7M4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, AceLan Kao <acelan.kao@canonical.com>,
        Tuowen Zhao <ztuowen@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/32] lib: devres: add a helper function for ioremap_uc
Date:   Fri,  8 May 2020 14:35:37 +0200
Message-Id: <20200508123038.272499757@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123034.886699170@linuxfoundation.org>
References: <20200508123034.886699170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuowen Zhao <ztuowen@gmail.com>

[ Upstream commit e537654b7039aacfe8ae629d49655c0e5692ad44 ]

Implement a resource managed strongly uncachable ioremap function.

Cc: <stable@vger.kernel.org> # v4.19+
Tested-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Tuowen Zhao <ztuowen@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/io.h |  2 ++
 lib/devres.c       | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/io.h b/include/linux/io.h
index 32e30e8fb9db9..da39ff89df651 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -75,6 +75,8 @@ static inline void devm_ioport_unmap(struct device *dev, void __iomem *addr)
 
 void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
 			   resource_size_t size);
+void __iomem *devm_ioremap_uc(struct device *dev, resource_size_t offset,
+				   resource_size_t size);
 void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
 				   resource_size_t size);
 void __iomem *devm_ioremap_wc(struct device *dev, resource_size_t offset,
diff --git a/lib/devres.c b/lib/devres.c
index aa0f5308ac6be..75ea32d9b661b 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -9,6 +9,7 @@
 enum devm_ioremap_type {
 	DEVM_IOREMAP = 0,
 	DEVM_IOREMAP_NC,
+	DEVM_IOREMAP_UC,
 	DEVM_IOREMAP_WC,
 };
 
@@ -39,6 +40,9 @@ static void __iomem *__devm_ioremap(struct device *dev, resource_size_t offset,
 	case DEVM_IOREMAP_NC:
 		addr = ioremap_nocache(offset, size);
 		break;
+	case DEVM_IOREMAP_UC:
+		addr = ioremap_uc(offset, size);
+		break;
 	case DEVM_IOREMAP_WC:
 		addr = ioremap_wc(offset, size);
 		break;
@@ -68,6 +72,21 @@ void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
 }
 EXPORT_SYMBOL(devm_ioremap);
 
+/**
+ * devm_ioremap_uc - Managed ioremap_uc()
+ * @dev: Generic device to remap IO address for
+ * @offset: Resource address to map
+ * @size: Size of map
+ *
+ * Managed ioremap_uc().  Map is automatically unmapped on driver detach.
+ */
+void __iomem *devm_ioremap_uc(struct device *dev, resource_size_t offset,
+			      resource_size_t size)
+{
+	return __devm_ioremap(dev, offset, size, DEVM_IOREMAP_UC);
+}
+EXPORT_SYMBOL_GPL(devm_ioremap_uc);
+
 /**
  * devm_ioremap_nocache - Managed ioremap_nocache()
  * @dev: Generic device to remap IO address for
-- 
2.20.1



