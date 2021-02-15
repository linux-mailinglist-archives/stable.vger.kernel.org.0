Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E0C31BD3E
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhBOPm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:42:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231280AbhBOPiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD40B64E52;
        Mon, 15 Feb 2021 15:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403281;
        bh=IbIM3s9XuvyiMOjFVmDrWo1VkIC6GberW/nW619dT8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8KtXwEz39YjusyaGutK6qwv7KKMUdddmcxAat1i423zqzxAkmMDfDwOdVAby26CW
         TjaRfN11WLUaOirSRJVY2mBmxf8jrWs44A2YnXQ7Er7BOrjenYeVPguw+ugyA74ze8
         yw7EZv84HFtD2wWmCZ5C4L4ffTCbEihYotQDW1uM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 096/104] net: watchdog: hold device global xmit lock during tx disable
Date:   Mon, 15 Feb 2021 16:27:49 +0100
Message-Id: <20210215152722.567168205@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

commit 3aa6bce9af0e25b735c9c1263739a5639a336ae8 upstream.

Prevent netif_tx_disable() running concurrently with dev_watchdog() by
taking the device global xmit lock. Otherwise, the recommended:

	netif_carrier_off(dev);
	netif_tx_disable(dev);

driver shutdown sequence can happen after the watchdog has already
checked carrier, resulting in possible false alarms. This is because
netif_tx_lock() only sets the frozen bit without maintaining the locks
on the individual queues.

Fixes: c3f26a269c24 ("netdev: Fix lockdep warnings in multiqueue configurations.")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4313,6 +4313,7 @@ static inline void netif_tx_disable(stru
 
 	local_bh_disable();
 	cpu = smp_processor_id();
+	spin_lock(&dev->tx_global_lock);
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
 
@@ -4320,6 +4321,7 @@ static inline void netif_tx_disable(stru
 		netif_tx_stop_queue(txq);
 		__netif_tx_unlock(txq);
 	}
+	spin_unlock(&dev->tx_global_lock);
 	local_bh_enable();
 }
 


