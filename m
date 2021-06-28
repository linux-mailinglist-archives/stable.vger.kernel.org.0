Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23813B6341
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbhF1Ox6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233843AbhF1OwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:52:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9144D61D33;
        Mon, 28 Jun 2021 14:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891034;
        bh=elsntXTpOtuQG0Xo96u6tNv8ea2pMZ5wYhvSnG6sM/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eH/jbpPjJQiJRBpSOcAk6LWu7SFO8rzr7QY+i75Hkj9YeoX8gOH62bwBOiYt7x2UI
         J9U+20dPwPUxf7gE4dsI1ALJWCv9DfM4gBr7TiyBN2hdlW1k8kwWTgwJnMyoR1rx4e
         XjxMbfqfNgR8ZebwonbVKFuJG80OU7kmqVsPlRxtXbeEMysssKQouqK0eKTEPXbdwO
         /TqnPUAhSE1p4UYWUtD4ZWLeNfGSN7x95FS/uh0ZWh/1xgfE1TFzJx2MCyPOGTr9FK
         kLsODDcqCyIT6ZVCYFrZWe1BPVGhLLWYO1Wp5D9gtVkId6/58DSmozIGgRG9VS8zO0
         qRETpvyNjr9Fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 51/88] PCI: Add ACS quirk for Broadcom BCM57414 NIC
Date:   Mon, 28 Jun 2021 10:35:51 -0400
Message-Id: <20210628143628.33342-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
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
index de7d65971d7f..3602e967e96a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4684,6 +4684,8 @@ static const struct pci_dev_acs_enabled {
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

