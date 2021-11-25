Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1802045D934
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbhKYLaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:30:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233885AbhKYL3d (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:29:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C107610CA;
        Thu, 25 Nov 2021 11:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637839582;
        bh=C26RaqD1KTu9NeG5FLNkFcwX99MR7q7rDT2frV4FFXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NcWUW7HiJL5mdn8LGBrTDaLU2ef9LbQJrH+2RL0fPi0ac5vx2Fowtmb3FKGhkZwV9
         DpJOMows8kcINhgfbeFxfSUi9nlfugBTXlx1sG6dKVGuCZMva731K3vwr8Nb4swMVR
         bHOKRrMomEpsz0vDS51AdN3BY2BFqzA604kzxYN06SPSBISZRhZseuy5wqrChUJLlc
         PFetVu5LAizzMhyCNzpzARX4dBLlYOCEBSRoTCWuWUCnmpEcS44vxH7FhWRYo0qiiR
         aBm1fDsHalMC/JhIsqgOSEKtgGjl984+5/AC0mLritgSGp9UuW6K6DtqducJpVtKae
         vAtUNJ/2HtIPw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.10 1/5] PCI: aardvark: Update comment about disabling link training
Date:   Thu, 25 Nov 2021 12:26:08 +0100
Message-Id: <20211125112612.11501-2-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211125112612.11501-1-kabel@kernel.org>
References: <20211125112612.11501-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 1d1cd163d0de22a4041a6f1aeabcf78f80076539 upstream.

According to PCI Express Base Specifications (rev 4.0, 6.6.1
"Conventional reset"), after fundamental reset a 100ms delay is needed
prior to enabling link training.

Update comment in code to reflect this requirement.

Link: https://lore.kernel.org/r/20201202184659.3795-1-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 434522465d98..10c2c3877fcc 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -389,7 +389,14 @@ static void advk_pcie_issue_perst(struct advk_pcie *pcie)
 	if (!pcie->reset_gpio)
 		return;
 
-	/* PERST does not work for some cards when link training is enabled */
+	/*
+	 * As required by PCI Express spec (PCI Express Base Specification, REV.
+	 * 4.0 PCI Express, February 19 2014, 6.6.1 Conventional Reset) a delay
+	 * for at least 100ms after de-asserting PERST# signal is needed before
+	 * link training is enabled. So ensure that link training is disabled
+	 * prior de-asserting PERST# signal to fulfill that PCI Express spec
+	 * requirement.
+	 */
 	reg = advk_readl(pcie, PCIE_CORE_CTRL0_REG);
 	reg &= ~LINK_TRAINING_EN;
 	advk_writel(pcie, reg, PCIE_CORE_CTRL0_REG);
-- 
2.32.0

