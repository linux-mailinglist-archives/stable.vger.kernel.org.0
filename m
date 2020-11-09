Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791BC2AB906
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbgKINDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:03:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730565AbgKINCs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:02:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9E04221F1;
        Mon,  9 Nov 2020 13:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926968;
        bh=KWaRCCHd41F6UqxgvZjcc7BERVdpeQtdTzZKmogmbxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1YOkhjYvqgrIezFqqExhMj6JZzrE2Zo/vr0tSTfVaM8JpltTbTjK2Bu/z04onI4iW
         XISCgaXo3/fqHyFrowNpDzpd/zkm2TNl+cgAkg5GH2IrOsZv9x8G7u8Yp0+y5lfk2h
         Y/hvQrPi+c2bWbYX3DZOt5m4aXnLm96jBO0yVTxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Artur Rojek <contact@artur-rojek.eu>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.9 065/117] dmaengine: dma-jz4780: Fix race in jz4780_dma_tx_status
Date:   Mon,  9 Nov 2020 13:54:51 +0100
Message-Id: <20201109125028.752789672@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit baf6fd97b16ea8f981b8a8b04039596f32fc2972 upstream.

The jz4780_dma_tx_status() function would check if a channel's cookie
state was set to 'completed', and if not, it would enter the critical
section. However, in that time frame, the jz4780_dma_chan_irq() function
was able to set the cookie to 'completed', and clear the jzchan->vchan
pointer, which was deferenced in the critical section of the first
function.

Fix this race by checking the channel's cookie state after entering the
critical function and not before.

Fixes: d894fc6046fe ("dmaengine: jz4780: add driver for the Ingenic JZ4780 DMA controller")
Cc: stable@vger.kernel.org # v4.0
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reported-by: Artur Rojek <contact@artur-rojek.eu>
Tested-by: Artur Rojek <contact@artur-rojek.eu>
Link: https://lore.kernel.org/r/20201004140307.885556-1-paul@crapouillou.net
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/dma-jz4780.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/dma/dma-jz4780.c
+++ b/drivers/dma/dma-jz4780.c
@@ -567,11 +567,11 @@ static enum dma_status jz4780_dma_tx_sta
 	enum dma_status status;
 	unsigned long flags;
 
+	spin_lock_irqsave(&jzchan->vchan.lock, flags);
+
 	status = dma_cookie_status(chan, cookie, txstate);
 	if ((status == DMA_COMPLETE) || (txstate == NULL))
-		return status;
-
-	spin_lock_irqsave(&jzchan->vchan.lock, flags);
+		goto out_unlock_irqrestore;
 
 	vdesc = vchan_find_desc(&jzchan->vchan, cookie);
 	if (vdesc) {
@@ -588,6 +588,7 @@ static enum dma_status jz4780_dma_tx_sta
 	    && jzchan->desc->status & (JZ_DMA_DCS_AR | JZ_DMA_DCS_HLT))
 		status = DMA_ERROR;
 
+out_unlock_irqrestore:
 	spin_unlock_irqrestore(&jzchan->vchan.lock, flags);
 	return status;
 }


