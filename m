Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2860E3B6295
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbhF1Osm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235654AbhF1Op3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:45:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31CD761D03;
        Mon, 28 Jun 2021 14:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890844;
        bh=oHWietslQmsL5XcK0i446ow/bSAhGtVpXjqHVJqLVgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s84VNVdWnlrYAEoS9CG7/Druit9ANH4QRWZMQK/GU1oVmDBZALjmr7B3wKfYuvf42
         MBkfR4NL/+85TfwwqfQD9FrB40Ad+3BFGvnH8LtHLTyVVWLGJBhravEca/l7P9T+hT
         3bxMDWo0dWjF5CCb2xreZgKEZXQWsaoN4Jf8i3n4GYpu0GqrVCgSMjbpNHOEPGVp2M
         33EI29f2GdmtVPAqe0M4c13BWjlsGm3xwhbxCbxUoovyaGZSyummamjBQVc61bMWZZ
         FRcqN3tkXPKSSreGDmSM+IaY9qSwy42HpVGffMafaiy8myOmnUAvOV4hO3vQwH7ekt
         fg8QKBRMt2jzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 066/109] PCI: Add ACS quirk for Broadcom BCM57414 NIC
Date:   Mon, 28 Jun 2021 10:32:22 -0400
Message-Id: <20210628143305.32978-67-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>

commit db2f77e2bd99dbd2fb23ddde58f0fae392fe3338 upstream.

The Broadcom BCM57414 NIC may be a multi-function device.  While it does
not advertise an ACS capability, peer-to-peer transactions are not possible
between the individual functions, so it is safe to treat them as fully
isolated.

Add an ACS quirk for this device so the functions can be in independent
IOMMU groups and attached individually to userspace applications using
VFIO.

[bhelgaas: commit log]
Link: https://lore.kernel.org/r/1621645997-16251-1-git-send-email-michael.chan@broadcom.com
Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 285b361831ec..c5141b0542d1 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4711,6 +4711,8 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_AMPERE, 0xE00A, pci_quirk_xgene_acs },
 	{ PCI_VENDOR_ID_AMPERE, 0xE00B, pci_quirk_xgene_acs },
 	{ PCI_VENDOR_ID_AMPERE, 0xE00C, pci_quirk_xgene_acs },
+	/* Broadcom multi-function device */
+	{ PCI_VENDOR_ID_BROADCOM, 0x16D7, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_BROADCOM, 0xD714, pci_quirk_brcm_acs },
 	{ 0 }
 };
-- 
2.30.2

