Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB768278826
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgIYMxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbgIYMxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:53:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 043F02075E;
        Fri, 25 Sep 2020 12:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038392;
        bh=10+rjzhobR+RtnyIJynio14kN4zwS2zsAfOlSiIypwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSqmFMqeuDjZ7CJsINnkYfmOieLWCl6P1n8+4BhlLGQCzhqURvDegFndgw+7P4XfN
         U35pktrDem3RZTFkRZy8oJhECWv2iOmfdHF0HMnEM+zhaZabt4lJraFtUhi20WdTy2
         ELg/tY6BK85yhA0EO/KfeHyYf8o7MJ/9AiqqXEjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 37/43] net: lantiq: Disable IRQs only if NAPI gets scheduled
Date:   Fri, 25 Sep 2020 14:48:49 +0200
Message-Id: <20200925124729.158570970@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
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
@@ -344,10 +344,12 @@ static irqreturn_t xrx200_dma_irq(int ir
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


