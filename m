Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899ED2C0AE5
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730833AbgKWMbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:31:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:42060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730825AbgKWMbN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:31:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB5F020781;
        Mon, 23 Nov 2020 12:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134671;
        bh=xlLfugiOHGGKEEAfOJDqFe3YxwH0PwHIuzYn3TTu5Lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmZ2P48rqwTBqyCsTnm7JmTw6ltDyuUQl7DG07kYRutJcLpGRZd2eB+RdHQ4f8lRI
         1U9tpxAxptRyZvvcu1W1jkZujFIEWM7JrOzP0kJz0EtEbb4S0yz6dOEdBNs01bUgAf
         aVBWx2bIOgTA9GTmf+PP6h289dJSGM8xDM985Pi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 10/91] net: bridge: add missing counters to ndo_get_stats64 callback
Date:   Mon, 23 Nov 2020 13:21:30 +0100
Message-Id: <20201123121809.801456175@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 7a30ecc9237681bb125cbd30eee92bef7e86293d ]

In br_forward.c and br_input.c fields dev->stats.tx_dropped and
dev->stats.multicast are populated, but they are ignored in
ndo_get_stats64.

Fixes: 28172739f0a2 ("net: fix 64 bit counters on 32 bit arches")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/58ea9963-77ad-a7cf-8dfd-fc95ab95f606@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_device.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -215,6 +215,7 @@ static void br_get_stats64(struct net_de
 		sum.rx_packets += tmp.rx_packets;
 	}
 
+	netdev_stats_to_stats64(stats, &dev->stats);
 	stats->tx_bytes   = sum.tx_bytes;
 	stats->tx_packets = sum.tx_packets;
 	stats->rx_bytes   = sum.rx_bytes;


