Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 856C4CD644
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbfJFRo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730889AbfJFRou (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:44:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C2A420700;
        Sun,  6 Oct 2019 17:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383889;
        bh=qa0mUQv2VHTLNbiFSyncuiRPcluh1c6Y3izKC1A5WRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atCKIrHk8g6cJJCVmN8vbTXu6etg6yFMtujkJhu9DFu7dRKUWVfCJCn1h1AgPvCRy
         ea3OtWl/laZF4IAUoorLwB2rUHLaXpab5w3UY6T55YcEVoLwLd6dkGedsrhFScxhDH
         XyfPOUabX443orTXD71yIycl7KRYmMIl+ktzGXxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Matthew Wilcox <willy@infradead.org>,
        Jake Oshins <jakeo@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Sasha Levin <sashal@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 5.3 091/166] PCI: pci-hyperv: Fix build errors on non-SYSFS config
Date:   Sun,  6 Oct 2019 19:20:57 +0200
Message-Id: <20191006171221.203974787@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit f58ba5e3f6863ea4486952698898848a6db726c2 ]

Fix build errors when building almost-allmodconfig but with SYSFS
not set (not enabled). Fixes these build errors:

ERROR: "pci_destroy_slot" [drivers/pci/controller/pci-hyperv.ko] undefined!
ERROR: "pci_create_slot" [drivers/pci/controller/pci-hyperv.ko] undefined!

drivers/pci/slot.o is only built when SYSFS is enabled, so
pci-hyperv.o has an implicit dependency on SYSFS.
Make that explicit.

Also, depending on X86 && X86_64 is not needed, so just change that
to depend on X86_64.

Fixes: a15f2c08c708 ("PCI: hv: support reporting serial number as slot information")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jake Oshins <jakeo@microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-hyperv@vger.kernel.org
Cc: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 2ab92409210af..297bf928d6522 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -181,7 +181,7 @@ config PCI_LABEL
 
 config PCI_HYPERV
         tristate "Hyper-V PCI Frontend"
-        depends on X86 && HYPERV && PCI_MSI && PCI_MSI_IRQ_DOMAIN && X86_64
+        depends on X86_64 && HYPERV && PCI_MSI && PCI_MSI_IRQ_DOMAIN && SYSFS
         help
           The PCI device frontend driver allows the kernel to import arbitrary
           PCI devices from a PCI backend to support PCI driver domains.
-- 
2.20.1



