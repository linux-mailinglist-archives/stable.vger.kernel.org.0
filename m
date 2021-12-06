Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE19469C71
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356622AbhLFPW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:22:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51242 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376366AbhLFPUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:20:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3794EB81018;
        Mon,  6 Dec 2021 15:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D07C341C2;
        Mon,  6 Dec 2021 15:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803823;
        bh=up8r64qDuwR879+JlGLpkyi45CGCA8L2tFXW8w233no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07Bfm0xbGB4dKNNS3tAX8fhOz1fzQlOYdUKn5b5b0mJ1WixD5IvS+ubWiNhpXA8pK
         EbTRwzv0Kd6UXcnpCcIehqN2fI4/a4pjPEIAoBIw9Bx0szc+Y5Jg6JCkPfDw3eD4Yy
         FkFhHhNKN9M2aIxA1F1vKNUqbXMgMQgIsmBz3RMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Streun Fabio <fstreun@student.ethz.ch>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 059/130] wireguard: receive: drop handshakes if queue lock is contended
Date:   Mon,  6 Dec 2021 15:56:16 +0100
Message-Id: <20211206145601.717727505@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit fb32f4f606c17b869805d7cede8b03d78339b50a upstream.

If we're being delivered packets from multiple CPUs so quickly that the
ring lock is contended for CPU tries, then it's safe to assume that the
queue is near capacity anyway, so just drop the packet rather than
spinning. This helps deal with multicore DoS that can interfere with
data path performance. It _still_ does not completely fix the issue, but
it again chips away at it.

Reported-by: Streun Fabio <fstreun@student.ethz.ch>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/receive.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -554,9 +554,19 @@ void wg_packet_receive(struct wg_device
 	case cpu_to_le32(MESSAGE_HANDSHAKE_INITIATION):
 	case cpu_to_le32(MESSAGE_HANDSHAKE_RESPONSE):
 	case cpu_to_le32(MESSAGE_HANDSHAKE_COOKIE): {
-		int cpu;
-		if (unlikely(!rng_is_initialized() ||
-			     ptr_ring_produce_bh(&wg->handshake_queue.ring, skb))) {
+		int cpu, ret = -EBUSY;
+
+		if (unlikely(!rng_is_initialized()))
+			goto drop;
+		if (atomic_read(&wg->handshake_queue_len) > MAX_QUEUED_INCOMING_HANDSHAKES / 2) {
+			if (spin_trylock_bh(&wg->handshake_queue.ring.producer_lock)) {
+				ret = __ptr_ring_produce(&wg->handshake_queue.ring, skb);
+				spin_unlock_bh(&wg->handshake_queue.ring.producer_lock);
+			}
+		} else
+			ret = ptr_ring_produce_bh(&wg->handshake_queue.ring, skb);
+		if (ret) {
+	drop:
 			net_dbg_skb_ratelimited("%s: Dropping handshake packet from %pISpfsc\n",
 						wg->dev->name, skb);
 			goto err;


