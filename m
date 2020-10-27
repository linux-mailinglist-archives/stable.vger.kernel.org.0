Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB15829B1C0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760185AbgJ0Odx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902476AbgJ0Odv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:33:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DD7E22202;
        Tue, 27 Oct 2020 14:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809231;
        bh=fCojRKFKbzKAGabAXLBdhs372pAVOGnVrVLOB7DtDWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhQ2ler/UGChg3mNnskHIoaMSMgyCDCcd4RQ0HQmy+ES495Qvwj2ual57hvlBoYqc
         OtWTwdGPbHJOBqIMriIoIQ9s80WsrFjDKxhgyQz5oX2l//sBlGVp8c5lTD7OL+WcVP
         JAZMT2ir9kY5z7GDCflUZLm2qG1v6Y5wRMuv8jVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Dewar <alex.dewar90@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/408] staging: emxx_udc: Fix passing of NULL to dma_alloc_coherent()
Date:   Tue, 27 Oct 2020 14:51:01 +0100
Message-Id: <20201027135500.818908013@linuxfoundation.org>
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

From: Alex Dewar <alex.dewar90@gmail.com>

[ Upstream commit cc34073c6248e9cec801bf690d1455f264d12357 ]

In nbu2ss_eq_queue() memory is allocated with dma_alloc_coherent(),
though, strangely, NULL is passed as the struct device* argument. Pass
the UDC's device instead. Fix up the corresponding call to
dma_free_coherent() in the same way.

Build-tested on x86 only.

Fixes: 33aa8d45a4fe ("staging: emxx_udc: Add Emma Mobile USB Gadget driver")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
Link: https://lore.kernel.org/r/20200825091928.55794-1-alex.dewar90@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/emxx_udc/emxx_udc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/emxx_udc/emxx_udc.c b/drivers/staging/emxx_udc/emxx_udc.c
index 147481bf680c3..a6c893ddbf280 100644
--- a/drivers/staging/emxx_udc/emxx_udc.c
+++ b/drivers/staging/emxx_udc/emxx_udc.c
@@ -2594,7 +2594,7 @@ static int nbu2ss_ep_queue(struct usb_ep *_ep,
 
 	if (req->unaligned) {
 		if (!ep->virt_buf)
-			ep->virt_buf = dma_alloc_coherent(NULL, PAGE_SIZE,
+			ep->virt_buf = dma_alloc_coherent(udc->dev, PAGE_SIZE,
 							  &ep->phys_buf,
 							  GFP_ATOMIC | GFP_DMA);
 		if (ep->epnum > 0)  {
@@ -3153,7 +3153,7 @@ static int nbu2ss_drv_remove(struct platform_device *pdev)
 	for (i = 0; i < NUM_ENDPOINTS; i++) {
 		ep = &udc->ep[i];
 		if (ep->virt_buf)
-			dma_free_coherent(NULL, PAGE_SIZE, (void *)ep->virt_buf,
+			dma_free_coherent(udc->dev, PAGE_SIZE, (void *)ep->virt_buf,
 					  ep->phys_buf);
 	}
 
-- 
2.25.1



