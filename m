Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA9345225F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242813AbhKPBLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:11:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244846AbhKOTRq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50B70634D9;
        Mon, 15 Nov 2021 18:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000686;
        bh=7TVDVMK/QRUb2Tm4l9JNtVjUfbBaKAzSBQComxX0nXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0hmGZKLjtSgVaM4vtgEedpJioaEGq6WhjsZ7duQynvj1soWeNq0ks8kazAR+DEQEN
         pshcK7zIXvPgllg5qdhtm8SbdlB3zhUw6gdUepLYM6wSAfbidcX1T5pdk2iCgYm8E8
         7ozkB9ZJiFgtk/aiFAZdg39F+lnOf2UecrF0J8Us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 754/849] can: etas_es58x: es58x_rx_err_msg(): fix memory leak in error path
Date:   Mon, 15 Nov 2021 18:03:57 +0100
Message-Id: <20211115165445.754292699@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 8e9102482c52a..c672320e0f15a 100644
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



