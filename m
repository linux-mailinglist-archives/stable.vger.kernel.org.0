Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DD3469E0B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388558AbhLFPeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:34:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45920 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236387AbhLFP2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:28:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 852AE61328;
        Mon,  6 Dec 2021 15:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A52FC34900;
        Mon,  6 Dec 2021 15:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804302;
        bh=up8r64qDuwR879+JlGLpkyi45CGCA8L2tFXW8w233no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4Dx/b/jajSzF2khEEbP9x4/oOCtzxtfvdr16IfFm/wbbnQNPJ34qvSAQVXPWAqcR
         XqTnGaRmVGmt6mE4sOsPH93MvwUky3myM+mXi/Oa7A62VIJR2SaF2hkC6lwOK+wcC/
         gPG/3igB56LHpLTCtyq3fypfvEJ92RqpUCeAdQ40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Streun Fabio <fstreun@student.ethz.ch>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 097/207] wireguard: receive: drop handshakes if queue lock is contended
Date:   Mon,  6 Dec 2021 15:55:51 +0100
Message-Id: <20211206145613.599467773@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
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


