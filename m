Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482042A5538
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388026AbgKCVGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:06:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388212AbgKCVGq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:06:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BBDD206B5;
        Tue,  3 Nov 2020 21:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437605;
        bh=DvEpMmqZWochAGWFLIfDIUJdSv6B7FqOuLt4kj04R5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdffgN+yWTq4+swyXJXT8rUz77JcXPZOQnNZxQKav3pRZo4VbPJ4F91IlTYuaIirS
         4RJ0Gdr/ZY2JDOV6fq896XEbYtu0xfrwZb0PMQynMQwVyut0cAl/Yk0WElQfeUaasf
         /UsSHF+luwKQEj+iiAPgTinvWoByi2q36RI0vDMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Artur Rojek <contact@artur-rojek.eu>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.19 148/191] dmaengine: dma-jz4780: Fix race in jz4780_dma_tx_status
Date:   Tue,  3 Nov 2020 21:37:20 +0100
Message-Id: <20201103203246.582987354@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
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
@@ -574,11 +574,11 @@ static enum dma_status jz4780_dma_tx_sta
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
@@ -595,6 +595,7 @@ static enum dma_status jz4780_dma_tx_sta
 	    && jzchan->desc->status & (JZ_DMA_DCS_AR | JZ_DMA_DCS_HLT))
 		status = DMA_ERROR;
 
+out_unlock_irqrestore:
 	spin_unlock_irqrestore(&jzchan->vchan.lock, flags);
 	return status;
 }


