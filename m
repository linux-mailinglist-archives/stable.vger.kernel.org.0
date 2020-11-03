Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0A42A532D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731744AbgKCU6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:58:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:32992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732967AbgKCU6a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:58:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 003FA2053B;
        Tue,  3 Nov 2020 20:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437109;
        bh=Hd4XbZiTS7NDDUJEkgjX4l37jNWVlR3STL53BlmaYcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0fHlcNDrJ76QBHv+iNDG7+vxda8Ggc2ziFRIW4XYS1t2hTLmaPsr0ku16OdjXf41
         acXw1wzdXkwKS8OQB3IIlVVsfiyuS9Uw8pn7O14SEsWRd1R8XeW4yprTVqQa3ZBToG
         oiGFp2NE/sHJxTddqNZ7KfUJLaXiJmRoF4ySFaPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Artur Rojek <contact@artur-rojek.eu>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 149/214] dmaengine: dma-jz4780: Fix race in jz4780_dma_tx_status
Date:   Tue,  3 Nov 2020 21:36:37 +0100
Message-Id: <20201103203304.757947181@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
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
@@ -639,11 +639,11 @@ static enum dma_status jz4780_dma_tx_sta
 	unsigned long flags;
 	unsigned long residue = 0;
 
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
@@ -660,6 +660,7 @@ static enum dma_status jz4780_dma_tx_sta
 	    && jzchan->desc->status & (JZ_DMA_DCS_AR | JZ_DMA_DCS_HLT))
 		status = DMA_ERROR;
 
+out_unlock_irqrestore:
 	spin_unlock_irqrestore(&jzchan->vchan.lock, flags);
 	return status;
 }


