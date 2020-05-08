Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0421CAB6A
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgEHMnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729065AbgEHMnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85B1824974;
        Fri,  8 May 2020 12:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941803;
        bh=210N5ZTiva9dE6x1lCnpWRSjhkjS0qSERVcrsrgETeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/d8MAn3QLcwCSc4Kx4UcA676zievPpl5lA/GHD9SnHrozE69y7OgzeBMZByEVyPm
         z9BjVaBtfOiglMhs1bfoGGnc80IsSBnXZDIpYK4vHy4zzCkFBX0ce9tjBzfQtGcf7d
         JfPI4xfp/RsECM0dCos/NP7tJUkdjb499NxEHF4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 177/312] ethernet: micrel: fix some error codes
Date:   Fri,  8 May 2020 14:32:48 +0200
Message-Id: <20200508123136.937183195@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 3af0d554c1ce11e9d0953381ff566271f9ab81a9 upstream.

There were two issues here:
1) dma_mapping_error() return true/false but we want to return -ENOMEM
2) If dmaengine_prep_slave_sg() failed then "err" wasn't set but
   presumably that should be -ENOMEM as well.

I changed the success path to "return 0;" instead of "return ret;" for
clarity.

Fixes: 94fe8c683cea ('ks8842: Support DMA when accessed via timberdale')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/micrel/ks8842.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -561,8 +561,8 @@ static int __ks8842_start_new_rx_dma(str
 		sg_init_table(sg, 1);
 		sg_dma_address(sg) = dma_map_single(adapter->dev,
 			ctl->skb->data, DMA_BUFFER_SIZE, DMA_FROM_DEVICE);
-		err = dma_mapping_error(adapter->dev, sg_dma_address(sg));
-		if (unlikely(err)) {
+		if (dma_mapping_error(adapter->dev, sg_dma_address(sg))) {
+			err = -ENOMEM;
 			sg_dma_address(sg) = 0;
 			goto out;
 		}
@@ -572,8 +572,10 @@ static int __ks8842_start_new_rx_dma(str
 		ctl->adesc = dmaengine_prep_slave_sg(ctl->chan,
 			sg, 1, DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT);
 
-		if (!ctl->adesc)
+		if (!ctl->adesc) {
+			err = -ENOMEM;
 			goto out;
+		}
 
 		ctl->adesc->callback_param = netdev;
 		ctl->adesc->callback = ks8842_dma_rx_cb;
@@ -584,7 +586,7 @@ static int __ks8842_start_new_rx_dma(str
 		goto out;
 	}
 
-	return err;
+	return 0;
 out:
 	if (sg_dma_address(sg))
 		dma_unmap_single(adapter->dev, sg_dma_address(sg),


