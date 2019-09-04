Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 554F0A8F49
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388817AbfIDSCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388825AbfIDSCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:02:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1256208E4;
        Wed,  4 Sep 2019 18:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620169;
        bh=VNSR+s2UWdt9kFnFDqoDOJhysEP2JUIFc0/oGR/GDGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8yKUjdsINk7QK/O27o3tG/1dujSApZlgXYCNsR4GoFHn091vZ5E2B4cg11M0gDox
         KObBQh/f2EUnqxoRq6QsE476jYo4elLGTAXwSjyyQ0iyoZ11MXr/LcQ/qzqawZ1DxB
         NrFDMt1dLVaB5JObfFxZujEtFJCgPL5KUJ8U0YSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tim Froidcoeur <tim.froidcoeur@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Christoph Paasch <cpaasch@apple.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 16/57] tcp: fix tcp_rtx_queue_tail in case of empty retransmit queue
Date:   Wed,  4 Sep 2019 19:53:44 +0200
Message-Id: <20190904175303.590821624@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 8c3088f895a0 ("tcp: be more careful in tcp_fragment()")
triggers following stack trace:

[25244.848046] kernel BUG at ./include/linux/skbuff.h:1406!
[25244.859335] RIP: 0010:skb_queue_prev+0x9/0xc
[25244.888167] Call Trace:
[25244.889182]  <IRQ>
[25244.890001]  tcp_fragment+0x9c/0x2cf
[25244.891295]  tcp_write_xmit+0x68f/0x988
[25244.892732]  __tcp_push_pending_frames+0x3b/0xa0
[25244.894347]  tcp_data_snd_check+0x2a/0xc8
[25244.895775]  tcp_rcv_established+0x2a8/0x30d
[25244.897282]  tcp_v4_do_rcv+0xb2/0x158
[25244.898666]  tcp_v4_rcv+0x692/0x956
[25244.899959]  ip_local_deliver_finish+0xeb/0x169
[25244.901547]  __netif_receive_skb_core+0x51c/0x582
[25244.903193]  ? inet_gro_receive+0x239/0x247
[25244.904756]  netif_receive_skb_internal+0xab/0xc6
[25244.906395]  napi_gro_receive+0x8a/0xc0
[25244.907760]  receive_buf+0x9a1/0x9cd
[25244.909160]  ? load_balance+0x17a/0x7b7
[25244.910536]  ? vring_unmap_one+0x18/0x61
[25244.911932]  ? detach_buf+0x60/0xfa
[25244.913234]  virtnet_poll+0x128/0x1e1
[25244.914607]  net_rx_action+0x12a/0x2b1
[25244.915953]  __do_softirq+0x11c/0x26b
[25244.917269]  ? handle_irq_event+0x44/0x56
[25244.918695]  irq_exit+0x61/0xa0
[25244.919947]  do_IRQ+0x9d/0xbb
[25244.921065]  common_interrupt+0x85/0x85
[25244.922479]  </IRQ>

tcp_rtx_queue_tail() (called by tcp_fragment()) can call
tcp_write_queue_prev() on the first packet in the queue, which will trigger
the BUG in tcp_write_queue_prev(), because there is no previous packet.

This happens when the retransmit queue is empty, for example in case of a
zero window.

Commit 8c3088f895a0 ("tcp: be more careful in tcp_fragment()") was not a
simple cherry-pick of the original one from master (b617158dc096)
because there is a specific TCP rtx queue only since v4.15. For more
details, please see the commit message of b617158dc096 ("tcp: be more
careful in tcp_fragment()").

The BUG() is hit due to the specific code added to versions older than
v4.15. The comment in skb_queue_prev() (include/linux/skbuff.h:1406),
just before the BUG_ON() somehow suggests to add a check before using
it, what Tim did.

In master, this code path causing the issue will not be taken because
the implementation of tcp_rtx_queue_tail() is different:

    tcp_fragment() → tcp_rtx_queue_tail() → tcp_write_queue_prev() →
skb_queue_prev() → BUG_ON()

Fixes: 8c3088f895a0 ("tcp: be more careful in tcp_fragment()")
Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 7994e569644e0..785c4ef4e1bf8 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1702,6 +1702,10 @@ static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
 {
 	struct sk_buff *skb = tcp_send_head(sk);
 
+	/* empty retransmit queue, for example due to zero window */
+	if (skb == tcp_write_queue_head(sk))
+		return NULL;
+
 	return skb ? tcp_write_queue_prev(sk, skb) : tcp_write_queue_tail(sk);
 }
 
-- 
2.20.1



