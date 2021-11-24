Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79F745BCCF
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244914AbhKXMco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:32:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344261AbhKXMam (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:30:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83B4D6115A;
        Wed, 24 Nov 2021 12:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756359;
        bh=W9Lm2qyFpay6X2mn4aqdnOgWJNZ6+dMrEGLlH1wEwyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBOVs+XU974af1I0+3s70MCVKEkBiFWWLjhUmGqoM8L/FMfB8IlpMQ9yUqawbTEtG
         pN8N+SePKdCu+L4X72wrhr2gcLw/Ibi/gmIwAPa8V/8Rc+PJG5XqZm4pDljaUEBm1e
         rRQesFlkPj1BVoD15dJqqCXpO5In+xgdpwTQTh6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 4.14 058/251] PCI: aardvark: Do not clear status bits of masked interrupts
Date:   Wed, 24 Nov 2021 12:55:00 +0100
Message-Id: <20211124115712.268509376@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit a7ca6d7fa3c02c032db5440ff392d96c04684c21 upstream.

The PCIE_ISR1_REG says which interrupts are currently set / active,
including those which are masked.

The driver currently reads this register and looks if some unmasked
interrupts are active, and if not, it clears status bits of _all_
interrupts, including the masked ones.

This is incorrect, since, for example, some drivers may poll these bits.

Remove this clearing, and also remove this early return statement
completely, since it does not change functionality in any way.

Link: https://lore.kernel.org/r/20211005180952.6812-7-kabel@kernel.org
Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host controller driver")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/host/pci-aardvark.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -863,12 +863,6 @@ static void advk_pcie_handle_int(struct
 	isr1_mask = advk_readl(pcie, PCIE_ISR1_MASK_REG);
 	isr1_status = isr1_val & ((~isr1_mask) & PCIE_ISR1_ALL_MASK);
 
-	if (!isr0_status && !isr1_status) {
-		advk_writel(pcie, isr0_val, PCIE_ISR0_REG);
-		advk_writel(pcie, isr1_val, PCIE_ISR1_REG);
-		return;
-	}
-
 	/* Process MSI interrupts */
 	if (isr0_status & PCIE_ISR0_MSI_INT_PENDING)
 		advk_pcie_handle_msi(pcie);


