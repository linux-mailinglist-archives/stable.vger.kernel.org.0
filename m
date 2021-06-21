Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469943AEE33
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhFUQ03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231282AbhFUQZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:25:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F20F76115B;
        Mon, 21 Jun 2021 16:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292494;
        bh=g8o9G1H9mtePYpd3bUS+euMGlKq8E0lRSKm51nh4af8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q77FFhM8Fkh6vYj+jzctA9ka7BPLK944K9rWd+fhC9ZVKeiFDN33q/+Pt3gMDU4u+
         58ZVgKhQanQxzOjYUvtV6Pq8vjEQwC2tiFJWbrvT/CTUU4Fu/4GyyaGIBVUT+Imjkg
         juuTbbQ+ruEqwPYaGl7QUOOqgEbnPS2hRzx9bU0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksander Jan Bajkowski <olek2@wp.pl>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/146] net: lantiq: disable interrupt before sheduling NAPI
Date:   Mon, 21 Jun 2021 18:14:11 +0200
Message-Id: <20210621154911.990517211@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit f2386cf7c5f4ff5d7b584f5d92014edd7df6c676 ]

This patch fixes TX hangs with threaded NAPI enabled. The scheduled
NAPI seems to be executed in parallel with the interrupt on second
thread. Sometimes it happens that ltq_dma_disable_irq() is executed
after xrx200_tx_housekeeping(). The symptom is that TX interrupts
are disabled in the DMA controller. As a result, the TX hangs after
a few seconds of the iperf test. Scheduling NAPI after disabling
interrupts fixes this issue.

Tested on Lantiq xRX200 (BT Home Hub 5A).

Fixes: 9423361da523 ("net: lantiq: Disable IRQs only if NAPI gets scheduled ")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_xrx200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 135ba5b6ae98..3da494df72f3 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -352,8 +352,8 @@ static irqreturn_t xrx200_dma_irq(int irq, void *ptr)
 	struct xrx200_chan *ch = ptr;
 
 	if (napi_schedule_prep(&ch->napi)) {
-		__napi_schedule(&ch->napi);
 		ltq_dma_disable_irq(&ch->dma);
+		__napi_schedule(&ch->napi);
 	}
 
 	ltq_dma_ack_irq(&ch->dma);
-- 
2.30.2



