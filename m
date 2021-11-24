Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D99545D06A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352170AbhKXWxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:47214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352240AbhKXWxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:53:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E79F7610A1;
        Wed, 24 Nov 2021 22:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794202;
        bh=4oxOI66cLHGmwxuAJfjlcfaiYjyEH6snYCCkOIcH42M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDizgt2H4mg2r2Jx2adxKlfenNYgTgU1QIBX1z0cr3Sn+Aeff4tgYv4hVA7y52zbg
         zXBF+tlpmSC1HLae9ppRpnV8LcZVjDt533uNUjAIRR9VaoVyj7NiOWc+IgyAQ/zy9j
         XPXFhFbySVVuiaqJrhfUgp8qaD8pbJf7iNJigZlOHS/mwzUi8GKdmy3AyqJX12MZOd
         kVSzcmVyPyD7Kij94T4V4KquIMw7ffok3W1yTxKBe3q6gPOvPN3TnhJbD/j1A9x2C2
         kKdVMBK0GYJeJEpbHnOo9fm0mxqsBiVlEbYwx98eH2TliijElh2rPTNcCnCAUC9dre
         puU8PfCelSJIw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 09/24] PCI: aardvark: Introduce an advk_pcie_valid_device() helper
Date:   Wed, 24 Nov 2021 23:49:18 +0100
Message-Id: <20211124224933.24275-10-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124224933.24275-1-kabel@kernel.org>
References: <20211124224933.24275-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@bootlin.com>

commit 248d4e59616c632f37f04c233eec6d5008384926 upstream.

In other to mimic other PCIe host controller drivers, introduce an
advk_pcie_valid_device() helper, used in the configuration read/write
functions.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
[lorenzo.pieralisi@arm.com: updated host->controller dir move]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/host/pci-aardvark.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index ae67e5c3fe70..9426715316b2 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -592,6 +592,15 @@ static bool advk_pcie_pio_is_running(struct advk_pcie *pcie)
 	return false;
 }
 
+static bool advk_pcie_valid_device(struct advk_pcie *pcie, struct pci_bus *bus,
+				  int devfn)
+{
+	if ((bus->number == pcie->root_bus_nr) && PCI_SLOT(devfn) != 0)
+		return false;
+
+	return true;
+}
+
 static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
 			     int where, int size, u32 *val)
 {
@@ -599,7 +608,7 @@ static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
 	u32 reg;
 	int ret;
 
-	if ((bus->number == pcie->root_bus_nr) && PCI_SLOT(devfn) != 0) {
+	if (!advk_pcie_valid_device(pcie, bus, devfn)) {
 		*val = 0xffffffff;
 		return PCIBIOS_DEVICE_NOT_FOUND;
 	}
@@ -660,7 +669,7 @@ static int advk_pcie_wr_conf(struct pci_bus *bus, u32 devfn,
 	int offset;
 	int ret;
 
-	if ((bus->number == pcie->root_bus_nr) && PCI_SLOT(devfn) != 0)
+	if (!advk_pcie_valid_device(pcie, bus, devfn))
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	if (where % size)
-- 
2.32.0

