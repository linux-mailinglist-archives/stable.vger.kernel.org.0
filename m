Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2C61FE0F9
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731825AbgFRBvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:51:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731770AbgFRB1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:27:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2750520897;
        Thu, 18 Jun 2020 01:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443623;
        bh=eBj2SV0H+lxZ+/rvct+DDT8Lrvn4UMAZ59kaoPGgF3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5YZimYVeGHeths5P+UmTekGGKer1YhprGfMpkPNyfy5MtXk7Yma2acGDHKqTvS7d
         KfsyKcDBKZfTe+D1fE6SDF/cBXOHnENFrV8pKWUhR30KtxD6Mv1tmu4NF5X3kR/5mf
         uYZBdPl20mUsf9EmLg1fJFvS0q80/SLyUHdEZmeg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Murray <andrew.murray@arm.com>,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 049/108] PCI: rcar: Fix incorrect programming of OB windows
Date:   Wed, 17 Jun 2020 21:25:01 -0400
Message-Id: <20200618012600.608744-49-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Murray <andrew.murray@arm.com>

[ Upstream commit 2b9f217433e31d125fb697ca7974d3de3ecc3e92 ]

The outbound windows (PCIEPAUR(x), PCIEPALR(x)) describe a mapping between
a CPU address (which is determined by the window number 'x') and a
programmed PCI address - Thus allowing the controller to translate CPU
accesses into PCI accesses.

However the existing code incorrectly writes the CPU address - lets fix
this by writing the PCI address instead.

For memory transactions, existing DT users describe a 1:1 identity mapping
and thus this change should have no effect. However the same isn't true for
I/O.

Link: https://lore.kernel.org/r/20191004132941.6660-1-andrew.murray@arm.com
Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
Tested-by: Marek Vasut <marek.vasut+renesas@gmail.com>
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Vasut <marek.vasut+renesas@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/host/pcie-rcar.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/host/pcie-rcar.c b/drivers/pci/host/pcie-rcar.c
index 2b0a1f3b8265..0077afca2493 100644
--- a/drivers/pci/host/pcie-rcar.c
+++ b/drivers/pci/host/pcie-rcar.c
@@ -328,11 +328,12 @@ static struct pci_ops rcar_pcie_ops = {
 };
 
 static void rcar_pcie_setup_window(int win, struct rcar_pcie *pcie,
-				   struct resource *res)
+				   struct resource_entry *window)
 {
 	/* Setup PCIe address space mappings for each resource */
 	resource_size_t size;
 	resource_size_t res_start;
+	struct resource *res = window->res;
 	u32 mask;
 
 	rcar_pci_write_reg(pcie, 0x00000000, PCIEPTCTLR(win));
@@ -346,9 +347,9 @@ static void rcar_pcie_setup_window(int win, struct rcar_pcie *pcie,
 	rcar_pci_write_reg(pcie, mask << 7, PCIEPAMR(win));
 
 	if (res->flags & IORESOURCE_IO)
-		res_start = pci_pio_to_address(res->start);
+		res_start = pci_pio_to_address(res->start) - window->offset;
 	else
-		res_start = res->start;
+		res_start = res->start - window->offset;
 
 	rcar_pci_write_reg(pcie, upper_32_bits(res_start), PCIEPAUR(win));
 	rcar_pci_write_reg(pcie, lower_32_bits(res_start) & ~0x7F,
@@ -377,7 +378,7 @@ static int rcar_pcie_setup(struct list_head *resource, struct rcar_pcie *pci)
 		switch (resource_type(res)) {
 		case IORESOURCE_IO:
 		case IORESOURCE_MEM:
-			rcar_pcie_setup_window(i, pci, res);
+			rcar_pcie_setup_window(i, pci, win);
 			i++;
 			break;
 		case IORESOURCE_BUS:
-- 
2.25.1

