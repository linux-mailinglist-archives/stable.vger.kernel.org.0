Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CAC31BCC8
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhBOPfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:35:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231371AbhBOPdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:33:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6CAA64E52;
        Mon, 15 Feb 2021 15:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403038;
        bh=klZW4V3EPZDlo0Bsg6QbybOANQ4eI5sriq/4SYKrtqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMWCOhNP/B++fku1k0gnN6gWdxm6s19ex6xHKF0UfKYdAX/VzaA4zxHqpTymeVUS6
         fl46BffocyyV46U03Zh5giHCdI7/+jWOzrerwLpsiIu5gdVQaYagm31y36gYA4XgJ/
         RsTQvXrpzU88HIwvFBU/fNRNGg/TedQLVO/H0ZBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 55/60] net: watchdog: hold device global xmit lock during tx disable
Date:   Mon, 15 Feb 2021 16:27:43 +0100
Message-Id: <20210215152717.142354296@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
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
@@ -4044,6 +4044,7 @@ static inline void netif_tx_disable(stru
 
 	local_bh_disable();
 	cpu = smp_processor_id();
+	spin_lock(&dev->tx_global_lock);
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
 
@@ -4051,6 +4052,7 @@ static inline void netif_tx_disable(stru
 		netif_tx_stop_queue(txq);
 		__netif_tx_unlock(txq);
 	}
+	spin_unlock(&dev->tx_global_lock);
 	local_bh_enable();
 }
 


