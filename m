Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5604A45133C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347953AbhKOTtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:49:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245494AbhKOTUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BD7863558;
        Mon, 15 Nov 2021 18:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001339;
        bh=t0bKRgsxqUMg3At4kjEc+ixjGhzXTiBcxQt9h+VrecQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lI5hwDSeTqgtLPUig5L20NmlpxRm0/S+4SERHvYPXX3znipTOqtoZjdeHIGtlxUy+
         bghCLaQhj1CsCC50ZZ2ZnjphG+abrnzgFvK/b9HBAxfdOr6hkvAjwkGQTganygGPmB
         0dEThXsmncU80M6JxcwzKmZcteYYik5R8CfuHOAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 153/917] PCI: aardvark: Fix support for PCI_ROM_ADDRESS1 on emulated bridge
Date:   Mon, 15 Nov 2021 17:54:08 +0100
Message-Id: <20211115165433.951072508@linuxfoundation.org>
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

commit 239edf686c14a9ff926dec2f350289ed7adfefe2 upstream.

This register is exported at address offset 0x30.

Link: https://lore.kernel.org/r/20211028185659.20329-8-kabel@kernel.org
Fixes: 8a3ebd8de328 ("PCI: aardvark: Implement emulated root PCI bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -32,6 +32,7 @@
 #define PCIE_CORE_DEV_ID_REG					0x0
 #define PCIE_CORE_CMD_STATUS_REG				0x4
 #define PCIE_CORE_DEV_REV_REG					0x8
+#define PCIE_CORE_EXP_ROM_BAR_REG				0x30
 #define PCIE_CORE_PCIEXP_CAP					0xc0
 #define PCIE_CORE_ERR_CAPCTL_REG				0x118
 #define     PCIE_CORE_ERR_CAPCTL_ECRC_CHK_TX			BIT(5)
@@ -813,6 +814,10 @@ advk_pci_bridge_emul_base_conf_read(stru
 		*value = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
 		return PCI_BRIDGE_EMUL_HANDLED;
 
+	case PCI_ROM_ADDRESS1:
+		*value = advk_readl(pcie, PCIE_CORE_EXP_ROM_BAR_REG);
+		return PCI_BRIDGE_EMUL_HANDLED;
+
 	case PCI_INTERRUPT_LINE: {
 		/*
 		 * From the whole 32bit register we support reading from HW only
@@ -845,6 +850,10 @@ advk_pci_bridge_emul_base_conf_write(str
 		advk_writel(pcie, new, PCIE_CORE_CMD_STATUS_REG);
 		break;
 
+	case PCI_ROM_ADDRESS1:
+		advk_writel(pcie, new, PCIE_CORE_EXP_ROM_BAR_REG);
+		break;
+
 	case PCI_INTERRUPT_LINE:
 		if (mask & (PCI_BRIDGE_CTL_BUS_RESET << 16)) {
 			u32 val = advk_readl(pcie, PCIE_CORE_CTRL1_REG);


