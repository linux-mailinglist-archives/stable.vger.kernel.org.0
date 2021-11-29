Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE72461E0E
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351338AbhK2Sb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:31:59 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49866 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351312AbhK2S36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:29:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 54535CE13E6;
        Mon, 29 Nov 2021 18:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03945C53FCD;
        Mon, 29 Nov 2021 18:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210397;
        bh=IladcV824PiP8lNaao/ARsLDyEI7bWFj2uI9Y2GYv3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAItUEWlGz0GYeMbgDNUts1bD0g2fOmO9oDw3C6r3wa8DFFzZvv5sRDCuo9/D+f6I
         CaOqgCA00EAYnh5Piz40040mx/SAeI2KZNtc0e5VrQ9q+KS9zJPikMdOKvHb/sW+yO
         fc9XUmtNxUnmIsp9Jt1F1uMifnFED1Ey+5vABECY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 41/92] PCI: aardvark: Set PCI Bridge Class Code to PCI Bridge
Date:   Mon, 29 Nov 2021 19:18:10 +0100
Message-Id: <20211129181708.797537178@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -502,6 +502,26 @@ static void advk_pcie_setup_hw(struct ad
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


