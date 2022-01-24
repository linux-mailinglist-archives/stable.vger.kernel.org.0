Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A5F49953E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392482AbiAXUvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40554 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390362AbiAXUpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:45:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D2A06091C;
        Mon, 24 Jan 2022 20:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B2FC340E5;
        Mon, 24 Jan 2022 20:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057111;
        bh=AaF7euI3kYHd/11AknQCQrpr2iggUpjasga3Y3juYgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJATeTYH705c+wuUSMiKjJxSwyRnbJaGjBhohoXn+rBYnNZsD9DdeDZ9br0oYgXCg
         Xjfev1+UN1NJPw37njPx/RCacCUXHxXSjRHSW289xscxcF74quEhojFsytlHJNqTb+
         WFtLstbnBARq/9Q0lfzGBvMc6HUReG0pkuE8Oodg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 705/846] PCI: pci-bridge-emul: Fix definitions of reserved bits
Date:   Mon, 24 Jan 2022 19:43:42 +0100
Message-Id: <20220124184125.371304108@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 12998087d9f48b66965b97412069c7826502cd7e upstream.

Some bits in PCI_EXP registers are reserved for non-root ports. Driver
pci-bridge-emul.c implements PCIe Root Port device therefore it should not
allow setting reserved bits of registers.

Properly define non-reserved bits for all PCI_EXP registers.

Link: https://lore.kernel.org/r/20211124155944.1290-5-pali@kernel.org
Fixes: 23a5fba4d941 ("PCI: Introduce PCI bridge emulated config space common logic")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-bridge-emul.c |   36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -176,41 +176,55 @@ struct pci_bridge_reg_behavior pcie_cap_
 	[PCI_CAP_LIST_ID / 4] = {
 		/*
 		 * Capability ID, Next Capability Pointer and
-		 * Capabilities register are all read-only.
+		 * bits [14:0] of Capabilities register are all read-only.
+		 * Bit 15 of Capabilities register is reserved.
 		 */
-		.ro = ~0,
+		.ro = GENMASK(30, 0),
 	},
 
 	[PCI_EXP_DEVCAP / 4] = {
-		.ro = ~0,
+		/*
+		 * Bits [31:29] and [17:16] are reserved.
+		 * Bits [27:18] are reserved for non-upstream ports.
+		 * Bits 28 and [14:6] are reserved for non-endpoint devices.
+		 * Other bits are read-only.
+		 */
+		.ro = BIT(15) | GENMASK(5, 0),
 	},
 
 	[PCI_EXP_DEVCTL / 4] = {
-		/* Device control register is RW */
-		.rw = GENMASK(15, 0),
+		/*
+		 * Device control register is RW, except bit 15 which is
+		 * reserved for non-endpoints or non-PCIe-to-PCI/X bridges.
+		 */
+		.rw = GENMASK(14, 0),
 
 		/*
 		 * Device status register has bits 6 and [3:0] W1C, [5:4] RO,
-		 * the rest is reserved
+		 * the rest is reserved. Also bit 6 is reserved for non-upstream
+		 * ports.
 		 */
-		.w1c = (BIT(6) | GENMASK(3, 0)) << 16,
+		.w1c = GENMASK(3, 0) << 16,
 		.ro = GENMASK(5, 4) << 16,
 	},
 
 	[PCI_EXP_LNKCAP / 4] = {
-		/* All bits are RO, except bit 23 which is reserved */
-		.ro = lower_32_bits(~BIT(23)),
+		/*
+		 * All bits are RO, except bit 23 which is reserved and
+		 * bit 18 which is reserved for non-upstream ports.
+		 */
+		.ro = lower_32_bits(~(BIT(23) | PCI_EXP_LNKCAP_CLKPM)),
 	},
 
 	[PCI_EXP_LNKCTL / 4] = {
 		/*
 		 * Link control has bits [15:14], [11:3] and [1:0] RW, the
-		 * rest is reserved.
+		 * rest is reserved. Bit 8 is reserved for non-upstream ports.
 		 *
 		 * Link status has bits [13:0] RO, and bits [15:14]
 		 * W1C.
 		 */
-		.rw = GENMASK(15, 14) | GENMASK(11, 3) | GENMASK(1, 0),
+		.rw = GENMASK(15, 14) | GENMASK(11, 9) | GENMASK(7, 3) | GENMASK(1, 0),
 		.ro = GENMASK(13, 0) << 16,
 		.w1c = GENMASK(15, 14) << 16,
 	},


