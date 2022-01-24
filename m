Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1F6498E5B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239472AbiAXTkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:40:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58860 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349723AbiAXTho (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:37:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 189ABB8121C;
        Mon, 24 Jan 2022 19:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5CAC340E5;
        Mon, 24 Jan 2022 19:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053061;
        bh=gvwNwUL2uzlUhdpiHJOTQEv4OnE/kqW5SjOPiiqcIDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izp9fJBeCiTso3o57AIVNTnTZPlu3thMaFxTI/4in5HL5PBkc/dDjnXy7gWey8X7s
         dtp+18TtSiq9pglijoHILVBH7pElMA6oRk+NWZZKV0o2THsepPiHoUHEfOC94LX+lX
         aoZFD90hKVDfpQVM8zsHoNR880Mn6q/BN0mp7Ns0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 263/320] PCI: pci-bridge-emul: Set PCI_STATUS_CAP_LIST for PCIe device
Date:   Mon, 24 Jan 2022 19:44:07 +0100
Message-Id: <20220124184002.931227601@linuxfoundation.org>
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
@@ -287,6 +287,7 @@ int pci_bridge_emul_init(struct pci_brid
 
 	if (bridge->has_pcie) {
 		bridge->conf.capabilities_pointer = PCI_CAP_PCIE_START;
+		bridge->conf.status |= cpu_to_le16(PCI_STATUS_CAP_LIST);
 		bridge->pcie_conf.cap_id = PCI_CAP_ID_EXP;
 		bridge->pcie_conf.cap |= cpu_to_le16(PCI_EXP_TYPE_ROOT_PORT << 4);
 		bridge->pcie_cap_regs_behavior =


