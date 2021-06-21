Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842B83AEDC4
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhFUQWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231755AbhFUQVa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:21:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A1C5611BD;
        Mon, 21 Jun 2021 16:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292355;
        bh=JQkpRwZFiWxFst1GdK2RLm3NhPUDc4ke4Y00MEoBsQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddydscsvqCmh/c+EEQUgH1TJe6wHe2bnaZhO4tCZfXDkj5TU4Q7giRfMk1LFehP1e
         1nFK6YVSLj1ClhbCH0Fpcn1Fj1pqTjR1DQNcJ/Eye3jKpyWVZR6x+4iY02bWhmZ0nM
         IPIIXpOU0ygZI/MXbOnFcJvlTJnw3u90PT8nQ6io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Remi Pommarel <repk@triplefau.lt>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH 5.4 60/90] PCI: aardvark: Dont rely on jiffies while holding spinlock
Date:   Mon, 21 Jun 2021 18:15:35 +0200
Message-Id: <20210621154906.191785136@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
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
 drivers/pci/controller/pci-aardvark.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -175,7 +175,8 @@
 	(PCIE_CONF_BUS(bus) | PCIE_CONF_DEV(PCI_SLOT(devfn))	| \
 	 PCIE_CONF_FUNC(PCI_FUNC(devfn)) | PCIE_CONF_REG(where))
 
-#define PIO_TIMEOUT_MS			1
+#define PIO_RETRY_CNT			500
+#define PIO_RETRY_DELAY			2 /* 2 us*/
 
 #define LINK_WAIT_MAX_RETRIES		10
 #define LINK_WAIT_USLEEP_MIN		90000
@@ -392,17 +393,16 @@ static void advk_pcie_check_pio_status(s
 static int advk_pcie_wait_pio(struct advk_pcie *pcie)
 {
 	struct device *dev = &pcie->pdev->dev;
-	unsigned long timeout;
+	int i;
 
-	timeout = jiffies + msecs_to_jiffies(PIO_TIMEOUT_MS);
-
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


