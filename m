Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C0AC1859
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729933AbfI2RmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729925AbfI2RdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:33:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0CC721835;
        Sun, 29 Sep 2019 17:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778389;
        bh=qa0mUQv2VHTLNbiFSyncuiRPcluh1c6Y3izKC1A5WRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIL2nbMY9LzekjLJPQKLtPmXxDjpkfgLpZnziDG71+8ksYe7etnldgcQuavmO/VR5
         C6KvGGnRBvoRgwHT6qqLbbJS709njK0s3zjUv69EHT+rdxgVJiG6PdfjGvmMOcNylz
         9gSiRSeKO1PQ18ZDr0rsvZTkbDpidz7V74zulpCU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
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
Subject: [PATCH AUTOSEL 5.2 10/42] PCI: pci-hyperv: Fix build errors on non-SYSFS config
Date:   Sun, 29 Sep 2019 13:32:09 -0400
Message-Id: <20190929173244.8918-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173244.8918-1-sashal@kernel.org>
References: <20190929173244.8918-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

