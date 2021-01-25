Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947283033A4
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbhAZFBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:01:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:38156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731145AbhAYSvZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79DD220E65;
        Mon, 25 Jan 2021 18:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600670;
        bh=llioaGPB6XgcCDt3uUdb5lUyRspvfqmycbptgBdnuHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXhqJ5fzX0+Jj/kEuNzvBmYrizb6jeHzpyiXCV+hAqUjfZiRrow8zaWEytgtFGWUX
         0/LWs/txJBn9/ZTwpK7tZiHPInmjJpEdJUBgr27ZllKh+gHIX9Us4Ovp3Uejo0G2qg
         2bMCoCMz/hs1HMafqLZbXq2k5hKW6iPUXilUWNZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/199] can: dev: can_restart: fix use after free bug
Date:   Mon, 25 Jan 2021 19:38:48 +0100
Message-Id: <20210125183220.736207941@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 03f16c5075b22c8902d2af739969e878b0879c94 ]

After calling netif_rx_ni(skb), dereferencing skb is unsafe.
Especially, the can_frame cf which aliases skb memory is accessed
after the netif_rx_ni() in:
      stats->rx_bytes += cf->len;

Reordering the lines solves the issue.

Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
Link: https://lore.kernel.org/r/20210120114137.200019-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 81e39d7507d8f..09879aea9f7cc 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -592,11 +592,11 @@ static void can_restart(struct net_device *dev)
 
 	cf->can_id |= CAN_ERR_RESTARTED;
 
-	netif_rx_ni(skb);
-
 	stats->rx_packets++;
 	stats->rx_bytes += cf->can_dlc;
 
+	netif_rx_ni(skb);
+
 restart:
 	netdev_dbg(dev, "restarted\n");
 	priv->can_stats.restarts++;
-- 
2.27.0



