Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5FD45BF82
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345915AbhKXM7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:59:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:33426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346019AbhKXM4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:56:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76020611C9;
        Wed, 24 Nov 2021 12:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757145;
        bh=mLpKvEUDIzgXLEuNj/tJb9F/V+Fi3J//Qk0Sdkbmjf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJwyRoJhV1lzdXr8zSFdQ32TqlGo4P7PEZQQsU99SYfWZZjo9iMNSVPO6iEIK+QOo
         NfWzm0we8Gd4xdh1DFMLHMhqDBpXADOckYrutk/1g5xfI/xGiRDBKnvHz5FrYJJZvu
         KkjSIMieW/5ETWV1epmxrVHlAH97IWSdXsrwSmxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 4.19 073/323] PCI: aardvark: Do not unmask unused interrupts
Date:   Wed, 24 Nov 2021 12:54:23 +0100
Message-Id: <20211124115721.335822991@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 1fb95d7d3c7a926b002fe8a6bd27a1cb428b46dc upstream.

There are lot of undocumented interrupt bits. To prevent unwanted
spurious interrupts, fix all *_ALL_MASK macros to define all interrupt
bits, so that driver can properly mask all interrupts, including those
which are undocumented.

Link: https://lore.kernel.org/r/20211005180952.6812-8-kabel@kernel.org
Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host controller driver")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -99,13 +99,13 @@
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
@@ -150,7 +150,7 @@
 #define     PCIE_IRQ_MSI_INT2_DET		BIT(21)
 #define     PCIE_IRQ_RC_DBELL_DET		BIT(22)
 #define     PCIE_IRQ_EP_STATUS			BIT(23)
-#define     PCIE_IRQ_ALL_MASK			0xfff0fb
+#define     PCIE_IRQ_ALL_MASK			GENMASK(31, 0)
 #define     PCIE_IRQ_ENABLE_INTS_MASK		PCIE_IRQ_CORE_INT
 
 /* Transaction types */


