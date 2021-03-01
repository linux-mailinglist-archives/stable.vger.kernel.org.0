Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBB2328D3F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241086AbhCATIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:08:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240921AbhCATCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:02:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 135FF64DE7;
        Mon,  1 Mar 2021 17:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619459;
        bh=xl51XW3imt5RYp4XOdMTgV5zmO6HMGyRFP/a/9rDIYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEChQ7uXxGnZ+/ORv3FBL/onCcEFGfAPXFOd5TpKUnzbH/Fpc1FumD56rk+FwNSKr
         TE0hwjPMJwf82fVQWS4516Gsqgpu9X/SZmtCAYrGBcHLUHX4cscOx2C0JIpFnb7yym
         jTSfZLyHw0Humd2D9ZhgW+EFkofzfQaq9184lnKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 432/663] PCI: pci-bridge-emul: Fix array overruns, improve safety
Date:   Mon,  1 Mar 2021 17:11:20 +0100
Message-Id: <20210301161203.263655361@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit f8ee579d53aca887d93f5f411462f25c085a5106 ]

We allow up to PCI_EXP_SLTSTA2 registers to be accessed, but the
pcie_cap_regs_behavior[] array only covers up to PCI_EXP_RTSTA.  Expand
this array to avoid walking off the end of it.

Do the same for pci_regs_behavior for consistency[], and add a
BUILD_BUG_ON() to also check the bridge->conf structure size.

Fixes: 23a5fba4d941 ("PCI: Introduce PCI bridge emulated config space common logic")
Link: https://lore.kernel.org/r/E1l6z9W-0006Re-MQ@rmk-PC.armlinux.org.uk
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-bridge-emul.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci-bridge-emul.c b/drivers/pci/pci-bridge-emul.c
index 139869d50eb26..fdaf86a888b73 100644
--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -21,8 +21,9 @@
 #include "pci-bridge-emul.h"
 
 #define PCI_BRIDGE_CONF_END	PCI_STD_HEADER_SIZEOF
+#define PCI_CAP_PCIE_SIZEOF	(PCI_EXP_SLTSTA2 + 2)
 #define PCI_CAP_PCIE_START	PCI_BRIDGE_CONF_END
-#define PCI_CAP_PCIE_END	(PCI_CAP_PCIE_START + PCI_EXP_SLTSTA2 + 2)
+#define PCI_CAP_PCIE_END	(PCI_CAP_PCIE_START + PCI_CAP_PCIE_SIZEOF)
 
 /**
  * struct pci_bridge_reg_behavior - register bits behaviors
@@ -46,7 +47,8 @@ struct pci_bridge_reg_behavior {
 	u32 w1c;
 };
 
-static const struct pci_bridge_reg_behavior pci_regs_behavior[] = {
+static const
+struct pci_bridge_reg_behavior pci_regs_behavior[PCI_STD_HEADER_SIZEOF / 4] = {
 	[PCI_VENDOR_ID / 4] = { .ro = ~0 },
 	[PCI_COMMAND / 4] = {
 		.rw = (PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
@@ -164,7 +166,8 @@ static const struct pci_bridge_reg_behavior pci_regs_behavior[] = {
 	},
 };
 
-static const struct pci_bridge_reg_behavior pcie_cap_regs_behavior[] = {
+static const
+struct pci_bridge_reg_behavior pcie_cap_regs_behavior[PCI_CAP_PCIE_SIZEOF / 4] = {
 	[PCI_CAP_LIST_ID / 4] = {
 		/*
 		 * Capability ID, Next Capability Pointer and
@@ -260,6 +263,8 @@ static const struct pci_bridge_reg_behavior pcie_cap_regs_behavior[] = {
 int pci_bridge_emul_init(struct pci_bridge_emul *bridge,
 			 unsigned int flags)
 {
+	BUILD_BUG_ON(sizeof(bridge->conf) != PCI_BRIDGE_CONF_END);
+
 	bridge->conf.class_revision |= cpu_to_le32(PCI_CLASS_BRIDGE_PCI << 16);
 	bridge->conf.header_type = PCI_HEADER_TYPE_BRIDGE;
 	bridge->conf.cache_line_size = 0x10;
-- 
2.27.0



