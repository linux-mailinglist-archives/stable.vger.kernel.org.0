Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86EA1450CB7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238565AbhKORmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:42:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:57854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237825AbhKORjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:39:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3666463285;
        Mon, 15 Nov 2021 17:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997181;
        bh=oq8B8RU2KZfdcyYDLgByDdyyH2lPssh52YnhsLixR2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hbv5vCxYjxHaNf2L3TeQ9o4bsV0fzGwVU7cLkcbug6WwdsOiacCYZ+G82OAP8ECRN
         mDZFd/Fbnx3yVibXA2hbEOCtbFK/9eiATW5yLIc/obNT24LYwLrfiqzfltTX38N39Q
         mD/iDyQBRdoeH7GqZKQkuIyvMpUFNeLSh4Y0jojE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/575] mISDN: Fix return values of the probe function
Date:   Mon, 15 Nov 2021 17:56:20 +0100
Message-Id: <20211115165345.538900104@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit e211210098cb7490db2183d725f5c0f10463a704 ]

During the process of driver probing, the probe function should return < 0
for failure, otherwise, the kernel will treat value > 0 as success.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index e501cb03f211d..bd087cca1c1d2 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -1994,14 +1994,14 @@ setup_hw(struct hfc_pci *hc)
 	pci_set_master(hc->pdev);
 	if (!hc->irq) {
 		printk(KERN_WARNING "HFC-PCI: No IRQ for PCI card found\n");
-		return 1;
+		return -EINVAL;
 	}
 	hc->hw.pci_io =
 		(char __iomem *)(unsigned long)hc->pdev->resource[1].start;
 
 	if (!hc->hw.pci_io) {
 		printk(KERN_WARNING "HFC-PCI: No IO-Mem for PCI card found\n");
-		return 1;
+		return -ENOMEM;
 	}
 	/* Allocate memory for FIFOS */
 	/* the memory needs to be on a 32k boundary within the first 4G */
@@ -2012,7 +2012,7 @@ setup_hw(struct hfc_pci *hc)
 	if (!buffer) {
 		printk(KERN_WARNING
 		       "HFC-PCI: Error allocating memory for FIFO!\n");
-		return 1;
+		return -ENOMEM;
 	}
 	hc->hw.fifos = buffer;
 	pci_write_config_dword(hc->pdev, 0x80, hc->hw.dmahandle);
@@ -2022,7 +2022,7 @@ setup_hw(struct hfc_pci *hc)
 		       "HFC-PCI: Error in ioremap for PCI!\n");
 		dma_free_coherent(&hc->pdev->dev, 0x8000, hc->hw.fifos,
 				  hc->hw.dmahandle);
-		return 1;
+		return -ENOMEM;
 	}
 
 	printk(KERN_INFO
-- 
2.33.0



