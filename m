Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE8E2C0B9D
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389022AbgKWN2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:28:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:42786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730879AbgKWMbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:31:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B368820728;
        Mon, 23 Nov 2020 12:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134696;
        bh=uiEihmVFQpWakOa2ZSw0/yLXIDE4p6agPGKsGcONUbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5RohR0xWMX6+/ieBxHvLuSKIBGkyuSTEftv6fjxwCAEzKIhJcKI13XG6gtcMRkJJ
         JGJw0MPO+7CoMNTQDf6vwk7hYS0u5mYOEebulCAUp/MhodsX1D8Oacf3NC9wQnbpj3
         ACimrIhitYX6WUhwJ3wCJwqHeDd356ASZVEbw628=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Loris Fauster <loris.fauster@ttcontrol.com>,
        Alejandro Concepcion Rodriguez <alejandro@acoro.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 50/91] can: dev: can_restart(): post buffer from the right context
Date:   Mon, 23 Nov 2020 13:22:10 +0100
Message-Id: <20201123121811.753440341@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alejandro Concepcion Rodriguez <alejandro@acoro.eu>

[ Upstream commit a1e654070a60d5d4f7cce59c38f4ca790bb79121 ]

netif_rx() is meant to be called from interrupt contexts. can_restart() may be
called by can_restart_work(), which is called from a worqueue, so it may run in
process context. Use netif_rx_ni() instead.

Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
Co-developed-by: Loris Fauster <loris.fauster@ttcontrol.com>
Signed-off-by: Loris Fauster <loris.fauster@ttcontrol.com>
Signed-off-by: Alejandro Concepcion Rodriguez <alejandro@acoro.eu>
Link: https://lore.kernel.org/r/4e84162b-fb31-3a73-fa9a-9438b4bd5234@acoro.eu
[mkl: use netif_rx_ni() instead of netif_rx_any_context()]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 1950b13f22dfc..f88590074569e 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -579,7 +579,7 @@ static void can_restart(struct net_device *dev)
 	}
 	cf->can_id |= CAN_ERR_RESTARTED;
 
-	netif_rx(skb);
+	netif_rx_ni(skb);
 
 	stats->rx_packets++;
 	stats->rx_bytes += cf->can_dlc;
-- 
2.27.0



