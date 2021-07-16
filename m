Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626723CB753
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 14:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238543AbhGPMX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 08:23:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234938AbhGPMX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 08:23:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7544613E9
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 12:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626438061;
        bh=9REmw2j7Qw4xoKyWh6OnZoRV3Aauyk+ssIF4QH2UbIk=;
        h=From:To:Subject:Date:From;
        b=gqbBi6bZro4OUAo2GBkdakMEobpt27h19IXHMf/HNCY8nwHaUmG1hyHhisWnYJRJN
         9jrbQ9sLANJmPi1cC5y4yxRZGOP2ebkE+soHhuBxp1GJrMF1BkyJLFVMkxGvnZYTbH
         dXiy1Pdq3BMo88Ln/jV3sPWsSIZM7IZt2E9ey8x+jrd3OeS/DYpXDOoAN/MJ+GFFxs
         vOVujFGM/QZq2esnC+1hsK2nIE/k/IZfIfqfsSd+uHkxP5pt9+MGYYPBpIPILXYUke
         RKSxOwvTz9Wh52ZNnH75d1m7e/ar5eYo+2nilqEA6yodUJWDZbm1iteG0Jev/Ttrp0
         XjBf8o0wOHEBQ==
Received: by pali.im (Postfix)
        id 53D3D735; Fri, 16 Jul 2021 14:20:59 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     stable@vger.kernel.org
Subject: [PATCH stable-4.14] PCI: aardvark: Don't rely on jiffies while holding spinlock
Date:   Fri, 16 Jul 2021 14:20:33 +0200
Message-Id: <20210716122033.22568-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Remi Pommarel <repk@triplefau.lt>

commit 7fbcb5da811be7d47468417c7795405058abb3da upstream.

advk_pcie_wait_pio() can be called while holding a spinlock (from
pci_bus_read_config_dword()), then depends on jiffies in order to
timeout while polling on PIO state registers. In the case the PIO
transaction failed, the timeout will never happen and will also cause
the cpu to stall.

This decrements a variable and wait instead of using jiffies.

Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
---
This is backport to 4.14 kernel. Backport of upstream commit can be done
automatically by git cherry-pick command if merge.renamelimit variable is
set to at least 12711.
---
 drivers/pci/host/pci-aardvark.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index c1db09fbbe04..5dbbf3d7de36 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -185,7 +185,8 @@
 	(PCIE_CONF_BUS(bus) | PCIE_CONF_DEV(PCI_SLOT(devfn))	| \
 	 PCIE_CONF_FUNC(PCI_FUNC(devfn)) | PCIE_CONF_REG(where))
 
-#define PIO_TIMEOUT_MS			1
+#define PIO_RETRY_CNT			500
+#define PIO_RETRY_DELAY			2 /* 2 us*/
 
 #define LINK_WAIT_MAX_RETRIES		10
 #define LINK_WAIT_USLEEP_MIN		90000
@@ -413,17 +414,16 @@ static void advk_pcie_check_pio_status(struct advk_pcie *pcie)
 static int advk_pcie_wait_pio(struct advk_pcie *pcie)
 {
 	struct device *dev = &pcie->pdev->dev;
-	unsigned long timeout;
-
-	timeout = jiffies + msecs_to_jiffies(PIO_TIMEOUT_MS);
+	int i;
 
-	while (time_before(jiffies, timeout)) {
+	for (i = 0; i < PIO_RETRY_CNT; i++) {
 		u32 start, isr;
 
 		start = advk_readl(pcie, PIO_START);
 		isr = advk_readl(pcie, PIO_ISR);
 		if (!start && isr)
 			return 0;
+		udelay(PIO_RETRY_DELAY);
 	}
 
 	dev_err(dev, "config read/write timed out\n");
-- 
2.20.1

