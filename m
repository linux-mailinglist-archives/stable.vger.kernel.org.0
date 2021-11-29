Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7D946230F
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 22:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhK2VRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 16:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbhK2VNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 16:13:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC96C0E49B0;
        Mon, 29 Nov 2021 10:24:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3717AB815CF;
        Mon, 29 Nov 2021 18:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606BDC53FCF;
        Mon, 29 Nov 2021 18:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210289;
        bh=gE+ucbt8F+WRtDdbd0LRVpF2xW+zjLqRWJpefI3eheo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fsclHUbFMd7aQwpdzjQUoVnB2zDuhP+wDvVpSfcegiAV10x3dVlX+XZOCvjNcLpOW
         vUvZyaimVlebuqtgrdYRjWXCNny8YYCWYlViV4IHQQtQRm/YeLbxxv/6r1APIoUrf3
         cR9MqN/flTSv2fhsNVmG4YaVkGLAvnko5wjSZW7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4 34/92] PCI: pci-bridge-emul: Fix array overruns, improve safety
Date:   Mon, 29 Nov 2021 19:18:03 +0100
Message-Id: <20211129181708.554871475@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-bridge-emul.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

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
@@ -173,7 +175,8 @@ static const struct pci_bridge_reg_behav
 	},
 };
 
-static const struct pci_bridge_reg_behavior pcie_cap_regs_behavior[] = {
+static const
+struct pci_bridge_reg_behavior pcie_cap_regs_behavior[PCI_CAP_PCIE_SIZEOF / 4] = {
 	[PCI_CAP_LIST_ID / 4] = {
 		/*
 		 * Capability ID, Next Capability Pointer and
@@ -270,6 +273,8 @@ static const struct pci_bridge_reg_behav
 int pci_bridge_emul_init(struct pci_bridge_emul *bridge,
 			 unsigned int flags)
 {
+	BUILD_BUG_ON(sizeof(bridge->conf) != PCI_BRIDGE_CONF_END);
+
 	bridge->conf.class_revision |= cpu_to_le32(PCI_CLASS_BRIDGE_PCI << 16);
 	bridge->conf.header_type = PCI_HEADER_TYPE_BRIDGE;
 	bridge->conf.cache_line_size = 0x10;


