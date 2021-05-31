Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286633962D8
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhEaPB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234367AbhEaO7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:59:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2CA361CCE;
        Mon, 31 May 2021 14:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469678;
        bh=2/vnSKFmBiPWtK2QwcFs5JOW2fCY6BqT0zNO9pZ7rfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+XySutns5ca3/SK0Mp3TD07jH9Umt+DRbJBuk+xI3Ekk/Y2OyYI1vyA9hwL2IEpL
         IOkyxGLfEwvF51c21xWyLjIUHSuH4ewpIJyOcSKqMF54czbgWf6wKFNB9mHGipvDWA
         27RRlOL8TjQFith5zKWy4+e2LywG/fj8geFAxfpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Willem de Brujin <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 254/296] gve: Upgrade memory barrier in poll routine
Date:   Mon, 31 May 2021 15:15:09 +0200
Message-Id: <20210531130712.295650193@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

[ Upstream commit f81781835f0adfae8d701545386030d223efcd6f ]

As currently written, if the driver checks for more work (via
gve_tx_poll or gve_rx_poll) before the device posts work and the
irq doorbell is not unmasked
(via iowrite32be(GVE_IRQ_ACK | GVE_IRQ_EVENT, ...)) before the device
attempts to raise an interrupt, an interrupt is lost and this could
potentially lead to the traffic being completely halted. For
example, if a tx queue has already been stopped, the driver won't get
the chance to complete work and egress will be halted.

We need a full memory barrier in the poll
routine to ensure that the irq doorbell is unmasked before the driver
checks for more work.

Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
Acked-by: Willem de Brujin <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 21a5d058dab4..bbc423e93122 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -180,7 +180,7 @@ static int gve_napi_poll(struct napi_struct *napi, int budget)
 	/* Double check we have no extra work.
 	 * Ensure unmask synchronizes with checking for work.
 	 */
-	dma_rmb();
+	mb();
 	if (block->tx)
 		reschedule |= gve_tx_poll(block, -1);
 	if (block->rx)
-- 
2.30.2



