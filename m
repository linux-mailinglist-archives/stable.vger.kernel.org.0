Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0C845D209
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 01:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344588AbhKYAbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 19:31:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245111AbhKYA3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 19:29:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0F93610CA;
        Thu, 25 Nov 2021 00:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637799984;
        bh=Cc4ky554+BkJoAAkY3+xth25mvBpzbLsUVgwZu6FDZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ri/Ir1KchZOy9aTiQiSA8IHMc5giMCPr13TJPT3bwe06ClkmV+86VqdpDDWEJP6Fx
         HB/Bjy/IIP5xAJCeC7nsqm/Y03PgAiDz2/LvrTFBcP0BqVmQX2h/ywoLKd8iGPiEWu
         bug8A43wH+TWKbMs76g/meNxWTWYHGxm0evFU7i4CLxQaC1gtDwPmc1n0b4Pd5/1cn
         JcplRWtSQnPnZGDRZ8Tfid9vVr3NMCsqLXpIxZssKkd6bec6ZNT/3J2uUmr1qrGxof
         cQ4QQy5k+ll9jL2m8Eql11a+FD0Bcdt2jacKdx81BnwxgeaMFQRb7b4dyK5BJqtuaq
         5tjk6IcVoxT1g==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4 02/22] PCI: aardvark: Fix big endian support
Date:   Thu, 25 Nov 2021 01:25:56 +0100
Message-Id: <20211125002616.31363-3-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211125002616.31363-1-kabel@kernel.org>
References: <20211125002616.31363-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grzegorz Jaszczyk <jaz@semihalf.com>

commit e078723f9cccd509482fd7f30a4afb1125ca7a2a upstream.

Initialise every multiple-byte field of emulated PCI bridge config
space with proper cpu_to_le* macro. This is required since the structure
describing config space of emulated bridge assumes little-endian
convention.

Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 9774896397b0..d92644e0206b 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -686,18 +686,20 @@ static int advk_sw_pci_bridge_init(struct advk_pcie *pcie)
 	struct pci_bridge_emul *bridge = &pcie->bridge;
 	int ret;
 
-	bridge->conf.vendor = advk_readl(pcie, PCIE_CORE_DEV_ID_REG) & 0xffff;
-	bridge->conf.device = advk_readl(pcie, PCIE_CORE_DEV_ID_REG) >> 16;
+	bridge->conf.vendor =
+		cpu_to_le16(advk_readl(pcie, PCIE_CORE_DEV_ID_REG) & 0xffff);
+	bridge->conf.device =
+		cpu_to_le16(advk_readl(pcie, PCIE_CORE_DEV_ID_REG) >> 16);
 	bridge->conf.class_revision =
-		advk_readl(pcie, PCIE_CORE_DEV_REV_REG) & 0xff;
+		cpu_to_le32(advk_readl(pcie, PCIE_CORE_DEV_REV_REG) & 0xff);
 
 	/* Support 32 bits I/O addressing */
 	bridge->conf.iobase = PCI_IO_RANGE_TYPE_32;
 	bridge->conf.iolimit = PCI_IO_RANGE_TYPE_32;
 
 	/* Support 64 bits memory pref */
-	bridge->conf.pref_mem_base = PCI_PREF_RANGE_TYPE_64;
-	bridge->conf.pref_mem_limit = PCI_PREF_RANGE_TYPE_64;
+	bridge->conf.pref_mem_base = cpu_to_le16(PCI_PREF_RANGE_TYPE_64);
+	bridge->conf.pref_mem_limit = cpu_to_le16(PCI_PREF_RANGE_TYPE_64);
 
 	/* Support interrupt A for MSI feature */
 	bridge->conf.intpin = PCIE_CORE_INT_A_ASSERT_ENABLE;
-- 
2.32.0

