Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C630945D217
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 01:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243253AbhKYAfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 19:35:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245111AbhKYAbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 19:31:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13B77610F7;
        Thu, 25 Nov 2021 00:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637800000;
        bh=XfNkVj5z+OreRvHtRmN3X82G7PTZPG+Uag3x4usKk04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8KgAAqYOiyt81g7aGbH9XfJrFhEy++qP4iyr7T8N0C5CgpNEq65ngo8gS+m6EIZf
         355YqCc2a5EXTC8jsT5DgjBwvOOuU0mQomK3KWiEEnbspVyXPCpUXzIryDatT79WJG
         B/PgcRAVzpehyo41BlceAUrKCh2ft7HYFThgXNK4leYMRoj/fnTmeI85pI2MVDrSfn
         fJlmVNlovsTROQvihRjDQ41t9Fy23lkb7b4Fk9zLvsOAiO1XSdKLSrxYDCymR4UbEH
         nG3Mb26YAFc23Mtmq/UV/DXzoToT5G4nWCBDOEjqG7A6VlhL0xX8JlznXixsgtL5ya
         XH1OB/fjTDgAw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4 11/22] PCI: pci-bridge-emul: Fix array overruns, improve safety
Date:   Thu, 25 Nov 2021 01:26:05 +0100
Message-Id: <20211125002616.31363-12-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211125002616.31363-1-kabel@kernel.org>
References: <20211125002616.31363-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

commit f8ee579d53aca887d93f5f411462f25c085a5106 upstream.

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
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/pci-bridge-emul.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci-bridge-emul.c b/drivers/pci/pci-bridge-emul.c
index b3d63e319bb3..3026346ccb18 100644
--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -21,8 +21,9 @@
 #include "pci-bridge-emul.h"
 
 #define PCI_BRIDGE_CONF_END	PCI_STD_HEADER_SIZEOF
+#define PCI_CAP_PCIE_SIZEOF	(PCI_EXP_SLTSTA2 + 2)
 #define PCI_CAP_PCIE_START	PCI_BRIDGE_CONF_END
-#define PCI_CAP_PCIE_END	(PCI_CAP_PCIE_START + PCI_EXP_SLTSTA2 + 2)
+#define PCI_CAP_PCIE_END	(PCI_CAP_PCIE_START + PCI_CAP_PCIE_SIZEOF)
 
 struct pci_bridge_reg_behavior {
 	/* Read-only bits */
@@ -38,7 +39,8 @@ struct pci_bridge_reg_behavior {
 	u32 rsvd;
 };
 
-static const struct pci_bridge_reg_behavior pci_regs_behavior[] = {
+static const
+struct pci_bridge_reg_behavior pci_regs_behavior[PCI_STD_HEADER_SIZEOF / 4] = {
 	[PCI_VENDOR_ID / 4] = { .ro = ~0 },
 	[PCI_COMMAND / 4] = {
 		.rw = (PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
@@ -173,7 +175,8 @@ static const struct pci_bridge_reg_behavior pci_regs_behavior[] = {
 	},
 };
 
-static const struct pci_bridge_reg_behavior pcie_cap_regs_behavior[] = {
+static const
+struct pci_bridge_reg_behavior pcie_cap_regs_behavior[PCI_CAP_PCIE_SIZEOF / 4] = {
 	[PCI_CAP_LIST_ID / 4] = {
 		/*
 		 * Capability ID, Next Capability Pointer and
@@ -270,6 +273,8 @@ static const struct pci_bridge_reg_behavior pcie_cap_regs_behavior[] = {
 int pci_bridge_emul_init(struct pci_bridge_emul *bridge,
 			 unsigned int flags)
 {
+	BUILD_BUG_ON(sizeof(bridge->conf) != PCI_BRIDGE_CONF_END);
+
 	bridge->conf.class_revision |= cpu_to_le32(PCI_CLASS_BRIDGE_PCI << 16);
 	bridge->conf.header_type = PCI_HEADER_TYPE_BRIDGE;
 	bridge->conf.cache_line_size = 0x10;
-- 
2.32.0

