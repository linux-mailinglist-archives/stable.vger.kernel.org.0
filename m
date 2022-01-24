Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41C549A586
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370939AbiAYAGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2360146AbiAXXgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:36:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E325C075D37;
        Mon, 24 Jan 2022 13:37:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF7036150D;
        Mon, 24 Jan 2022 21:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB009C340E4;
        Mon, 24 Jan 2022 21:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060223;
        bh=YcFsUeslYa8xYA7haRFrlwUsZXiclWBMo3itOg4vcr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxzcgK0v82+wCNtPNr9GT/vwBP0RXE3NPRHzJXsVncM6iBZOdDXbJFM0AZvuRa2Bb
         bvHSmxT50A6F6bYJOOmpz24MeH/Ulwq+gdcbPvGiAsIjX1ylIlasKe9ybGkWHMy6Jf
         VXwyczEWSO+f51eCj9nkeFvL8aEF1UtMV7s5hTzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.16 0879/1039] PCI: pci-bridge-emul: Set PCI_STATUS_CAP_LIST for PCIe device
Date:   Mon, 24 Jan 2022 19:44:28 +0100
Message-Id: <20220124184154.845878511@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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


