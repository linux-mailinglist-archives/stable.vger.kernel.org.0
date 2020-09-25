Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B762788B2
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgIYMu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:50:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729129AbgIYMuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:50:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CF4021741;
        Fri, 25 Sep 2020 12:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038255;
        bh=a+LE7N1y/cw6pO1GRiDcCRrheFURuNGYvQyKOMjF/UA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YiDe1CUNwCDKD4qzaPbVgztlDQSHZzSW0OiwGotfJGVPloNiwQnUZ3OmpINl12XZb
         6sS1xZEsfLvyDbc1zbRKsvEHhWUJuOA2hPI7qyKPvfVpWOGPeBVqQMUR86eef+Yohl
         b+tFVPwW82o35rCo+PSzr3c9rntdBH4oFFriStTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 38/56] net: lantiq: Disable IRQs only if NAPI gets scheduled
Date:   Fri, 25 Sep 2020 14:48:28 +0200
Message-Id: <20200925124733.582195949@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>

[ Upstream commit 9423361da52356cb68642db5b2729b6b85aad330 ]

The napi_schedule() call will only schedule the NAPI if it is not
already running. To make sure that we do not deactivate interrupts
without scheduling NAPI only deactivate the interrupts in case NAPI also
gets scheduled.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/lantiq_xrx200.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -345,10 +345,12 @@ static irqreturn_t xrx200_dma_irq(int ir
 {
 	struct xrx200_chan *ch = ptr;
 
-	ltq_dma_disable_irq(&ch->dma);
-	ltq_dma_ack_irq(&ch->dma);
+	if (napi_schedule_prep(&ch->napi)) {
+		__napi_schedule(&ch->napi);
+		ltq_dma_disable_irq(&ch->dma);
+	}
 
-	napi_schedule(&ch->napi);
+	ltq_dma_ack_irq(&ch->dma);
 
 	return IRQ_HANDLED;
 }


