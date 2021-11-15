Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3364A4514A7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349380AbhKOUMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:12:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344903AbhKOTZl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C399636E1;
        Mon, 15 Nov 2021 19:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003191;
        bh=hIItPzpPOxlzT1mxOSXXFrbBaapcpnlpkKMStKkLOA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xuL0VEheJQgRE6XYkMTDmeXlgi5uTV5tiiEc+FtosjR3sTCoyH7+/YVm0CzCeQNV4
         nvox7Htxqi6rVacRtXeOMZx+GwbyToDZL+y8P1FsHLPto5eR47SowICF1qxFZLss8T
         YPv1ZucpB5aQ+awOF3aHMoeu55WtcCGcb+NM8T9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 811/917] can: etas_es58x: es58x_rx_err_msg(): fix memory leak in error path
Date:   Mon, 15 Nov 2021 18:05:06 +0100
Message-Id: <20211115165456.510851871@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit d9447f768bc8c60623e4bb3ce65b8f4654d33a50 ]

In es58x_rx_err_msg(), if can->do_set_mode() fails, the function
directly returns without calling netif_rx(skb). This means that the
skb previously allocated by alloc_can_err_skb() is not freed. In other
terms, this is a memory leak.

This patch simply removes the return statement in the error branch and
let the function continue.

Issue was found with GCC -fanalyzer, please follow the link below for
details.

Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Link: https://lore.kernel.org/all/20211026180740.1953265-1-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 96a13c770e4a1..24627ab146261 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -664,7 +664,7 @@ int es58x_rx_err_msg(struct net_device *netdev, enum es58x_err error,
 	struct can_device_stats *can_stats = &can->can_stats;
 	struct can_frame *cf = NULL;
 	struct sk_buff *skb;
-	int ret;
+	int ret = 0;
 
 	if (!netif_running(netdev)) {
 		if (net_ratelimit())
@@ -823,8 +823,6 @@ int es58x_rx_err_msg(struct net_device *netdev, enum es58x_err error,
 			can->state = CAN_STATE_BUS_OFF;
 			can_bus_off(netdev);
 			ret = can->do_set_mode(netdev, CAN_MODE_STOP);
-			if (ret)
-				return ret;
 		}
 		break;
 
@@ -881,7 +879,7 @@ int es58x_rx_err_msg(struct net_device *netdev, enum es58x_err error,
 					ES58X_EVENT_BUSOFF, timestamp);
 	}
 
-	return 0;
+	return ret;
 }
 
 /**
-- 
2.33.0



