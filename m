Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE9A41F607
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 21:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353310AbhJAUAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 16:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241726AbhJAUAy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 16:00:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C67E761AE0;
        Fri,  1 Oct 2021 19:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633118350;
        bh=RqyrewmnrCEu148W3hZVOHonsU0izWALcHQxYH5Kk60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBTm5vHBloopaxLo4XEnMByiWgQGrtDpZP58Wd5fmx5LB0+igtSeRjvDfCUaYzbZW
         WNPcUAbn0WoePg0YWBcQLTshuTQJWaOfa0TfbrmgsE99ek8Wp+UxDgVltS9KhPX10p
         mmKcirHRWY0kJmim8sPpEriKMP+T0mAtjgzfz1YZkk1p9RGqY/FaWSr06znURYJMgR
         +m7azii/AF4DFcsQm9xqa3478uxUiHPUThVNPIZTb3rM4lQQhfx6uGkDZapwcRt5Uz
         FmqH4G8PKF2Wak/LWafO2uaMTF3XhB4wOtR+JykGLR3gmuCSQ1hxdX37z5DAxpBrRE
         aExpFx9xTLvGA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        pali@kernel.org, =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 06/13] PCI: aardvark: Do not clear status bits of masked interrupts
Date:   Fri,  1 Oct 2021 21:58:49 +0200
Message-Id: <20211001195856.10081-7-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211001195856.10081-1-kabel@kernel.org>
References: <20211001195856.10081-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

It is incorrect to clear status bits of masked interrupts.

The aardvark driver clears all status interrupt bits if no unmasked
status bit is set. Masked bits should never be cleared.

Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host controller driver")
Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/pci/controller/pci-aardvark.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index d5d6f92e5143..e4986806a189 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1295,11 +1295,8 @@ static void advk_pcie_handle_int(struct advk_pcie *pcie)
 	isr1_mask = advk_readl(pcie, PCIE_ISR1_MASK_REG);
 	isr1_status = isr1_val & ((~isr1_mask) & PCIE_ISR1_ALL_MASK);
 
-	if (!isr0_status && !isr1_status) {
-		advk_writel(pcie, isr0_val, PCIE_ISR0_REG);
-		advk_writel(pcie, isr1_val, PCIE_ISR1_REG);
+	if (!isr0_status && !isr1_status)
 		return;
-	}
 
 	/* Process MSI interrupts */
 	if (isr0_status & PCIE_ISR0_MSI_INT_PENDING)
-- 
2.32.0

