Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB714723F9
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhLMJdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbhLMJdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:33:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB65C06173F;
        Mon, 13 Dec 2021 01:33:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22529B80E26;
        Mon, 13 Dec 2021 09:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA6EC341C5;
        Mon, 13 Dec 2021 09:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639387977;
        bh=+BqtltrckDBCrIwhgxZdJy60JLi4NeUnum0BgYQnNfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1oKKdHZkMcPpq0IHRdLTysAl4dAi833xAM/ohlYoRFN8s2FY9jEak6i3enCCK6tK8
         OhM5oGqKo0w37qe7w1xowVKzTHwmqYf1a1GJgnx4nHK8IwpPVMmUwGJsXGP5w00mAG
         YdrfsW73wZ6Sfix+lFEKDiL5NTECRMfe4d9Wf/o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 24/37] net: altera: set a couple error code in probe()
Date:   Mon, 13 Dec 2021 10:30:02 +0100
Message-Id: <20211213092926.158782570@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092925.380184671@linuxfoundation.org>
References: <20211213092925.380184671@linuxfoundation.org>
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
@@ -1383,16 +1383,19 @@ static int altera_tse_probe(struct platf
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


