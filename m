Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3ED45D0C9
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 00:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352455AbhKXXIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 18:08:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:51394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352485AbhKXXIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 18:08:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0613B610A5;
        Wed, 24 Nov 2021 23:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637795125;
        bh=dvf2tdlwSe5DC82fO9H8RGLy0dHQX/kF92ZUts249YA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cui9FgGS+hQ+Z53vDTfs9MEGeBQ+aO2L2ODhV/A9ygOAxChYP9eSHgWpkuih3becX
         s3pcYEgD8gChqtP+CD6Uy4HjbCUqKQQqD93X2BMxWmrp892U+Dh4I8S/V+MG9cwLnn
         8SF767iBfkcLbw+1gLWOkSNBLSxJfPupcGWjNIx1vm0V8J23SWVXy5DeQtG04dD1j8
         y74MbuX+JG6V4JMIc+YpdfKY+y9BA3pZrnarViVlvbaa5bTaE4uNApgx/YR0dSRHbs
         w6lcHedNVLTw2CoCmmUGUFpNS6m3ZTeM6GJukQxOUdopoNUsssr5mfKtA0E6q4/6A1
         GCsNX1Rz9etyQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 11/20] PCI: aardvark: Update comment about disabling link training
Date:   Thu, 25 Nov 2021 00:04:51 +0100
Message-Id: <20211124230500.27109-12-kabel@kernel.org>
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
index e26abbab506c..b4b9cebf09b4 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -236,7 +236,14 @@ static void advk_pcie_issue_perst(struct advk_pcie *pcie)
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

