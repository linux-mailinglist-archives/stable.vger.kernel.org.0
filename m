Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68984727CD
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbhLMKFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:05:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47430 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235820AbhLMKB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:01:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47166B80E7E;
        Mon, 13 Dec 2021 10:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C34AC34604;
        Mon, 13 Dec 2021 10:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389685;
        bh=+vPKmXZOpbaI6eDKbLOaBp7RHLbNQ+ECGVLPet+BzDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVo/5Uc/Udg8hDX5nUFDXFcmPoZZZhFIFY45w6WF4oTr+nTUneYYNuwKzhtMlr3FK
         rDwMz72Rjhu58fsNFJCclDkkwOH6WMYek5mOYtezIQVpdCLC5Vu1+4IYnC73r3kSGE
         BT0Qwgho/coonmJMV6dpkqCTCruVorjpo4B1xLKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 131/171] net: altera: set a couple error code in probe()
Date:   Mon, 13 Dec 2021 10:30:46 +0100
Message-Id: <20211213092949.452648228@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit badd7857f5c933a3dc34942a2c11d67fdbdc24de upstream.

There are two error paths which accidentally return success instead of
a negative error code.

Fixes: bbd2190ce96d ("Altera TSE: Add main and header file for Altera Ethernet Driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/altera/altera_tse_main.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1430,16 +1430,19 @@ static int altera_tse_probe(struct platf
 		priv->rxdescmem_busaddr = dma_res->start;
 
 	} else {
+		ret = -ENODEV;
 		goto err_free_netdev;
 	}
 
-	if (!dma_set_mask(priv->device, DMA_BIT_MASK(priv->dmaops->dmamask)))
+	if (!dma_set_mask(priv->device, DMA_BIT_MASK(priv->dmaops->dmamask))) {
 		dma_set_coherent_mask(priv->device,
 				      DMA_BIT_MASK(priv->dmaops->dmamask));
-	else if (!dma_set_mask(priv->device, DMA_BIT_MASK(32)))
+	} else if (!dma_set_mask(priv->device, DMA_BIT_MASK(32))) {
 		dma_set_coherent_mask(priv->device, DMA_BIT_MASK(32));
-	else
+	} else {
+		ret = -EIO;
 		goto err_free_netdev;
+	}
 
 	/* MAC address space */
 	ret = request_and_map(pdev, "control_port", &control_port,


