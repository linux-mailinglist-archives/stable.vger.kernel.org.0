Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F43035BFC7
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238771AbhDLJGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239968AbhDLJEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:04:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 631B26128B;
        Mon, 12 Apr 2021 09:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218112;
        bh=soO65RWWiAufIVqij2Tf9tJ6jf33ypvx+Bw7cZSUuJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJPYcZaHBjfM1SPvX3puXTpxVPnfIfO5D7niABPrMjKldN5ciYhSSYNssIkdjGvc4
         /Ryr5FbG0jCfLPLSFdJTWlq6/qmeMZvWbRk/JcMuHrmGDuB0SMgGyI1KtdeMKB1shm
         wVTw5p45X29kF8JOO1n8Wc58oMHe+kRAXdZAHrSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 075/210] net: hsr: Reset MAC header for Tx path
Date:   Mon, 12 Apr 2021 10:39:40 +0200
Message-Id: <20210412084018.519381697@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

commit 9d6803921a16f4d768dc41a75375629828f4d91e upstream.

Reset MAC header in HSR Tx path. This is needed, because direct packet
transmission, e.g. by specifying PACKET_QDISC_BYPASS does not reset the MAC
header.

This has been observed using the following setup:

|$ ip link add name hsr0 type hsr slave1 lan0 slave2 lan1 supervision 45 version 1
|$ ifconfig hsr0 up
|$ ./test hsr0

The test binary is using mmap'ed sockets and is specifying the
PACKET_QDISC_BYPASS socket option.

This patch resolves the following warning on a non-patched kernel:

|[  112.725394] ------------[ cut here ]------------
|[  112.731418] WARNING: CPU: 1 PID: 257 at net/hsr/hsr_forward.c:560 hsr_forward_skb+0x484/0x568
|[  112.739962] net/hsr/hsr_forward.c:560: Malformed frame (port_src hsr0)

The warning can be safely removed, because the other call sites of
hsr_forward_skb() make sure that the skb is prepared correctly.

Fixes: d346a3fae3ff ("packet: introduce PACKET_QDISC_BYPASS socket option")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_device.c  |    1 +
 net/hsr/hsr_forward.c |    6 ------
 2 files changed, 1 insertion(+), 6 deletions(-)

--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -217,6 +217,7 @@ static netdev_tx_t hsr_dev_xmit(struct s
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 	if (master) {
 		skb->dev = master->dev;
+		skb_reset_mac_header(skb);
 		hsr_forward_skb(skb, master);
 	} else {
 		atomic_long_inc(&dev->tx_dropped);
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -528,12 +528,6 @@ void hsr_forward_skb(struct sk_buff *skb
 {
 	struct hsr_frame_info frame;
 
-	if (skb_mac_header(skb) != skb->data) {
-		WARN_ONCE(1, "%s:%d: Malformed frame (port_src %s)\n",
-			  __FILE__, __LINE__, port->dev->name);
-		goto out_drop;
-	}
-
 	if (fill_frame_info(&frame, skb, port) < 0)
 		goto out_drop;
 


