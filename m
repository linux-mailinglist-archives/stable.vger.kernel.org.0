Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A8F3B6452
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbhF1PGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237169AbhF1PFV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:05:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6D3A61CFB;
        Mon, 28 Jun 2021 14:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891406;
        bh=t5jNJkaysKyIxKdaij9r6OjECbdg/3DgdVbquUKZwIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5jj/QSM2lMtVvwf37cV9Ti2rch9qHB1H/rwM8XkLYwI+UBOkIIfYY5vCxS5ClO/r
         nzGYc7dEBY/TMNRUnW4ubH9+aLecutPTGeZVbKWZOtJYoJOru4fvg45L+avzhcufa3
         hV7odDij+9ubtLswANKU8g/YpDXCsGT3PX6H/pFcWUCyZ97QqC9kUZOMIZdKkrsymT
         G6++XUmSkZHPfrckOUGU6gg5lLG0TqzexU5Rts3vjT3joe0J+ymjKvmDqsGilwBOjN
         rBr0MthmwtuH3kkbB1ShU0XLVvhhiOBE93hwaMQ9PWgpxMNUUwSPGY/IXSjWTEMMbh
         ylHKKG9FSMnsw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Antti=20J=C3=A4rvinen?= <antti.jarvinen@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 33/57] PCI: Mark TI C667X to avoid bus reset
Date:   Mon, 28 Jun 2021 10:42:32 -0400
Message-Id: <20210628144256.34524-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
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
index bc0aa0849e72..d6199776c0f6 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3157,6 +3157,16 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003c, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0033, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0034, quirk_no_bus_reset);
 
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

