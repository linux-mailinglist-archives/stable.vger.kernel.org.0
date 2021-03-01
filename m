Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53BA3290A9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238650AbhCAUMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:12:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242573AbhCAUC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:02:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 693EF65390;
        Mon,  1 Mar 2021 17:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621453;
        bh=xl51XW3imt5RYp4XOdMTgV5zmO6HMGyRFP/a/9rDIYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2uU+43eVvFcgkqdwdayOCQVaI1f/mLLXGRMkh2NnXgRyOBDpdDZWXLRpdDDwploJ
         g1W105VhoeE7HW7/S97vePTHjK3WKS+vXYS6bQNqkwyCoznCbwDSrd9YmJ9UqTqJI1
         cipFtPi/P62pAbkzqsOh/zKMdOmD9DpnjYK660o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 521/775] PCI: pci-bridge-emul: Fix array overruns, improve safety
Date:   Mon,  1 Mar 2021 17:11:29 +0100
Message-Id: <20210301161227.269830899@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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



