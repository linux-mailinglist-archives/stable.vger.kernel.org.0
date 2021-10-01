Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B33041F609
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 21:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241935AbhJAUA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 16:00:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354131AbhJAUA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 16:00:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7890C61ACF;
        Fri,  1 Oct 2021 19:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633118351;
        bh=lmgWailf9PCmhTaU6pNgRCCvdpOpXgJpPGWHcrWeySE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zh2SmhBpU6/ISLID/EMXhAYIScniFND7a5rPJFw0Cp9DS6/Ugq4e9VU3EbVOi7PuK
         rkzSsa+5y4rxQ8dCjqFVNYOqvuL4dT3gXc7PzsZ7+W6XYSmGxFH0/VOpmDD3YSAztY
         nH+b5WYV88mFS+k3+VXdjeTYXsQjV5nDzE7y3fDUQZQlyQPKFuSXiI/itAIrO7t5UK
         Su74gq2JrQsPf0R8xjTI7eRKGCIJEv6x+HQUbMPyTEX7OpcGMRy+A0aK2J96nGfpge
         74/W5eZ28khU0eA438KjNZb07iRkLQG2LP7dEWpcLi7tOUBXX0BDDsKKKcBfzbmgXR
         G9o+JNAk8A00A==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        pali@kernel.org, =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 07/13] PCI: aardvark: Do not unmask unused interrupts
Date:   Fri,  1 Oct 2021 21:58:50 +0200
Message-Id: <20211001195856.10081-8-kabel@kernel.org>
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

There are lot of undocumented interrupt bits. Fix all *_ALL_MASK macros to
define all interrupt bits, so that driver can properly mask all interrupts,
including those which are undocumented.

Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host controller driver")
Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/pci/controller/pci-aardvark.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index e4986806a189..46fbaba1e6e4 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -107,13 +107,13 @@
 #define     PCIE_ISR0_MSI_INT_PENDING		BIT(24)
 #define     PCIE_ISR0_INTX_ASSERT(val)		BIT(16 + (val))
 #define     PCIE_ISR0_INTX_DEASSERT(val)	BIT(20 + (val))
-#define	    PCIE_ISR0_ALL_MASK			GENMASK(26, 0)
+#define     PCIE_ISR0_ALL_MASK			GENMASK(31, 0)
 #define PCIE_ISR1_REG				(CONTROL_BASE_ADDR + 0x48)
 #define PCIE_ISR1_MASK_REG			(CONTROL_BASE_ADDR + 0x4C)
 #define     PCIE_ISR1_POWER_STATE_CHANGE	BIT(4)
 #define     PCIE_ISR1_FLUSH			BIT(5)
 #define     PCIE_ISR1_INTX_ASSERT(val)		BIT(8 + (val))
-#define     PCIE_ISR1_ALL_MASK			GENMASK(11, 4)
+#define     PCIE_ISR1_ALL_MASK			GENMASK(31, 0)
 #define PCIE_MSI_ADDR_LOW_REG			(CONTROL_BASE_ADDR + 0x50)
 #define PCIE_MSI_ADDR_HIGH_REG			(CONTROL_BASE_ADDR + 0x54)
 #define PCIE_MSI_STATUS_REG			(CONTROL_BASE_ADDR + 0x58)
@@ -199,7 +199,7 @@
 #define     PCIE_IRQ_MSI_INT2_DET		BIT(21)
 #define     PCIE_IRQ_RC_DBELL_DET		BIT(22)
 #define     PCIE_IRQ_EP_STATUS			BIT(23)
-#define     PCIE_IRQ_ALL_MASK			0xfff0fb
+#define     PCIE_IRQ_ALL_MASK			GENMASK(31, 0)
 #define     PCIE_IRQ_ENABLE_INTS_MASK		PCIE_IRQ_CORE_INT
 
 /* Transaction types */
-- 
2.32.0

