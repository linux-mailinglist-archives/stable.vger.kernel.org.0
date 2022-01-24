Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6829D499175
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345956AbiAXUKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:10:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60596 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378121AbiAXUGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:06:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2A24611CD;
        Mon, 24 Jan 2022 20:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB01C340E5;
        Mon, 24 Jan 2022 20:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054780;
        bh=YcFsUeslYa8xYA7haRFrlwUsZXiclWBMo3itOg4vcr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xc1pzXAXH/SB3svvP63QPpNsCqIOaaiEZr8SBicrwIRZNmnJcL0fluv1gYg7tRVVR
         N6NAu2/O51OwCFlJRCNQXzYhCk65nqFMapI1DCi9MMdDOXB6bSDdO58mk+t62VmjW6
         6NssIbn9OFA5TIWwR3rQ5f+7ykwhfKZg9AA6SseM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.10 467/563] PCI: pci-bridge-emul: Set PCI_STATUS_CAP_LIST for PCIe device
Date:   Mon, 24 Jan 2022 19:43:52 +0100
Message-Id: <20220124184040.615274042@linuxfoundation.org>
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


