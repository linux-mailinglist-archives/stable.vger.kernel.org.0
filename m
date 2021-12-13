Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F4B4726BC
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237153AbhLMJyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:54:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38208 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235737AbhLMJvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:51:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 702B2B80CAB;
        Mon, 13 Dec 2021 09:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A46BC00446;
        Mon, 13 Dec 2021 09:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389111;
        bh=NTeWr66kQim53JaM+l6jQjzjqcUNIyxEt14Y4yhf0Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVUyiBLQ7qbwALdosV1XbzXpqtSrWvXi/2r6Z5hBzdzM59QjCZ1D7fgfe6Zv0XP3y
         PQXafUaOY0dXOKZk073Fa4S8amf2Gdy2SggO4ZPrpMT1yehc0nXwH3j9gyEqgcKQ06
         hmuvbQTiuHtnZ/umv+zhl3LaCjbrCgPVEF+ElcVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 5.10 089/132] Revert "PCI: aardvark: Fix support for PCI_ROM_ADDRESS1 on emulated bridge"
Date:   Mon, 13 Dec 2021 10:30:30 +0100
Message-Id: <20211213092942.166653933@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit 39bd54d43b3f8b3c7b3a75f5d868d8bb858860e7 upstream.

This reverts commit 239edf686c14a9ff926dec2f350289ed7adfefe2.

239edf686c14 ("PCI: aardvark: Fix support for PCI_ROM_ADDRESS1 on emulated
bridge") added support for the Type 1 Expansion ROM BAR at config offset
0x38, based on the register being listed in the Marvell Armada A3720 spec.
But the spec doesn't document it at all for RC mode, and there is no ROM in
the SOC, so remove this emulation for now.

The PCI bridge which represents aardvark's PCIe Root Port has an Expansion
ROM Base Address register at offset 0x30, but its meaning is different than
PCI's Expansion ROM BAR register, although the layout is the same.  (This
is why we thought it does the same thing.)

First: there is no ROM (or part of BootROM) in the A3720 SOC dedicated for
PCIe Root Port (or controller in RC mode) containing executable code that
would initialize the Root Port, suitable for execution in bootloader (this
is how Expansion ROM BAR is used on x86).

Second: in A3720 spec the register (address 0xD0070030) is not documented
at all for Root Complex mode, but similar to other BAR registers, it has an
"entangled partner" in register 0xD0075920, which does address translation
for the BAR in 0xD0070030:

  - the BAR register sets the address from the view of PCIe bus

  - the translation register sets the address from the view of the CPU

The other BAR registers also have this entangled partner, and they can be
used to:

  - in RC mode: address-checking on the receive side of the RC (they can
    define address ranges for memory accesses from remote Endpoints to the
    RC)

  - in Endpoint mode: allow the remote CPU to access memory on A3720

The Expansion ROM BAR has only the Endpoint part documented, but from the
similarities we think that it can also be used in RC mode in that way.

So either Expansion ROM BAR has different meaning (if the hypothesis above
is true), or we don't know it's meaning (since it is not documented for RC
mode).

Remove the register from the emulated bridge accessing functions.

[bhelgaas: summarize reason for removal (first paragraph)]
Fixes: 239edf686c14 ("PCI: aardvark: Fix support for PCI_ROM_ADDRESS1 on emulated bridge")
Link: https://lore.kernel.org/r/20211125160148.26029-3-kabel@kernel.org
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -31,7 +31,6 @@
 #define PCIE_CORE_DEV_ID_REG					0x0
 #define PCIE_CORE_CMD_STATUS_REG				0x4
 #define PCIE_CORE_DEV_REV_REG					0x8
-#define PCIE_CORE_EXP_ROM_BAR_REG				0x30
 #define PCIE_CORE_PCIEXP_CAP					0xc0
 #define PCIE_CORE_ERR_CAPCTL_REG				0x118
 #define     PCIE_CORE_ERR_CAPCTL_ECRC_CHK_TX			BIT(5)
@@ -781,10 +780,6 @@ advk_pci_bridge_emul_base_conf_read(stru
 		*value = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
 		return PCI_BRIDGE_EMUL_HANDLED;
 
-	case PCI_ROM_ADDRESS1:
-		*value = advk_readl(pcie, PCIE_CORE_EXP_ROM_BAR_REG);
-		return PCI_BRIDGE_EMUL_HANDLED;
-
 	case PCI_INTERRUPT_LINE: {
 		/*
 		 * From the whole 32bit register we support reading from HW only
@@ -817,10 +812,6 @@ advk_pci_bridge_emul_base_conf_write(str
 		advk_writel(pcie, new, PCIE_CORE_CMD_STATUS_REG);
 		break;
 
-	case PCI_ROM_ADDRESS1:
-		advk_writel(pcie, new, PCIE_CORE_EXP_ROM_BAR_REG);
-		break;
-
 	case PCI_INTERRUPT_LINE:
 		if (mask & (PCI_BRIDGE_CTL_BUS_RESET << 16)) {
 			u32 val = advk_readl(pcie, PCIE_CORE_CTRL1_REG);


