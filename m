Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E93321669
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhBVMWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:22:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229943AbhBVMSO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:18:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 878FD64F04;
        Mon, 22 Feb 2021 12:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996276;
        bh=tIfRKpo12rFSkjertjK98w3AQ7aGGsWX7UqcvClpDzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uezwhRXfXA6F4SWlkXGhrRk+VGjmHwMTPhD07lri+5IKjQym7gq7mmUANZxaR457f
         Ok0agisudulQDuDLQkwD71AFTTEMUgSNMukfGwkf+Leik7GERlFSc2FdCwCfLFRbE8
         OGYj3VWNymXAToh2+TB2WcosiGsC4TopyQAHZk3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 31/50] net: watchdog: hold device global xmit lock during tx disable
Date:   Mon, 22 Feb 2021 13:13:22 +0100
Message-Id: <20210222121025.797842016@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
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
@@ -3966,6 +3966,7 @@ static inline void netif_tx_disable(stru
 
 	local_bh_disable();
 	cpu = smp_processor_id();
+	spin_lock(&dev->tx_global_lock);
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
 
@@ -3973,6 +3974,7 @@ static inline void netif_tx_disable(stru
 		netif_tx_stop_queue(txq);
 		__netif_tx_unlock(txq);
 	}
+	spin_unlock(&dev->tx_global_lock);
 	local_bh_enable();
 }
 


