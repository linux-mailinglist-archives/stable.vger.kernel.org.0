Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2A045133B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347950AbhKOTtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:49:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245498AbhKOTUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2D286354F;
        Mon, 15 Nov 2021 18:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001337;
        bh=WUsHo/fgChsNbElzKrqrNKdFhPDwZSfP2o/2HV834NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnSrL+nqIZaAiFMk0aA/+xZYKtz8yRJL5IhQu6zcoaDu8Zqau1wHG6xMz+PypdWmx
         vuEKoQxs488c17bpJi7Tek6+TTkf5w4gu5hiTlXDQNm93kJwQ1Tvw0lrCOd5uK/1dE
         JBE8UPA8hsNfWCzpc7xzBJbnKJZbXXM45Uk5RjFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 152/917] PCI: aardvark: Set PCI Bridge Class Code to PCI Bridge
Date:   Mon, 15 Nov 2021 17:54:07 +0100
Message-Id: <20211115165433.905518861@linuxfoundation.org>
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

commit 84e1b4045dc887b78bdc87d92927093dc3a465aa upstream.

Aardvark controller has something like config space of a Root Port
available at offset 0x0 of internal registers - these registers are used
for implementation of the emulated bridge.

The default value of Class Code of this bridge corresponds to a RAID Mass
storage controller, though. (This is probably intended for when the
controller is used as Endpoint.)

Change the Class Code to correspond to a PCI Bridge.

Add comment explaining this change.

Link: https://lore.kernel.org/r/20211028185659.20329-6-kabel@kernel.org
Fixes: 8a3ebd8de328 ("PCI: aardvark: Implement emulated root PCI bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -560,6 +560,26 @@ static void advk_pcie_setup_hw(struct ad
 	reg = (PCI_VENDOR_ID_MARVELL << 16) | PCI_VENDOR_ID_MARVELL;
 	advk_writel(pcie, reg, VENDOR_ID_REG);
 
+	/*
+	 * Change Class Code of PCI Bridge device to PCI Bridge (0x600400),
+	 * because the default value is Mass storage controller (0x010400).
+	 *
+	 * Note that this Aardvark PCI Bridge does not have compliant Type 1
+	 * Configuration Space and it even cannot be accessed via Aardvark's
+	 * PCI config space access method. Something like config space is
+	 * available in internal Aardvark registers starting at offset 0x0
+	 * and is reported as Type 0. In range 0x10 - 0x34 it has totally
+	 * different registers.
+	 *
+	 * Therefore driver uses emulation of PCI Bridge which emulates
+	 * access to configuration space via internal Aardvark registers or
+	 * emulated configuration buffer.
+	 */
+	reg = advk_readl(pcie, PCIE_CORE_DEV_REV_REG);
+	reg &= ~0xffffff00;
+	reg |= (PCI_CLASS_BRIDGE_PCI << 8) << 8;
+	advk_writel(pcie, reg, PCIE_CORE_DEV_REV_REG);
+
 	/* Disable Root Bridge I/O space, memory space and bus mastering */
 	reg = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
 	reg &= ~(PCI_COMMAND_IO | PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER);


