Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9955497354
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 18:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbiAWRBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 12:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiAWRBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 12:01:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B908FC06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 09:01:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80C5CB80D31
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 17:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D16AC340E2;
        Sun, 23 Jan 2022 17:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642957312;
        bh=7o5C8Z3WClwgMI3Wsh/K4r5r1yKcfgZG5GMniLfG3ZI=;
        h=Subject:To:Cc:From:Date:From;
        b=kpcN4AAt0BwKn2d0lMORtBBf0BKD6eJ/fPLwgISqfpUZg9+GdpytNd34zDrZ8J5bo
         quXNyybE8T3PWN6bgv0sTH5kYqr1Hva1AjgSwJOTGxT9BI7AZ7g0Y+sbVi6nzhTRU+
         gbSa6KntMUPwRNLNRfhMkF2MUC19yNY0LGpzGViI=
Subject: FAILED: patch "[PATCH] PCI: pci-bridge-emul: Fix definitions of reserved bits" failed to apply to 5.4-stable tree
To:     pali@kernel.org, lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 18:01:49 +0100
Message-ID: <1642957309148161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 12998087d9f48b66965b97412069c7826502cd7e Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Wed, 24 Nov 2021 16:59:42 +0100
Subject: [PATCH] PCI: pci-bridge-emul: Fix definitions of reserved bits
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Some bits in PCI_EXP registers are reserved for non-root ports. Driver
pci-bridge-emul.c implements PCIe Root Port device therefore it should not
allow setting reserved bits of registers.

Properly define non-reserved bits for all PCI_EXP registers.

Link: https://lore.kernel.org/r/20211124155944.1290-5-pali@kernel.org
Fixes: 23a5fba4d941 ("PCI: Introduce PCI bridge emulated config space common logic")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/pci/pci-bridge-emul.c b/drivers/pci/pci-bridge-emul.c
index 0cbb4e3ca827..2c7e04fb2685 100644
--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -176,41 +176,55 @@ struct pci_bridge_reg_behavior pcie_cap_regs_behavior[PCI_CAP_PCIE_SIZEOF / 4] =
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

