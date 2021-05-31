Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB85395F53
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhEaOKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232726AbhEaOIB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:08:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A39F361455;
        Mon, 31 May 2021 13:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468378;
        bh=0rEjWKAlmJ30eRK65Wdy8KGlQ9zvTgZ9ZHF61gnUEJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xi4nFtiNe5opFVM2hF0OmEiCT7T0m8HCYdD0Qa1H4BnnfBkgg0jmov7EnnNDLfNVW
         NXAyCyaMmr3ZNjeiEHmhLVDHDWsVsLx0tiDbSdaMfwRMsyfDdVBHHWeJHkXaCYj0D6
         GR4kj5Y+JJv8kcUxF0Xuq0PcOr6ntxKF/QUVTH54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Willem de Brujin <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/252] gve: Upgrade memory barrier in poll routine
Date:   Mon, 31 May 2021 15:14:44 +0200
Message-Id: <20210531130705.448694163@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
index 839102ea6aa1..d6e35421d8f7 100644
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



