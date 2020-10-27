Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D866729B3AB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752388AbgJ0OyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1773079AbgJ0OvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:51:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24E6E207DE;
        Tue, 27 Oct 2020 14:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810267;
        bh=IbrBttr252SB39PQbupv/VG2aRjO9sVcimOpjFXrj5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxSZ3BMUI9oQBZm2Jv4ow2OLvKyNIZGgNClS4gtuSR7uJF4f67KJBgoySkcdUAtzq
         KohTwZEYDkKW+iBmLkWDMrdV/VVDwsI6TPHM0o732H9HPOmQWcd/8YWGYBYohaP6V4
         /IrXDWib5Svm/gqyyUKSj1Mh+bxctd6TOSM5LRu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 049/633] r8169: fix operation under forced interrupt threading
Date:   Tue, 27 Oct 2020 14:46:32 +0100
Message-Id: <20201027135524.996920454@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
 drivers/net/ethernet/realtek/r8169_main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4675,7 +4675,7 @@ static int rtl8169_close(struct net_devi
 
 	phy_disconnect(tp->phydev);
 
-	pci_free_irq(pdev, 0, tp);
+	free_irq(pci_irq_vector(pdev, 0), tp);
 
 	dma_free_coherent(&pdev->dev, R8169_RX_RING_BYTES, tp->RxDescArray,
 			  tp->RxPhyAddr);
@@ -4726,8 +4726,8 @@ static int rtl_open(struct net_device *d
 
 	rtl_request_firmware(tp);
 
-	retval = pci_request_irq(pdev, 0, rtl8169_interrupt, NULL, tp,
-				 dev->name);
+	retval = request_irq(pci_irq_vector(pdev, 0), rtl8169_interrupt,
+			     IRQF_NO_THREAD | IRQF_SHARED, dev->name, tp);
 	if (retval < 0)
 		goto err_release_fw_2;
 
@@ -4759,7 +4759,7 @@ out:
 	return retval;
 
 err_free_irq:
-	pci_free_irq(pdev, 0, tp);
+	free_irq(pci_irq_vector(pdev, 0), tp);
 err_release_fw_2:
 	rtl_release_firmware(tp);
 	rtl8169_rx_clear(tp);


