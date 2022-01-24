Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D314649922A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348899AbiAXURr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352811AbiAXUOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:14:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DFEC0604E7;
        Mon, 24 Jan 2022 11:37:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BA07B81235;
        Mon, 24 Jan 2022 19:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3086DC340E5;
        Mon, 24 Jan 2022 19:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053055;
        bh=ql6piuZkCz58r60WoTyFBToaCwhIxWa4iazsS4gyJgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTOPelgHsgv+A0EOdD3EHSBbBBPMGlBwq4APl20IzMCVFAB3muK8vsdQ1b6rSfis4
         suDDxQ0+Pe57JAf7Y0XzuXC8R8+IfS7l4oaPNht+IE8mAWUiodJCbZF+ATBKww2Qo8
         jInuQ4hPjerezC3vWYay/DNn6bu9iMC5mDKaVohY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 261/320] PCI: pci-bridge-emul: Properly mark reserved PCIe bits in PCI config space
Date:   Mon, 24 Jan 2022 19:44:05 +0100
Message-Id: <20220124184002.859435416@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 7b067ac63a5730d2fae18399fed7e45f23d36912 upstream.

Some bits in PCI config space are reserved when device is PCIe. Properly
define behavior of PCI registers for PCIe emulated bridge and ensure that
it would not be possible change these reserved bits.

Link: https://lore.kernel.org/r/20211124155944.1290-3-pali@kernel.org
Fixes: 23a5fba4d941 ("PCI: Introduce PCI bridge emulated config space common logic")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-bridge-emul.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -300,6 +300,27 @@ int pci_bridge_emul_init(struct pci_brid
 			kfree(bridge->pci_regs_behavior);
 			return -ENOMEM;
 		}
+		/* These bits are applicable only for PCI and reserved on PCIe */
+		bridge->pci_regs_behavior[PCI_CACHE_LINE_SIZE / 4].ro &=
+			~GENMASK(15, 8);
+		bridge->pci_regs_behavior[PCI_COMMAND / 4].ro &=
+			~((PCI_COMMAND_SPECIAL | PCI_COMMAND_INVALIDATE |
+			   PCI_COMMAND_VGA_PALETTE | PCI_COMMAND_WAIT |
+			   PCI_COMMAND_FAST_BACK) |
+			  (PCI_STATUS_66MHZ | PCI_STATUS_FAST_BACK |
+			   PCI_STATUS_DEVSEL_MASK) << 16);
+		bridge->pci_regs_behavior[PCI_PRIMARY_BUS / 4].ro &=
+			~GENMASK(31, 24);
+		bridge->pci_regs_behavior[PCI_IO_BASE / 4].ro &=
+			~((PCI_STATUS_66MHZ | PCI_STATUS_FAST_BACK |
+			   PCI_STATUS_DEVSEL_MASK) << 16);
+		bridge->pci_regs_behavior[PCI_INTERRUPT_LINE / 4].rw &=
+			~((PCI_BRIDGE_CTL_MASTER_ABORT |
+			   BIT(8) | BIT(9) | BIT(11)) << 16);
+		bridge->pci_regs_behavior[PCI_INTERRUPT_LINE / 4].ro &=
+			~((PCI_BRIDGE_CTL_FAST_BACK) << 16);
+		bridge->pci_regs_behavior[PCI_INTERRUPT_LINE / 4].w1c &=
+			~(BIT(10) << 16);
 	}
 
 	if (flags & PCI_BRIDGE_EMUL_NO_PREFETCHABLE_BAR) {


