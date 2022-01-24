Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406114991B8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237596AbiAXUNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355385AbiAXUNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:13:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C3FC06127A;
        Mon, 24 Jan 2022 11:11:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D448B81235;
        Mon, 24 Jan 2022 19:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1917C340E5;
        Mon, 24 Jan 2022 19:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051476;
        bh=XvKunCyUTqhoDJttVMh5EWZ4rnj0JNBQ0NSEL9yv4Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2VV+QU2c/avSAMVpPclprtkbwBr9Q5HAgQJwDPZrXJ0CcjEhxn7gmlc2yMNa5AJF
         yrPa3sJm+3bkfN1ER0r3f16Jn4/Oy1w1c+WFIcAeGIdyX8ZsMH6Ye13SyibcJuVbdl
         iAceqWJdqlmqOHvwaQv4V1fA8EmSZwO1FLfqJOsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.14 173/186] dmaengine: at_xdmac: Print debug message after realeasing the lock
Date:   Mon, 24 Jan 2022 19:44:08 +0100
Message-Id: <20220124183942.674933103@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 5edc24ac876a928f36f407a0fcdb33b94a3a210f upstream.

It is desirable to do the prints without the lock held if possible, so
move the print after the lock is released.

Fixes: e1f7c9eee707 ("dmaengine: at_xdmac: creation of the atmel eXtended DMA Controller driver")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20211215110115.191749-4-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_xdmac.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -424,10 +424,12 @@ static dma_cookie_t at_xdmac_tx_submit(s
 	spin_lock_irqsave(&atchan->lock, irqflags);
 	cookie = dma_cookie_assign(tx);
 
-	dev_vdbg(chan2dev(tx->chan), "%s: atchan 0x%p, add desc 0x%p to xfers_list\n",
-		 __func__, atchan, desc);
 	list_add_tail(&desc->xfer_node, &atchan->xfers_list);
 	spin_unlock_irqrestore(&atchan->lock, irqflags);
+
+	dev_vdbg(chan2dev(tx->chan), "%s: atchan 0x%p, add desc 0x%p to xfers_list\n",
+		 __func__, atchan, desc);
+
 	return cookie;
 }
 


