Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244A729B183
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896827AbgJ0Oa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:30:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902103AbgJ0O3x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:29:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F044820780;
        Tue, 27 Oct 2020 14:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808993;
        bh=ODdMXT6rEqYE41sd1IuwIbG6hQnUrMyDYBUkElowpf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2cEQfwXdTkRBbhWI3rpCJi2cjhNh5uvO3+sidN2O1X+VDOfRM3wbKDSaS/yi7yoAK
         tWLLehCaBNTvHP93MvM3j6ShRSs8Ry1/7J7bForTNqL+X06PWCg/4HnGt/XHtg1a4j
         ourjOQ7Wxd3aJ8020wQ9r+3rZqLEwdWkijQAeVEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 036/408] r8169: fix operation under forced interrupt threading
Date:   Tue, 27 Oct 2020 14:49:34 +0100
Message-Id: <20201027135456.754963604@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
@@ -6418,7 +6418,7 @@ static int rtl8169_close(struct net_devi
 
 	phy_disconnect(tp->phydev);
 
-	pci_free_irq(pdev, 0, tp);
+	free_irq(pci_irq_vector(pdev, 0), tp);
 
 	dma_free_coherent(&pdev->dev, R8169_RX_RING_BYTES, tp->RxDescArray,
 			  tp->RxPhyAddr);
@@ -6469,8 +6469,8 @@ static int rtl_open(struct net_device *d
 
 	rtl_request_firmware(tp);
 
-	retval = pci_request_irq(pdev, 0, rtl8169_interrupt, NULL, tp,
-				 dev->name);
+	retval = request_irq(pci_irq_vector(pdev, 0), rtl8169_interrupt,
+			     IRQF_NO_THREAD | IRQF_SHARED, dev->name, tp);
 	if (retval < 0)
 		goto err_release_fw_2;
 
@@ -6503,7 +6503,7 @@ out:
 	return retval;
 
 err_free_irq:
-	pci_free_irq(pdev, 0, tp);
+	free_irq(pci_irq_vector(pdev, 0), tp);
 err_release_fw_2:
 	rtl_release_firmware(tp);
 	rtl8169_rx_clear(tp);


