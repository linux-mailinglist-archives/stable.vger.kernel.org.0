Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC7137CB16
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242350AbhELQeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241450AbhELQ1T (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 783C9613EE;
        Wed, 12 May 2021 15:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834756;
        bh=WPxUwQe8u99ofw6ZGE11GzGFazsZ1tTEFDYvN+gAbSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8EWkmOO7jd2KMb2/lCFvNBByicMSHgaLYFTV7yyWMl38YHIf2exxkAdQp2Og6r1V
         Nj4JsWTiRM2avrtVd07OWqzeckfd9IlTEItVSVbStMo7+w2VfUqCGZfZGzMzr0Q868
         ArLyEe4th9GWICuCndjudqMRmkXfotYsGD39zcYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>
Subject: [PATCH 5.12 036/677] PCI: keystone: Let AM65 use the pci_ops defined in pcie-designware-host.c
Date:   Wed, 12 May 2021 16:41:22 +0200
Message-Id: <20210512144838.414882629@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 3d0b2a3a87ce5ae85de46c4241afd52ab8b566fe upstream.

Both TI's AM65x (K3) and TI's K2 PCIe driver are implemented in
pci-keystone. However Only K2 PCIe driver should use it's own pci_ops
for configuration space accesses. But commit 10a797c6e54a
("PCI: dwc: keystone: Use pci_ops for config space accessors") used
custom pci_ops for both AM65x and K2. This breaks configuration space
access for AM65x platform. Fix it here.

Link: https://lore.kernel.org/r/20210317131518.11040-1-kishon@ti.com
Fixes: 10a797c6e54a ("PCI: dwc: keystone: Use pci_ops for config space accessors")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Krzysztof Wilczyński <kw@linux.com>
Cc: <stable@vger.kernel.org> # v5.10
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-keystone.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -798,7 +798,8 @@ static int __init ks_pcie_host_init(stru
 	int ret;
 
 	pp->bridge->ops = &ks_pcie_ops;
-	pp->bridge->child_ops = &ks_child_pcie_ops;
+	if (!ks_pcie->is_am6)
+		pp->bridge->child_ops = &ks_child_pcie_ops;
 
 	ret = ks_pcie_config_legacy_irq(ks_pcie);
 	if (ret)


