Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2ABF20D3D6
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 21:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbgF2TCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730349AbgF2TAU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:00:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 878C02553E;
        Mon, 29 Jun 2020 15:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446105;
        bh=SNWP29qCVCL6BzwKYZRbzz78rukpj11bEpKdu3tOFXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/H+FFZPzE/qbhOJscPe3N7xf2/Cci6Br9IMgkLO1jiYKioWh3gqLv9dfqmCW6UJY
         sONf/x38x+LmepcXfbz25qb2JIqAsVB6wRO5CKhD/uxx5dX1c1U3Dbg85AkoGZrGf2
         uVXT0ikSAtvez+eP9AvXSabZjACuYadI3QuQyJqg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongdong Liu <liudongdong3@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Gabriele Paoloni <gabriele.paoloni@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 097/135] PCI: Disable MSI for HiSilicon Hip06/Hip07 Root Ports
Date:   Mon, 29 Jun 2020 11:52:31 -0400
Message-Id: <20200629155309.2495516-98-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongdong Liu <liudongdong3@huawei.com>

commit 72f2ff0deb870145a5a2d24cd75b4f9936159a62 upstream.

The PCIe Root Port in Hip06/Hip07 SoCs advertises an MSI capability, but it
cannot generate MSIs.  It can transfer MSI/MSI-X from downstream devices,
but does not support MSI/MSI-X itself.

Add a quirk to prevent use of MSI/MSI-X by the Root Port.

[bhelgaas: changelog, sort vendor ID #define, drop device ID #define]
Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Gabriele Paoloni <gabriele.paoloni@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c    | 1 +
 include/linux/pci_ids.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 83ad32b07cc39..eeb771ecda15b 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1623,6 +1623,7 @@ static void quirk_pcie_mch(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_E7520_MCH,	quirk_pcie_mch);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_E7320_MCH,	quirk_pcie_mch);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_E7525_MCH,	quirk_pcie_mch);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_HUAWEI,	0x1610,	quirk_pcie_mch);
 
 
 /*
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 1af616138d1dc..5547f1a0f83b2 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2496,6 +2496,8 @@
 #define PCI_DEVICE_ID_KORENIX_JETCARDF2	0x1700
 #define PCI_DEVICE_ID_KORENIX_JETCARDF3	0x17ff
 
+#define PCI_VENDOR_ID_HUAWEI         	0x19e5
+
 #define PCI_VENDOR_ID_NETRONOME		0x19ee
 #define PCI_DEVICE_ID_NETRONOME_NFP3200	0x3200
 #define PCI_DEVICE_ID_NETRONOME_NFP3240	0x3240
-- 
2.25.1

