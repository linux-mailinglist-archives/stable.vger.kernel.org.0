Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B09A499176
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355133AbiAXUKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:10:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49166 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378055AbiAXUGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:06:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 674E4B81229;
        Mon, 24 Jan 2022 20:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF61C340E5;
        Mon, 24 Jan 2022 20:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054771;
        bh=O/8B47WCHt/7NggE2om+s/HBijeVuMCAcR01gd/vuYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTFGqyhWIyMP4Hzzev7ieGnuBGdVYFD3vUUrrYzBgK10so0Gs/ypEpPkUCZ8k0kdF
         L64GZEcssYkSIOPOtx91tzogZ9EEMx27RTd9JM79wntejNa1yGxyP8nFH3lV40Xz8b
         svCzF8E2wRS6cKFywlSEW8M6ycJtbmODWDMgfD5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.10 464/563] PCI: pci-bridge-emul: Properly mark reserved PCIe bits in PCI config space
Date:   Mon, 24 Jan 2022 19:43:49 +0100
Message-Id: <20220124184040.507268441@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
@@ -295,6 +295,27 @@ int pci_bridge_emul_init(struct pci_brid
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


