Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C64499540
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392493AbiAXUvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40618 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390399AbiAXUpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:45:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28DCF60C13;
        Mon, 24 Jan 2022 20:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C131C340E5;
        Mon, 24 Jan 2022 20:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057117;
        bh=YcFsUeslYa8xYA7haRFrlwUsZXiclWBMo3itOg4vcr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hdVrYnzUZSmIl9D9nQP48Q5L8SW2IA5A9KSlRWFRzJaPUawng5wz2c0GeyHoQ0A6i
         DkwBeNM9GKLbHniFXO75jVagbNp+rVJseZt6UBZEiMG1bmJNtSm524gd4j/4mcflVm
         ACk2gkRU+i4I1vyV/VS00K0OLKIMhdhCZlS34Iqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 707/846] PCI: pci-bridge-emul: Set PCI_STATUS_CAP_LIST for PCIe device
Date:   Mon, 24 Jan 2022 19:43:44 +0100
Message-Id: <20220124184125.431779033@linuxfoundation.org>
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

commit 3be9d243b21724d49b65043d4520d688b6040b36 upstream.

Since all PCI Express device Functions are required to implement the PCI
Express Capability structure, Capabilities List bit in PCI Status Register
must be hardwired to 1b. Capabilities Pointer register (which is already
set by pci-bride-emul.c driver) is valid only when Capabilities List is set
to 1b.

Link: https://lore.kernel.org/r/20211124155944.1290-7-pali@kernel.org
Fixes: 23a5fba4d941 ("PCI: Introduce PCI bridge emulated config space common logic")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-bridge-emul.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -296,6 +296,7 @@ int pci_bridge_emul_init(struct pci_brid
 
 	if (bridge->has_pcie) {
 		bridge->conf.capabilities_pointer = PCI_CAP_PCIE_START;
+		bridge->conf.status |= cpu_to_le16(PCI_STATUS_CAP_LIST);
 		bridge->pcie_conf.cap_id = PCI_CAP_ID_EXP;
 		bridge->pcie_conf.cap |= cpu_to_le16(PCI_EXP_TYPE_ROOT_PORT << 4);
 		bridge->pcie_cap_regs_behavior =


