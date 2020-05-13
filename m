Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434AB1D0D83
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387990AbgEMJxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:53:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732603AbgEMJxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:53:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C896820575;
        Wed, 13 May 2020 09:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363619;
        bh=9Id/3gUvE69ng67jci/Ipgi+B0JOa0NZwiI0Aii5NOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2QHmKl3qoPjwyAzTFQ4SI5rdK8277nhYvaNw6iQ2l+WQAc5PqmFdztZZSVxBT6iQU
         mYqbAqwziYN60fgPBviZNT4LAmwEH1ZgmxuyP3rIDpoASZMdNGsuWVDO5Ir7CgvUaW
         odLPjMsNUixIzn3gv4vHpDqfBT5/NVXMFTsD3dxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sultan Alsawaf <sultan@kerneltoast.com>,
        Wang Jian <larkwang@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 056/118] wireguard: send/receive: cond_resched() when processing worker ringbuffers
Date:   Wed, 13 May 2020 11:44:35 +0200
Message-Id: <20200513094421.948432116@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 4005f5c3c9d006157ba716594e0d70c88a235c5e ]

Users with pathological hardware reported CPU stalls on CONFIG_
PREEMPT_VOLUNTARY=y, because the ringbuffers would stay full, meaning
these workers would never terminate. That turned out not to be okay on
systems without forced preemption, which Sultan observed. This commit
adds a cond_resched() to the bottom of each loop iteration, so that
these workers don't hog the core. Note that we don't need this on the
napi poll worker, since that terminates after its budget is expended.

Suggested-by: Sultan Alsawaf <sultan@kerneltoast.com>
Reported-by: Wang Jian <larkwang@gmail.com>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/receive.c |    2 ++
 drivers/net/wireguard/send.c    |    4 ++++
 2 files changed, 6 insertions(+)

--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -516,6 +516,8 @@ void wg_packet_decrypt_worker(struct wor
 				&PACKET_CB(skb)->keypair->receiving)) ?
 				PACKET_STATE_CRYPTED : PACKET_STATE_DEAD;
 		wg_queue_enqueue_per_peer_napi(skb, state);
+		if (need_resched())
+			cond_resched();
 	}
 }
 
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -281,6 +281,8 @@ void wg_packet_tx_worker(struct work_str
 
 		wg_noise_keypair_put(keypair, false);
 		wg_peer_put(peer);
+		if (need_resched())
+			cond_resched();
 	}
 }
 
@@ -305,6 +307,8 @@ void wg_packet_encrypt_worker(struct wor
 		wg_queue_enqueue_per_peer(&PACKET_PEER(first)->tx_queue, first,
 					  state);
 
+		if (need_resched())
+			cond_resched();
 	}
 }
 


