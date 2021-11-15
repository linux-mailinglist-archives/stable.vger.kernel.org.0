Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D100A4514D5
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349248AbhKOUNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:13:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345087AbhKOT0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:26:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7847F6349F;
        Mon, 15 Nov 2021 19:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003402;
        bh=YrkME0dW2fYwBrJ4fq5sdmolI0Ycmfy85H/CD9DWOjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXxpGJ+L1DywdZ1VGYic8jsP/OzBDEL8TIjGYrDZmlCjpDRuex5+pTIatSVLxozWJ
         CwhKPRoorAmcGJTR5Gl1rBTg0FM1zReOZwpzXqbIM8lLUUeWq/gbFQQSznEO6DZeZq
         xYmphn4oVR5Zmf0RdrKZqesjFG3QM7k7PESprrbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 915/917] PCI: aardvark: Fix PCIe Max Payload Size setting
Date:   Mon, 15 Nov 2021 18:06:50 +0100
Message-Id: <20211115165500.066891621@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -597,8 +597,9 @@ static void advk_pcie_setup_hw(struct ad
 	reg = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + PCI_EXP_DEVCTL);
 	reg &= ~PCI_EXP_DEVCTL_RELAX_EN;
 	reg &= ~PCI_EXP_DEVCTL_NOSNOOP_EN;
+	reg &= ~PCI_EXP_DEVCTL_PAYLOAD;
 	reg &= ~PCI_EXP_DEVCTL_READRQ;
-	reg |= PCI_EXP_DEVCTL_PAYLOAD; /* Set max payload size */
+	reg |= PCI_EXP_DEVCTL_PAYLOAD_512B;
 	reg |= PCI_EXP_DEVCTL_READRQ_512B;
 	advk_writel(pcie, reg, PCIE_CORE_PCIEXP_CAP + PCI_EXP_DEVCTL);
 


