Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAB745D0CB
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 00:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352485AbhKXXIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 18:08:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352491AbhKXXIi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 18:08:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15CF2610A0;
        Wed, 24 Nov 2021 23:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637795128;
        bh=dOzdoiof0Qqw3pZKj041pYLXweDYH0NpQ3dNdJvkjGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P23FGfl3BhHqImGTIJivGe1k3hKdRRMdQH7hNLLA+X7jG9okkDzcEyem6FhtVDrPB
         4xIVs75NJVqK6yqyPPh+9Co6ghYOSKZ8axQGzw9cBTPMhuOcUSwCP139esjN23Djve
         7T5J5aV8B0YF1LdpHJglAIWkaPJ58FAeDryfClRLj5xYGJwkzJWlXYvulGU3Y009u0
         g56ZEnCcKA30I4TnNVRXhtn80y9djeSJgx4jvodd+EoaXkIzNY89CmGI4NV9PYRgXT
         sWLZ++xEHiG+X78SU8r63nj3tEIRio7HKabvoh8+i+/2QAmmIz9k9lBqcxmhim3hdR
         SVmHc5Cs1WQKg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 4.19 13/20] PCI: aardvark: Fix PCIe Max Payload Size setting
Date:   Thu, 25 Nov 2021 00:04:53 +0100
Message-Id: <20211124230500.27109-14-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124230500.27109-1-kabel@kernel.org>
References: <20211124230500.27109-1-kabel@kernel.org>
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
 drivers/pci/controller/pci-aardvark.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index dd3bf2ece6b6..4789f4692a5f 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -452,8 +452,9 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
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

