Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D4D45BC46
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244849AbhKXM1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:27:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245301AbhKXMZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:25:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D15E161108;
        Wed, 24 Nov 2021 12:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756150;
        bh=Wy0zgEHaPo5WFsIcANYq3Jg9Lg3HHQlbR3eyo1u/Ftg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=km3LVJ6rvRqHvrtpgnOxMVeHzAMl8lHaaeR62rcvrKn/SX1Ud2H5R9ukNbyYdcyyq
         VTlvO5YPCM3ti0jBy71Q/P81U9PN7p68EvZaFX87JAYq+TiEc+xjGAbBc/1P7Cypwy
         LYoFzvF+Oq85DRciQiZcM6CF8QOovnX8U8zdMZGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 190/207] tun: fix bonding active backup with arp monitoring
Date:   Wed, 24 Nov 2021 12:57:41 +0100
Message-Id: <20211124115710.109913289@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit a31d27fbed5d518734cb60956303eb15089a7634 upstream.

As stated in the bonding doc, trans_start must be set manually for drivers
using NETIF_F_LLTX:
 Drivers that use NETIF_F_LLTX flag must also update
 netdev_queue->trans_start. If they do not, then the ARP monitor will
 immediately fail any slaves using that driver, and those slaves will stay
 down.

Link: https://www.kernel.org/doc/html/v5.15/networking/bonding.html#arp-monitor-operation
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -855,6 +855,7 @@ static netdev_tx_t tun_net_xmit(struct s
 {
 	struct tun_struct *tun = netdev_priv(dev);
 	int txq = skb->queue_mapping;
+	struct netdev_queue *queue;
 	struct tun_file *tfile;
 	u32 numqueues = 0;
 
@@ -920,6 +921,10 @@ static netdev_tx_t tun_net_xmit(struct s
 	if (skb_array_produce(&tfile->tx_array, skb))
 		goto drop;
 
+	/* NETIF_F_LLTX requires to do our own update of trans_start */
+	queue = netdev_get_tx_queue(dev, txq);
+	queue->trans_start = jiffies;
+
 	/* Notify and wake up reader process */
 	if (tfile->flags & TUN_FASYNC)
 		kill_fasync(&tfile->fasync, SIGIO, POLL_IN);


