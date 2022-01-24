Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5E2499759
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448544AbiAXVNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446546AbiAXVIr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:08:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD21C034610;
        Mon, 24 Jan 2022 12:08:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67EE8B8122D;
        Mon, 24 Jan 2022 20:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8132DC340E5;
        Mon, 24 Jan 2022 20:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054905;
        bh=XvKunCyUTqhoDJttVMh5EWZ4rnj0JNBQ0NSEL9yv4Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKPLzUt8ntv6MT1813HpeyS+g5VBvs4kOXYbCT44WC+idYaYU7TUO0gaoZdayCtSW
         C03133t6VKCqeWUwntlcNzlurd1uNcKOfYMnRj/N7umByxg8zLQpWP9lKlsS0yB+l8
         p7y540yd0RBoN98K7r7wYDwr5b7+cZVrrrcBLdB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 542/563] dmaengine: at_xdmac: Print debug message after realeasing the lock
Date:   Mon, 24 Jan 2022 19:45:07 +0100
Message-Id: <20220124184043.176567848@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
 


