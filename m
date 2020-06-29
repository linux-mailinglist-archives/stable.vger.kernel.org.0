Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1222520E76E
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404560AbgF2V5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbgF2Sfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5271324747;
        Mon, 29 Jun 2020 15:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444064;
        bh=QcRfZJniiltEW6KmV8PKB4BRobpN1Ff18VLIQgwZ1yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7voeI0m9U4bLSC1mFFU/q4jy9qf6DdFH0x0jw+LO8fOhn6i8r9pVGTWP45s7mN23
         ET/SvtI94wvhV5CRerVOj4JH/9tvvNPNK//5KD0j0NJSpbOzEJ695EhgpEVBz7V7Wv
         IbVZTgWAQxnxNbiOT7OIWpCSYXSKrGwrnzFsuNZ4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 173/265] wireguard: receive: account for napi_gro_receive never returning GRO_DROP
Date:   Mon, 29 Jun 2020 11:16:46 -0400
Message-Id: <20200629151818.2493727-174-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit df08126e3833e9dca19e2407db5f5860a7c194fb ]

The napi_gro_receive function no longer returns GRO_DROP ever, making
handling GRO_DROP dead code. This commit removes that dead code.
Further, it's not even clear that device drivers have any business in
taking action after passing off received packets; that's arguably out of
their hands.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Fixes: 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireguard/receive.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 91438144e4f7a..9b2ab6fc91cdd 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -414,14 +414,8 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 	if (unlikely(routed_peer != peer))
 		goto dishonest_packet_peer;
 
-	if (unlikely(napi_gro_receive(&peer->napi, skb) == GRO_DROP)) {
-		++dev->stats.rx_dropped;
-		net_dbg_ratelimited("%s: Failed to give packet to userspace from peer %llu (%pISpfsc)\n",
-				    dev->name, peer->internal_id,
-				    &peer->endpoint.addr);
-	} else {
-		update_rx_stats(peer, message_data_len(len_before_trim));
-	}
+	napi_gro_receive(&peer->napi, skb);
+	update_rx_stats(peer, message_data_len(len_before_trim));
 	return;
 
 dishonest_packet_peer:
-- 
2.25.1

