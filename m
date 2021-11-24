Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D327845D071
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352257AbhKXWxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352225AbhKXWxY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:53:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D395D610A6;
        Wed, 24 Nov 2021 22:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794214;
        bh=+jbzVrHpjt29zY3iDky6yyDKYmw8D3peBGhsujnawtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lfpr4GJ2yv0m2D6NTwBDlscAR4B+XiZmwgJXm05u31QtC+pMhnFEc1XK6HEpwdZqa
         B6Q2loTV8wiLblqP547R3SIznjO5favdt725FSuVaK19SpSHmgOj52RY96boKL2zId
         W3ndse0PXkK9NVG+jfF7RVaaTRmXhXizrrnHf+lDkU1LaXjEVhmuySj1cm0UcOOwG2
         ZXC4tmqiMUjnh3+Qi5q50Ns3Xsc3w+H8YjH2r0xY2rGG5pxPaG4YLrmYLv2rC7waFO
         1+2bq7UGFIdZcybZKv88ai0UAVOl4AUVQEeg8o+jOk6RbmFLgiOJNUllBO3MRn8M2l
         Bd5Z89dl58cKQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 4.14 16/24] PCI: aardvark: Fix PCIe Max Payload Size setting
Date:   Wed, 24 Nov 2021 23:49:25 +0100
Message-Id: <20211124224933.24275-17-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124224933.24275-1-kabel@kernel.org>
References: <20211124224933.24275-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit a4e17d65dafdd3513042d8f00404c9b6068a825c upstream.

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
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/host/pci-aardvark.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index fd5155b10c1d..fc198e6e7fa4 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -453,8 +453,9 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	reg = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + PCI_EXP_DEVCTL);
 	reg &= ~PCI_EXP_DEVCTL_RELAX_EN;
 	reg &= ~PCI_EXP_DEVCTL_NOSNOOP_EN;
+	reg &= ~PCI_EXP_DEVCTL_PAYLOAD;
 	reg &= ~PCI_EXP_DEVCTL_READRQ;
-	reg |= PCI_EXP_DEVCTL_PAYLOAD; /* Set max payload size */
+	reg |= PCI_EXP_DEVCTL_PAYLOAD_512B;
 	reg |= PCI_EXP_DEVCTL_READRQ_512B;
 	advk_writel(pcie, reg, PCIE_CORE_PCIEXP_CAP + PCI_EXP_DEVCTL);
 
-- 
2.32.0

