Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380C83CDC89
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244526AbhGSOwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245430AbhGSOr1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:47:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA7A96113B;
        Mon, 19 Jul 2021 15:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708235;
        bh=pjhl/Ikbkwp9aJzO3QhyFGkx/kiFCiBdzsiwReEX5Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVNU9yUu8pIHK3NDzsbBcvN0ciAP71Vwl2CPH5vyb5n+rAxhma4C4foQeeEBEfB31
         Iw6+198GAhAU5m6a1DdQSAjqK1WEOuGytOdzXlAVMHP+MHs3vluKRgZuQya+q3Qgfl
         ACeKEthDVDDbD0cbwGTkToSRYD1mFXf5BRATfdrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Remi Pommarel <repk@triplefau.lt>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH 4.14 234/315] PCI: aardvark: Dont rely on jiffies while holding spinlock
Date:   Mon, 19 Jul 2021 16:52:03 +0200
Message-Id: <20210719144951.115590417@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/host/pci-aardvark.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

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
@@ -413,17 +414,16 @@ static void advk_pcie_check_pio_status(s
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


