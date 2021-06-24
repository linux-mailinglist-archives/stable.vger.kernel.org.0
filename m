Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D89C3B3482
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 19:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbhFXRQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 13:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230116AbhFXRQn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 13:16:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01497613DC;
        Thu, 24 Jun 2021 17:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624554863;
        bh=zVx5VItzPLj7HM2YlVcVsl4Odcp6W+sfx757TCcPVvo=;
        h=From:To:Cc:Subject:Date:From;
        b=lLVOyh83aDlfzLS35Lp6FTJ9GjwU890OLYt3ugyyuhqJKZOXsZ31j6RbKA/3YzPPZ
         otQb+zN1LEBQXnNX4zfKiMWvQIYNHSA2KOZsJ3c3cwEZ0tl50Won0eWl/BSJO2xga3
         rocixqHPfQU43C/00V3ia+q+lMXNUaqCR3eCvufViJFSJPSzPDlS5BUZNPBopBIODw
         G9M9o1hS26H5cHfgUbj5mTLGcqGDNa0VFGzLcDWqNd2hiBhqM1eUECmdB+Lh7vcvjF
         Nv5C/espaC6lGRAb/591DtiFwdoZhs9bKx7k12IcPayOrebldsQbdva8rtmawEEAw9
         2eLXEa6BHYQRg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     linux-pci@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>
Cc:     =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?R=C3=B6tti?= 
        <espressobinboardarmbiantempmailaddress@posteo.de>,
        Zachary Zhang <zhangzg@marvell.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] PCI: Call MPS fixup quirks early
Date:   Thu, 24 Jun 2021 19:14:17 +0200
Message-Id: <20210624171418.27194-1-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The pci_device_add() function calls header fixups only after
pci_configure_device(), which configures MPS.

So in order to have MPS fixups working, they need to be called early.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 27d868b5e6cfa ("PCI: Set MPS to match upstream bridge")
Cc: stable@vger.kernel.org
---
 drivers/pci/quirks.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 22b2bb1109c9..4d9b9d8fbc43 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3233,12 +3233,12 @@ static void fixup_mpss_256(struct pci_dev *dev)
 {
 	dev->pcie_mpss = 1; /* 256 bytes */
 }
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
-			 PCI_DEVICE_ID_SOLARFLARE_SFC4000A_0, fixup_mpss_256);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
-			 PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
-			 PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
+			PCI_DEVICE_ID_SOLARFLARE_SFC4000A_0, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
+			PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
+			PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
 
 /*
  * Intel 5000 and 5100 Memory controllers have an erratum with read completion
-- 
2.31.1

