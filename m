Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB5A3B62CA
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbhF1Ota (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:49:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235548AbhF1OpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:45:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 800E361C93;
        Mon, 28 Jun 2021 14:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890843;
        bh=9M84u6ZzyESkhUmLfSOS38pTRPECjwl61+6yUK/rcwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rz3p8o3hqGhq/NaXHmXfjPFyLi+B9vGJ/GoslHcIZXNKopjVGhx+pDSCVqkPWyVLc
         EnrpgPwacLfBfGPyThT4r7kCvpifg5JYzUJh0XclcM0TRhzB3l5rGhPff2ZHa+mV9E
         aTUWvydBa/V64/uBKH7xZVIb7x3ATEHEv6yaHFYJbYTKi3rB60jN/mlQNUyFL7df4q
         cUHs05Lm50NYpXSA2YgdbnbeuZSEKQCSiICzyE2f/C/Y5jKksIExrtH5/AMqKcHYNe
         HlS96lP/FqJvGAXzDf4RoW8UZQZLZlg9dp3wt8CMtQ9W6KEnWNDRAe943IZvW2pz5j
         qG9+VUzDIz02w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Antti=20J=C3=A4rvinen?= <antti.jarvinen@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 064/109] PCI: Mark TI C667X to avoid bus reset
Date:   Mon, 28 Jun 2021 10:32:20 -0400
Message-Id: <20210628143305.32978-65-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Antti Järvinen <antti.jarvinen@gmail.com>

commit b5cf198e74a91073d12839a3e2db99994a39995d upstream.

Some TI KeyStone C667X devices do not support bus/hot reset.  The PCIESS
automatically disables LTSSM when Secondary Bus Reset is received and
device stops working.  Prevent bus reset for these devices.  With this
change, the device can be assigned to VMs with VFIO, but it will leak state
between VMs.

Reference: https://e2e.ti.com/support/processors/f/791/t/954382
Link: https://lore.kernel.org/r/20210315102606.17153-1-antti.jarvinen@gmail.com
Signed-off-by: Antti Järvinen <antti.jarvinen@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kishon Vijay Abraham I <kishon@ti.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 70f05595da60..bc4858b056f9 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3483,6 +3483,16 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0034, quirk_no_bus_reset);
  */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_CAVIUM, 0xa100, quirk_no_bus_reset);
 
+/*
+ * Some TI KeyStone C667X devices do not support bus/hot reset.  The PCIESS
+ * automatically disables LTSSM when Secondary Bus Reset is received and
+ * the device stops working.  Prevent bus reset for these devices.  With
+ * this change, the device can be assigned to VMs with VFIO, but it will
+ * leak state between VMs.  Reference
+ * https://e2e.ti.com/support/processors/f/791/t/954382
+ */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TI, 0xb005, quirk_no_bus_reset);
+
 static void quirk_no_pm_reset(struct pci_dev *dev)
 {
 	/*
-- 
2.30.2

