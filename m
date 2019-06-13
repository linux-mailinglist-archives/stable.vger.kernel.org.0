Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5537442D7
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730975AbfFMQZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730973AbfFMIgf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:36:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 134042133D;
        Thu, 13 Jun 2019 08:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560414994;
        bh=Tzu9nVnELtW6QYt8Pc2RvRISPk+UT9MpiyAky8zDLVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0NZiCbHXfz98BCZD+/SZfXS0u/3lQfRhwmx+NiJQ3LS3vXRaJ0nb0opee+3m1SYBH
         nWWg3MuOZAIafl62kqTMF9o72am5SbsmxlkH/azxO2aY42rXR8lLHEEgti8qbU5NRb
         AN6vD4YSKhQe7/UTgTRP7fUCBMyBunG0QXvZjhX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 48/81] PCI: keystone: Prevent ARM32 specific code to be compiled for ARM64
Date:   Thu, 13 Jun 2019 10:33:31 +0200
Message-Id: <20190613075652.808493848@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f316a2b53cd7f37963ae20ec7072eb27a349a4ce ]

hook_fault_code() is an ARM32 specific API for hooking into data abort.

AM65X platforms (that integrate ARM v8 cores and select CONFIG_ARM64 as
arch) rely on pci-keystone.c but on them the enumeration of a
non-present BDF does not trigger a bus error, so the fixup exception
provided by calling hook_fault_code() is not needed and can be guarded
with CONFIG_ARM.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
[lorenzo.pieralisi@arm.com: commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/dwc/pci-keystone.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/dwc/pci-keystone.c b/drivers/pci/dwc/pci-keystone.c
index 39405598b22d..9bc52e4cf52a 100644
--- a/drivers/pci/dwc/pci-keystone.c
+++ b/drivers/pci/dwc/pci-keystone.c
@@ -240,6 +240,7 @@ static void ks_pcie_setup_interrupts(struct keystone_pcie *ks_pcie)
 		ks_dw_pcie_enable_error_irq(ks_pcie);
 }
 
+#ifdef CONFIG_ARM
 /*
  * When a PCI device does not exist during config cycles, keystone host gets a
  * bus error instead of returning 0xffffffff. This handler always returns 0
@@ -259,6 +260,7 @@ static int keystone_pcie_fault(unsigned long addr, unsigned int fsr,
 
 	return 0;
 }
+#endif
 
 static int __init ks_pcie_host_init(struct pcie_port *pp)
 {
@@ -282,12 +284,14 @@ static int __init ks_pcie_host_init(struct pcie_port *pp)
 	val |= BIT(12);
 	writel(val, pci->dbi_base + PCIE_CAP_BASE + PCI_EXP_DEVCTL);
 
+#ifdef CONFIG_ARM
 	/*
 	 * PCIe access errors that result into OCP errors are caught by ARM as
 	 * "External aborts"
 	 */
 	hook_fault_code(17, keystone_pcie_fault, SIGBUS, 0,
 			"Asynchronous external abort");
+#endif
 
 	return 0;
 }
-- 
2.20.1



