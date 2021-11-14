Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B3044F83A
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 14:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhKNNx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 08:53:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234137AbhKNNxW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 08:53:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C60861183;
        Sun, 14 Nov 2021 13:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636897829;
        bh=dC2Bjg00cz74XHF3wxYwQmdvihA5DwLi8oayXZBKi+o=;
        h=Subject:To:Cc:From:Date:From;
        b=qjvlEo9N+63kV2DxwnuZ4DkkecI6uZ8nSY/kYreJ87EwYzWkccrlJXyn+OWMQeAA/
         V0FwISrY+tPTyBfqYQaXYXYDXOZtuBygbB92vzXVNmN7CsBes+CJm/1NUiLsimMm5f
         0FyzciLAFgp5O2PncQwk/Ub8qzYQwuMNLtZoQCkg=
Subject: FAILED: patch "[PATCH] PCI: aardvark: Fix PCIe Max Payload Size setting" failed to apply to 4.14-stable tree
To:     pali@kernel.org, kabel@kernel.org, lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Nov 2021 14:50:16 +0100
Message-ID: <163689781619145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a4e17d65dafdd3513042d8f00404c9b6068a825c Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Tue, 5 Oct 2021 20:09:41 +0200
Subject: [PATCH] PCI: aardvark: Fix PCIe Max Payload Size setting
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Change PCIe Max Payload Size setting in PCIe Device Control register to 512
bytes to align with PCIe Link Initialization sequence as defined in Marvell
Armada 3700 Functional Specification. According to the specification,
maximal Max Payload Size supported by this device is 512 bytes.

Without this kernel prints suspicious line:

    pci 0000:01:00.0: Upstream bridge's Max Payload Size set to 256 (was 16384, max 512)

With this change it changes to:

    pci 0000:01:00.0: Upstream bridge's Max Payload Size set to 256 (was 512, max 512)

Link: https://lore.kernel.org/r/20211005180952.6812-3-kabel@kernel.org
Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host controller driver")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 596ebcfcc82d..884510630bae 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -488,8 +488,9 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	reg = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + PCI_EXP_DEVCTL);
 	reg &= ~PCI_EXP_DEVCTL_RELAX_EN;
 	reg &= ~PCI_EXP_DEVCTL_NOSNOOP_EN;
+	reg &= ~PCI_EXP_DEVCTL_PAYLOAD;
 	reg &= ~PCI_EXP_DEVCTL_READRQ;
-	reg |= PCI_EXP_DEVCTL_PAYLOAD; /* Set max payload size */
+	reg |= PCI_EXP_DEVCTL_PAYLOAD_512B;
 	reg |= PCI_EXP_DEVCTL_READRQ_512B;
 	advk_writel(pcie, reg, PCIE_CORE_PCIEXP_CAP + PCI_EXP_DEVCTL);
 

