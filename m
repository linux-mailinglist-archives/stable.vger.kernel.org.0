Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085C129B044
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756539AbgJ0ORj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S460358AbgJ0ORi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:17:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF5D0206F7;
        Tue, 27 Oct 2020 14:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808258;
        bh=m5PM8Aalp8ez1lWfySaxFWEGz5AJ2IA8HDibuZMhuOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w+9pnE+U57EBoP9v/7yMw9fJErYrwujxZ7ol6Cfl6CwseoPgzUhmaR+15dMDcsmSL
         d/RihusAVzYIkLJ5b4orbmH8pgRGLeGdnsXk9fYM5EAcaJVgHBC9qEmaSbpVk8qgru
         3lw27I4cYwb9WCtWxgx9+B1BgOAUfPNRl10ZOEVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 024/264] r8169: fix operation under forced interrupt threading
Date:   Tue, 27 Oct 2020 14:51:22 +0100
Message-Id: <20201027135431.790182685@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 424a646e072a887aa87283b53aa6f8b19c2a7bef ]

For several network drivers it was reported that using
__napi_schedule_irqoff() is unsafe with forced threading. One way to
fix this is switching back to __napi_schedule, but then we lose the
benefit of the irqoff version in general. As stated by Eric it doesn't
make sense to make the minimal hard irq handlers in drivers using NAPI
a thread. Therefore ensure that the hard irq handler is never
thread-ified.

Fixes: 9a899a35b0d6 ("r8169: switch to napi_schedule_irqoff")
Link: https://lkml.org/lkml/2020/10/18/19
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/4d3ef84a-c812-5072-918a-22a6f6468310@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -6830,7 +6830,7 @@ static int rtl8169_close(struct net_devi
 
 	phy_disconnect(dev->phydev);
 
-	pci_free_irq(pdev, 0, tp);
+	free_irq(pci_irq_vector(pdev, 0), tp);
 
 	dma_free_coherent(&pdev->dev, R8169_RX_RING_BYTES, tp->RxDescArray,
 			  tp->RxPhyAddr);
@@ -6885,8 +6885,8 @@ static int rtl_open(struct net_device *d
 
 	rtl_request_firmware(tp);
 
-	retval = pci_request_irq(pdev, 0, rtl8169_interrupt, NULL, tp,
-				 dev->name);
+	retval = request_irq(pci_irq_vector(pdev, 0), rtl8169_interrupt,
+			     IRQF_NO_THREAD | IRQF_SHARED, dev->name, tp);
 	if (retval < 0)
 		goto err_release_fw_2;
 
@@ -6919,7 +6919,7 @@ out:
 	return retval;
 
 err_free_irq:
-	pci_free_irq(pdev, 0, tp);
+	free_irq(pci_irq_vector(pdev, 0), tp);
 err_release_fw_2:
 	rtl_release_firmware(tp);
 	rtl8169_rx_clear(tp);


