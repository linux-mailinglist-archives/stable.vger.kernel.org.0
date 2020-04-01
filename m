Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7392419B454
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 19:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733193AbgDAQXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:23:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732869AbgDAQXR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:23:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B7852137B;
        Wed,  1 Apr 2020 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758196;
        bh=G8nl8P9MAhyOwyCLG+KWBee0YHD0lzCBQ4bBIKqdtIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQ9EFvMKtLiwk0SqaQQMN6Fs6zM0kH+KYyU4yFA4FW9PtVqf4tO5JQrl9kDR8ZRGX
         +SopLkvgWMoM6B5AfVbAO/2MKwXuKkthl1jeRZW1i/W/B4N8AZylzI/uAkGMEO9RvZ
         DRoQHtR22GZAhoNhHm/nwFkfpxQdLHmJ8WhRcKIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Rosen <jrosen@cisco.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 014/116] net/packet: tpacket_rcv: avoid a producer race condition
Date:   Wed,  1 Apr 2020 18:16:30 +0200
Message-Id: <20200401161543.889131757@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 61fad6816fc10fb8793a925d5c1256d1c3db0cd2 ]

PACKET_RX_RING can cause multiple writers to access the same slot if a
fast writer wraps the ring while a slow writer is still copying. This
is particularly likely with few, large, slots (e.g., GSO packets).

Synchronize kernel thread ownership of rx ring slots with a bitmap.

Writers acquire a slot race-free by testing tp_status TP_STATUS_KERNEL
while holding the sk receive queue lock. They release this lock before
copying and set tp_status to TP_STATUS_USER to release to userspace
when done. During copying, another writer may take the lock, also see
TP_STATUS_KERNEL, and start writing to the same slot.

Introduce a new rx_owner_map bitmap with a bit per slot. To acquire a
slot, test and set with the lock held. To release race-free, update
tp_status and owner bit as a transaction, so take the lock again.

This is the one of a variety of discussed options (see Link below):

* instead of a shadow ring, embed the data in the slot itself, such as
in tp_padding. But any test for this field may match a value left by
userspace, causing deadlock.

* avoid the lock on release. This leaves a small race if releasing the
shadow slot before setting TP_STATUS_USER. The below reproducer showed
that this race is not academic. If releasing the slot after tp_status,
the race is more subtle. See the first link for details.

* add a new tp_status TP_KERNEL_OWNED to avoid the transactional store
of two fields. But, legacy applications may interpret all non-zero
tp_status as owned by the user. As libpcap does. So this is possible
only opt-in by newer processes. It can be added as an optional mode.

* embed the struct at the tail of pg_vec to avoid extra allocation.
The implementation proved no less complex than a separate field.

The additional locking cost on release adds contention, no different
than scaling on multicore or multiqueue h/w. In practice, below
reproducer nor small packet tcpdump showed a noticeable change in
perf report in cycles spent in spinlock. Where contention is
problematic, packet sockets support mitigation through PACKET_FANOUT.
And we can consider adding opt-in state TP_KERNEL_OWNED.

Easy to reproduce by running multiple netperf or similar TCP_STREAM
flows concurrently with `tcpdump -B 129 -n greater 60000`.

Based on an earlier patchset by Jon Rosen. See links below.

I believe this issue goes back to the introduction of tpacket_rcv,
which predates git history.

Link: https://www.mail-archive.com/netdev@vger.kernel.org/msg237222.html
Suggested-by: Jon Rosen <jrosen@cisco.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jon Rosen <jrosen@cisco.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |   21 +++++++++++++++++++++
 net/packet/internal.h  |    5 ++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2165,6 +2165,7 @@ static int tpacket_rcv(struct sk_buff *s
 	struct timespec ts;
 	__u32 ts_status;
 	bool is_drop_n_account = false;
+	unsigned int slot_id = 0;
 	bool do_vnet = false;
 
 	/* struct tpacket{2,3}_hdr is aligned to a multiple of TPACKET_ALIGNMENT.
@@ -2261,6 +2262,13 @@ static int tpacket_rcv(struct sk_buff *s
 	if (!h.raw)
 		goto drop_n_account;
 
+	if (po->tp_version <= TPACKET_V2) {
+		slot_id = po->rx_ring.head;
+		if (test_bit(slot_id, po->rx_ring.rx_owner_map))
+			goto drop_n_account;
+		__set_bit(slot_id, po->rx_ring.rx_owner_map);
+	}
+
 	if (do_vnet &&
 	    virtio_net_hdr_from_skb(skb, h.raw + macoff -
 				    sizeof(struct virtio_net_hdr),
@@ -2366,7 +2374,10 @@ static int tpacket_rcv(struct sk_buff *s
 #endif
 
 	if (po->tp_version <= TPACKET_V2) {
+		spin_lock(&sk->sk_receive_queue.lock);
 		__packet_set_status(po, h.raw, status);
+		__clear_bit(slot_id, po->rx_ring.rx_owner_map);
+		spin_unlock(&sk->sk_receive_queue.lock);
 		sk->sk_data_ready(sk);
 	} else {
 		prb_clear_blk_fill_status(&po->rx_ring);
@@ -4260,6 +4271,7 @@ static int packet_set_ring(struct sock *
 {
 	struct pgv *pg_vec = NULL;
 	struct packet_sock *po = pkt_sk(sk);
+	unsigned long *rx_owner_map = NULL;
 	int was_running, order = 0;
 	struct packet_ring_buffer *rb;
 	struct sk_buff_head *rb_queue;
@@ -4345,6 +4357,12 @@ static int packet_set_ring(struct sock *
 			}
 			break;
 		default:
+			if (!tx_ring) {
+				rx_owner_map = bitmap_alloc(req->tp_frame_nr,
+					GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO);
+				if (!rx_owner_map)
+					goto out_free_pg_vec;
+			}
 			break;
 		}
 	}
@@ -4374,6 +4392,8 @@ static int packet_set_ring(struct sock *
 		err = 0;
 		spin_lock_bh(&rb_queue->lock);
 		swap(rb->pg_vec, pg_vec);
+		if (po->tp_version <= TPACKET_V2)
+			swap(rb->rx_owner_map, rx_owner_map);
 		rb->frame_max = (req->tp_frame_nr - 1);
 		rb->head = 0;
 		rb->frame_size = req->tp_frame_size;
@@ -4405,6 +4425,7 @@ static int packet_set_ring(struct sock *
 	}
 
 out_free_pg_vec:
+	bitmap_free(rx_owner_map);
 	if (pg_vec)
 		free_pg_vec(pg_vec, order, req->tp_block_nr);
 out:
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -70,7 +70,10 @@ struct packet_ring_buffer {
 
 	unsigned int __percpu	*pending_refcnt;
 
-	struct tpacket_kbdq_core	prb_bdqc;
+	union {
+		unsigned long			*rx_owner_map;
+		struct tpacket_kbdq_core	prb_bdqc;
+	};
 };
 
 extern struct mutex fanout_mutex;


